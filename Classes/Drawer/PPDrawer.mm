//
//  PPDrawer.mm
//  NoteBook
//
//  Created by chen wu on 09-7-22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "DrawerLabel.h"
#import "PPDrawer.h"
#import "Global.h"
#import "ObjEncrypt.h"
#import <QuartzCore/CALayer.h>
#import "Constant.h"
#import "Plist.h"


/*
 *      The private part for the PPDrawer implementation.
 */
@interface PPDrawer(Private)

- (void) removePath;
- (void) addPoint:(CGPoint)pt;
//- (void) addPathWithList:(DrawerList *) list Color:(UIColor *)color Size:(CGFloat) size blendMode:(CGBlendMode)mode;
- (void) addPathWithDrawElement:(NSDictionary *)drawElement;
- (void) deleteAllDrawerPath;
- (void) onDraw;
- (void)onUpdate;
@end

@implementation PPDrawer(Private)

- (void) removePath
{
	//MLOG(@"on remove path");
	NSDictionary * drawerElement = [drawerList lastObject];
	[drawerElement retain];//it will release on undo
	if([drawerList count]>0)
		[drawerList removeLastObject];
	[undoManager beginUndoGrouping];
	[undoManager registerUndoWithTarget:self selector:@selector(addPathWithDrawElement:) object:drawerElement];
	[undoManager endUndoGrouping];
}

- (void)addPoint:(CGPoint)pt
{
	DrawerList * line = (DrawerList*)[[drawerList lastObject] objectForKey:@"line"];
	[line addNode:pt];
}

- (void) addPathWithDrawElement:(NSDictionary *)drawElement
{
	//MLOG(@"on add path");
	
	[drawerList addObject:drawElement];
	
	[undoManager beginUndoGrouping];
	[undoManager registerUndoWithTarget:self selector:@selector(removePath) object:nil];
	[undoManager endUndoGrouping];
}

- (void)deleteAllDrawerPath
{
	[drawerList  removeAllObjects];
	[undoManager removeAllActionsWithTarget:self];//清空redo 和 undo栈
	[self onDraw];
}

- (void) onDraw
{
	
	
	CGContextSetFlatness(bitMapContext, 0.5);
	CGContextSetAllowsAntialiasing(bitMapContext,YES);
	CGContextSetLineCap(bitMapContext, kCGLineCapRound);
	CGContextSetLineJoin(bitMapContext,kCGLineJoinRound);
	
	CGContextClearRect(bitMapContext, self.bounds);
	
	int count = [drawerList count];
	
	for(int i = 0 ; i< count; i++)
	{
		CGContextSaveGState(bitMapContext);
		NSDictionary * dict = [drawerList objectAtIndex:i];
		UIColor  *color = [dict objectForKey:@"color"];
		CGFloat	  size  = [[dict objectForKey:@"size"] floatValue];
		CGBlendMode mode= (CGBlendMode)[[dict objectForKey:@"blendMode"] intValue];
		CGContextSetBlendMode(bitMapContext, mode);
		DrawerList*line = [dict objectForKey:@"line"];
		//MLOG(@"line %d ,pensize ... %f",i,size);
		
		CGContextSetLineWidth(bitMapContext, size);
		CGContextSetStrokeColorWithColor(bitMapContext, color.CGColor);
		Node * begin = [line getHead];
		
		for(int j = 0 ; j < line.count-1; j++)
		{
			CGContextMoveToPoint(bitMapContext, begin.point.x, begin.point.y);
			begin = begin.next;
			CGContextAddLineToPoint(bitMapContext, begin.point.x, begin.point.y);
		}
		CGContextStrokePath(bitMapContext);
		CGContextRestoreGState(bitMapContext);
	}
	
	CGImageRef drawImage = CGBitmapContextCreateImage (bitMapContext); 
	[drawLayer setContents:(id)drawImage];
	CGImageRelease(drawImage);
//	[self setNeedsDisplay];
}

