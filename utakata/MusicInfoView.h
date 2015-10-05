//
//  MusicInfoView.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicInfoView : UIView
@property (copy) void (^tappedShuffleButton)();
@property (copy) void (^tappedRepeatButton)();
- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl songTitle:(NSString *)songTitle artistTitle:(NSString *)artistTitle;
@end
