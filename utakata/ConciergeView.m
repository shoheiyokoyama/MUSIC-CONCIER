//
//  ConciergeView.m
//  utakata
//
//  Created by 横山祥平 on 2015/09/02.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "ConciergeView.h"

@interface ConciergeView()

@end
@implementation ConciergeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _conciergeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"concierge_shadow"]];
        [self addSubview:_conciergeView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect conFrame = _conciergeView.frame;
    conFrame.size.width = self.bounds.size.width;
    conFrame.size.height = self.bounds.size.height;
    _conciergeView.frame = conFrame;
}
@end