- (void)onUpdate
{
	if([undoManager.redoStack count]>0)
		[undoManager.redoStack removeAllObjects];
	
	CGContextSaveGState(bitMapContext);
	//begin new draw
	CGContextSetFlatness(bitMapContext, 0.5);
	CGContextSetAllowsAntialiasing(bitMapContext,YES);
	CGContextSetLineCap(bitMapContext, kCGLineCapRound);
	CGContextSetLineJoin(bitMapContext,kCGLineJoinRound);
	CGContextSetBlendMode(bitMapContext,blendMode);
	CGContextSetLineWidth(bitMapContext, penSize);
	CGContextSetStrokeColorWithColor(bitMapContext,penColor.CGColor);
	CGContextMoveToPoint(bitMapContext,previousLocation.x, previousLocation.y);
	CGContextAddLineToPoint(bitMapContext,location.x,location.y);
	CGContextStrokePath(bitMapContext);
	CGContextRestoreGState(bitMapContext);
	
	CGImageRef myImage = CGBitmapContextCreateImage (bitMapContext); 
	[drawLayer setContents:(id)myImage];
	CGImageRelease(myImage);
	
//	[self setNeedsDisplay];
    
}
#define  transparent 0
#if transparent
void ColoredPatternCallback(void *info, CGContextRef context)
{
	// Dark Gray
	CGContextSetRGBFillColor(context, 0.667, 0.667, 0.667, 1.00);
	CGContextFillRect(context, CGRectMake(0.0, 0.0, 8.0, 8.0));
	CGContextFillRect(context, CGRectMake(8.0, 8.0, 8.0, 8.0));
	
	// Light White
	CGContextSetRGBFillColor(context, 1, 1,1, 1.00);
	CGContextFillRect(context, CGRectMake(8.0, 0.0, 8.0, 8.0));
	CGContextFillRect(context, CGRectMake(0.0, 8.0, 8.0, 8.0));
}
- (void)loadBackgroundContext
{
	// Colored Pattern setup
	CGPatternCallbacks coloredPatternCallbacks = {0, ColoredPatternCallback, NULL};
	// First we need to create a CGPatternRef that specifies the qualities of our pattern.
	CGPatternRef coloredPattern = CGPatternCreate(
												  NULL, // 'info' pointer for our callback
												  CGRectMake(0.0, 0.0, 16.0, 16.0), // the pattern coordinate space, drawing is clipped to this rectangle
												  CGAffineTransformIdentity, // a transform on the pattern coordinate space used before it is drawn.
												  16.0, 16.0, // the spacing (horizontal, vertical) of the pattern - how far to move after drawing each cell
												  kCGPatternTilingNoDistortion,
												  true, // this is a colored pattern, which means that you only specify an alpha value when drawing it
												  &coloredPatternCallbacks); // the callbacks for this pattern.
	
	// To draw a pattern, you need a pattern colorspace.
	// Since this is an colored pattern, the parent colorspace is NULL, indicating that it only has an alpha value.
	CGColorSpaceRef coloredPatternColorSpace = CGColorSpaceCreatePattern(NULL);
	CGFloat alpha = 1.0;
	// Since this pattern is colored, we'll create a CGColorRef for it to make drawing it easier and more efficient.
	// From here on, the colored pattern is referenced entirely via the associated CGColorRef rather than the
	// originally created CGPatternRef.
	CGColorRef coloredPatternColor = CGColorCreateWithPattern(coloredPatternColorSpace, coloredPattern, &alpha);
	CGColorSpaceRelease(coloredPatternColorSpace);
	CGPatternRelease(coloredPattern);
	
	CGContextSetFillColorWithColor(backgroundContext, coloredPatternColor);
	CGContextFillRect(backgroundContext, CGRectMake(0.0, 0.0, 360, 480));
	
}
#else
- (void)loadBackgroundContext
{
	[self renderCanvas:YES];
}
#endif
@end



/*
 *      The public part for the PPDrawer implementation.
 */


@implementation PPDrawer
@synthesize delegate;
@synthesize undoManager;
@synthesize drawerList;
@synthesize drawLayer;

