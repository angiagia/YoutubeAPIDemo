//
//  KaraokeSong.m
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/8/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import "KaraokeSong.h"


@implementation KaraokeSong

@dynamic nameSong;
@dynamic idSong;

-(id)initKaraokeSong:(NSString*)nameSong idSong:(NSString *)idSong managedObjectContext:(NSManagedObjectContext *)context{
    KaraokeSong *song = [NSEntityDescription insertNewObjectForEntityForName:@"KaraokeSong"
                                                     inManagedObjectContext:context];
    song.nameSong=nameSong;
    song.idSong=idSong;
    return song;
}
@end
