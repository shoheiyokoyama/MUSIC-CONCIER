//
//  SuggestionView.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuggestionView;
@protocol  SuggestionViewDelegate <NSObject>

@required
- (void)changePage:(NSInteger)pageIndex;
- (void)scrollControll;
@end

@interface SuggestionView : UIView
@property (copy) void (^tappedRefreshButton)();
@property (nonatomic) UIPageControl *pager;
@property (nonatomic, weak) id<SuggestionViewDelegate> suggestionViewDelegate;
@end
