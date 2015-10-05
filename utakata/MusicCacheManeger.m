//
//  MusicCacheManeger.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/29.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MusicCacheManeger.h"

@interface MusicCacheManeger()

@end
@implementation MusicCacheManeger

static MusicCacheManeger *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MusicCacheManeger alloc] init];
    });
    return sharedManager;
}

- (void)saveData:(NSMutableArray *)array
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    
    BOOL successful = [NSKeyedArchiver archiveRootObject:array toFile:filePath];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
    }
}

- (void)saveMusicArray:(NSMutableArray *)array fileName:(NSString *)fileName
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dataFileName = [NSString stringWithFormat:@"%@.dat", fileName];
    NSString *filePath = [directory stringByAppendingPathComponent:dataFileName];
    
    BOOL successful = [NSKeyedArchiver archiveRootObject:array toFile:filePath];
    if (successful) {
        NSLog(@"%@", @"データの保存に成功しました。");
    }
}

- (NSMutableArray *)getMusicArray:(NSString *)fileName
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dataFileName = [NSString stringWithFormat:@"%@.dat", fileName];
    NSString *filePath = [directory stringByAppendingPathComponent:dataFileName];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!array) {
        NSLog(@"%@", @"データが存在しません。");
    }
    return array;
}

- (NSMutableArray *)getData
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [directory stringByAppendingPathComponent:@"data.dat"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!array) {
        NSLog(@"%@", @"データが存在しません。");
    }
    return array;
}

@end
