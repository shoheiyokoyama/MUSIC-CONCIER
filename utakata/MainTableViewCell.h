//
//  MainTableViewCell.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/31.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *songTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;


@end
