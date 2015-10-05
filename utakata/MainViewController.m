//
//  MainViewController.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MainViewController.h"
#import "MusicItems.h"
#import "MusicServiceManager.h"
#import "SuggestionView.h"
#import "PlayAlbumSongViewController.h"
#import "MusicCacheManeger.h"
#import "PlayMusicViewTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "SuggestionTableViewCell.h"
#import "PlayStatusView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainTableViewCell.h"
#import "MainExtensionTableViewCell.h"
#import "ConciergeView.h"
#import "utakata-Swift.h"
//#import "ActivityIndicatorView.swift"
#import "GTScrollNavigationBar.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource, PlayAlbumSongViewControllerDelegate, AVAudioPlayerDelegate, SuggestionViewDelegate, UIScrollViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *musicData;
@property (nonatomic) NSMutableArray *songsGroupByAlbam;
@property (nonatomic, weak, readonly) MusicServiceManager *manager;
@property (nonatomic) SuggestionView *suggestView;
@property (nonatomic) NSInteger playingIndex;
@property (nonatomic) PlayStatusView * playStatusView;
@property (nonatomic) SuggestionTableViewCell *suggestionCell;
@property (nonatomic) BOOL isShuffle;
@property (nonatomic) BOOL isRepeat;
@property (nonatomic) NSMutableArray* shuffledData;
//@property (nonatomic) NSMutableArray *similarMusicArray;
@property (nonatomic) NSTimer *updateTimer;
@property (nonatomic) NSTimer *stopAnimationTimer;
@property (nonatomic) NSMutableArray *animationCellArray;
@property (nonatomic) NSMutableArray *stopAnimationCellArray;
@property (nonatomic)int timerIntenger;
@property (nonatomic) ConciergeView *conView;
@property (nonatomic) BOOL viewDidAppeard;
@property (nonatomic) BOOL conciergeAppeard;
@property (nonatomic) BOOL isSimilar;
@property (nonatomic) NSIndexPath *focusIndexPath;
@property (nonatomic) ActivityIndicatorView *indicatorView;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger playingPage;

@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _playStatusView = [[PlayStatusView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_playStatusView];
        _playStatusView.hidden = YES;
        _timerIntenger = 0;

        _viewDidAppeard = NO;
        self.animationCellArray = [NSMutableArray array];
        self.stopAnimationCellArray = [NSMutableArray array];
        
        //UIImageView* logoImageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_bar"]];
        UIButton* logoImageView =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 33)];
        [logoImageView setBackgroundImage:[UIImage imageNamed:@"left_bar"] forState:UIControlStateNormal];
        [logoImageView addTarget:self action:@selector(didTapLogoButton) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* logoItem = [[UIBarButtonItem alloc] initWithCustomView:logoImageView];
        self.navigationItem.leftBarButtonItem = logoItem;
        
        _conView = [[ConciergeView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_conView];
        
        _focusIndexPath = nil;
        
    }
    return self;
}

- (void)didTapLogoButton
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //logo tap ivent
}

