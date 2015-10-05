//
//  MusicControllView.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

@interface MusicControllView : UIView
@property (nonatomic) UAProgressView *timeProgress;
@property (nonatomic) UILabel *songProgressTime;
@property (nonatomic) UILabel *songTime;
@property (copy) void (^tappedToggleButton)(BOOL playing);
@property (copy) void (^tappedNextButton)();
@property (copy) void (^tappedPrevButton)();
- (instancetype)initWithFrame:(CGRect)frame sonfTime:(NSString *)sonfTime;
@end