static inline double radians(double degrees) {
    return degrees * M_PI / 180;
}
#pragma mark -- Created functon;
CGContextRef MyCreateBitmapContext (int pixelsWide, 
									int pixelsHigh) 
{ 
    CGContextRef    context = NULL; 
    CGColorSpaceRef colorSpace; 
    void *          bitmapData; 
    int             bitmapByteCount; 
    int             bitmapBytesPerRow; 
	
    bitmapBytesPerRow   = (pixelsWide * 4); 
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh); 
	
    colorSpace = CGColorSpaceCreateDeviceRGB();//CGColorSpaceCreateWithName(kCGColorSpaceAdobeRGB1998); 
	//
    bitmapData = malloc( bitmapByteCount ); 
    if (bitmapData == NULL) 
    { 
        fprintf (stderr, "Memory not allocated!"); 
        return NULL; 
    } 
	
    context = CGBitmapContextCreate (bitmapData, 
									 pixelsWide, 
									 pixelsHigh, 
									 8,      // bits per component 
									 bitmapBytesPerRow, 
									 colorSpace, 
									 kCGImageAlphaPremultipliedLast); 
    if (context== NULL) 
    { 
	    free (bitmapData); 
        fprintf (stderr, "Context not created!"); 
        return NULL; 
    } 
	
    return context; 
} 

void MyCreateAndDrawJPEGImage (CGContextRef myContext, 
							   CGRect myContextRect, 
							   const char *filename) 
{ 
    CGImageRef image; 
    CGDataProviderRef provider; 
    CFStringRef path; 
    CFURLRef url; 
	
    path = CFStringCreateWithCString (NULL, filename, 
									  kCFStringEncodingUTF8); 
	
    url = CFURLCreateWithFileSystemPath (NULL, path, 
										 kCFURLPOSIXPathStyle, NULL); 
    CFRelease(path); 
	
    provider = CGDataProviderCreateWithURL (url); 
    CFRelease (url); 
	
    image = CGImageCreateWithJPEGDataProvider (provider, 
											   NULL, 
											   true, 
											   kCGRenderingIntentDefault); 
	
    CGDataProviderRelease (provider);
	
    CGContextDrawImage (myContext, myContextRect, image); 
	
    CGImageRelease (image); 
}

void MyCreateAndDrawPNGImage(CGContextRef myContext, 
							 CGRect myContextRect, 
							 const char *filename) 
{
	
    CGDataProviderRef provider = CGDataProviderCreateWithFilename(filename);
    CGImageRef image = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
	CGRect rc = [[UIScreen mainScreen] bounds];
	CGContextClearRect(myContext, rc);
	if (image != nil)
	{	
		CGContextDrawImage(myContext, rc, image);
		CGImageRelease(image);
		CGDataProviderRelease(provider);		
	}
	
}