- (void)didTapNext
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.playingIndex inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellStyleValue1;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//    v.backgroundColor = [UIColor clearColor];
//    _tableView.tableHeaderView = v;
//    
//    [self.view bringSubviewToFront:v];
//    [self.view bringSubviewToFront:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"MainTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MainTableViewCell"];
    
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    
    _indicatorView = [[ActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_indicatorView];
    
    self.view.backgroundColor = [UIColor clearColor];
    // 初回時の読み込み
    [self loadData:@"Mix"];
    UIImageView *tableBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_background"]];
    [self.view insertSubview:tableBack atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playStatusControll];
    
    _viewDidAppeard = YES;
    
    if (!_playStatusView.hidden) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;

    
    if (self.player) {
        //nextボタンの生成
        if(self.player.playing){
            UIButton* nextIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nextIconBtn.frame = CGRectMake(0, 0, 22, 38);
            [nextIconBtn setImage:[UIImage imageNamed:@"nav_next"] forState:UIControlStateNormal];
            [nextIconBtn addTarget:self action:@selector(didTapNext) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *nextIcon = [[UIBarButtonItem alloc] initWithCustomView:nextIconBtn];
            
            self.navigationItem.rightBarButtonItem= nextIcon;
        }
        
        //関連曲なら消す。
        self.playStatusView.hidden = NO;

        
        MusicItems *item = self.isShuffle? _shuffledData[_playingIndex]:_musicData[_playingIndex];
        [_playStatusView.artwork sd_setImageWithURL:[NSURL URLWithString:item.artworkUrl100] placeholderImage:nil];
        _playStatusView.songTitleLabel.text = item.songName;
        _playStatusView.artistTitleLabel.text = item.artistName;
        [_playStatusView.songTitleLabel sizeToFit];
        [_playStatusView.artistTitleLabel sizeToFit];
        
        
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                                target:self
                                                              selector:@selector(updateTime)
                                                              userInfo:nil
                                                               repeats:YES];
        
        if (self.player.playing) {
            [_playStatusView.toggleButton setImage:[UIImage imageNamed:@"subbar_pause"] forState:UIControlStateNormal];
            _playStatusView.playing = YES;
        } else {
            [_playStatusView.toggleButton setImage:[UIImage imageNamed:@"subbar_play"] forState:UIControlStateNormal];
            _playStatusView.playing = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _focusIndexPath = nil;
//    [self conciergeDisappear];
    
    self.navigationController.scrollNavigationBar.scrollView = nil;
}

- (void)conciergeDisappear
{
    if (_conciergeAppeard) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             _conView.center = CGPointMake(self.view.bounds.size.width + _conView.frame.size.width, (self.view.bounds.size.height / 2) + 190.0f);
                         } completion:^(BOOL finished){
                             _conciergeAppeard = NO;
                             _conView.hidden = YES;
                         }];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    [self conciergeDisappear];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
//    self.automaticallyAdjustsScrollViewInsets
    _tableView.frame = [UIScreen mainScreen].bounds;
    CGRect tableFrame = _tableView.frame;
    tableFrame.origin.y += self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
//    tableFrame.size.height += 50.0f;
    _tableView.frame = tableFrame;
    
    CGRect statusFrame = _playStatusView.frame;
    statusFrame.size.width = self.view.bounds.size.width;
    statusFrame.size.height = 50.0f;
    statusFrame.origin.y = self.view.bounds.size.height - 50.0f;
    _playStatusView.frame = statusFrame;
    
    _conView.center = CGPointMake(self.view.bounds.size.width + _conView.frame.size.width, (self.view.bounds.size.height / 2) + 190.0f);
    CGRect conFrame = _conView.frame;
    conFrame.size.width = 280.0f;
    conFrame.size.height = 100.0f;
    _conView.frame = conFrame;
    
    CGRect indicatorFrame = _indicatorView.frame;
    indicatorFrame.size.width = 30.0f;
    indicatorFrame.size.height = 30.0f;
    indicatorFrame.origin.y = (self.view.bounds.size.height - 30.0f) / 2;
    indicatorFrame.origin.x = (self.view.bounds.size.width - 30.0f) / 2;
    _indicatorView.frame = _indicatorView.frame;
}

- (void)updateTime
{
    float minutesRatio = (self.player.currentTime / self.player.duration);
    _playStatusView.statusView.progress = minutesRatio;
}

- (void)getMusicData {
    
    [[MusicServiceManager sharedManager] getJsonData:^(NSMutableArray *items, NSError *error)
     {
         if (error) {
             NSLog(@"error: %@", error);
         }
         dispatch_async(dispatch_get_main_queue(),^{
             _musicData= items;
             [[MusicCacheManeger sharedManager] saveData:_musicData];
             [_tableView reloadData];
             [self endIndicator];
         });
     }];
}

