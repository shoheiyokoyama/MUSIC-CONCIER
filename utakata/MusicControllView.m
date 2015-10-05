//
//  MusicControllView.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MusicControllView.h"

@interface MusicControllView()
@property (nonatomic) UIButton *toggleButton;
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UIButton *prevButton;
@property (nonatomic) BOOL playing;
@end

@implementation MusicControllView
@synthesize toggleButton;
@synthesize timeProgress;
@synthesize nextButton;
@synthesize prevButton;
@synthesize songTime;
@synthesize songProgressTime;

- (instancetype)initWithFrame:(CGRect)frame sonfTime:(NSString *)sonfTime
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:0.2f];
        
        _playing = NO;
        
        timeProgress = [[UAProgressView alloc]initWithFrame:CGRectZero];
        timeProgress.borderWidth = 0.2;
        timeProgress.lineWidth = 3.0f;
        timeProgress.fillOnTouch = NO;
        timeProgress.tintColor = [UIColor whiteColor];
        [self addSubview:timeProgress];
        
        toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        [toggleButton setImage:[UIImage imageNamed:@"play_posh.png"] forState:UIControlStateNormal];
        toggleButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapToggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToggleButton:)];
        [toggleButton addGestureRecognizer:tapToggleGesture];
        [self addSubview:toggleButton];
        
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        [nextButton setImage:[UIImage imageNamed:@"next_r.png"] forState:UIControlStateNormal];
        nextButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapNextGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNextButton:)];
        [nextButton addGestureRecognizer:tapNextGesture];
        [self addSubview:nextButton];
        
        prevButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        [prevButton setImage:[UIImage imageNamed:@"next_l.png"] forState:UIControlStateNormal];
        prevButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapPrevGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPrevButton:)];
        [prevButton addGestureRecognizer:tapPrevGesture];
        [self addSubview:prevButton];
        
        songTime = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
        songTime.text = sonfTime;
        songTime.font = [UIFont systemFontOfSize:9];
        [songTime sizeToFit];
        [self addSubview:songTime];
        
        songProgressTime = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
//        songProgressTime.text = @"3:00";
        songProgressTime.font = [UIFont systemFontOfSize:9];
        [songProgressTime sizeToFit];
        [self addSubview:songProgressTime];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect toggleFrame = toggleButton.frame;
    toggleFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(toggleButton.frame)) / 2;
    toggleFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(toggleButton.frame)) / 2;
    toggleButton.frame = toggleFrame;
    
    CGRect nextFrame = nextButton.frame;
    nextFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(nextButton.frame)) / 2 + 120.0f;
    nextFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(nextButton.frame)) / 2;
    nextButton.frame = nextFrame;
    
    CGRect prevFrame = prevButton.frame;
    prevFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(prevButton.frame)) / 2 - 120.0f;
    prevFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(prevButton.frame)) / 2;
    prevButton.frame = prevFrame;
    
    CGRect songTimeFrame = songTime.frame;
    songTimeFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(songTime.frame)) / 2 + 20.0f;
    songTimeFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(songTime.frame)) / 2 + 50.0f;
    songTime.frame = songTimeFrame;
    
    CGRect songProgressTimeFrame = songProgressTime.frame;
    songProgressTimeFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(songProgressTime.frame)) / 2 - 20.0f;
    songProgressTimeFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(songProgressTime.frame)) / 2 + 50.0f;
    songProgressTime.frame = songProgressTimeFrame;
    
    CGRect progressFrame = timeProgress.frame;
    progressFrame.size.width = 160.0f;
    progressFrame.size.height = 160.0f;
    progressFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(timeProgress.frame)) / 2;
    progressFrame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(timeProgress.frame)) / 2;
    timeProgress.frame = progressFrame;

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0f);
    float x = CGRectGetMidX(toggleButton.frame);
    float startY = CGRectGetMinY(songTime.frame);
    float endY = CGRectGetMaxY(songTime.frame);
    CGContextMoveToPoint(context, x, startY);
    CGContextAddLineToPoint(context, x, endY);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}

# pragma marl - tap Action

- (void)tapToggleButton:(UITapGestureRecognizer *)sender
{
    NSLog(@"TAP");
    if(self.tappedToggleButton){
        if (_playing) {
            self.tappedToggleButton(YES);
            [toggleButton setImage:[UIImage imageNamed:@"play_posh.png"] forState:UIControlStateNormal];
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

@end
