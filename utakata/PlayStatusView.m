//
//  PlayStatusView.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/30.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "PlayStatusView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlayStatusView()

@end

@implementation PlayStatusView

@synthesize artwork;
@synthesize nextButton;
@synthesize toggleButton;
@synthesize artistTitleLabel;
@synthesize songTitleLabel;
@synthesize statusView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self addGestureRecognizer:tapGesture];
        
        
        artwork = [[UIImageView alloc] initWithFrame:CGRectZero];
        artwork.backgroundColor = [UIColor clearColor];
        [self addSubview:artwork];
        
//        [artwork sd_setImageWithURL:[NSURL URLWithString:_music.artworkUrl100] placeholderImage:nil];
        
        toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [toggleButton setImage:[UIImage imageNamed:_playing ? @"subbar_pause" : @"subbar_play"] forState:UIControlStateNormal];
        toggleButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapToggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToggleButton:)];
        [toggleButton addGestureRecognizer:tapToggleGesture];
        [self addSubview:toggleButton];
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        [nextButton setImage:[UIImage imageNamed:@"subbar_next"] forState:UIControlStateNormal];
        nextButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapNextGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNextButton:)];
        [nextButton addGestureRecognizer:tapNextGesture];
        [self addSubview:nextButton];
        
        songTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        songTitleLabel.textColor = [UIColor whiteColor];
        songTitleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:songTitleLabel];
        
//        artistTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        artistTitleLabel.textColor = [UIColor whiteColor];
//        artistTitleLabel.font = [UIFont systemFontOfSize:7];
//        [self addSubview:artistTitleLabel];
        
        statusView = [[UIProgressView alloc]initWithFrame:CGRectZero];
        statusView.tintColor = [UIColor colorWithRed:231/255.0 green:56/255.0 blue:40/255.0 alpha:1.0];
        [self addSubview:statusView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect artworkFrame = artwork.frame;
    artworkFrame.size.height = self.bounds.size.height;
    artworkFrame.size.width = self.bounds.size.height;
    artwork.frame = artworkFrame;
    
    CGRect toggleFrame = toggleButton.frame;
    toggleFrame.origin.x = CGRectGetMaxX(artwork.frame) + (CGRectGetMaxX(artwork.frame) - CGRectGetWidth(toggleButton.frame) ) /2;
    toggleFrame.origin.y = (self.bounds.size.height - CGRectGetHeight(toggleButton.frame)) / 2;
    toggleFrame.size.width = 20.0f;
    toggleFrame.size.height = 20.0f;
    toggleButton.frame = toggleFrame;
    
    CGRect nextFrame = nextButton.frame;
    nextFrame.origin.x = CGRectGetMaxX(artwork.frame) * 2 + (CGRectGetMaxX(artwork.frame) - CGRectGetWidth(nextButton.frame) ) /2;
    nextFrame.origin.y = (self.bounds.size.height - CGRectGetHeight(nextButton.frame)) / 2;
    nextFrame.size.width = 20.0f;
    nextFrame.size.height = 20.0f;
    nextButton.frame = nextFrame;
    
    float linePointX = CGRectGetMaxX(nextButton.frame) + (CGRectGetWidth(artwork.frame) / 2);
    CGRect songFrame = songTitleLabel.frame;
    songFrame.origin.x = linePointX + 5.0f;
    songFrame.origin.y = 8.0f;
    songTitleLabel.frame = songFrame;
    
    CGRect artistFrame = artistTitleLabel.frame;
    artistFrame.origin.x = CGRectGetMinX(songTitleLabel.frame);
    artistFrame.origin.y = CGRectGetMaxY(songTitleLabel.frame) + 5.0f;
    artistTitleLabel.frame = artistFrame;
    
    CGRect statusFrame = statusView.frame;
    statusFrame.size.width = self.bounds.size.width - CGRectGetMinX(songTitleLabel.frame) - 10.0f;
    statusFrame.origin.y = CGRectGetMaxY(songTitleLabel.frame) + 10.0f;
    statusFrame.origin.x = CGRectGetMinX(songTitleLabel.frame);
    statusView.frame = statusFrame;
}

//あとで実装
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0f);
    float x = CGRectGetMaxX(nextButton.frame) + 15;
    float startY = CGRectGetMinY(songTitleLabel.frame);
    float endY = self.bounds.size.height - 10.0f; // あとで調整
    CGContextMoveToPoint(context, x, startY);
    CGContextAddLineToPoint(context, x, endY);
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1.0);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

# pragma marl - tap Action

- (void)tapView:(UITapGestureRecognizer *)sender
{
    NSLog(@"TAP view");
    if (self.tappedView) {
        self.tappedView();
    }
}

- (void)tapToggleButton:(UITapGestureRecognizer *)sender
{
    NSLog(@"TAP");
    if(self.tappedToggleButton){
        if (_playing) {
            self.tappedToggleButton(YES);
            [toggleButton setImage:[UIImage imageNamed:@"subbar_play"] forState:UIControlStateNormal];
            _playing = NO;
        } else {
            self.tappedToggleButton(NO);
            [toggleButton setImage:[UIImage imageNamed:@"subbar_pause"] forState:UIControlStateNormal];
            _playing = YES;
        }
    }
}

- (void)tapNextButton:(UITapGestureRecognizer *)sender
{
    NSLog(@"TAP");
    if(self.tappedNextButton){
        self.tappedNextButton();
    }
}
@end
