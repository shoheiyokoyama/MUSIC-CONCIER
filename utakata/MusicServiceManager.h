//
//  MusicServiceManager.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicServiceManager : NSObject
typedef void (^GetRemoteCompletionHandler)(NSMutableArray *items, NSError *error);
- (void)getJsonData:(GetRemoteCompletionHandler)completionHandler;
+ (instancetype)sharedManager;
- (void)getSimilarSong:(GetRemoteCompletionHandler)completionHandler track_name:(NSString *)track_name artist_name:(NSString*)artist_name;
- (void)getGenreSong:(GetRemoteCompletionHandler)completionHandler GenreTitle:(NSString *)GenreTitle;
@end
