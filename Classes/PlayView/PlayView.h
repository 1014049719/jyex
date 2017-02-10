//
//  PlayView.h
//  NoteBook
//
//  Created by chen wu on 09-7-22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol PlayViewDelegate;
@interface PlayView: UIView<AVAudioPlayerDelegate> {
    
    AVAudioSession *session;
    AVAudioPlayer *player;
    
    UIImageView *viBack;
    
    UILabel *lbTime1;
    UILabel *lbTime2;
    UIProgressView *meter1;
    
    UIButton *btnPlay;
    UIButton *btnPause;
    UIButton *btnFinish;
    
    UIImageView *viCurHint;
    CGFloat originx;
    
    NSTimer *timer;
    
    NSString *strFilePath;
	id<PlayViewDelegate> delegate;

}

@property(nonatomic,retain) NSString *strFilePath;
@property(nonatomic,assign) id<PlayViewDelegate> delegate;


- (id) initWithFrame:(CGRect)frame;

- (void) exitPlaying;
- (void) startPlay:(NSString *) path;
- (void) stopPlaying;
- (void) continuePlaying;
- (void) pauseRecording;


@end


@protocol PlayViewDelegate<NSObject>

-(void) PlayFinish;

@end


