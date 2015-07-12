//
//  ListKaraokeSong.h
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/2/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListKaraokeSong : UITableViewController<NSURLConnectionDataDelegate, NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSDictionary *request;
@property (strong, nonatomic) NSMutableArray *arrSongs;
@property (strong, nonatomic) NSMutableDictionary *Items;
@property (strong, nonatomic) NSMutableDictionary *receiverDatawithURL;//save recvieve data follow request URL String

@end
