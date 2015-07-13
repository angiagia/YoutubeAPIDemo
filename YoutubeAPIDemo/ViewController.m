//
//  ViewController.m
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/1/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController (){
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
    // --------------------CREATE YOUTUBE PLAYER------------------------
@property (strong, nonatomic) IBOutlet YTPlayerView *youtubePlayer;
@property (weak, nonatomic) IBOutlet YTPlayerView *viewPlayer;

@end

@implementation ViewController

@synthesize stopButton, playButton, recordPauseButton;


- (IBAction)playVideo:(id)sender {
    [self.viewPlayer playVideo];
}

- (IBAction)stopVideo:(id)sender {
    [self.viewPlayer stopVideo];
}
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
        {
            NSLog(@"Started playback");
            [self recordPauseTapped];
        }
            break;
        case kYTPlayerStatePaused:
        {
            NSLog(@"Paused playback");
            [self recordPauseTapped];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewPlayer.delegate = self;
//    [self.viewPlayer loadWithVideoId:@"emfGE2hy51Q"];
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    [self.viewPlayer loadWithVideoId:[NSString stringWithFormat:@"%@",self.idOfSong] playerVars:playerVars];
    
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)recordPauseTapped {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
//        [recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        NSLog(@"Play recoder");
        
    } else {
        
        // Pause recording
        [recorder pause];
//        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
        NSLog(@"Pause recoding");
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    NSLog(@"Stop recoding");
}

- (IBAction)playTapped:(id)sender{
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
