//
//  MusicServiceManager.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MusicServiceManager.h"
#import "MusicItems.h"
#import "AFNetworking.h"

#define REQUESTURL @"http://localhost:3000/.json"

@interface MusicServiceManager()
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSMutableArray *songsGroupByAlbam;
@end
@implementation MusicServiceManager

static MusicServiceManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MusicServiceManager alloc] init];
    });
    return sharedManager;
}

- (void)getJsonData:(GetRemoteCompletionHandler)completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = @"http://cyber.ei-plus.com/api/genre?genre=Mix";
    NSString* encodeString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodeString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             //NSLog(@"success: %@", responseObject);
             _items = [NSMutableArray array];
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
             //NSLog(@"%@", dic);
             NSArray *results = dic[@"results"];
             for (NSDictionary *result in results) {
                 MusicItems *musics = [[MusicItems alloc] initWithData:result];
                 [_items addObject:musics];
             }
             
             if (completionHandler) {
                 completionHandler(_items, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"error: %@", error);
             
             if (completionHandler) {
                 completionHandler(nil, error);
             }
         }];
}


- (void)getSimilarSong:(GetRemoteCompletionHandler)completionHandler track_name:(NSString *)track_name artist_name:(NSString*)artist_name
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://cyber.ei-plus.com/api/play?track_name=%@&artist_name=%@",track_name,artist_name];
    NSString* encodeString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:encodeString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             //NSLog(@"success: %@", responseObject);
             _songsGroupByAlbam = [NSMutableArray array];
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
             NSLog(@"%@", dic.description);
             NSArray *results = dic[@"results"];

             for (NSDictionary *result in results) {
                 MusicItems *musics = [[MusicItems alloc] initWithData:result];
                 [_songsGroupByAlbam addObject:musics];
             }
             
             if (completionHandler) {
                 completionHandler(_songsGroupByAlbam, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"error: %@", error);
             
             if (completionHandler) {
                 completionHandler(nil, error);
             }
         }];
}

- (void)getGenreSong:(GetRemoteCompletionHandler)completionHandler GenreTitle:(NSString *)GenreTitle
{
    NSString *requestUrl = [NSString stringWithFormat:@"http://cyber.ei-plus.com/api/genre?genre=%@",GenreTitle];
    NSString* encodeString = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:encodeString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             NSMutableArray *songGroupByGenre = [NSMutableArray array];
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
             NSError *error = nil;
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
             
             NSLog(@"%@", dic.description);
             NSArray *results = dic[@"results"];
             for (NSDictionary *result in results) {
                 MusicItems *musics = [[MusicItems alloc] initWithData:result];
                 [songGroupByGenre addObject:musics];
             }
             
             if (completionHandler) {
                 completionHandler(songGroupByGenre, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"error: %@", error);
             
             if (completionHandler) {
                 completionHandler(nil, error);
             }
         }];
}

@end
