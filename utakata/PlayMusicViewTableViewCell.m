//
//  PlayMusicViewTableViewCell.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "PlayMusicViewTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define NextView_Height 70.0

@interface PlayMusicViewTableViewCell()

typedef enum {
    angle0,
    angle45,
    angle90,
} angle;

@property (nonatomic) MusicItems * music;
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UIButton *prevButton;
@property (nonatomic) UIView *filterView;
@property (nonatomic) UIView *headerView;
@property (nonatomic) UIView *whiteView;
@property (nonatomic) UIView *nextSongViwe;

@end

@implementation PlayMusicViewTableViewCell

@synthesize toggleButton;
@synthesize artwork;
@synthesize timeProgress;
@synthesize nextButton;
@synthesize prevButton;
@synthesize songTitleLabel;
@synthesize songTime;
@synthesize songProgressTime;
@synthesize filterView;
@synthesize artistTitleLabel;
@synthesize repeatButton;
@synthesize shuffleButton;
@synthesize headerView;
@synthesize whiteView;
@synthesize nextSongViwe;
@synthesize nextSongArtistName;
@synthesize nextSongName;
@synthesize nextImage;
@synthesize nextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier musicItem:(MusicItems *)musicItem repeat:(BOOL)repeat shuffle:(BOOL)shuffle
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isRepeat = repeat;
        _isShuffle = shuffle;
        _music = musicItem;
        [self setup];
    }
    return self;
}

