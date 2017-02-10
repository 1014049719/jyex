//
//  CSImagePickerController.m
//  PLPhoto
//
//  Created by Qiliang Shen on 09-3-27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import "PPPhotoPickerCtr.h"
//#import "PLPhotoPicker.h"
//#import <QuartzCore/QuartzCore.h>
//#import "PLUIController.h"
//@implementation PPPhotoPickerCtr
//@synthesize delegate;
//
//- (void)loadView {
//	
//	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//	pickerView = [[PLPhotoPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//	
//	[pickerView setDelegate:self];
//	
//	[pickerView setAllowsAlbumSelection:1];
//	[pickerView setAllowsPlayingSlideshow:0];
//	
//	[pickerView setAllowsFullSizeImageDisplay:1];
//	[pickerView setAllowsZoomingWhenCropping:1];
//	[pickerView setCropPhotoAfterSelection:1];
//	
//	self.view = pickerView;
//	
//	[pickerView _loadPickerUI];
//	[pickerView release];
//	
//	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
//}
//
//- (void)photoPicker:(PLPhotoPicker*)picker didCropPhotoToRect:(CGRect)r fullSizeImageData:(NSData*)d1 fullScreenImageData:(NSData*)d2 croppedImageData:(NSData*)d3{
//	[delegate photoPickerCtr:self didPickedImage:[UIImage imageWithData:d1]];
////	UIImage * img1 = [UIImage imageWithData:d1];
////	UIImage * img2 = [UIImage imageWithData:d2];
////	UIImage * img3 = [UIImage imageWithData:d3];
////	
////	[UIImagePNGRepresentation(img1) writeToFile:@"d1.png" atomically:YES];
////	[UIImagePNGRepresentation(img2) writeToFile:@"d2.png" atomically:YES];
////	[UIImagePNGRepresentation(img3) writeToFile:@"d3.png" atomically:YES];
//}
//- (void)photoPickerDidCancel:(PLPhotoPicker*)picker{
//	[delegate photoPickerCtrDidCancel:self];
//}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
//    // Release anything that's not essential, such as cached data
//}
////- (void)photoPickerCroppedPhotoDestination:(id)i{
////}
//
//- (void)dealloc {
//	
//    [super dealloc];
//}
//
//
//@end