- (void) loadData
{
	self.backgroundColor = [UIColor whiteColor];
	drawerList = [[NSMutableArray alloc] init];
	undoManager = [[PPUndoManager alloc] init];
	
	location = previousLocation = CGPointMake(0.0f,0.0f);
	delegate = nil;
	
	cavasColor = [UIColor whiteColor];
	penColor = [UIColor blackColor];
	penSize = 5.0f;
	blendMode = kCGBlendModeNormal;
	normalRect = self.frame;
	selectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Resource/Image/selection.png"]];
	selectionView.alpha = 0;
	[self addSubview:selectionView];
    //	waterMarkLabel = nil;
}
// path is backgroundImage path
- (id) initWithFrame:(CGRect)frame andFile:(NSString *) path {
	if(CGRectEqualToRect(frame,CGRectZero))
	{
		UIImage * image = [UIImage imageWithContentsOfFile:path];
		CGSize imgSize  = image.size;
		frame = CGRectMake(0, 0, imgSize.width, imgSize.height);
		//printf("imgSize.width = %f , imgSize.heigth = %f \n",imgSize.width,imgSize.height);
	}
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self loadData];
		
		drawLayer = [[[CALayer alloc] init] autorelease];
		drawLayer.frame = self.layer.frame;
		[self.layer insertSublayer:drawLayer above:self.layer];
		
		bitMapContext = MyCreateBitmapContext(self.frame.size.width,self.frame.size.height);
		backgroundContext = MyCreateBitmapContext(self.frame.size.width,self.frame.size.height);
		if(path == nil){//如果传进来的参数为空，就生成一个绘画层即可
			haveBackSource = false;	
			[self loadBackgroundContext];
		}
		else
		{
			NSString * filename = [path lastPathComponent];
			NSRange range = [filename rangeOfString:@"."];
			NSString * name = [filename substringFromIndex:range.location+1];
			if([name caseInsensitiveCompare:@"jpg"] == 0)
			{
				MyCreateAndDrawJPEGImage(backgroundContext, self.bounds, [path	UTF8String]);
			}
			else if([name caseInsensitiveCompare:@"png"] == 0)
			{
				MyCreateAndDrawPNGImage(backgroundContext, self.bounds, [path	UTF8String]);
			}
			haveBackSource = true;	
		}
		CGImageRef backImage = CGBitmapContextCreateImage (backgroundContext); 
		[self.layer setContents:(id)backImage];
		CGImageRelease(backImage);
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
	if(self = [super initWithFrame:frame])
	{
		[self loadData];
		drawLayer = [[[CALayer alloc] init] autorelease];
		drawLayer.frame = self.layer.frame;
		[self.layer insertSublayer:drawLayer above:self.layer];
		
		bitMapContext = MyCreateBitmapContext(self.bounds.size.width,self.bounds.size.height);
		backgroundContext = MyCreateBitmapContext(self.bounds.size.width,self.bounds.size.height);
		//[self renderCanvas];
		if (image != nil)
		{	
			haveBackSource = true;	
			
			[self.layer setContents:(id)image.CGImage];
			//CGContextDrawImage(backgroundContext,self.bounds, image.CGImage);
		}else
		{
			haveBackSource = false;
			[self loadBackgroundContext];
		}
	}
	return self;
}

- (void)dealloc
{
	if (bitMapContext != NULL) {
		CGContextRelease (bitMapContext); 
	}
	
	if (backgroundContext != NULL) {
		CGContextRelease (backgroundContext); 
	}
	
	[undoManager  release];
	[drawerList	  release];
	[selectionView release];
	[drawLayer removeFromSuperlayer];
	[self.layer setContents:nil];
	
	[super dealloc];
}

#pragma mark Parameter setting
- (void) setBlendMode:(CGBlendMode)mode 
{
	blendMode = mode;
}

//- (void) setWaterMark:(NSString *) mark
//{
//	if(waterMarkLabel!=nil)
//	{
//		[waterMarkLabel removeFromSuperview];
//	}
//	CGSize size = [mark sizeWithFont:[UIFont italicSystemFontOfSize:22] constrainedToSize:CGSizeMake(300,200)];
//	CGRect frame = CGRectMake(0,0, size.width+10, size.height);
//	
//	waterMarkLabel = [[DrawerLabel alloc] initWithFrame:frame];
//	waterMarkLabel.textColor = penColor;
//	waterMarkLabel.backgroundColor = [UIColor clearColor];
//	waterMarkLabel.shadowColor = [UIColor yellowColor];
//	waterMarkLabel.shadowOffset = CGSizeMake(1,1);
//	waterMarkLabel.textAlignment = NSTextAlignmentCenter;
//	waterMarkLabel.text = mark;
//	waterMarkLabel.center = self.center;
//	[self addSubview:waterMarkLabel];
//	[waterMarkLabel release];
//}
//
//- (NSString *)getMarkText
//{
//	if(waterMarkLabel!=nil)
//		return waterMarkLabel.text;
//	else 
//		return @"";
//}
//
- (BOOL) canRedo
{
	return [undoManager canRedo];
}

