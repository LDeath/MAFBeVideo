//
//  KMPMoviePlayerController.m
//  BEVideo
//
//  Created by FM on 16/1/15.
//  Copyright © 2016年 BlueEye. All rights reserved.
//

#import "KMPMoviePlayerViewController.h"

@implementation KMPMoviePlayerViewController

-(id)initWithContentURL:(NSURL *)movieURL
{
    if(self = [super initWithContentURL:movieURL])
    {
        MPMoviePlayerController *theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        [theMovie play];
        
        // Remove the movie player view controller from the "playback did finish" notification observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:self.moviePlayer];
        
        // Register this class as an observer instead
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayer];
        
        // Set the modal transition style of your choice
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    // Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    // Dismiss the view controller ONLY when the reason is not "playback ended"
//    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
//    {
        MPMoviePlayerController *moviePlayer = [aNotification object];
        
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        
        // Dismiss the view controller
        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}
@end
