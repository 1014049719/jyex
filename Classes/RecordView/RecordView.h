//
//  PPDrawer.h
//  NoteBook
//
//  Created by chen wu on 09-7-22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol RecordViewDelegate;
@interface RecordView: UIView<AVAudioRecorderDelegate> {
    
    AVAudioSession *session;
    AVAudioRecorder *recorder;
    
    UILabel *lbTime;
    UIProgressView *meter1;
    UIProgressView *meter2;
    
    NSTimer *timer;
    NSTimer *timerStop;
    
    NSString *strFilePath;
	id<RecordViewDelegate> delegate;

}

@property(nonatomic,retain) NSString *strFilePath;
@property(nonatomic,assign) id<RecordViewDelegate> delegate;


- (id) initWithFrame:(CGRect)frame andFile:(NSString *) path;
- (void) startRecord;
- (void) stopRecording;

@end


@protocol RecordViewDelegate<NSObject>

-(void) RecordFinish:(RecordView *) RecordView successfully:(BOOL)flag;

@end


