//
//  MusicInfoView.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MusicInfoView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MusicInfoView()
@property (nonatomic) UIButton *repeatButton;
@property (nonatomic) UIButton *shuffleButton;
@property (nonatomic) UILabel *songTitleLabel;
@property (nonatomic) UILabel *artistTitleLabel;
@property (nonatomic) UIImageView *artwork;
@end

@implementation MusicInfoView
@synthesize repeatButton;
@synthesize shuffleButton;
@synthesize songTitleLabel;
@synthesize artistTitleLabel;
@synthesize artwork;

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl songTitle:(NSString *)songTitle artistTitle:(NSString *)artistTitle
{
    self = [self initWithFrame:frame];
    if (self) {
        songTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        songTitleLabel.textColor = [UIColor whiteColor];
        songTitleLabel.font = [UIFont systemFontOfSize:15];
        songTitleLabel.text = @"TITLE";
        songTitleLabel.text = songTitle;
        [songTitleLabel sizeToFit];
        [self addSubview:songTitleLabel];
        
        artistTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        artistTitleLabel.textColor = [UIColor whiteColor];
        artistTitleLabel.font = [UIFont systemFontOfSize:10];
        artistTitleLabel.text = @"ARTISTTITLE";
        artistTitleLabel.text = artistTitle;
        [artistTitleLabel sizeToFit];
        [self addSubview:artistTitleLabel];
        
        artwork = [[UIImageView alloc] initWithFrame:CGRectZero];
        artwork.backgroundColor = [UIColor whiteColor];
        [self addSubview:artwork];

        [artwork sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        [repeatButton setImage:[UIImage imageNamed:@"loop_white.png"] forState:UIControlStateNormal];
        repeatButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRepeatButton:)];
        [repeatButton addGestureRecognizer:tapGesture];
        [self addSubview:repeatButton];
        
        shuffleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        [shuffleButton setImage:[UIImage imageNamed:@"shuffle_white.png"] forState:UIControlStateNormal];
        shuffleButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapShuffleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShuffleButton:)];
        [shuffleButton addGestureRecognizer:tapShuffleGesture];
        [self addSubview:shuffleButton];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect repeatFrame = repeatButton.frame;
    repeatFrame.origin.x = self.bounds.size.width - 15.0f - CGRectGetWidth(repeatButton.frame);
    repeatFrame.origin.y = self.bounds.size.height - 40.0f;
    repeatButton.frame = repeatFrame;
    
    CGRect shuffleFrame = shuffleButton.frame;
    shuffleFrame.origin.x = CGRectGetMinX(repeatButton.frame) - 10.0f - CGRectGetWidth(shuffleButton.frame);
    shuffleFrame.origin.y = self.bounds.size.height - 40.0f;
    shuffleButton.frame = shuffleFrame;
    
    CGRect artworkFrame = artwork.frame;
    artworkFrame.origin.x = 17.0f;
    artworkFrame.origin.y = 100.0f;
    artworkFrame.size.width = self.bounds.size.width - 34.0f;
    artworkFrame.size.height = self.bounds.size.height - 170.0f;
    artwork.frame = artworkFrame;
    
    //UIScreen *sc = [UIScreen mainScreen];
    //float deviceWidth = sc.bounds.size.width;
    
    CGRect songFrame = songTitleLabel.frame;
    songFrame.origin.x = 25.0f;
    songFrame.origin.y = self.bounds.size.height - 30.0f - CGRectGetHeight(songTitleLabel.frame);
    if(songFrame.size.width  > shuffleFrame.origin.x){
        songFrame.size.width = shuffleFrame.origin.x - 25.0f;
    }
    songTitleLabel.frame = songFrame;
    
    CGRect artistFrame = artistTitleLabel.frame;
    artistFrame.origin.x = CGRectGetMinX(songTitleLabel.frame);
    artistFrame.origin.y = CGRectGetMaxY(songTitleLabel.frame) + 5.0f;
    if(artistFrame.size.width > shuffleFrame.origin.x){
        artistFrame.size.width = shuffleFrame.origin.x - 25.0f;
    }
    artistTitleLabel.frame = artistFrame;
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1.0);
    CGContextSetLineWidth(context, 1.0f);
    float startY = CGRectGetMidY(songTitleLabel.frame);
    float endY = CGRectGetMidY(artistTitleLabel.frame);
    CGContextMoveToPoint(context, 17.0f, startY);
    CGContextAddLineToPoint(context, 17.0f, endY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}

- (void)tapRepeatButton:(UITapGestureRecognizer *)sender
{
    if(self.tappedRepeatButton){
        self.tappedRepeatButton();
    }
}

- (void)tapShuffleButton:(UITapGestureRecognizer *)sender
{
    if(self.tappedShuffleButton){
        self.tappedShuffleButton();
    }
}

@end
