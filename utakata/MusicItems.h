//
//  MusicItems.h
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicItems : NSObject
@property (nonatomic) NSString *albumName;
@property (nonatomic) NSString *albumId;
@property (nonatomic) NSString *artistName;
@property (nonatomic) NSNumber *artistId;
@property (nonatomic) NSString *artworkUrl60;
@property (nonatomic) NSString *artworkUrl100;
@property (nonatomic) NSString *songName;
@property (nonatomic) NSString *previewUrl;
- (instancetype)initWithData:(NSDictionary *)dictionary;
@end
