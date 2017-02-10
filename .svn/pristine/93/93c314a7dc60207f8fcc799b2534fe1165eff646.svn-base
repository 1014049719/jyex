//
//  ImagePickerController.mm
//  CallShow
//
//  Created by wu chen on 09-3-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//	last modifed qiliang 09-4-10
//#import "PPCameraImagePickerCtr.h"
//#import "PLPhotoPicker.h"
//#import "Plist.h"
//#import "Global.h"
//#import "Common.h"
//
//@implementation PPCameraImagePickerCtr
//@synthesize pickerdelegate,isWriteToLib;
//
//- (id) initWithType:(UIImagePickerControllerSourceType)type
//{
//	if (!(self = [super init])) 
//		return self;
//	
//	self.sourceType = type;
//	if(type==UIImagePickerControllerSourceTypePhotoLibrary) self.allowsImageEditing = NO;
//    else self.allowsImageEditing = YES;
//	self.delegate = self;
//	
//	return self;
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//	if(self.sourceType==UIImagePickerControllerSourceTypePhotoLibrary)
//    {
//		
//		MLOG(@"UIImagePickerControllerSourceTypePhotoLibrary");
//		PLPhotoPicker *photoview = [[PLPhotoPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//		[photoview setDelegate:self];
//		UIViewController *vc = [[[UIViewController alloc] init] autorelease];
//		vc.view = photoview;
//		[photoview _loadPickerUI];	
//		vc.view.frame = CGRectMake(0, 0, 320, 480);
//		[photoview release];
//        
//		MLOG(@"image.imageOrientation:%d",image.imageOrientation);
//		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//		CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
//		CGColorSpaceRelease(colorSpace);
//		CGContextTranslateCTM(context, 0, image.size.height);
//		CGContextScaleCTM(context, 1, -1);
//		UIGraphicsPushContext(context);
//		[image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//		UIGraphicsPopContext();
//		CGImageRef rImg = CGBitmapContextCreateImage(context);
//		CGContextRelease(context);
//		image = [UIImage imageWithCGImage:rImg];
//		CGImageRelease(rImg);
//		
//		[(PLPhotoPicker*)vc.view setFullSizeImageData:UIImageJPEGRepresentation(image, 1.0)  cropRect:CGRectZero];
//		[self pushViewController:vc animated:YES];
//		self.navigationBarHidden = YES;
//		self.view.frame = CGRectMake(0, -20, 320, 480);
//		
//		return;
//	}
//	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//	//MLOG(@"%@",[self.view dump]);
//	
//	UIImage *fullSizeImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
//	CGSize size = fullSizeImage.size;
//    //	MLOG(@"%f,%f",size.width,size.height);
//    //	if(size.width>size.height&&size.width>640.0){
//    //		size.height = 640*size.height/size.width;
//    //		size.width = 640.0;
//    //	}
//    //	if(size.height>size.width&&size.height>640.0){
//    //		size.width = 640*size.width/size.height;
//    //		size.height = 640.0;
//    //
//    //	}
//	if(self.sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//		PlistController *pc = [[PlistController alloc] initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:CONFIGURE_FILE_PATH]];
//		NSMutableDictionary *dic = [pc readDicPlist];
//		NSNumber * timeMarkFlag = [dic objectForKey:@"timeMarkFlag"];
//		BOOL flag = [timeMarkFlag boolValue];
//		if(flag)
//		{
//			
//			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//			CGContextRef context = CGBitmapContextCreate(nil, fullSizeImage.size.width, fullSizeImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
//			UIGraphicsPushContext(context);
//			CGColorSpaceRelease(colorSpace);
//			CGContextTranslateCTM(context, 0, fullSizeImage.size.height);
//			CGContextScaleCTM(context, 1, -1);
//			
//			[fullSizeImage drawInRect:CGRectMake(0, 0, fullSizeImage.size.width, fullSizeImage.size.height)];
//			NSString * time = [CommonFunc getCurrentTime];
//            
//			CGSize  sz = [time sizeWithFont:[UIFont italicSystemFontOfSize:60] constrainedToSize:CGSizeMake(500,100)];
//            //	[time drawAtPoint:CGPointMake(fullSizeImage.size.width-sz.width-500,fullSizeImage.size.height-sz.height-150) withFont:[UIFont italicSystemFontOfSize:60]];
//            
//			CGContextTranslateCTM(context, 0, fullSizeImage.size.height);
//			CGContextScaleCTM(context, 1, -1);
//			
//			CGAffineTransform myTextTransform; 
//			
//			CGContextSelectFont (context, 
//								 "Helvetica-Bold", 
//								 60, 
//								 kCGEncodingMacRoman); 
//			
//			CGContextSetCharacterSpacing (context, 10); 
//			
//			CGContextSetTextDrawingMode (context, kCGTextFillStroke); 
//			
//			CGContextSetRGBFillColor (context, 1, 1, 0.4, 0.5); 
//			
//			CGContextSetRGBStrokeColor (context, 1, 1, 1, 1); 
//			
//			myTextTransform =  CGAffineTransformMakeRotation  (0 * M_PI / 180 ); 
//			CGContextSetTextMatrix (context, myTextTransform); 
//			CGContextShowTextAtPoint (context, 700, 80, [time UTF8String], 10); 
//			
//			
//			UIGraphicsPopContext();
//			CGImageRef rImg = CGBitmapContextCreateImage(context);
//			CGContextRelease(context);
//			fullSizeImage = [UIImage imageWithCGImage:rImg];
//			CGImageRelease(rImg);
//		}
//		if(isWriteToLib)
//			UIImageWriteToSavedPhotosAlbum(fullSizeImage, nil, nil, nil);
//	}
//	NSValue *rectValue = [editingInfo objectForKey:UIImagePickerControllerCropRect];
//	CGRect cropRect;
//	[rectValue getValue:&cropRect];
//	double wph = size.width/size.height;
//	CGRect drawRect;
//	if(wph<1.0)  drawRect = CGRectMake(-20, 0, 360, 480);
//	else drawRect = CGRectMake(0, 120, 320, 240);
//	if(self.sourceType != UIImagePickerControllerSourceTypeCamera){
//		MLOG(@"%f,%f,%f,%f",cropRect.origin.x,cropRect.origin.y,cropRect.size.width,cropRect.size.height);
//		if(cropRect.size.height<=size.height){
//			double scanRate = 320.0/cropRect.size.width;
//			drawRect = CGRectMake(-cropRect.origin.x*scanRate, -cropRect.origin.y*scanRate+60, size.width*scanRate, size.height*scanRate);
//		}
//		else /*if(cropRect.size.width>cropRect.size.height)*/{
//			double scanRate = 320.0/cropRect.size.width;
//			drawRect = CGRectMake(-cropRect.origin.x*scanRate,(480-size.height)/2, size.width*scanRate, size.height*scanRate);
//		}
//	}
//    //	else if(cropRect.size.width<cropRect.size.height){
//    //		double scanRate = 320.0/cropRect.size.height;
//    //		drawRect = CGRectMake(-cropRect.origin.x*scanRate, -cropRect.origin.y*scanRate+80, size.width*scanRate, size.height*scanRate);
//    //	}
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	CGContextRef context = CGBitmapContextCreate(nil, 320, 480, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
//	CGColorSpaceRelease(colorSpace);
//	CGContextTranslateCTM(context, 0, 480);
//	CGContextScaleCTM(context, 1, -1);
//	UIGraphicsPushContext(context);
//	[[UIColor blackColor] set];
//	CGContextFillRect(UIGraphicsGetCurrentContext(),CGRectMake(0, 0, 320, 480));
//	[fullSizeImage drawInRect:drawRect];
//	UIGraphicsPopContext();
//	CGImageRef rImg = CGBitmapContextCreateImage(context);
//	CGContextRelease(context);
//	image = [UIImage imageWithCGImage:rImg];
//	CGImageRelease(rImg);
//	[pickerdelegate cameraImagePickerCtr:self didPickedImage:image];
//	[NSTimer scheduledTimerWithTimeInterval:0.5 target:[UIApplication sharedApplication] selector:@selector(endIgnoringInteractionEvents) userInfo:nil repeats:NO];
//	//[[UIApplication sharedApplication] endIgnoringInteractionEvents];
//	//[self.parentViewController  dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)photoPickerDidCancel:(id)picker{
//	[self popViewControllerAnimated:YES];
//	self.navigationBarHidden = NO;
//	self.view.frame = CGRectMake(0, 0, 320, 480);
//	
//}
//- (void)photoPicker:(id)picker didCropPhotoToRect:(CGRect)r fullSizeImageData:(NSData*)d1 fullScreenImageData:(NSData*)d2 croppedImageData:(NSData*)d3{
//	self.view.frame = CGRectMake(0, 0, 320, 480);
//	[pickerdelegate cameraImagePickerCtr:self didPickedImage:[UIImage imageWithData:d2]];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//	[pickerdelegate cameraImagePickerCtrDidCancel:self];
//}
//- (void)dealloc{
//	[super dealloc];
//}
//@end
