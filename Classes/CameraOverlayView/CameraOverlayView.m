//
//  CameraOverlayView.m
//  ARmarket
//
//  Created by Boguslaw Parol on 20.05.2012.
//  Copyright (c) 2012 mWorldApps.com. All rights reserved.
//

#import "CameraOverlayView.h" 

@implementation CameraOverlayView

@synthesize delegate = _delegate,toolbar = _toolbar, zoomSlider = _zoomSlider, picker = _picker;



- (void)dealloc{
    
    NSLog(@"---->CameraOverlayView dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    
    self.delegate = nil;
    //self.backButton = nil;
    [self.toolbar removeFromSuperview];
    self.toolbar = nil;
    
    [self.zoomSlider removeFromSuperview];
    self.zoomSlider = nil;
    self.picker = nil;
    //self.cameraButton = nil;
    //self.sunImageView = nil;
    //self.othertoolbar = nil;
    //self.image = nil;
    
    [super dealloc];
}


- (void)initToolbar
{	
	if(self.toolbar)
	{
        [self.toolbar removeFromSuperview];
		self.toolbar = nil;
	}
    
    CGRect frame;
    frame = self.frame;
    //加上状态栏的高度
    //frame.size.height += 20;
    //self.frame = frame;
    
    frame.size.width = self.frame.size.width;
    frame.size.height = 54;//44;
    frame.origin.x = 0;
    frame.origin.y = self.frame.size.height - frame.size.height;
    
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:frame];
	self.toolbar = bar;
    [bar release];
	
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				 target:self
                                                                                action:@selector(cancelAction:)];
    cancelItem.style = UIBarButtonItemStyleBordered;
    
    
	UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
    flexItem1.style = UIBarButtonItemStylePlain;
    
    UIBarButtonItem *cameraItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
																				target:self
                                                                                 action:@selector(cameraAction:)];
    cameraItem.style = UIBarButtonItemStyleBordered;
    
	UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
    flexItem2.style = UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *photoItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																				target:self
																				action:@selector(photoAction:)];   
    photoItem.style = UIBarButtonItemStyleBordered;
    
	
    /*
     UIBarButtonItem *colorItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"palette.png"]]
     style:UIBarButtonItemStylePlain target:self action:@selector(colorAction)];
     */
    
	NSArray *items = nil;
    
    items = [NSArray arrayWithObjects: cancelItem,flexItem1,cameraItem,flexItem2,photoItem, nil];
    [self.toolbar setItems:items animated:NO];
    
	self.toolbar.barStyle = UIBarStyleBlackTranslucent;
	[self addSubview:self.toolbar];
	
    [cancelItem release];
	[flexItem1	 release];
    [cameraItem	 release];
    [flexItem2	 release];
    [photoItem	 release];
    
}

- (void)initSlider
{
    CGRect frame;
    frame.size.width = self.frame.size.width;
    frame.size.height = 41;
    frame.origin.x = 0;
    frame.origin.y = self.toolbar.frame.origin.y - frame.size.height;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    
    frame.origin.y = (frame.size.height - 23)/2;
    frame.size.height = 23;
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    self.zoomSlider = slider;
    [slider release];
    
    self.zoomSlider.continuous = YES;
    self.zoomSlider.minimumValueImage = [UIImage imageNamed:@"minus.png"];
    self.zoomSlider.maximumValueImage = [UIImage imageNamed:@"plus.png"];
    [self.zoomSlider addTarget:self action:@selector(zoom:) forControlEvents:UIControlEventValueChanged];    
    
    [view addSubview:self.zoomSlider];
    [self addSubview:view];
    
    //可能还要再加2个按钮
    [view release];
    
}


-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
        [self initToolbar];
        //[self initOtherToolbar];
        //[self initSlider];  //2013.2.19
        //[self configure];
	}
	return self;    
}



//----------------
- (void)cancelAction:(id)sender{
    if ( self.delegate )
        [self.delegate didCancel];
}

- (void)cameraAction:(id)sender{
    [self.picker takePicture];    
}

- (void)photoAction:(id)sender{ 
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}


#pragma mark - User Actions
- (void)zoom:(id)sender{
    UISlider *slider = (UISlider*)sender;
    CGFloat zoom =  1 + 4*slider.value;
    self.picker.cameraViewTransform = CGAffineTransformScale(CGAffineTransformIdentity,zoom, zoom);
}

@end
