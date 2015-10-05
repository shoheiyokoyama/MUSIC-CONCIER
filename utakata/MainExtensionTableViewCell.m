//
//  MainExtensionTableViewCell.m
//  utakata
//
//  Created by 横山祥平 on 2015/09/02.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MainExtensionTableViewCell.h"

@interface MainExtensionTableViewCell()

@end
@implementation MainExtensionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += self.inset;
    frame.size.width -= 2 * self.inset;
    [super setFrame:frame];
}

@end
