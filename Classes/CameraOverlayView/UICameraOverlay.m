//
//  UICameraOverlay.m
//  NoteBook
//
//  Created by susn on 12-11-27.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "UICameraOverlay.h"

@implementation UICameraOverlay
@synthesize delegate;
@synthesize zoomSlider = _zoomSlider, sunImageView = _sunImageView, othertoolbar = _othertoolbar,image = _image;


- (void) dealloc
{
    NSLog(@"---->UICameraOverlay dealloc");
    
    self.delegate = nil;
    
    [self.sunImageView removeFromSuperview];
    self.sunImageView = nil;
    
    [self.othertoolbar removeFromSuperview];
    self.othertoolbar = nil;
    
    self.image = nil;    
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initOtherToolbar];
    [self configure];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.sunImageView = iv;
    [iv release];
    [self.view addSubview:self.sunImageView];
    
    
    //[self takePhoto];
    [self performSelector:@selector(takePhoto) withObject:nil afterDelay:0.5];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)initOtherToolbar
{	
	if(self.othertoolbar)
	{
        [self.othertoolbar removeFromSuperview];
		self.othertoolbar = nil;
		
	}
    
    CGRect frame;
    frame = self.view.frame;
    //加上状态栏的高度
    frame.size.height += 20;
    self.view.frame = frame;
    
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 44;
    frame.origin.x = 0;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:frame];
	self.othertoolbar = bar;
    [bar release];
	
    UIBarButtonItem *discardItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
																				 target:self
																				 action:@selector(cleanAction:)];
    discardItem.style = UIBarButtonItemStyleBordered;
    
	UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
    flexItem1.style = UIBarButtonItemStylePlain;
    
    UIBarButtonItem *redoItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo
                                                                                 target:self
                                                                                 action:@selector(redoAction:)];
    redoItem.style = UIBarButtonItemStyleBordered;    
    
	UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
    flexItem2.style = UIBarButtonItemStylePlain;
    
    UIBarButtonItem *finshiItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                 target:self
                                                                                 action:@selector(finishAction:)];
    finshiItem.style = UIBarButtonItemStyleBordered;
	
    /*
     UIBarButtonItem *colorItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"palette.png"]]
     style:UIBarButtonItemStylePlain target:self action:@selector(colorAction)];
     */
    
	NSArray *items = nil;
    
    items = [NSArray arrayWithObjects: discardItem,flexItem1,redoItem,flexItem2,finshiItem, nil];
    [self.othertoolbar setItems:items animated:NO];
    
	self.othertoolbar.barStyle = UIBarStyleBlackTranslucent;
	[self.view addSubview:self.othertoolbar];
	
    [discardItem release];
	[flexItem1	 release];
    [redoItem	 release];
    [flexItem2	 release];
    [finshiItem	 release];
    
}

- (void)configure{
    
    UIPinchGestureRecognizer *pinch;
    pinch = [[[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(pinch:)] autorelease];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];  
}


- (void)cleanAction:(id)sender{
    [delegate Camera_ClickCancel];
}


- (void)redoAction:(id)sender{
    [self takePhoto];
}

- (void)finishAction:(id)sender{
    //if ( self.delegate )
    //    [self.delegate didFinished:nil];
    [delegate Camera_ClickFinish:nil];
}



- (void)takePhoto
{
#if TARGET_IPHONE_SIMULATOR
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsImageEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
        return;
    }
#endif
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    picker.showsCameraControls = NO;
    picker.delegate = self;
    
    CameraOverlayView *cameraView = [[CameraOverlayView alloc] initWithFrame:self.view.frame];
    cameraView.delegate = self;
    cameraView.picker = picker;
    picker.cameraOverlayView = cameraView;
    [cameraView release];
    
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}


//拍照的回调
/*
- (void)didFinished:(UIImage *)image {
    
    if ( delegate )
    {
        [delegate Camera_ClickFinish:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

- (void)didCancel {
    //if ( delegate ) 
    //{
    //    [delegate Camera_ClickCancel];
    //}
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController*)picker
        didFinishPickingImage:(UIImage*)image
                    edingInfo:(NSDictionary*)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];   
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //[self insertImage:image];
        //cameraView.image = image;
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = image.size.height;
        frame.size.width = image.size.width;
        //self.sunImageView.frame = frame;
        //self.sunImageView.image = image;
        
        [self.view bringSubviewToFront:self.othertoolbar];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)pinch:(UIPinchGestureRecognizer*)recognizer{
    
    static CGFloat factor = 20;
    
    CGFloat scale = [recognizer scale];
    
    if(scale < 1){
        self.sunImageView.transform = CGAffineTransformScale(self.sunImageView.transform, 1 - (1 - scale)/factor, 1 - (1 - scale)/factor);
    }else{
        self.sunImageView.transform = CGAffineTransformScale(self.sunImageView.transform, 1 + (scale -  1)/factor,1 + (scale -  1)/factor);        
    }
    
    NSLog(@"[%.0f %.0f] [%.0f %.0f] == [%.0f %.0f] scale=%.2f",self.sunImageView.frame.origin.x,self.sunImageView.frame.origin.y,
          self.sunImageView.frame.size.width,self.sunImageView.frame.size.height,
          self.sunImageView.image.size.width,self.sunImageView.image.size.height,self.sunImageView.image.scale);
    
}

#pragma mark GestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer 
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if(gestureRecognizer.delegate == self && 
       [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]){
        return NO;
    }
    return YES;    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}


@end
