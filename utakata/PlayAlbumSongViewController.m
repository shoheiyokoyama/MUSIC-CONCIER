//
//  PlayAlbumSongViewController.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "PlayAlbumSongViewController.h"
#import "MusicServiceManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MainViewController.h"
#import "MusicCacheManeger.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainTableViewCell.h"
#import "ConciergeView.h"
#import "MainExtensionTableViewCell.h"
#import "ConciergePlayTableViewCell.h"
#import "utakata-Swift.h"
#import "GTScrollNavigationBar.h"

#define Concierge_Offset_Y 190.0f
@interface PlayAlbumSongViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate, UIScrollViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic, weak) MusicServiceManager *manager;
@property (nonatomic) NSMutableArray *similarMusicArray;

@property (nonatomic) MusicItems *music;
//@property (nonatomic) int playingIndex;
@property (nonatomic) NSURL *musicUrl;
@property (nonatomic) NSData *musicData;
@property (nonatomic) NSInteger playIndex;
@property (nonatomic) NSInteger originOrderNum;
@property (nonatomic) BOOL isShuffle;
@property (nonatomic) BOOL isRepeat;
@property (nonatomic) BOOL isSimilarMusic;
@property (nonatomic) NSMutableArray* shuffledData;
@property (nonatomic) NSMutableArray* cacheData;
@property (nonatomic) ConciergeView *conView;
@property (nonatomic) BOOL readyDisappear;
@property (nonatomic) ActivityIndicatorView *indicatorView;

enum Type{
    next,
    prev
};
@end

@implementation PlayAlbumSongViewController

@synthesize player;

