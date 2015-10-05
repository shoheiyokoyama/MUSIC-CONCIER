//
//  SuggestionTableViewCell.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/30.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "SuggestionTableViewCell.h"

#define PagerHeight 40

@interface SuggestionTableViewCell()
@property (nonatomic) UIView *textView;
@property (nonatomic) UIImageView *headerView;
@end

@implementation SuggestionTableViewCell

@synthesize suggestView;
@synthesize positionLabel;
@synthesize nameLabel;
@synthesize commentLabel;
@synthesize textView;
@synthesize headerView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor yellowColor];
//        headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"concierge"]];
//        [self addSubview:headerView];

        suggestView = [[SuggestionView alloc] initWithFrame:CGRectZero];
        [self addSubview:suggestView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [positionLabel sizeToFit];
    [nameLabel sizeToFit];
    [commentLabel sizeToFit];
    
    CGRect suggestFrame = suggestView.frame;
    suggestFrame.size.width = self.bounds.size.width;
    suggestFrame.size.height = self.bounds.size.height;
    suggestView.frame = suggestFrame;
    
    //SuggestionView のパラメータと合わせる -> 変えたらSuggestionViewも変えること
    float conciergeImageWidth = CGRectGetHeight(self.bounds) - PagerHeight -30.0f;
    float conciergeMarginY = 10.0f;
    float imageMarginX = 5.0f;
    float textMarginX = 15.0f;
    
    CGRect textFrame = textView.frame;
    textFrame.origin.x = conciergeImageWidth + 15.0f;
    textFrame.origin.y = conciergeMarginY;
    textFrame.size.width = self.bounds.size.width - imageMarginX - conciergeImageWidth - textMarginX - imageMarginX; // iPhone 5sだとテキストが少しはみでる
//    textFrame.size.width = 180.0f; //iPhone - 6 に合わせた
    textFrame.size.height = conciergeImageWidth;
    textView.frame = textFrame;
    
    CGRect pagerFrame = headerView.frame;
    pagerFrame.origin.y = self.bounds.size.height - PagerHeight;
    pagerFrame.size.width = self.bounds.size.width;
    pagerFrame.size.height = PagerHeight;
    headerView.frame = pagerFrame;
    
    CGRect positionFrame = positionLabel.frame;
    positionFrame.origin.x = 5.0f;
    positionFrame.origin.y = 5.0f;
    positionLabel.frame = positionFrame;
    
    CGRect nameFrame = nameLabel.frame;
    nameFrame.origin.x = CGRectGetMinX(positionLabel.frame);
    nameFrame.origin.y = CGRectGetMinY(positionLabel.frame) + 25.0f;
    nameLabel.frame = nameFrame;
    
    CGRect commentFrame = commentLabel.frame;
    commentFrame.origin.x = CGRectGetMinX(positionLabel.frame);
    commentFrame.origin.y = CGRectGetMinY(nameLabel.frame) + 50.0f;
    commentLabel.frame = commentFrame;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