- (void)startIndicator
{
    _indicatorView.hidden = NO;
    [_indicatorView animationStart];
}

- (void)endIndicator
{
    _indicatorView.hidden = YES;
    [_indicatorView animationStop];
}

- (void)loadData:(NSString *)pageKey
{
    NSMutableArray *musicArray = [[MusicCacheManeger sharedManager] getMusicArray:pageKey];
    
    if (!musicArray.count == 0) {
        dispatch_async(dispatch_get_main_queue(),^{
            _musicData = musicArray;
            [_tableView reloadData];
        });
    } else {
        [self startIndicator];
        [[MusicServiceManager sharedManager] getGenreSong:^(NSMutableArray *items, NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }
            dispatch_async(dispatch_get_main_queue(),^{
                _musicData = items;
                [[MusicCacheManeger sharedManager] saveMusicArray:items fileName:pageKey];
                [_tableView reloadData];
                [self endIndicator];
            });
            
        } GenreTitle:pageKey];
    }
}

- (void)getGenreSong:(NSString *)GenreTitle
{

        [[MusicServiceManager sharedManager] getGenreSong:^(NSMutableArray *items, NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }
            NSLog(@"call back");
            dispatch_async(dispatch_get_main_queue(),^{
                _musicData = items;
                [_tableView reloadData];
                [self endIndicator];
            });
            
        } GenreTitle:GenreTitle];
}

- (UIImage *)trimSquareImage:(UIImage *)image
{
    if (image.size.height > image.size.width) {
        CGRect cropRegion = CGRectMake(0, (image.size.height - image.size.width) / 2, image.size.width, image.size.width);
        CGImageRef squareImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRegion);
        UIImage *squareImage = [UIImage imageWithCGImage:squareImageRef];
        CGImageRelease(squareImageRef);
        return squareImage;
    } else if (image.size.height < image.size.width) {
        CGRect cropRegion = CGRectMake((image.size.width - image.size.height) / 2, 0, image.size.height, image.size.height);
        CGImageRef squareImageRef = CGImageCreateWithImageInRect(image.CGImage, cropRegion);
        UIImage *squareImage = [UIImage imageWithCGImage:squareImageRef];
        CGImageRelease(squareImageRef);
        return squareImage;
    } else {
        return image;
    }
    return image;
}

# pragma marl - tap Action
- (void)playStatusControll
{
    __weak typeof(self) weakSelf = self;
    _playStatusView.tappedToggleButton = ^(BOOL playing) {
        NSLog(@"tappedToggleButton!");
        playing ? [weakSelf.player pause] : [weakSelf.player play];
        
        if (playing) {
            [weakSelf.updateTimer invalidate];
        } else {
            if (!weakSelf.updateTimer.valid) {
                weakSelf.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                                        target:weakSelf
                                                                      selector:@selector(updateTime)
                                                                      userInfo:nil
                                                                       repeats:YES];
            }
        }
    };
    
    _playStatusView.tappedNextButton = ^() {
        weakSelf.player.currentTime = weakSelf.player.duration;
        NSLog(@"tappedNextButton");
    };
    
    _playStatusView.tappedView = ^() {
        NSLog(@"tappedView");
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:_playingIndex inSection:1];
        
        BOOL sameSong;
        if (self.playingIndex == path.row) {
            sameSong = YES;
        } else {
            sameSong = NO;
        }
        
        PlayAlbumSongViewController *controller = [[PlayAlbumSongViewController alloc] initWithMusic:self.musicData selectedNum:path.row playingPlayer:sameSong ? self.player : nil isShuffle:self.isShuffle isRepeat:self.isRepeat];
        controller.playAlbumDelegate = self;
        
        if(self.player.playing && !(self.playingIndex == path.row)){
            [self.player stop];
            
        }
        [self.navigationController pushViewController:controller animated:YES];
        
    };
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isSimilar = NO;
    BOOL sameSong;
    if (self.playingIndex == indexPath.row && self.playingPage == self.currentPage) {
        sameSong = YES;
    } else {
        sameSong = NO;
        [self.player stop];
    }
    self.playingPage = self.currentPage;
    PlayAlbumSongViewController *controller = [[PlayAlbumSongViewController alloc] initWithMusic:self.musicData selectedNum:indexPath.row playingPlayer:sameSong ? self.player : nil isShuffle:self.isShuffle isRepeat:self.isRepeat];

    controller.playAlbumDelegate = self;
