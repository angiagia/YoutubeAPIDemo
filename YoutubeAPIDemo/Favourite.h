//
//  Favourite.h
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/8/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favourite : NSManagedObject

@property (nonatomic, retain) NSString * nameSong;
@property (nonatomic, retain) NSString * idSong;
-(id)initKaraokeSong:(NSString*)nameSong idSong:(NSString *)idSong managedObjectContext:(NSManagedObjectContext *)context;
@end
