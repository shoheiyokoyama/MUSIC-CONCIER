//
//  MusicItems.m
//  utakata
//
//  Created by 横山祥平 on 2015/08/28.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

#import "MusicItems.h"

@interface MusicItems()<NSCoding>

@end
@implementation MusicItems

@synthesize songName;
@synthesize artistName;
@synthesize artistId;
@synthesize artworkUrl60;
@synthesize artworkUrl100;
@synthesize albumName;
@synthesize albumId;
@synthesize previewUrl;

- (instancetype)initWithData:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if (dictionary[@"trackName"]) {
            songName = dictionary[@"trackName"];
        }
        
        if (dictionary[@"artistId"]) {
            artistId = dictionary[@"artistId"];
        }
        
        if (dictionary[@"artworkUrl60"]) {
            artworkUrl60 = dictionary[@"artworkUrl60"];
        }
        
        if (dictionary[@"artworkUrl100"]) {
            artworkUrl100 = dictionary[@"artworkUrl100"];
        }
        
        if (dictionary[@"collectionName"]) {
            albumName = dictionary[@"collectionName"];
        }
        
        if (dictionary[@"previewUrl"]) {
            previewUrl = dictionary[@"previewUrl"];
        }

        if (dictionary[@"artistName"]) {
            artistName = dictionary[@"artistName"];
        }
        if (dictionary[@"collectionId"]) {
            albumId = dictionary[@"collectionId"];
        }
    }

    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        songName = [aDecoder decodeObjectForKey:@"trackName"];
        artistId = [aDecoder decodeObjectForKey:@"artistId"];
        artworkUrl60 = [aDecoder decodeObjectForKey:@"artworkUrl60"];
        artworkUrl100 = [aDecoder decodeObjectForKey:@"artworkUrl100"];
        albumName = [aDecoder decodeObjectForKey:@"collectionName"];
        previewUrl = [aDecoder decodeObjectForKey:@"previewUrl"];
        artistName = [aDecoder decodeObjectForKey:@"artistName"];
        albumId = [aDecoder decodeObjectForKey:@"collectionId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:songName forKey:@"trackName"];
    [encoder encodeObject:artistId forKey:@"artistId"];
    [encoder encodeObject:artworkUrl60 forKey:@"artworkUrl60"];
    [encoder encodeObject:artworkUrl100 forKey:@"artworkUrl100"];
    [encoder encodeObject:albumName forKey:@"collectionName"];
    [encoder encodeObject:previewUrl forKey:@"previewUrl"];
    [encoder encodeObject:albumName forKey:@"collectionName"];
    [encoder encodeObject:previewUrl forKey:@"previewUrl"];
    [encoder encodeObject:artistName forKey:@"artistName"];
    [encoder encodeObject:albumId forKey:@"collectionId"];
}

@end
