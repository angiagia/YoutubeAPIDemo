//
//  CoredataHelper.m
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/8/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import "CoredataHelper.h"

@implementation CoredataHelper

- (NSArray*)fetchSong
{
    NSManagedObjectContext *moc = self.context;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"KaraokeSong" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    return array;
}

- (NSArray*)fetchFavourite{
    NSManagedObjectContext *moc = self.context;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Favourite" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    return array;
}

- (BOOL)deleteSongInFavourite:(Favourite*)object{
    [self.context deleteObject:object];
    
    return YES;
}

- (KaraokeSong*)queryKaraokeWithName:(NSString*)nameSong{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"KaraokeSong"
                inManagedObjectContext:self.context];
    [request setEntity:entity];
    
    //query condition
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"nameSong LIKE[c] %@", nameSong];
    [request setPredicate:predicate];
    
    //sort option
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"firstName" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        //
    }
    else {
        // Deal with error.
    }
    
    
    return array[0];
}
-(BOOL)addKaraokeSong:(NSString*)nameSong idSong:(NSString*)idSong{
    BOOL result = NO;
    if ([nameSong length] == 0 ||
        [idSong length] == 0){
        NSLog(@"Name and ID are mandatory."); return NO;
    }
    KaraokeSong *newsong = [NSEntityDescription
                         insertNewObjectForEntityForName:@"KaraokeSong"
                         inManagedObjectContext:self.context];
    if (newsong == nil){
        NSLog(@"Failed to create the new person."); return NO;
    }
    newsong.nameSong=nameSong;
    newsong.idSong=idSong;
    NSError *savingError = nil;
    if ([self.context save:&savingError]){ return YES;
    } else {
        NSLog(@"Failed to save the new person. Error = %@", savingError);
    }
    return result;
}
- (void)saveContext{
    
    [self.context save:nil];
}

@end
