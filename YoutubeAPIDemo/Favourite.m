//
//  Favourite.m
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/8/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import "Favourite.h"


@implementation Favourite

@dynamic nameSong;
@dynamic idSong;
-(id)initKaraokeSong:(NSString*)nameSong idSong:(NSString *)idSong managedObjectContext:(NSManagedObjectContext *)context{
    Favourite *favourite = [NSEntityDescription insertNewObjectForEntityForName:@"Favourite"
                                                      inManagedObjectContext:context];
    favourite.nameSong=nameSong;
    favourite.idSong=idSong;
    return favourite;
}
@end
