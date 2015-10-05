//
//  PlayStatusView.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/30.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayStatusView : UIView
@property (nonatomic) UIImageView *artwork;
@property (nonatomic) UIButton *nextButton;
@property (nonatomic) UIButton *toggleButton;
@property (copy) void (^tappedToggleButton)(BOOL playing);
@property (copy) void (^tappedNextButton)();
@property (copy) void (^tappedView)();
@property (nonatomic) BOOL playing;
@property (nonatomic) UILabel *songTitleLabel;
@property (nonatomic) UILabel *artistTitleLabel;
@property (nonatomic) UIProgressView *statusView;
@end