- (BOOL) canUndo
{
	return [undoManager canUndo];
}

// 填充
- (void)renderCanvas:(BOOL)includeBackground
{// 根据参数看是否填充背景，在新建模式下可能需要删除时也填充背景，而在编辑模式的时候可能就不用填充，但是绘画层肯定是要删除的
	if(backgroundContext != nil && includeBackground){
		CGContextSetFillColorWithColor(backgroundContext, cavasColor.CGColor);
		CGContextFillRect(backgroundContext,[UIScreen mainScreen].bounds);
	}
	//[self deleteAllDrawerPath];
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) 
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//设置背景图片
- (void)setBackImage:(UIImage *)image
{
	if(nil!=backgroundContext && image!=nil)
	{
		haveBackSource = YES;
		[self deleteAllDrawerPath];

		//CGContextDrawImage(backgroundContext,self.bounds, image.CGImage);
		//[self.layer setContents:(id)image.CGImage];
		UIImageOrientation o = image.imageOrientation;
        UIImage *i = [PPDrawer fixOrientation:image];
        o = i.imageOrientation;
        [self.layer setContents:(id)i.CGImage];
		[self setNeedsDisplay];
	}
}
# pragma mark  -- drawAction

//- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	
//	CGContextTranslateCTM( context, 0,self.bounds.size.height);
//	CGContextScaleCTM (context, 1.0, -1.0);
	
//	NSDate* time1 = [NSDate date];
//	NSDate *time2 = nil;
//	NSDate *time3 = nil;
	//设置背景context 是为了把背景层和绘画层分开,不直接在contxt中画是因为context每次都会自动清除,清除再创建浪费性能
//	if(backgroundContext!=nil)
//	{
//		CGImageRef backImage = CGBitmapContextCreateImage (backgroundContext); 
////		time2 = [NSDate date];
////		NSTimeInterval flip1 = [time2 timeIntervalSinceDate:time1];
////		DLOG(@"flip1 use time: %f", flip1 * 1000);
//
//		[self.layer setContents:(id)backImage];
//		//CGContextDrawImage(context, self.bounds, backImage);
//		
//		CGImageRelease(backImage);
////		time3 = [NSDate date];
////		NSTimeInterval flip2 = [time3 timeIntervalSinceDate:time2];
////		DLOG(@"flip2 use time: %f", flip2 * 1000);
//	}
//	else {
//		DLOG(@"backgroundContext == nil");
//	}
	
//	CGImageRef myImage = CGBitmapContextCreateImage (bitMapContext); 
////	NSDate* time4 = [NSDate date];
////	NSTimeInterval flip3 = [time4 timeIntervalSinceDate:time3];
////	DLOG(@"flip3 use time: %f", flip3 * 1000);
//	
//	[drawLayer setContents:(id)myImage];
//	//CGContextDrawImage(context, self.bounds, myImage);
//	
//	CGImageRelease(myImage);
	
//	NSDate* time5 = [NSDate date];
//	NSTimeInterval flip4 = [time5 timeIntervalSinceDate:time4];
//	DLOG(@"flip4 use time: %f", flip4 * 1000);
	
//	CGContextTranslateCTM( context, 0,self.bounds.size.height);
//	CGContextScaleCTM (context, 1.0, -1.0);