- (instancetype)initWithMusic:(NSMutableArray *)musicArray selectedNum:(NSInteger)selectedNum playingPlayer:(AVAudioPlayer *)playingPlayer isShuffle:(BOOL)isShuffle isRepeat:(BOOL)isRepeat
{
    self = [super init];
    if (self) {
//        UIBarButtonItem* backIcon = [[UIBarButtonItem alloc]
//                                     initWithImage:[UIImage imageNamed:@"nav_back"]
//                                     style:UIBarButtonItemStylePlain
//                                     target:self
//                                     action:@selector(didTapBack)
//                                     ];
//        [backIcon setBackgroundImage:[UIImage imageNamed:@"arrow_tp"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIButton* backIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backIconBtn.frame = CGRectMake(0, 0, 22, 38);
        [backIconBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backIconBtn addTarget:self action:@selector(didTapBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backIcon = [[UIBarButtonItem alloc] initWithCustomView:backIconBtn];
        
        self.navigationItem.leftBarButtonItem = backIcon;
        self.isRepeat = isRepeat;
        self.isShuffle = isShuffle;
        self.cacheData = musicArray;
        self.isSimilarMusic = NO;
        
        _music = musicArray[selectedNum];
        self.playIndex = selectedNum;
        
        _conView = [[ConciergeView alloc] initWithFrame:CGRectZero];
        _conView.conciergeView.image = [UIImage imageNamed:@"recommend_concierge"];
        [self.view addSubview:_conView];
        [self.view bringSubviewToFront:_conView];
        _conView.hidden = NO;
        
        //MainViewから再生中の曲じゃないものを選択した時
        if (!playingPlayer) {
            _musicUrl = [NSURL URLWithString:_music.previewUrl];
            _musicData = [NSData dataWithContentsOfURL:_musicUrl];
            player = [[AVAudioPlayer alloc] initWithData:_musicData error:nil];

            [player setDelegate:self];
            //リピート処理
            if(isRepeat){
                player.numberOfLoops = -1;
            }
            //ランダム処理
            if(isShuffle){
                [self shuffleFunc];
            }
        } else {
            player = playingPlayer;
        }
        
    }
    return self;
}

- (void)didTapBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellStyleValue1;
    [self.view addSubview:_tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = v;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getSimilarData];
    
    UINib *nib = [UINib nibWithNibName:@"MainTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MainTableViewCell"];
    UIImageView *tableBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_background"]];
    [self.view insertSubview:tableBack atIndex:0];
    UINib *conNib = [UINib nibWithNibName:@"ConciergePlayTableViewCell" bundle:nil];
    [self.tableView registerNib:conNib forCellReuseIdentifier:@"ConciergePlayTableViewCell"];
    
    _indicatorView = [[ActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_indicatorView];
    [self startIndicator];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.scrollNavigationBar.scrollView = nil;
    if ([_playAlbumDelegate respondsToSelector:@selector(playingPlayer:playingIndex:shuffleData:)]) {
        //再生中のプレイヤーを渡す
        [_playAlbumDelegate playingPlayer:self.player playingIndex:self.playIndex shuffleData:self.isShuffle? self.shuffledData:nil];
    }
    if([_playAlbumDelegate respondsToSelector:@selector(getPlayMusicViewTableData:isRepeat:)]){
        //リピかシャッフルかのデータを渡す
        [_playAlbumDelegate getPlayMusicViewTableData:self.isShuffle isRepeat:self.isRepeat];
    }
    
    if(self.isSimilarMusic && [_playAlbumDelegate respondsToSelector:@selector(getSimilarMusic:)]){
        [_playAlbumDelegate getSimilarMusic:self.isSimilarMusic];
    }
    [self endIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self controllAction];
    [self.player play];
//    self.player.currentTime = 20.0f;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         _conView.center = CGPointMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height / 2) + Concierge_Offset_Y - 4);
                     } completion:^(BOOL finished){
                         _readyDisappear = YES;
//                         [self performSelector:@selector(conciergeDisappear) withObject:nil afterDelay:2.0f];
                     }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    float barHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    _tableView.frame = [UIScreen mainScreen].bounds;
    CGRect tableFrame = _tableView.frame;
    tableFrame.origin.y += barHeight;
    _tableView.frame = tableFrame;
    

    _conView.center = CGPointMake(-_conView.frame.size.width, (self.view.bounds.size.height / 2) + Concierge_Offset_Y - 4);
    CGRect conFrame = _conView.frame;
    conFrame.size.width = self.view.bounds.size.width - 16.0f;
    conFrame.size.height = 101.0f - 16.0f;
    _conView.frame = conFrame;
    
    CGRect indicatorFrame = _indicatorView.frame;
    indicatorFrame.size.width = 30.0f;
    indicatorFrame.size.height = 30.0f;
    indicatorFrame.origin.y = (self.view.bounds.size.height - 30.0f) / 2;
    indicatorFrame.origin.x = (self.view.bounds.size.width - 30.0f) / 2;
    _indicatorView.frame = _indicatorView.frame;
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

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
}

- (void)controllAction
{
    __weak typeof(self) weakSelf = self;
    _playCell.tappedToggleButton = ^(BOOL playing) {
        NSLog(@"tappedToggleButton");
        playing ? [weakSelf.player stop] : [weakSelf.player play];
    };
    
    _playCell.tappedNextButton = ^() {
        NSLog(@"tappedNextButton");
        [weakSelf prepareForNextSong:next];
    };
    
    _playCell.tappedPrevButton = ^() {
        NSLog(@"tappedPrevButton");
        [weakSelf prepareForNextSong:prev];
    };
    
    _playCell.tappedRepeatButton = ^(BOOL isRepeat) {
        NSLog(@"tappedRepeatButton");
        weakSelf.isRepeat = isRepeat;
        weakSelf.player.numberOfLoops = isRepeat?  -1:0;
    };
    
    _playCell.tappedShuffleButton= ^(BOOL isShuffle) {
        weakSelf.isShuffle = isShuffle;
        NSLog(@"tappedShuffleButton");
        if(isShuffle){
            [weakSelf shuffleFunc];
        }else{
            weakSelf.playIndex = weakSelf.originOrderNum;
        }
        
        
    };
}

- (void)shuffleFunc
{
    //現在のトラックNo.
    self.originOrderNum = self.playIndex;
    //シャッフル用にコピー
    self.shuffledData = self.cacheData;
    //今流れている曲
    MusicItems* item = self.cacheData[self.originOrderNum];
    //シャッフル用、再生中の曲を削除
    [self.shuffledData removeObjectAtIndex:self.originOrderNum];
    //データをシャッフル
    NSInteger count = [self.cacheData count];
    for (NSInteger i = count - 1; i > 0; i--) {
        int rand = arc4random() % i;
        [self.shuffledData exchangeObjectAtIndex:i withObjectAtIndex:rand];
    }
    //先頭に現在流れている曲を追加
    [self.shuffledData insertObject:item atIndex:0];
    //初期化
    self.playIndex = 0;
}


- (void)getSimilarData
{
    [[MusicServiceManager sharedManager] getSimilarSong:^(NSMutableArray *items, NSError *error){
        if (error) {
            NSLog(@"error: %@", error);
        }
        dispatch_async(dispatch_get_main_queue(),^{
            _playCell.nextSongName.hidden = NO;
            _playCell.nextSongArtistName.hidden = NO;
            _playCell.nextImage.hidden = NO;
            _playCell.nextLabel.hidden = NO;
            _conView.hidden = YES;
            _similarMusicArray = items;
            [_tableView reloadData];
            [self endIndicator];
//            [self conciergeDisappear];
        });
        
    }track_name:_music.songName artist_name:_music.artistName];
}

- (void)conciergeDisappear
{
    if (!_similarMusicArray.count == 0) {
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^ {
                             _conView.center = CGPointMake(-_conView.frame.size.width, (self.view.bounds.size.height / 2) + Concierge_Offset_Y);
                         } completion:^(BOOL finished){
                             _conView.hidden = YES;
                         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTime
{
    int elapsedSec = (int)fmodf(player.currentTime, 60);
    int elapsedMinute = player.currentTime / 60;
//    NSString* test = self.isShuffle? @"YES":@"NO";
//    NSLog(@"%@",test);
    NSTimeInterval ti =  player.duration;
    int totalMinutes = floor(ti / 60);
    int totalSecond = round(ti - totalMinutes * 60);
    
    NSString *formatedTime = [NSString stringWithFormat:@"%02d:%02d  |  %02d:%02d",elapsedMinute, elapsedSec, totalMinutes,totalSecond];
    
    float minutesRatio = (player.currentTime / player.duration);
    
    _playCell.timeProgress.progress = minutesRatio;
    _playCell.songTime.text = formatedTime;
    [_playCell.songTime sizeToFit];

}

/**
 * prepareForNextSong
 * レコメンドの前後処理
 **/
- (void)prepareForNextSong:(enum Type)type
{
    //キャッシュから取得。
    //NSMutableArray* cacheData = self.isShuffle? self.shuffledData:self.cacheData;
    NSMutableArray* cacheData = self.isSimilarMusic ? self.similarMusicArray : self.cacheData;
    //メインかプレイかで判断

    NSInteger nextCount;

    BOOL nextFlag = YES;

    //次のレコメンド曲へ
    if(type == 0){
        //レコメンドの次の曲へ
        nextCount = self.playIndex + 1;
        if(nextCount >= cacheData.count){
            self.playIndex = cacheData.count -1 ;
            nextFlag =NO;
        }else{
            self.playIndex = nextCount;
        }
    }else{
        //レコメンド前の曲へ
        nextCount = self.playIndex - 1;
        if(nextCount < 0){
            self.playIndex = 0;
            nextFlag = NO;
        }else{
            self.playIndex = nextCount;
        }
    }
    [self.player stop];
    //self.player.currentTime = 0.0f;
    if(nextFlag){
        MusicItems *music = cacheData[nextCount];
        [self initSong:music];
        //2曲後のトラックある場合
        if(cacheData.count > nextCount + 1){
            MusicItems *nextMusic = cacheData[nextCount + 1];
            [self nextSong:nextMusic];
        }
    }else{
        //次の曲がセットされていなければMainViewに戻る
        if(self.player){
            [self.player stop];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)initSong:(MusicItems*)music
{
    _music = music;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:music.previewUrl]];
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    if (self.isRepeat) {
        self.player.numberOfLoops = -1;
    }
    
    //if (!_isSimilarMusic) {
        [_playCell.artwork sd_setImageWithURL:[NSURL URLWithString:music.artworkUrl100] placeholderImage:nil];
    //}

    _playCell.artistTitleLabel.text = music.artistName;
    _playCell.songTitleLabel.text = music.songName;
//    _playCell.nextSongName.text = music.songName;
//    _playCell.nextSongArtistName.text = music.artistName;
    
    self.player.delegate = self;
    [self.player play];


}

- (void)nextSong:(MusicItems*)music
{
    _playCell.nextSongName.text = music.songName;
    [_playCell.nextSongName sizeToFit];
    _playCell.nextSongArtistName.text = music.artistName;
    [_playCell.nextSongArtistName sizeToFit];
    [_playCell layoutSubviews];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return;
    }
    if (!indexPath.section == 0) {
        _isSimilarMusic = YES;
        MusicItems *item = _similarMusicArray[indexPath.row];
        
        self.playIndex = indexPath.row;
        _musicUrl = [NSURL URLWithString:item.previewUrl];

        _musicData = [NSData dataWithContentsOfURL:_musicUrl];
        if(self.player.playing){
            [self.player stop];
        }
        self.player = [[AVAudioPlayer alloc] initWithData:_musicData error:nil];
        [self.player play];
        [self.player setDelegate:self];
//        self.player.currentTime = 20.0f;
        [_playCell.artwork sd_setImageWithURL:[NSURL URLWithString:item.artworkUrl100] placeholderImage:nil];
        _playCell.playing = YES;
        [_playCell.toggleButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        _playCell.songTitleLabel.text = item.songName;
        _playCell.artistTitleLabel.text = item.artistName;
        
        if(_similarMusicArray.count > indexPath.row + 1){
            MusicItems *nextItem = _similarMusicArray[indexPath.row + 1];
            _playCell.nextSongName.text = nextItem.songName;
            [_playCell.nextSongName sizeToFit];
            _playCell.nextSongArtistName.text = nextItem.artistName;
            [_playCell.nextSongArtistName sizeToFit];
            [_playCell layoutSubviews];
        }

    }
    
    
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        if (_similarMusicArray.count == 0) {
            return 0;
        }
        return _similarMusicArray.count;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
//    }
//    return 0.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 0) {
        return self.view.frame.size.width + 30.0f;
    } else {
        if (_similarMusicArray.count == 0){
            return 0.0f;
        }
        return 100.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_similarMusicArray.count <= indexPath.row) {
        if (indexPath.section == 1) {
            UITableViewCell *whiteCell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
            return whiteCell;
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            if (!_playCell) {
                _playCell = [[PlayMusicViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil musicItem:_music repeat:self.isRepeat shuffle:self.isShuffle];
                
                NSTimeInterval ti =  player.duration;
                int totalMinutes = floor(ti / 60);
                int totalSecond = round(ti - totalMinutes * 60);
                
                _playCell.songTime.text = [NSString stringWithFormat:@"00:30  |  %02d:%02d", totalMinutes, totalSecond];
                [_playCell.songTime sizeToFit];
                
                if (!_cacheData.count == indexPath.row + 1) {
                    
                    MusicItems *nextMusic = _cacheData[self.playIndex + 1];
                    _playCell.nextSongName.text = nextMusic.songName;
                    [_playCell.nextSongName sizeToFit];
                    _playCell.nextSongArtistName.text = nextMusic.artistName;
                    [_playCell.nextSongArtistName sizeToFit];
                    _playCell.nextSongName.hidden = YES;
                    _playCell.nextSongArtistName.hidden = YES;
                    _playCell.nextImage.hidden = YES;
                    _playCell.nextLabel.hidden = YES;
                }
                
                NSTimer *updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                                        target:self
                                                                      selector:@selector(updateTime)
                                                                      userInfo:nil
                                                                       repeats:YES];
            }
            return _playCell;
        }
        return nil;
    } else {
        if (indexPath.row == 0) {
            NSString *cellIdentifier = @"ConciergePlayTableViewCell";
            ConciergePlayTableViewCell *cell = (ConciergePlayTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            cell.imageView.image = [UIImage imageNamed:@"concierge_shadow"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        NSString *cellIdentifier = @"MainTableViewCell";
        
        MainTableViewCell *cell = (MainTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = (MainTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.backgroundColor = [UIColor clearColor];

        MusicItems *musicItems = self.similarMusicArray[indexPath.row];
        cell.songNameLabel.text = musicItems.songName;
        cell.artistNameLabel.text = musicItems.artistName;
        cell.albumNameLabel.text = musicItems.albumName;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    } else {
        return 0.0f;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        return @"";
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(flag){
        [self prepareForNextSong:next];
    }
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

@end