- (void)setup
{
//    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:206/255.0 green:190/255.0 blue:161/255.0 alpha:1.0];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _playing = YES;
    
    headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor clearColor];
    [self addSubview:headerView];
    
    nextSongViwe = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    UIColor *color = [UIColor whiteColor];
    UIColor *acolor = [color colorWithAlphaComponent:0.5];
    nextSongViwe.backgroundColor = acolor;
    [self addSubview:nextSongViwe];
    
    nextSongName = [[UILabel alloc] initWithFrame:CGRectZero];
    nextSongName.textColor = [UIColor whiteColor];
    nextSongName.font = [UIFont systemFontOfSize:16];
    nextSongName.text = @"songname";
    [nextSongName sizeToFit];
    [nextSongViwe addSubview:nextSongName];
    
    
    nextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nextLabel.textColor = [UIColor whiteColor];
    nextLabel.font = [UIFont systemFontOfSize:14];
    nextLabel.text = @"next";
    [nextLabel sizeToFit];
    [nextSongViwe addSubview:nextLabel];
    
    nextSongArtistName = [[UILabel alloc] initWithFrame:CGRectZero];
    nextSongArtistName.textColor = [UIColor whiteColor];
    nextSongArtistName.font = [UIFont systemFontOfSize:15];
    nextSongArtistName.text = @"songArtistname";
    [nextSongArtistName sizeToFit];
    [nextSongViwe addSubview:nextSongArtistName];
    
    nextImage = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    [nextImage setImage:[UIImage imageNamed:@"next_song_icon"] forState:UIControlStateNormal];
    [nextSongViwe addSubview:nextImage];
    
    whiteView = [[UIView alloc] initWithFrame:CGRectZero];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    artwork = [[UIImageView alloc] initWithFrame:CGRectZero];
    artwork.backgroundColor = [UIColor clearColor];
    [self addSubview:artwork];
    
    [artwork sd_setImageWithURL:[NSURL URLWithString:_music.artworkUrl100] placeholderImage:nil];
    
    filterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height)];
    filterView.backgroundColor = [UIColor blackColor];
    filterView.alpha = 0.3f;
    [self.artwork addSubview:filterView];
    
    float progressOriginX = (CGRectGetWidth(self.bounds) - CGRectGetWidth(timeProgress.frame)) / 2;
    float progressOriginY = (CGRectGetHeight(self.bounds) - CGRectGetHeight(timeProgress.frame)) / 2;
    timeProgress = [[UAProgressView alloc]initWithFrame:CGRectMake(progressOriginX, progressOriginY, 210.0f, 210.0f)];
    timeProgress.borderWidth = 0.4;
    timeProgress.lineWidth = 3.0f;
    timeProgress.fillOnTouch = NO;
    timeProgress.tintColor = [UIColor colorWithRed:231/255.0 green:56/255.0 blue:40/255.0 alpha:1.0];
    [self addSubview:timeProgress];
    
    toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [toggleButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    toggleButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapToggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToggleButton:)];
    [toggleButton addGestureRecognizer:tapToggleGesture];
    [self addSubview:toggleButton];
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [nextButton setImage:[UIImage imageNamed:@"next_r.png"] forState:UIControlStateNormal];
    nextButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapNextGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNextButton:)];
    [nextButton addGestureRecognizer:tapNextGesture];
    [self addSubview:nextButton];
    
    prevButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [prevButton setImage:[UIImage imageNamed:@"next_l.png"] forState:UIControlStateNormal];
    prevButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPrevGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPrevButton:)];
    [prevButton addGestureRecognizer:tapPrevGesture];
    [self addSubview:prevButton];
    
    songTime = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    songTime.font = [UIFont systemFontOfSize:9];
    songTime.backgroundColor = [UIColor clearColor];
    songTime.textColor = [UIColor whiteColor];
    [songTime sizeToFit];
    [self addSubview:songTime];
    
    songTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    songTitleLabel.textColor = [UIColor blackColor];
    songTitleLabel.font = [UIFont systemFontOfSize:15];
    songTitleLabel.text = _music.songName;
    [songTitleLabel sizeToFit];
    [self addSubview:songTitleLabel];
    
    artistTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    artistTitleLabel.textColor = [UIColor blackColor];
    artistTitleLabel.font = [UIFont systemFontOfSize:10];
    artistTitleLabel.text = _music.artistName;
    [artistTitleLabel sizeToFit];
    [self addSubview:artistTitleLabel];
    
    repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [repeatButton setImage:[UIImage imageNamed:self.isRepeat? @"loop_o.png":@"loop_g.png"] forState:UIControlStateNormal];
    repeatButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRepeatButton:)];
    [repeatButton addGestureRecognizer:tapGesture];
    [self addSubview:repeatButton];
    
    shuffleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [shuffleButton setImage:[UIImage imageNamed:self.isShuffle? @"shuffle_o.png":@"shuffle_g.png"] forState:UIControlStateNormal];
    shuffleButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapShuffleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShuffleButton:)];
    [shuffleButton addGestureRecognizer:tapShuffleGesture];
    [self addSubview:shuffleButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect headerFrame = headerView.frame;
    headerFrame.origin.x = 0.0f;
    headerFrame.origin.y = self.bounds.size.height - NextView_Height;
    headerFrame.size.width = self.bounds.size.width;
    headerFrame.size.height = self.bounds.size.height - CGRectGetHeight(artwork.frame) - NextView_Height;
    headerView.frame = headerFrame;
    
    CGRect whiteFrame = whiteView.frame;
    whiteFrame.origin.x = 0.0f;
    whiteFrame.origin.y = CGRectGetHeight(artwork.frame);
    whiteFrame.size.width = self.bounds.size.width;
    whiteFrame.size.height = self.bounds.size.height -  CGRectGetHeight(artwork.frame) -NextView_Height;
    whiteView.frame = whiteFrame;
    
//    nextSongViwe.center = CGPointMake(self.bounds.size.width / 2, (self.bounds.size.height + CGRectGetHeight(artwork.frame) + CGRectGetHeight(whiteView.frame) + NextView_Height / 2));
    CGRect nextViewFrame = nextSongViwe.frame;
    nextViewFrame.origin.x = 0.0f;
    nextViewFrame.origin.y = CGRectGetHeight(artwork.frame) + CGRectGetHeight(whiteView.frame) + ((NextView_Height - CGRectGetHeight(nextSongViwe.frame)) / 2);
    nextViewFrame.size.width = self.bounds.size.width;
    nextViewFrame.size.height = (self.bounds.size.height -  CGRectGetHeight(artwork.frame) -CGRectGetHeight(whiteView.frame)) * 0.7;
    nextSongViwe.frame = nextViewFrame;
    
    CGRect nextLabelFrame = nextLabel.frame;
    nextLabelFrame.origin.x = 34.0f;
    nextLabelFrame.origin.y = 14.0f;
    nextLabel.frame = nextLabelFrame;
    
    CGRect nextImageFrame = nextImage.frame;
    nextImageFrame.origin.x = CGRectGetMaxX(nextLabel.frame) + 10.0f;
    nextImageFrame.origin.y = CGRectGetMinY(nextLabel.frame) + 5.0f;
    nextImage.frame = nextImageFrame;
    
    CGRect nextSongFrame = nextSongName.frame;
    nextSongFrame.origin.x = CGRectGetMaxX(nextImage.frame) + 10.0f;
    nextSongFrame.origin.y = CGRectGetMinY(nextLabel.frame);
    nextSongName.frame = nextSongFrame;
    
    CGRect nextSongArtistFrame = nextSongArtistName.frame;
    nextSongArtistFrame.origin.x = CGRectGetMaxX(nextSongName.frame) + 10.0f;
    nextSongArtistFrame.origin.y = CGRectGetMinY(nextLabel.frame);
    nextSongArtistName.frame = nextSongArtistFrame;
    
    CGRect artworkFrame = artwork.frame;
    artworkFrame.origin.x = 0.0f;
    artworkFrame.origin.y = 0.0f;
    artworkFrame.size.width = self.bounds.size.width;
    artworkFrame.size.height = self.bounds.size.height - 50.0f - NextView_Height;
    artwork.frame = artworkFrame;
    
    CGRect filterFrame = filterView.frame;
    filterFrame.origin.x = 0.0f;
    filterFrame.origin.y = 0.0f;
    filterFrame.size.width = self.bounds.size.width;
    filterFrame.size.height = self.bounds.size.height - 50.0f - NextView_Height;
    filterView.frame = filterFrame;
    
    CGRect progressFrame = timeProgress.frame;
    progressFrame.size.width = 210.0f;
    progressFrame.size.height = 210.0f;
    progressFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(timeProgress.frame)) / 2;
    progressFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(timeProgress.frame)) / 2 - NextView_Height;
    timeProgress.frame = progressFrame;
    
    CGRect toggleFrame = toggleButton.frame;
    toggleFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(toggleButton.frame)) / 2;
    toggleFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(toggleButton.frame)) / 2 - NextView_Height;
    toggleButton.frame = toggleFrame;
    
    CGRect nextFrame = nextButton.frame;
    nextFrame.origin.x = CGRectGetMaxX(timeProgress.frame) + (self.bounds.size.width - CGRectGetMaxX(timeProgress.frame) - CGRectGetWidth(nextButton.frame)) / 2;
    nextFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(nextButton.frame)) / 2 - NextView_Height;
    nextButton.frame = nextFrame;
    
    CGRect prevFrame = prevButton.frame;
    prevFrame.origin.x = (CGRectGetMinX(timeProgress.frame) - CGRectGetWidth(prevButton.frame)) / 2;
    prevFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(prevButton.frame)) / 2 - NextView_Height;
    prevButton.frame = prevFrame;
    
    CGRect songTimeFrame = songTime.frame;
    songTimeFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(songTime.frame)) / 2;
    songTimeFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(songTime.frame)) / 2 + 50.0f - NextView_Height;
    songTime.frame = songTimeFrame;
    
    CGRect repeatFrame = repeatButton.frame;
    repeatFrame.origin.x = self.bounds.size.width - 15.0f - CGRectGetWidth(repeatButton.frame);
    repeatFrame.origin.y = self.bounds.size.height - 40.0f - NextView_Height;
    repeatButton.frame = repeatFrame;
    
    CGRect shuffleFrame = shuffleButton.frame;
    shuffleFrame.origin.x = CGRectGetMinX(repeatButton.frame) - 10.0f - CGRectGetWidth(shuffleButton.frame);
    shuffleFrame.origin.y = self.bounds.size.height - 40.0f - NextView_Height;
    shuffleButton.frame = shuffleFrame;
    
    CGRect songFrame = songTitleLabel.frame;
    songFrame.origin.x = 16.0f;
    songFrame.origin.y = self.bounds.size.height - 24.0f - CGRectGetHeight(songTitleLabel.frame) - NextView_Height;
    songFrame.size.width = shuffleFrame.origin.x - 25.0f;
