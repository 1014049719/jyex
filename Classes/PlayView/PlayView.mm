//
//  PPDrawer.mm
//  NoteBook
//
//  Created by chen wu on 09-7-22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "PlayView.h"
#import "PubFunction.h"
#import "UIImage+Scale.h"

#define XMAX	20.0f

#define DEVICE_ALARM()   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"播放设备不可用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];\
                    [alertView show];\
                    [alertView release];


@implementation PlayView
@synthesize strFilePath;
@synthesize delegate;

// path is backgroundImage path
- (id) initWithFrame:(CGRect)frame 
{

    if (self = [super initWithFrame:frame]) {
        // Initialization code
        
        //CGRect viewframe = self.frame;
        CGFloat viewheight = self.frame.size.height;
        CGFloat viewwidth = self.frame.size.width;
        
        //self.backgroundColor = [UIColor yellowColor];
        //创建背景图
        viBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewwidth, viewheight)];
        viBack.image = [UIImage imageNamed:@"TongYongTouLan.png"];
        [self addSubview:viBack];
        [viBack release];
        
        //创建左边按钮
        UIImage *imgePlay = [UIImage imageNamed:@"play.png"];
        CGRect rect;
        rect.size.width = 10+10+imgePlay.size.width;
        rect.size.height = viewheight;
        rect.origin.x = 0;
        rect.origin.y = 0;
        UIEdgeInsets inset=UIEdgeInsetsMake((viewheight - imgePlay.size.height)/2, 10, (viewheight - imgePlay.size.height)/2, 10);
        
        btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPlay.frame = rect;
        [btnPlay addTarget:self action:@selector(pressPlay:) forControlEvents:UIControlEventTouchUpInside];
        [btnPlay setTitle:@"" forState:nil];
        [btnPlay setTitleColor:[UIColor whiteColor] forState:nil];
        [btnPlay setBackgroundColor:[UIColor clearColor]];
        [btnPlay setImage:imgePlay forState:UIControlStateNormal];
        [btnPlay setImage:[imgePlay UpdateImageAlpha:0.6] forState:UIControlStateHighlighted];
        btnPlay.imageEdgeInsets = inset;
        [self addSubview:btnPlay];
        btnPlay.hidden = YES;
        
        //左边暂停按钮
        btnPause = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPause.frame = rect;
        [btnPause addTarget:self action:@selector(pressPause:) forControlEvents:UIControlEventTouchUpInside];
        [btnPause setTitle:@"" forState:nil];
        [btnPause setTitleColor:[UIColor whiteColor] forState:nil];
        [btnPause setBackgroundColor:[UIColor clearColor]];
        [btnPause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [btnPause setImage:[[UIImage imageNamed:@"pause.png"] UpdateImageAlpha:0.6] forState:UIControlStateHighlighted];
        btnPause.imageEdgeInsets = inset;
        [self addSubview:btnPause];  

        //创建右边按钮
        rect.size.width = SIZE_BUTTON.width;
        rect.size.height = SIZE_BUTTON.height;
        rect.origin.x = (frame.size.width/4 - rect.size.width)/2  + frame.size.width*3/4;
        rect.origin.y = (frame.size.height - rect.size.height)/2;
        btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFinish.frame = rect;
        [btnFinish addTarget:self action:@selector(pressCancel:) forControlEvents:UIControlEventTouchUpInside];
        [btnFinish setTitle:@"完成" forState:nil];
        btnFinish.titleLabel.font = FONT_BUTTON;
        [btnFinish setTitleColor:COLOR_BUTTON forState:nil];
        [btnFinish setBackgroundColor:[UIColor clearColor]];
        [btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [self addSubview:btnFinish];
        

        //右边结束按钮
        /*
        rect.size.width = viewheight;
        rect.size.height = viewheight;
        rect.origin.x = viewwidth-viewheight-5;
        rect.origin.y = 0;
        UIButton  *btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFinish.frame = rect;
        [btnFinish addTarget:self action:@selector(pressCancel:) forControlEvents:UIControlEventTouchUpInside];
        [btnFinish setTitle:@"" forState:nil];
        [btnFinish setTitleColor:[UIColor whiteColor] forState:nil];
        [btnFinish setBackgroundColor:[UIColor blackColor]];
        [btnFinish setBackgroundImage:[UIImage imageNamed:@"TB3-1.png"] forState:UIControlStateNormal];
        [btnFinish setBackgroundImage:[UIImage imageNamed:@"TB3-1.png"] forState:UIControlStateHighlighted];
        [self addSubview:btnFinish];  
        */
        
        //创建时间label
        CGSize size = [@"00:00" sizeWithFont: FONT_BUTTON];
        rect.size.width = size.width+4;
        rect.size.height = size.height;
        rect.origin.x = btnPlay.frame.origin.x + btnPlay.frame.size.width + 5;
        rect.origin.y = (viewheight - size.height)/2;
        lbTime1 = [[UILabel alloc] initWithFrame:rect];
        lbTime1.textColor = COLOR_BUTTON;
        lbTime1.backgroundColor = [UIColor clearColor];
        lbTime1.text = @"00:00";
        lbTime1.font = FONT_BUTTON;
        [self addSubview:lbTime1];
        
        //右边
        size = [@"-00:00" sizeWithFont:FONT_BUTTON ];
        rect.size.width = size.width+4;
        rect.size.height = size.height;
        rect.origin.x = btnFinish.frame.origin.x -10-size.width;
        rect.origin.y = (viewheight - size.height)/2;
        lbTime2 = [[UILabel alloc] initWithFrame:rect];
        lbTime2.textColor = COLOR_BUTTON;
        lbTime2.backgroundColor = [UIColor clearColor];
        lbTime2.text = @"-00:00";
        lbTime2.font = FONT_BUTTON;
        [self addSubview:lbTime2];
        
        
        
        //创建progressView
        rect.origin.x = lbTime1.frame.origin.x + lbTime1.frame.size.width + 5;
        rect.size.width = (lbTime2.frame.origin.x - lbTime1.frame.origin.x - lbTime1.frame.size.width) - 2*5;
        rect.size.height = 9;
        rect.origin.y = (viewheight - rect.size.height)/2;
 
        
        UIImage *imgTrack = [UIImage imageNamed:@"volume1.png"];
        UIImage *imgProgress = [UIImage imageNamed:@"volume2.png"];
 
        meter1 = [[UIProgressView alloc] initWithFrame:rect];
        [meter1 setTrackImage:[imgTrack stretchableImageWithLeftCapWidth:6 topCapHeight:3]];
        [meter1 setProgressImage:[imgProgress stretchableImageWithLeftCapWidth:6 topCapHeight:3]];
        [self addSubview:meter1];
        
        //创建中间的图符，需要移动
        UIImage *imgHint = [UIImage imageNamed:@"progress.png"];
        rect.size.height = imgHint.size.height;
        rect.size.width = imgHint.size.width;
        rect.origin.y = (viewheight - rect.size.height)/2;
        viCurHint = [[UIImageView alloc] initWithFrame:rect];
        viCurHint.image = imgHint;
        [self addSubview:viCurHint]; 
        originx = rect.origin.x;
        
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"---->PlayView dealloc");
    
    self.strFilePath = nil;
    self.delegate = nil;
    
    if ( player )
    {
        player.delegate = nil;
        [player stop];
        [player release];
        player = nil;
    }
    
    [session setActive:NO error:nil];
    
    SAFEREMOVEANDFREE_OBJECT(viCurHint);
    SAFEREMOVEANDFREE_OBJECT(meter1);
    SAFEREMOVEANDFREE_OBJECT(lbTime2);
    SAFEREMOVEANDFREE_OBJECT(lbTime1);
    SAFEREMOVEANDFREE_OBJECT(meter1);
    SAFEREMOVEANDFREE_OBJECT(meter1);
    SAFEREMOVEANDFREE_OBJECT(meter1);
    SAFEREMOVE_OBJECT(btnFinish);
    SAFEREMOVE_OBJECT(btnPlay);
    SAFEREMOVE_OBJECT(btnPause);
    SAFEREMOVE_OBJECT(viBack);

    
    [viCurHint removeFromSuperview];
    [viCurHint release];
    viCurHint = nil;
    
    
    
    if ( timer ) {
        [timer invalidate];
        timer = nil;
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
	[player updateMeters];
	meter1.progress = player.currentTime / player.duration;
    
	// Update the current recording time
	lbTime1.text = [NSString stringWithFormat:@"%@", [self formatTime:player.currentTime]];
    lbTime2.text = [NSString stringWithFormat:@"-%@", [self formatTime:(player.duration-player.currentTime)]];
    
    CGRect  rect = viCurHint.frame;
    rect.origin.x = originx + (meter1.frame.size.width-rect.size.width) * meter1.progress;
    if ( rect.origin.x + rect.size.width <meter1.frame.origin.x + meter1.frame.size.width )
    {
        viCurHint.frame = rect;
    }
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)recorder successfully:(BOOL)flag
{
	// Stop monitoring levels, time
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
    if ( meter1 ) {
        meter1.progress = 0.0f;
        [self updateMeters];
    }
    
    CGRect rect = viCurHint.frame;
    rect.origin.x = originx;
    viCurHint.frame = rect;

    if ( btnPlay ) 
        btnPlay.hidden = NO;
    if ( btnPause )
        btnPause.hidden = YES;


	//[ModalAlert say:@"File saved to %@", [[self.recorder.url path] lastPathComponent]];
	//self.title = @"Playing back recording...";
	
    //返回结果
    /*
    if ( self.delegate && [self.delegate respondsToSelector:@selector(RecordFinish:successfully:)] ) {
        
       [self.delegate RecordFinish:self successfully:YES];
    }*/
    
}

- (void) exitPlaying
{
    [player stop];
    player.delegate = nil;
    
    if ( timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [player release];
    player = nil;
}

- (void) stopPlaying
{
	//This causes the didFinishRecording delegate method to fire
	[player stop];
    player.delegate = nil;
    
    if ( timer) {
        [timer invalidate];
        timer = nil;
    }
}


- (void) continuePlaying
{
	// resume from a paused recording
    player.delegate = self;
	[player play];
    

}

- (void) pauseRecording
{
	// pause an ongoing recording
	[player pause];
}


- (BOOL) play
{
    if ( player ) {
        player.delegate = nil;
        [player stop];
        [player release];
    }
    
    // File URL
	NSURL *url = [NSURL fileURLWithPath:self.strFilePath];
    // Start playback
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.delegate = self;
	
    // Change audio session for playback
    NSError *error;
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return NO;
    }
        
    [player play];
    

	// Set a timer to monitor levels, current time
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
	   
	return YES;
}

- (BOOL) startAudioSession
{
	// Prepare the audio session
	NSError *error;
	session = [AVAudioSession sharedInstance];
	
	if (![session setCategory:AVAudioSessionCategoryPlayback error:&error])
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

- (void) startPlay:(NSString *)path
{	    
    self.strFilePath = path;

	if ([self startAudioSession]) {
        
        [self play];
	}
    else {
		DEVICE_ALARM();
    }
    
}


- (void)pressPlay:(id)sendid
{
    btnPause.hidden = NO;
    btnPlay.hidden = YES;
    
    player.delegate = self;
    [player play];
    
    if ( timer) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

- (void)pressPause:(id)sendid
{
    btnPause.hidden = YES;
    btnPlay.hidden = NO;
    
    [player pause];
    
    if ( timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)pressCancel:(id)sendid
{
    [player stop];
    player.delegate = nil;
    
    if ( timer) {
        [timer invalidate];
        timer = nil;
    }
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(PlayFinish)] ) {
        
        [self.delegate PlayFinish];
    }
}

@end


