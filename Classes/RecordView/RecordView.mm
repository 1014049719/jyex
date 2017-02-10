//
//  PPDrawer.mm
//  NoteBook
//
//  Created by chen wu on 09-7-22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "RecordView.h"
#import "PubFunction.h"

#define XMAX	20.0f

#define DEVICE_ALARM()   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"录音设备不可用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];\
                    [alertView show];\
                    [alertView release];


@implementation RecordView
@synthesize strFilePath;
@synthesize delegate;

// path is backgroundImage path
- (id) initWithFrame:(CGRect)frame andFile:(NSString *) path 
{

    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.strFilePath = path;
        
        CGRect viewframe = self.frame;
        
        //创建背景图
        UIImageView *viBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewframe.size.width, viewframe.size.height)];
        viBack.image = [UIImage imageNamed:@"TongYongTouLan.png"];
        [self addSubview:viBack];
        [viBack release];
        
        //创建label
        CGSize size = [@"00:00" sizeWithFont:FONT_BUTTON ];
        
        CGRect rect = viewframe;
        rect.size.width = size.width+4;
        rect.size.height = size.height;
        rect.origin.x = (viewframe.size.width/4 - rect.size.width)/2;
        rect.origin.y = (viewframe.size.height - rect.size.height)/2;
        lbTime = [[UILabel alloc] initWithFrame:rect];
        lbTime.textColor = COLOR_BUTTON;
        lbTime.backgroundColor = [UIColor clearColor];
        lbTime.text = @"00:00";
        lbTime.font = FONT_BUTTON;
        [self addSubview:lbTime];
        
        //创建右边按钮
        rect.size.width = SIZE_BUTTON.width;
        rect.size.height = SIZE_BUTTON.height;
        rect.origin.x = (viewframe.size.width/4 - rect.size.width)/2  + viewframe.size.width*3/4;
        rect.origin.y = (viewframe.size.height - rect.size.height)/2;
        UIButton *btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFinish.frame = rect;
        [btnFinish addTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchUpInside];
        [btnFinish setTitle:@"停止" forState:nil];
        btnFinish.titleLabel.font = FONT_BUTTON;
        [btnFinish setTitleColor:COLOR_BUTTON forState:nil];
        [btnFinish setBackgroundColor:[UIColor clearColor]];
        [btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [self addSubview:btnFinish];
        
        
        //创建中间底图
        rect.size.width = viewframe.size.width/2;
        rect.size.height = SIZE_BUTTON.height;
        rect.origin.x = viewframe.size.width/4;
        rect.origin.y = (viewframe.size.height-rect.size.height)/2;
        UIImageView *viRecordBack = [[UIImageView alloc] initWithFrame:rect];
        viRecordBack.image = [UIImage imageNamed:@"music_bk.png"];
        [self addSubview:viRecordBack];
  
        //创建小喇叭
        UIImage *imageHorn = [UIImage imageNamed:@"btn_volume.png"];
        rect.size.width = imageHorn.size.width;
        rect.size.height = imageHorn.size.height;
        rect.origin.x = 8;
        rect.origin.y = (viRecordBack.frame.size.height - rect.size.height)/2;
        UIImageView *viHorn = [[UIImageView alloc] initWithFrame:rect];
        viHorn.image = imageHorn;
        [viRecordBack addSubview:viHorn];
        [viHorn release];
        
        //创建progressView
        rect.origin.x = viHorn.frame.origin.x + viHorn.frame.size.width + 5;
        rect.size.width = viRecordBack.frame.size.width - rect.origin.x - 5;
        rect.size.height = 8;
        rect.origin.y = (viRecordBack.frame.size.height-rect.size.height)/2;

        UIImage *imgTrack = [UIImage imageNamed:@"volume1.png"];
        UIImage *imgProgress = [UIImage imageNamed:@"volume2.png"];
        //CGSize size1 = imgTrack.size;
        //size1 = imgProgress.size;
        
        meter1 = [[UIProgressView alloc] initWithFrame:rect];
        [meter1 setTrackImage:[imgTrack stretchableImageWithLeftCapWidth:6 topCapHeight:3]];
        [meter1 setProgressImage:[imgProgress stretchableImageWithLeftCapWidth:6 topCapHeight:3]];
        [viRecordBack addSubview:meter1];
        //设置图片
        
        
        rect.origin.y = 5+9+5;
        meter2 = [[UIProgressView alloc] initWithFrame:rect];
        [viRecordBack addSubview:meter2];
        meter2.hidden = YES;
        
        [viRecordBack release];
        
        
    }
    return self;
}


