//
//  ViewController.h
//  YoutubeAPIDemo
//
//  Created by Gia An on 7/1/15.
//  Copyright (c) 2015 GIAAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YTPlayerView.h"
@interface ViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate,YTPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) NSString *idOfSong;

- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;
- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;
@end

