//
//  SuggestionTableViewCell.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/30.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestionView.h"

@interface SuggestionTableViewCell : UITableViewCell
@property (nonatomic) UILabel *positionLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *commentLabel;
@property (nonatomic) SuggestionView *suggestView;
@property (nonatomic) NSString *message;
@end
