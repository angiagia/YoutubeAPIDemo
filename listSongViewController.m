//
//  listSongViewController.m
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/9/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import "listSongViewController.h"
#import <Parse/Parse.h>

@interface listSongViewController ()

@property (strong, nonatomic) CoredataHelper *coreDataHelper;
@end


@implementation listSongViewController
int indexOfSong;
//    -----------------ActionSheet for cell click
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIStoryboardSegue *segue;
    KaraokeSong *song =[self.arrSongsList objectAtIndex:indexOfSong];
    if(buttonIndex==0){
        NSLog(@"%ld", buttonIndex);
        KaraokeSong *song = [self.arrSongsList objectAtIndex:indexOfSong];
        
//        ViewController *second=[[ViewController alloc] initWithNibName:nil bundle:nil];
        //    self.arrImage =arrDataRequest;
//        [self.navigationController pushViewController:second animated:YES];
//        second.idOfSong =song.idSong;
        
        
//        ViewController *viewController = [[ViewController alloc] init];
        ViewController *nextController = segue.destinationViewController;
        nextController.idOfSong=song.idSong;
//        NSLog(@"%@",song.idSong);
        // Perform Segue
        [self performSegueWithIdentifier:@"pushToOnlySing" sender:nil];
//        if ([segue.identifier isEqualToString:@"pushOnlySing"]){
//            ViewController *nextController = segue.destinationViewController;
//            nextController.idOfSong=song.idSong;
//        }
        
    }
    else if(buttonIndex==1){
        NSLog(@"%ld", buttonIndex);
    }else if(buttonIndex==2){
        NSLog(@"%ld", buttonIndex);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate=self;
    [self initData];
//    [self requestToServerYoutubeAPI];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KaraokeSong"];
    NSError *requestError=nil;
    self.arrSongsList = [managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if([self.arrSongsList count]>1)
    {
        
        for(KaraokeSong *song in self.arrSongsList){
            NSLog(@"%@ - %@", song.nameSong, song.idSong);
            
        }
        
        [self.tableListSong reloadData];
    }
    else
    {
        NSLog(@"No attribute for this entity!");
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
//    [self deleteAllInCoreData];
    [super viewDidAppear:self];
    // Fetch the devices from persistent data store
    
}
-(void)deleteAllInCoreData{
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest * allSong = [[NSFetchRequest alloc] init];
    [allSong setEntity:[NSEntityDescription entityForName:@"KaraokeSong" inManagedObjectContext:context]];
    [allSong setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * songs = [context executeFetchRequest:allSong error:&error];
    //error handling goes here
    for (NSManagedObject * car in songs) {
        [context deleteObject:car];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}
-(void)initData{
    self.arrSongsList =[[NSMutableArray alloc] init];
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
        [self insertArrSongs:[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"] idSong:[[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"resourceId"] objectForKey:@"videoId"]];
        NSLog(@"%@ -%@",[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"title"],[[[[self.arrSongs objectAtIndex:i] objectForKey:@"snippet"] objectForKey:@"resourceId"] objectForKey:@"videoId"]);
    }
    UIAlertView *aleart=[[UIAlertView alloc]initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"Insert to data",nil] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [aleart show];

    [self.tableListSong reloadData];
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
    return self.arrSongsList.count;
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
    
    listSongCell *cell = [self.tableListSong dequeueReusableCellWithIdentifier:@"cellID"];
    
    if(!cell)
    {
        [self.tableListSong registerNib:[UINib nibWithNibName:@"listSongCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        cell =[self.tableListSong dequeueReusableCellWithIdentifier:@"cellID"];
        //        cell.nameSong.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row ];
        
    }
//    NSManagedObject *feed= [self.arrSongsList objectAtIndex:indexPath.row];
//    cell.nameSong.text = [NSString stringWithFormat:@"%@",[feed valueForKey:@"songName"] ];
    KaraokeSong *song = [self.arrSongsList objectAtIndex:indexPath.row];
    cell.nameSong.text=song.nameSong;
    return cell;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSManagedObjectContext *context =[self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"KaraokeSong" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchBar.text];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
//    NSArray* searchResults = [context executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"%@", searchResults);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the file?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Only sing"
                                                    otherButtonTitles:@"Add to favourite list", @"Sing and record", nil];
    indexOfSong=indexPath.row;
    [actionSheet showInView:self.view];
}

@end
