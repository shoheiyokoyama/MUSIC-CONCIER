//
//  PlayAlbumSongViewController.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicItems.h"
#import "PlayMusicViewTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@class PlayAlbumSong;
@protocol PlayAlbumSongViewControllerDelegate <NSObject>

@required
- (void)playingPlayer:(AVAudioPlayer *)player playingIndex:(NSInteger)playingIndex shuffleData:(NSMutableArray*)shuffleData;
- (void)getPlayMusicViewTableData:(bool)isShuffle isRepeat:(BOOL)isRepeat;
- (void)getSimilarMusic:(BOOL)isSimilar;

@end

@interface PlayAlbumSongViewController : UIViewController

- (instancetype)initWithMusic:(NSMutableArray *)musciArray selectedNum:(NSInteger)selectedNum playingPlayer:(AVAudioPlayer *)playingPlayer isShuffle:(BOOL)isShuffle isRepeat:(BOOL)isRepeat;
@property (nonatomic) AVAudioPlayer *player;
@property (nonatomic) PlayMusicViewTableViewCell *playCell;
@property (nonatomic, weak) id<PlayAlbumSongViewControllerDelegate> playAlbumDelegate;
@end
