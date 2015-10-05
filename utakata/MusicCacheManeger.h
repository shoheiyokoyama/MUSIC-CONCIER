//
//  MusicCacheManeger.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicCacheManeger : NSObject
+ (instancetype)sharedManager;
- (void)saveData:(NSMutableArray *)array;
- (NSMutableArray *)getData;
- (NSMutableArray *)getMusicArray:(NSString *)fileName;
- (void)saveMusicArray:(NSMutableArray *)array fileName:(NSString *)fileName;
@end