//    MusicItems *nextMusicItems = self.musicData[indexPath.row + 1];
//    controller.playCell.nextSongName.text = nextMusicItems.songName;
//    controller.playCell.nextSongArtistName.text = nextMusicItems.artistName;

    if(self.player.playing && !(self.playingIndex == indexPath.row)){
        [self.player stop];

    }
    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        if (_musicData.count == 0) {
            return 0;
        }
        return _musicData.count;
    }
}
//表示ばぐる

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    float topBar = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
//    float viewStatusHeight =  topBar + 50.0f;
//    if (section == 1) {
//        return _conciergeAppeard ? viewStatusHeight: topBar;
//    }
//    return 0.0f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_musicData.count <= indexPath.row) {
        if (indexPath.section == 1) {
            UITableViewCell *whiteCell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
            return whiteCell;
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!_suggestionCell) {
                _suggestionCell = [[SuggestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                _suggestionCell.suggestView.suggestionViewDelegate = self;
            }
            return _suggestionCell;
        }
        return nil;
    } else {
        MusicItems *musicItems = self.musicData[indexPath.row];
        
        NSString *cellIdentifier = @"MainTableViewCell";
        
        MainTableViewCell *cell = (MainTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        MainExtensionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = (MainTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor clearColor];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.3];
        }
        cell.songNameLabel.text = musicItems.songName;
        cell.artistNameLabel.text = musicItems.artistName;
        cell.albumNameLabel.text = musicItems.albumName;
        cell.songTimeLabel.text = @"00:30";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:musicItems.artworkUrl100]];
        UIImage *image = [[UIImage alloc] initWithData:data];
        cell.artworkImageView.image = [self trimSquareImage:image];
        
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 0) {
        return 200.0f;
    } else {
        if (_musicData.count == 0){
            return 0.0f;
        }
        
        if (self.focusIndexPath != nil && self.focusIndexPath.row == indexPath.row) {
            return 160.0f;
        } else {
            for (NSArray *array in _animationCellArray) {
                NSIndexPath *scaledIndexPath = array[0];
                if (scaledIndexPath.row == indexPath.row) {
                    return 100.0f * [array[1] floatValue];
                }
            }
        }
    }
    return 100.0f;
}

#pragma mark - PlayAlbumSongViewControllerDelegate

- (void)playingPlayer:(AVAudioPlayer *)player playingIndex:(NSInteger)playingIndex shuffleData:(NSMutableArray*)shuffleData
{
    NSLog(@"CALL BACK!!!");
    if(shuffleData){
        self.shuffledData = shuffleData;
    }
    self.player = player;
    self.player.delegate = self;
    self.playingIndex = playingIndex;
}

- (void)getPlayMusicViewTableData:(BOOL)isShuffle isRepeat:(BOOL)isRepeat
{
    NSLog(@"STATUS CALL BACK");
    self.isShuffle = isShuffle;
    self.isRepeat = isRepeat;
}