//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([_GLOBAL GetDrawerState]%2 == 0)// 如果菜单已经弹出，收回
	{
		return;
	}
	
    UITouch*	touch = [[event touchesForView:self] anyObject];
	
	//	
	//
	//CGRect	bounds = [self bounds];
	firstTouch = YES;
	location = [touch locationInView:self];
	
	//	如果是擦除模式添加圈圈表示擦除的位置
	if(blendMode==kCGBlendModeClear)
	{
		selectionView.alpha = 1;
		selectionView.frame = CGRectMake(0, 0, penSize+10, penSize+10);
		selectionView.center= location;
	}else if(blendMode == kCGBlendModeNormal)
	{
		selectionView.alpha = 0;
	}
	//sender delegate selector
	if(delegate!=nil&&[delegate respondsToSelector:@selector(PPDrawer:didBeginDraw:)])
		[delegate PPDrawer:self didBeginDraw:location];
	
	//move water mark
    //	if(waterMarkLabel!=nil&&CGRectContainsPoint(waterMarkLabel.frame, location)&&[Global GetDrawerState] == STATE_MOVE)
    //	{
    //		[waterMarkLabel touchesBegan:touches withEvent:event];
    //		return;
    //	}
	
	//adjust to negative CTM
	location.y = self.bounds.size.height - location.y;
	if([_GLOBAL GetDrawerState]==STATE_MOVE) return;
	
	
	DrawerList *newLine = [[DrawerList alloc] init];
	NSDictionary * drawElement = [NSDictionary dictionaryWithObjectsAndKeys:
								  newLine,@"line",
								  penColor,@"color",
								  [NSNumber numberWithFloat:penSize],@"size",
								  [NSNumber numberWithInt:blendMode],@"blendMode",nil];
	[newLine release];
	[self addPathWithDrawElement:drawElement];
	[self addPoint:location];
	
	
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	if([_GLOBAL GetDrawerState]%2 == 0)
	{
		return;
	}
	//CGRect				frame = [self bounds];
	UITouch*			touch = [[event touchesForView:self] anyObject];
	
	location = [touch locationInView:self];
	previousLocation = [touch previousLocationInView:self];
	
	//	如果是擦除模式添加圈圈表示擦除的位置
	if(blendMode==kCGBlendModeClear)
	{
		selectionView.center= location;
	}
	
	//sender delegate selector
	if(delegate!=nil&&[delegate respondsToSelector:@selector(PPDrawer:didMoveToPoint:)])
	{
		[delegate PPDrawer:self didMoveToPoint:location];
	}
	
	//wark mark move
    //	if(waterMarkLabel!=nil&&CGRectContainsPoint(waterMarkLabel.frame, location)&&[Global GetDrawerState] == STATE_MOVE)
    //	{
    //		[waterMarkLabel touchesMoved:touches withEvent:event];
    //		return;
    //	}
	
	// CTM adjustment
	location.y = self.bounds.size.height - location.y;
	previousLocation.y = self.bounds.size.height - previousLocation.y;
	
	if([_GLOBAL GetDrawerState]!=STATE_MOVE)
	{
		[self addPoint:location];
		//[self onDraw];
		[self onUpdate];
	}
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([_GLOBAL GetDrawerState]%2 == 0)
	{
		NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:kDismissMenuNotification object:nil];
		return;
	}
	selectionView.alpha = 0;
	if([_GLOBAL GetDrawerState] == STATE_MOVE) return;
	
	//CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		
		previousLocation.y = self.bounds.size.height - previousLocation.y;
		
		[self addPoint:location];
		
		[self onUpdate];
	}
	//sender delegate selector	
	if(delegate!=nil&&[delegate respondsToSelector:@selector(PPDrawer:didEndDraw:)])
		[delegate PPDrawer:self didEndDraw: CGPointMake( location.x,(self.frame.size.height - location.y))];
	
}

#pragma mark --setAndGetAction

- (void) setPenColor:(UIColor *) color
{
	penColor = [UIColor colorWithCGColor: CGColorCreateCopy(color.CGColor)];
	[penColor retain];
}

- (void) setCanvasColor:(UIColor *) color
{
	cavasColor = [UIColor colorWithCGColor: CGColorCreateCopy(color.CGColor)];
	[cavasColor retain];
	//[self renderCanvas];
	[self setNeedsDisplay];
}

- (void) setPenSize:(CGFloat) size
{
	penSize = size;
}

- (void) resetCanvas
{
	//	CGBlendMode mode = blendMode;
	//	blendMode = kCGBlendModeClear;
	//	[self onDraw];
	//	blendMode = mode;
	haveBackSource = false;
	[self loadBackgroundContext];
	//waterMarkLabel.text = nil;
	[self deleteAllDrawerPath];
	
}

