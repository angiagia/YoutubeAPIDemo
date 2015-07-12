//
//  ListKaraokeSong.m
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/2/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import "ListKaraokeSong.h"
#import <Coredata/CoreData.h>
#import "listSongCell.h"
#import "KaraokeSong.h"
#import "CoredataHelper.h"

@interface ListKaraokeSong ()

@property (strong, nonatomic) CoredataHelper *coreDataHelper;
@end

@implementation ListKaraokeSong
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self requestToServerYoutubeAPI];
    
}

-(void)initData{
    self.request=[[NSMutableDictionary alloc]init];
    self.arrSongs=[[NSMutableArray alloc] init];
    self.Items=[[NSMutableDictionary alloc] init];
}
//--------------------------------Get JSON from youtube API playlist
-(void)requestToServerYoutubeAPI{
    NSString *stringRequest=@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLJLnKbQ3yimePWSbqifs43MPHUj1zn4sL&key=AIzaSyA3Nwlz6uormK9I1fab0NnqE3atMadSQLQ";
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:stringRequest ] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if(!theConnection){
        self.request =nil;
    }
    [theConnection start];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *aleart=[[UIAlertView alloc]initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Can't connect to server %@",error] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [aleart show];
};
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString *absoluteURL = [connection.currentRequest.URL absoluteString];
    
    NSMutableData *receiveData = [self.receiverDatawithURL objectForKey:absoluteURL];
    
    if(receiveData){
        [receiveData appendData:data];
    }
};
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *absoluteURL = [connection.currentRequest.URL absoluteString];
    
    NSMutableData *receiveData = [self.receiverDatawithURL objectForKey:absoluteURL];
    
    self.request = [self parseJSON:receiveData];
    
    [self.receiverDatawithURL removeObjectForKey:absoluteURL];
    
    self.arrSongs=[self.request objectForKey:@"items"];
    
    NSLog(@"%ld",self.arrSongs.count);
    for(int i=0 ;i<self.arrSongs.count;i++)
    {
        [self insertArrSongs:[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"] idSong:[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"videoID"]];
        NSLog(@"%@ -%@",[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"],[[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"resourceId"] objectForKey:@"videoId"]);
    }
    [self.tableView reloadData];
}

-(void)insertArrSongs:(NSString*)nameSong idSong:(NSString*)idSong
{
    NSManagedObjectContext *context= [self managedObjectContext];
    KaraokeSong *song = [NSEntityDescription
                         insertNewObjectForEntityForName:@"KaraokeSong"
                         inManagedObjectContext:context];
    if (song != nil){
        song.nameSong = nameSong;
        song.idSong = idSong;
        NSError *savingError = nil;
        if ([context save:&savingError]){ NSLog(@"Successfully saved the context.");
        } else {
            NSLog(@"Failed to save the context. Error = %@", savingError);
        }
    } else {
        NSLog(@"Failed to create the new person.");
    }
}

- (NSDictionary*)parseJSON:(NSData*)data {
    NSError *jsonParsingError = nil;
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:0 error:&jsonParsingError];
}

-(void)insetNewSongToListKaraoke:(NSMutableArray *)arrSong{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSString *absoluteURL = [connection.currentRequest.URL absoluteString];
    
    
    NSLog(@"Request URL");
    
    if(!self.receiverDatawithURL)
    {
        self.receiverDatawithURL = [NSMutableDictionary dictionary];
    }
    
    //create recieve data for this URL
    NSMutableData *recieveData = [NSMutableData data];
    [self.receiverDatawithURL setObject:recieveData forKey:absoluteURL];
};
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrSongs.count;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    listSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"listSongCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
        //        cell.nameSong.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row ];
        
    }
    cell.nameSong.text=[[[self.arrSongs objectAtIndex:indexPath.row] objectForKey:@"snippet"] objectForKey:@"title"];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