- (void)getSimilarMusic:(BOOL)isSimilar
{
    self.isSimilar = isSimilar;

}
#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(flag) {
        NSInteger nextIndex = self.playingIndex + 1;
        NSMutableArray* musicArray = self.isShuffle? _shuffledData:_musicData;
        
        if(nextIndex < musicArray.count){
            self.playingIndex++;
            MusicItems *items = musicArray[nextIndex];

            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:items.previewUrl]];
            self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            //テキスト変更
            self.playStatusView.artistTitleLabel.text = items.artistName;
            self.playStatusView.songTitleLabel.text = items.songName;
            //アーティストジャケット変更
            [self.playStatusView.artwork sd_setImageWithURL:[NSURL URLWithString:items.artworkUrl100] placeholderImage:nil];
            
            [self.player play];
            //self.player.currentTime = 20.0f;
            [self.player setDelegate:self];
        }else{
            _playStatusView.hidden = YES;
        }
    }
}

#pragma mark - SuggestionViewDelegate
- (void)changePage:(NSInteger)pageIndex
{
    if (pageIndex == 0) {
        _currentPage = pageIndex;
        [self loadData:@"Mix"];
    } else if (pageIndex == 1) {
        _currentPage = pageIndex;
        [self loadData:@"Pop"];
    } else if (pageIndex == 2){
        _currentPage = pageIndex;
        [self loadData:@"Rock"];
        _currentPage = pageIndex;
    } else if (pageIndex == 3) {
        [self loadData:@"Reg"];
        _currentPage = pageIndex;
    } else if (pageIndex == 4) {
        _currentPage = pageIndex;
        [self loadData:@"Jazz"];
        
    } else {
        [self loadData:@"Class"];
        _currentPage = pageIndex;

    }
}

- (void)scrollControll
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(conciergeApper)
                                               object:nil];
    
    if (_conciergeAppeard) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             _conView.center = CGPointMake(self.view.bounds.size.width + _conView.frame.size.width, (self.view.bounds.size.height / 2) + 190.0f);
                         } completion:^(BOOL finished){
                             _conciergeAppeard = NO;
                             //                             _conView.hidden = YES;
                         }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.focusIndexPath = nil;
    if (_viewDidAppeard == NO) return;
    
    if (_conciergeAppeard) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             _conView.center = CGPointMake(self.view.bounds.size.width + _conView.frame.size.width, (self.view.bounds.size.height / 2) + 190.0f);
                         } completion:^(BOOL finished){
                             _conciergeAppeard = NO;
//                             _conView.hidden = YES;
                         }];
    }
    
    NSArray *cells = (NSArray *)_tableView.visibleCells;
    
    if (cells.count > 0) {
        for (UITableViewCell *cell in cells) {
            [self updateCell:cell];
        }
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        [_animationCellArray removeAllObjects];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSLog(@"fire");
    
    NSArray *cells = (NSArray *)_tableView.visibleCells;
    MainTableViewCell *cell = cells[2];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _conView.hidden = NO;

    [self performSelector:@selector(conciergeApper) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(focusToRow:) withObject:indexPath afterDelay:1.0f];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
}

- (void)conciergeApper
{
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         _conView.center = CGPointMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height / 2) + 190.0f);
                         
                     } completion:^(BOOL finished){
                         _conciergeAppeard = YES;
                     }];
}

- (void)focusToRow:(NSIndexPath *)indexPath
{
    self.focusIndexPath = indexPath;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)updateCell:(UITableViewCell *)cell
{
    CGPoint top = cell.frame.origin;
    CGPoint offset = self.tableView.contentOffset;
    CGPoint point = CGPointZero;
    point.x = top.x - offset.x;
    point.y = top.y - offset.y;
    
    CGFloat distance = fabs(point.y - self.tableView.center.y + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    CGFloat maxScale = 1.06f; //　ズーム率
    CGFloat animationDistance = 50.0f;// centerからの絶対値
    CGFloat a = 0.5 * maxScale - 0.5f;
    CGFloat animationCenter = (maxScale + 1.0f) / 2;
    CGFloat animationScale = a * cos(distance * M_PI / animationDistance) + animationCenter;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (distance <= animationDistance) {
            [self.animationCellArray addObject:@[indexPath, @(animationScale)]];
        }
}

@end
