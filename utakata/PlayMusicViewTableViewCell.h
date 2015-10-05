//
//  PlayMusicViewTableViewCell.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicItems.h"
#import "UAProgressView.h"

@interface PlayMusicViewTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier musicItem:(MusicItems *)musicItem repeat:(BOOL)repeat shuffle:(BOOL)shuffle;
@property (nonatomic) UAProgressView *timeProgress;
@property (copy) void (^tappedToggleButton)(BOOL playing);
@property (copy) void (^tappedNextButton)();
@property (copy) void (^tappedPrevButton)();
@property (copy) void (^tappedShuffleButton)(BOOL isShuffle);
@property (copy) void (^tappedRepeatButton)(BOOL isRepeat);
@property (nonatomic) UILabel *songProgressTime;
@property (nonatomic) UILabel *songTime;
@property (nonatomic) BOOL playing;
@property (nonatomic) UIButton *toggleButton;
@property (nonatomic) UILabel *songTitleLabel;
@property (nonatomic) UILabel *artistTitleLabel;
@property (nonatomic) UIButton *repeatButton;
@property (nonatomic) UIButton *shuffleButton;
@property (nonatomic) BOOL isShuffle;
@property (nonatomic) BOOL isRepeat;
@property (nonatomic) UIImageView *artwork;
@property (nonatomic) UILabel *nextSongName;
@property (nonatomic) UILabel *nextSongArtistName;
@property (nonatomic) UIButton *nextImage;
@property (nonatomic) UILabel *nextLabel;
@end