- (UIImage * )getImage
{
	UIImage * image = nil;
	if(bitMapContext != nil)
	{
		//		CGImageRef myImage = CGBitmapContextCreateImage (bitMapContext); 
		//		image = [UIImage imageWithCGImage:myImage];
		//		CGImageRelease(myImage);
		if(!haveBackSource)
		{
			CGContextSetFillColorWithColor(backgroundContext, [UIColor whiteColor].CGColor);
			CGContextFillRect(backgroundContext,[UIScreen mainScreen].bounds);
		}
		UIGraphicsBeginImageContext(self.bounds.size);
		//[self  setNeedsDisplay];
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}	
	return image;
}
- (BOOL) undoAction
{
	if([undoManager canUndo])
	{
		[undoManager undo];
		[self onDraw];
		return YES;
	}else
	{
		return NO;
	}
}
- (BOOL) redoAction
{
	if([undoManager canRedo])
	{
		[undoManager redo];
		[self onDraw];
		return YES;
	}else
	{
		return NO;
	}
}

#pragma mark  saveData
- (int)saveDataToPath:(NSString *)filePath EncryptType:(int)encryptFlag Password:(NSString *)password
{
	//  SCREEN SHOT
	int dataLen = 0;
	//	CGImageRef image1 = CGBitmapContextCreateImage(bitMapContext);
	//	
	//	if (image1 != nil) {
	//		UIImage *uiimage = [UIImage imageWithCGImage:image1];
	//		NSData* imageData =  UIImagePNGRepresentation(uiimage);	
	//		[imageData writeToFile:@"/abc.png" atomically:NO];
	//		//Smart Point don't need to release;
	//		CGImageRelease(image1);
	//	} //save a context
	
	
	UIGraphicsBeginImageContext(self.bounds.size);
	
	//if we have background image there is no need to fill background
//	if(!haveBackSource)
//	{
//		CGContextSetFillColorWithColor(backgroundContext, [UIColor whiteColor].CGColor);
//		CGContextFillRect(backgroundContext,[UIScreen mainScreen].bounds);
//	}
	selectionView.alpha = 0;
//	[self  setNeedsDisplay];
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	//  透明底图时去掉注释内容	
	//	[self loadBackgroundContext];
	//	[self deleteAllDrawerPath];
	//	[self setNeedsDisplay];
    
	NSData * data = UIImageJPEGRepresentation(image, 1.0f);
    char *dstdata = NULL;
    int dstlen = 0;
    if (encryptFlag == EF_NOT_ENCRYPTED) {
        
    }
    else if (encryptFlag == EF_NORMAL_ENCRYPTED) {
        if (ENCRYPT_SUCCESS == [ObjEncrypt EncryptItemEx:(const char *)data.bytes srclen:data.length dst:&dstdata dstlen:&dstlen pwd:(const char *)[password cStringUsingEncoding:NSASCIIStringEncoding]]) {
            data = [NSData dataWithBytes:dstdata length:dstlen];
        }
    }
    else if (encryptFlag == EF_HIGH_ENCRYPTED) {
        if (ENCRYPT_SUCCESS == [ObjEncrypt EncryptItem:(const char *)data.bytes srclen:data.length dst:&dstdata dstlen:&dstlen pwd:(const char *)[password cStringUsingEncoding:NSASCIIStringEncoding]]) {
            data = [NSData dataWithBytes:dstdata length:dstlen];
        }
    }
    
	dataLen = [data length];
	PlistController *pc = [[PlistController alloc] initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:CONFIGURE_FILE_PATH]];
	BOOL flag = [[[pc readDicPlist] objectForKey:@"drawerFlag"] boolValue];
	[pc	 release];
	if(flag)
	{
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	}
    
	[data writeToFile:filePath atomically:YES];
    
    if (dstdata) {
        delete dstdata;
    }
	
	//waterMarkLabel.text = nil;
	return dataLen;
}
@end

// 参考代码