- (void)dealloc
{
    self.strFilePath = nil;
    self.delegate = nil;
    
    recorder.delegate = nil;
    [recorder stop];
    [recorder release];
    recorder = nil;
    
    [session setActive:NO error:nil];
    
    SAFEREMOVEANDFREE_OBJECT(lbTime);
    SAFEREMOVEANDFREE_OBJECT(meter1);
    SAFEREMOVEANDFREE_OBJECT(meter2);
    
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
    if ( timerStop ) {
        [timerStop invalidate];
        timerStop = nil;
    }
    
	[super dealloc];
}


- (NSString *) formatTime: (int) num
{
	// return a formatted ellapsed time string
	int secs = num % 60;
	int min = num / 60;
	return	[NSString stringWithFormat:@"%02d:%02d", min, secs];
}

- (void) updateMeters
{
	// Show the current power levels
	[recorder updateMeters];
	float avg = [recorder averagePowerForChannel:0];
	float peak = [recorder peakPowerForChannel:0];
	meter1.progress = (XMAX + avg) / XMAX;
	meter2.progress = (XMAX + peak) / XMAX;
    
	// Update the current recording time
	lbTime.text = [NSString stringWithFormat:@"%@", [self formatTime:recorder.currentTime]];
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
	// Stop monitoring levels, time
	[timer invalidate];
    timer = nil;
    [timerStop invalidate];
    timerStop = nil;
    
	meter1.progress = 0.0f;
	meter1.hidden = YES;
	meter2.progress = 0.0f;
	meter2.hidden = YES;

	//[ModalAlert say:@"File saved to %@", [[self.recorder.url path] lastPathComponent]];
	//self.title = @"Playing back recording...";
	
    //返回结果
    if ( self.delegate && [self.delegate respondsToSelector:@selector(RecordFinish:successfully:)] ) {
        
       [self.delegate RecordFinish:self successfully:YES];
    }
    
    NSLog(@"audioRecorderDidFinishRecording");
}


- (void) stopRecording
{
	//This causes the didFinishRecording delegate method to fire
	[recorder stop];
}

- (void) continueRecording
{
	// resume from a paused recording
	[recorder record];
}

- (void) pauseRecording
{
	// pause an ongoing recording
	[recorder pause];
}

- (BOOL) record
{
	NSError *error;
	
	// Recording settings
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey]; // mono
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	[settings setValue :[NSNumber numberWithInt:AVAudioQualityMin]  forKey:AVEncoderAudioQualityKey];//编码质量
    
	// File URL
	NSURL *url = [NSURL fileURLWithPath:self.strFilePath];
	
	// Create recorder
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
	if (!recorder)
	{
        DEVICE_ALARM();
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	// Initialize degate, metering, etc.
	recorder.delegate = self;
	recorder.meteringEnabled = YES;
	meter1.progress = 0.0f;
	meter2.progress = 0.0f;
	
	if (![recorder prepareToRecord])
	{
        DEVICE_ALARM();
		NSLog(@"Error: Prepare to record failed");
		//[ModalAlert say:@"Error while preparing recording"];
		return NO;
	}
	
	if (![recorder record])
	{
        DEVICE_ALARM();
		NSLog(@"Error: Record failed");
		//[ModalAlert say:@"Error while attempting to record audio"];
		return NO;
	}
	
	// Set a timer to monitor levels, current time
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    timerStop = [NSTimer scheduledTimerWithTimeInterval:1200.0f target:self selector:@selector(stopRecording) userInfo:nil repeats:YES];
	   
	return YES;
}

- (BOOL) startAudioSession
{
	// Prepare the audio session
	NSError *error;
	session = [AVAudioSession sharedInstance];
	
	if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
        DEVICE_ALARM();
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	if (![session setActive:YES error:&error])
	{
        DEVICE_ALARM();
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	return session.inputIsAvailable;
}

- (void) startRecord
{	    
	if ([self startAudioSession]) {
		
        [self record];
	}
    else {
		DEVICE_ALARM();
    }
    
}

@end