//    if(songFrame.size.width  > shuffleFrame.origin.x - 25.0f){
//        songFrame.size.width = shuffleFrame.origin.x - 25.0f;
//    }
    songTitleLabel.frame = songFrame;
    
    CGRect artistFrame = artistTitleLabel.frame;
    artistFrame.origin.x = CGRectGetMinX(songTitleLabel.frame);
    artistFrame.origin.y = CGRectGetMaxY(songTitleLabel.frame) + 5.0f;
    artistFrame.size.width =CGRectGetMaxX(songTitleLabel.frame);
//    if(artistFrame.size.width > shuffleFrame.origin.x + 25.0f){
//        artistFrame.size.width = shuffleFrame.origin.x - 25.0f;
//    }
    artistTitleLabel.frame = artistFrame;
    
//    CGRect nextViewFrame = nextSongViwe.frame;
    nextViewFrame.origin.x = 0.0f;
    nextViewFrame.origin.y = CGRectGetHeight(artwork.frame) + CGRectGetHeight(whiteView.frame) + ((NextView_Height - CGRectGetHeight(nextSongViwe.frame)) / 2);
    nextViewFrame.size.width = self.bounds.size.width;
    nextViewFrame.size.height = (self.bounds.size.height -  CGRectGetHeight(artwork.frame) -CGRectGetHeight(whiteView.frame)) * 0.7;
    nextSongViwe.frame = nextViewFrame;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapToggleButton:(UITapGestureRecognizer *)sender
{
    NSLog(@"TAP");
    if(self.tappedToggleButton){
        if (_playing) {
            self.tappedToggleButton(YES);
            [toggleButton setImage:[UIImage imageNamed:@"play_w.png"] forState:UIControlStateNormal];
            [toggleButton setImage:[UIImage imageNamed:@"play_o.png"] forState:UIControlStateHighlighted];
            _playing = NO;
        } else {
            self.tappedToggleButton(NO);
            [toggleButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            _playing = YES;
        }
    }
}

- (void)tapNextButton:(UITapGestureRecognizer *)sender
{
    if(self.tappedNextButton){
        self.tappedNextButton();
    }
}

- (void)tapPrevButton:(UITapGestureRecognizer *)sender
{
    if(self.tappedPrevButton){
        self.tappedPrevButton();
    }
}

- (void)tapRepeatButton:(UITapGestureRecognizer *)sender
{
    if(self.tappedRepeatButton){
        if(_isRepeat){
            self.tappedRepeatButton(NO);
            [repeatButton setImage:[UIImage imageNamed:@"loop_g.png"] forState:UIControlStateNormal];
            _isRepeat = NO;
        }else{
            self.tappedRepeatButton(YES);
            [repeatButton setImage:[UIImage imageNamed:@"loop_o.png"] forState:UIControlStateNormal];
            _isRepeat = YES;
        }
    }
}

- (void)tapShuffleButton:(UITapGestureRecognizer *)sender
{
    if(self.shuffleButton){
        if(_isShuffle){
            self.tappedShuffleButton(NO);
            [shuffleButton setImage:[UIImage imageNamed:@"shuffle_g.png"] forState:UIControlStateNormal];
            _isShuffle = NO;
        }else{
            self.tappedShuffleButton(YES);
            [shuffleButton setImage:[UIImage imageNamed:@"shuffle_o.png"] forState:UIControlStateNormal];
            _isShuffle = YES;
        }
    }
}

- (UIView *)gradationImage:(UIView *)view startColor:(UIColor *)startColor centerColor:(UIColor *)centerColor endColor:(UIColor *)endColor
{
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    NSInteger angle = angle0;
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)startColor.CGColor,
                            (id)centerColor,
                            (id)endColor.CGColor,
                            nil];
    
    CGPoint startPoint = CGPointMake(0.0f, 0.0f);
    CGPoint endPoint = CGPointMake(0.0f, 0.0f);
    
    switch (angle) {
        case angle0:
            startPoint = CGPointMake(0.5f, 0.0f);
            endPoint = CGPointMake(0.5f, 1.0f);
            break;
        case angle45:
            startPoint = CGPointMake(1.0f, 0.0f);
            endPoint = CGPointMake(0.0f, 1.0f);
            break;
        case angle90:
            startPoint = CGPointMake(1.0f, 0.5f);
            endPoint = CGPointMake(0.0f, 0.5f);
            break;
        default:
            startPoint = CGPointMake(0.5f, 0.0f);
            endPoint = CGPointMake(0.5f, 1.0f);
            break;
    }
    
    [gradientLayer setStartPoint:startPoint];
    [gradientLayer setEndPoint:endPoint];
    [view.layer insertSublayer:gradientLayer atIndex:0];
    return view;
}

@end