//- (void) removePath
//{
//	MLOG(@"on remove path");
//	NSDictionary * drawerElement = [drawerList lastObject];
//	[drawerElement retain];//it will release on undo
//	if([drawerList count]>0)
//		[drawerList removeLastObject];
//	[[undoManager prepareWithInvocationTarget:self] addPathWithList:[drawerElement objectForKey:@"line"]
//															  Color:[drawerElement objectForKey:@"color"]
//															   Size:[[drawerElement objectForKey: @"size"] floatValue]
//														  blendMode:(CGBlendMode)[[drawerElement objectForKey:@"blendMode"] intValue]];
//	
//}
//- (void) addPathWithList:(DrawerList *) list Color:(UIColor *)color Size:(CGFloat) size blendMode:(CGBlendMode)mode
//{
//	MLOG(@"on add path");
//	DrawerList * newLine = nil;
//	if(list == nil)
//		newLine = [[DrawerList alloc] init];
//		else
//			newLine = list;
//			
//			NSDictionary * drawElement = [NSDictionary dictionaryWithObjectsAndKeys:
//										  newLine,@"line",
//										  color,@"color",
//										  [NSNumber numberWithFloat:size],@"size",
//										  [NSNumber numberWithInt:mode],@"blendMode",nil];
//			[drawerList addObject:drawElement];
//	[newLine release];
//	[[undoManager prepareWithInvocationTarget:self] removePath];
//	
//}


//if(drawerString!=nil)
//{
//	CGSize          myShadowOffset = CGSizeMake (2,  2);
//	//CGContextSetShadow (context, myShadowOffset, 5);
//	CGContextSetShadowWithColor (context, myShadowOffset, 5, [UIColor whiteColor].CGColor); 
//	CGAffineTransform myTextTransform =  CGAffineTransformMakeRotation  (radians (45)); 
//	CGContextSetTextMatrix (context, myTextTransform); 
//	
//	CGSize size = [drawerString sizeWithFont:[UIFont italicSystemFontOfSize:25]];
//	
//	[penColor set];
//	[drawerString drawAtPoint:CGPointMake((self.center.x-size.width/2),(self.center.y-size.height/2)+80) withFont:[UIFont systemFontOfSize:25]];
//	myTextTransform  = CGAffineTransformMakeRotation  (radians (-45));
//	CGContextSetTextMatrix (context, myTextTransform);
//	CGContextSetShadowWithColor (context, myShadowOffset, 5, [UIColor clearColor].CGColor); 
//}
#if 0  //点坐标会变掉,所以暂时没加进去	
//UIScrollView * scroll = (UIScrollView*)(self.superview);
//CGFloat height = scroll.contentSize.height;
//CGFloat width  = scroll.contentSize.width;
//if([touch tapCount] == 2&&[Global GetDrawerState] == STATE_MOVE)
//{
//	
//	if(height == normalRect.size.height || width == normalRect.size.width)
//	{
//		// scroll.contentSize = CGRectInset(self.bounds,-320/2,-480/2).size;
//		CGPoint center = self.center;
//		self.frame = CGRectInset(self.frame,-normalRect.size.width/2,-normalRect.size.height/2);
//		self.center = CGPointMake(center.x+normalRect.size.width/2,center.y+normalRect.size.height/2);
//		scroll.contentSize = self.frame.size;
//		scroll.maximumZoomScale = scroll.maximumZoomScale*0.5;
//		scroll.minimumZoomScale = scroll.minimumZoomScale*0.5;
//		
//		[scroll setContentOffset:CGPointMake(normalRect.size.width/2,normalRect.size.height/2-44)];
//	}else
//	{	
//		// scroll.contentSize = CGRectMake(0, 0, 320, 480).size;
//		self.frame = normalRect;
//		scroll.contentSize = self.frame.size;
//		scroll.maximumZoomScale = 15;
//		scroll.minimumZoomScale = 1;
//		[scroll setContentOffset:CGPointZero];
//		
//	}
//}
#endif
