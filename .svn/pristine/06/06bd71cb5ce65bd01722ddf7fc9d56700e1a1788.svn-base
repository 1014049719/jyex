//
//  DrawerCtr.m
//  NoteBook
//
//  Created by chen wu on 09-7-20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPAnimation.h"
#import "DrawerCtr.h"
#import "Global.h"
#import "Common.h"
#import "ObjEncrypt.h"
#import "Constant.h"
#import "logging.h"


enum SETTING_TOOL {
	TOOL_COLOR,
	TOOL_SHAPE,
	TOOL_BUCKET
};

@interface UIAlertView (extended)
- (void) setNumberOfRows: (int) number;
@end



@implementation DrawerCtr
@synthesize penColor,renderImage,imagePath,defaultSegmentIndex;
@synthesize noteTitle;


#pragma mark Actions
// all menus actions
- (void) colorAction
{
	
	if(![colorManager hasShowed])
	{
		[curMenu dismiss];
		[colorManager showAboveView:toolbar];
		curMenu = colorManager;
	}
	else
	{
		[curMenu dismiss];
		[self setPenColor:[colorManager getColor]];
		[drawer setPenColor:penColor];
	}
}

- (void)sizeAction
{
	
	if(![sizeManager hasShowed])
	{
		[curMenu dismiss];
		if([Global GetDrawerState] == STATE_ERASE)	
		{
			[sizeManager setPenColor:[UIColor whiteColor] size:eraserSize];
		}	
		else
		{
			[self setPenColor:[colorManager getColor]];
			[sizeManager setPenColor:penColor size:penSize];
		}
		[sizeManager showAboveView:toolbar];
		
		curMenu = sizeManager;
	}
	else
	{
		[curMenu dismiss];
		
		if([Global GetDrawerState] == STATE_ERASE)	
		{
			eraserSize = [sizeManager getPenSize];
			[drawer setPenSize:eraserSize];
		}else
		{
			penSize = [sizeManager getPenSize];
			[drawer setPenSize:penSize];
		}
	}
}

- (void) dimissMenu:(id)sender
{
	if([curMenu hasShowed])
	{
		[curMenu dismiss];
	}
}

- (void)PPMenuSheetDelegate:(PPMenuSheet *)menu willShowAboveView:(UIView *)view
{
	if([Global GetDrawerState]%2 == 1)
		[Global SetDrawerState:[Global GetDrawerState]<<1];
}

- (void)PPMenuSheetDelegate:(PPMenuSheet *)menu willDismissFromView:(UIView *)view
{
	if([Global GetDrawerState]%2 == 0)
		[Global SetDrawerState:[Global GetDrawerState]>>1];
	
	if(menu == colorManager)
	{
		[self setPenColor:[colorManager getColor]];
		[drawer setPenColor:penColor];
		
	}else if(menu == sizeManager)
	{
		if([Global GetDrawerState] == STATE_ERASE)	
		{
			eraserSize = [sizeManager getPenSize];
			[drawer setPenSize:eraserSize];
		}else
		{
			penSize = [sizeManager getPenSize];
			[drawer setPenSize:penSize];
		}
	}
	
	
}

// all menus actions end

// all image actions
- (UIImage * )getImage
{
	return [drawer getImage];
}

- (void) showAlbum
{
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void) getFromAlbum
{
	
	if([drawer canUndo])
	{
		/*
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"OPEN_FILE ?")
														 message:_(@"ALERT_GET_IMAGE") 
														delegate:self 
											   cancelButtonTitle:_(@"Cancel")
											   otherButtonTitles:_(@"OK"),nil];
		*/
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"OPEN_FILE ?"
														 message:@"ALERT_GET_IMAGE"
														delegate:self 
											   cancelButtonTitle:@"Cancel"
											   otherButtonTitles:@"OK",nil];        
        
		alert.tag = 102;
		[alert show];
		[alert release];
	}
    else
	{
		[self showAlbum];
	}
	
}
// all image actions end

// redo and undo
- (void) cancelAction:(id)sender
{
	//[self dismissModalViewControllerAnimated:YES];
    
    //要修改。。
}


- (void)redoAction
{
	[curMenu dismiss];
	if([Global GetDrawerState]!=STATE_MOVE&&[drawer redoAction])
	{
		self.navigationItem.rightBarButtonItem = saveButton;
	}
}

- (void)undoAction
{
	[curMenu dismiss];
	if([Global GetDrawerState]!=STATE_MOVE)
	{
		[drawer undoAction];	
		
		if([drawer.drawerList count] == 0 && !hasChanged)
			self.navigationItem.rightBarButtonItem = nil;
	}
}
//  redo and und end 

//  create and save actions 
- (void) segmentAction:(id)sender
{
	if([Global GetDrawerState]%2 == 0)
	{
		[self dimissMenu:nil];
	}
	
	int toolKind = segment.selectedSegmentIndex;
	
	switch (toolKind) {
		case 0:
			[Global SetDrawerState:STATE_DRAW];
			[drawer setPenSize:penSize];
			[drawer setBlendMode:kCGBlendModeNormal];
			canvaView.delegate = nil;
			canvaView.scrollEnabled = NO;
			break;
		case 1:
			[Global SetDrawerState:STATE_ERASE];
			[drawer setBlendMode:kCGBlendModeClear];
			[drawer setPenSize:eraserSize];
			canvaView.delegate = nil;
			canvaView.scrollEnabled = NO;
			break;
		case 2:
			canvaView.scrollEnabled = YES;
			[drawer setBlendMode:kCGBlendModeNormal];
			[Global SetDrawerState:STATE_MOVE];
			canvaView.delegate = self;
			break;
		default:
			break;
	}
	[self initToolbarItems];
}

- (void) saveAction
{
	[curMenu dismiss];

	if(isNewState)// 是否新建
	{
        /*
		PlayerViewController * record = [[PlayerViewController alloc] initWithNoteInfo:NULL lastViewController:self];
		record.m_delegateSaveNew = self;
		record.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																					style:UIBarButtonItemStyleBordered 
																				   target:record action:@selector(canelAction:)] autorelease];
		UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:record];
		[self presentModalViewController:nav animated:YES];
		
		[record release];
		[nav release];
		
		record = nil;
		nav = nil;
        */ 
	}
    else
	{
        /*
		int len = [drawer saveDataToPath:[NSString stringWithFormat:@"%@/%@.jpg",[CommonFunc getTempDir], [CommonFunc guidToNSString:m_noteInfo.guidFirstItem]] EncryptType:m_noteInfo.nEncryptFlag Password:[Global getItemPassword]];
        
        m_noteInfo.dwSize = len;
        
        [Business updateItemLen:m_noteInfo.guidFirstItem newItemLen:len];
        [Business updateItem:m_noteInfo.guidFirstItem encrypttype:m_noteInfo.nEncryptFlag];
        [Business updateNote:m_noteInfo];
		hasSave = YES;
        
        RecentNoteListCtr *viewer = [RecentNoteListCtr defaultView];
		[viewer.navigationController popViewControllerAnimated:NO];
		[self dismissModalViewControllerAnimated:NO];
		[[HomePageCtr shareHomeCtr] setSelectIndex:3];
		*/
	}
}
//  create and save actions  end



- (void)cleanAction
{
	[curMenu dismiss];
	if(isNewState == YES)
	{
		if(self.navigationItem.rightBarButtonItem!=nil)
		{
            /*
			UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Hint")
															 message:_(@"DRAWER_CHANGE_FOR_CLEAN_NEW") 
															delegate:self
												   cancelButtonTitle:_(@"Cancel") 
												   otherButtonTitles:_(@"Yes"),nil];
            */
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hint"
															 message:@"DRAWER_CHANGE_FOR_CLEAN_NEW"
															delegate:self
												   cancelButtonTitle:@"Cancel"
												   otherButtonTitles:@"Yes",nil];
            
			alert.tag = 1;
			[alert show];
			[alert release];
		}else {
			//[drawer setCanvasColor:[UIColor whiteColor]];
			//[drawer renderCanvas:YES];
			[drawer resetCanvas];
		}
	}else
	{
        /*
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Hint")
														 message:_(@"DRAWER_CHANGE_FOR_CLEAN_EDIT") 
														delegate:self
											   cancelButtonTitle:_(@"Cancel") 
											   otherButtonTitles:_(@"Yes"),nil];
        */
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hint"
														 message:@"DRAWER_CHANGE_FOR_CLEAN_EDIT"
														delegate:self
											   cancelButtonTitle:@"Cancel"
											   otherButtonTitles:@"Yes",nil];
		
		alert.tag = 2;
		[alert show];
		[alert release];
	}
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		if(alertView.tag == 1)
		{
			self.navigationItem.rightBarButtonItem = nil;
			[drawer resetCanvas];
		}else if(alertView.tag == 2)
		{
			///[drawer setCanvasColor:[UIColor whiteColor]];
			self.navigationItem.rightBarButtonItem = saveButton;
			[drawer resetCanvas];
		}else if(alertView.tag == 3)
		{
			
		}else if (alertView.tag == 102)
		{
			[self showAlbum];
		}else if (alertView.tag == 122)
		{
			self.navigationItem.rightBarButtonItem = saveButton;
		}
		//[drawer renderCanvas:YES];
		
	}
}

#pragma mark view Created
- (void)initToolbarItems 
{	
	if(toolbar)
	{
		[toolbar release];
		[toolbar removeFromSuperview];
	}
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460-44-44, 320, 44)];
	
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	UIBarButtonItem *waterMark =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
																				target:self
																				action:@selector(bookMarkAction)];
	
	
	UIBarButtonItem *discardItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
																				 target:self
																				 action:@selector(cleanAction)];
	
	UIBarButtonItem *colorItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"palette.png"]]
																  style:UIBarButtonItemStylePlain target:self action:@selector(colorAction)];
	
	UIBarButtonItem *sizeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"brush.png"]]
																 style:UIBarButtonItemStylePlain
																target:self action:@selector(sizeAction)];
	
	UIBarButtonItem *redoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"redo.png"]]
																 style:UIBarButtonItemStylePlain
																target:self action:@selector(redoAction)];
	
	UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"undo.png"]]
																 style:UIBarButtonItemStylePlain
																target:self action:@selector(undoAction)];
	UIBarButtonItem *albumItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemOrganize
																			   target: self
																			   action: @selector(getFromAlbum)];
	
	NSArray *items = nil;
	if(segment.selectedSegmentIndex == 0)
	{
		items = [NSArray arrayWithObjects:
				 undoItem,flexItem,redoItem,flexItem,colorItem,flexItem,sizeItem,flexItem,/*waterMark,flexItem,*/albumItem,flexItem,discardItem, nil];
		[toolbar setItems:items animated:NO];
	}else if(segment.selectedSegmentIndex == 1)
	{
		items = [NSArray arrayWithObjects:flexItem,undoItem,flexItem,sizeItem,flexItem,redoItem,flexItem,nil];
		[toolbar setItems:items animated:NO];
	}else if(segment.selectedSegmentIndex == 2){
		UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,44)];
		lb.text = @"MOVE_NOTICE";
		lb.textColor = [UIColor whiteColor];
		lb.shadowColor = [UIColor grayColor];
		lb.shadowOffset = CGSizeMake(1, 1);
		lb.highlighted = YES;
		lb.textAlignment = UITextAlignmentCenter;
		lb.backgroundColor = [UIColor clearColor];
		[toolbar addSubview:lb];
		[lb release];
	}
	
	
	//[toolbar addSubview:segment];
	//self.navigationItem.titleView = segment;
	self.navigationItem.titleView = segment;
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	[self.view addSubview:toolbar];
	
	
	[waterMark	 release];
	[flexItem	 release];
	[colorItem	 release];
	[sizeItem	 release];
	[redoItem	 release];
	[undoItem	 release];
	[discardItem release];
	[albumItem	 release];
}

- (void)dismissViewControllerDelay:(NSNotification *)notification {
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:0.5];
}
- (void)dismissViewController {
    [self dismissModalViewControllerAnimated:YES];
    //[[HomePageCtr shareHomeCtr] setSelectIndex:3];
}

/*
-(void) createdSegment
{
	
	segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
														 [UIImage imageNamed:@"pen.png"],
														 [UIImage imageNamed:@"eraser.png"],
														 [UIImage imageNamed:@"move.png"],nil]];
	[segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segment.frame = CGRectMake(10, 7, 88+60, 30);
	segment.segmentedControlStyle = UISegmentedControlStyleBar;	
	segment.tintColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.1];
	segment.selectedSegmentIndex = defaultSegmentIndex;
	
}
*/


- (void)loadPenState
{
	pc = [[PlistController alloc] initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:CONFIGURE_FILE_PATH]];
	NSMutableDictionary *dic = [pc readDicPlist];
	NSNumber * pSize = [dic objectForKey:@"penSize"];
	NSNumber * eSize = [dic objectForKey:@"eraserSize"];
	penSize = [pSize floatValue];
	eraserSize = [eSize floatValue];
	if(penSize == 0) penSize = 2;//防止没有plist文件的情况;
	[drawer setPenSize:penSize];
	
	NSDictionary *color = [dic objectForKey:@"selectedColor"];
	NSNumber * red = [color objectForKey:@"red"];
	NSNumber * blue= [color objectForKey:@"blue"];
	NSNumber * green=[color objectForKey:@"green"];
	
	penColor = [[UIColor alloc] initWithRed:[red floatValue] green:[green floatValue] blue:[blue floatValue] alpha:1];
	
	if(penColor == nil)
		penColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
	[drawer setPenColor:penColor];
}

- (id)init
{
	if(self = [super init])
	{
		self.renderImage = nil;
		self.imagePath = nil;
		isNewState = NO;
		self.hidesBottomBarWhenPushed = YES;
		drawer = [[PPDrawer alloc] initWithFrame:[UIScreen mainScreen].bounds andFile:nil];
		drawer.delegate = self;
		
	}
	return self;
}


- (id) initWithImagePath:(NSString * )path title:(NSString *)aTitle state:(BOOL) isNew
{
	if(self = [super init])
    {
		self.title = aTitle;
		isNewState = isNew;
		self.imagePath = path;
		self.renderImage = nil;
		
		if(path == nil)
		{
			drawer = [[PPDrawer alloc] initWithFrame:[UIScreen mainScreen].bounds andFile:imagePath];
		}else
			drawer = [[PPDrawer alloc] initWithFrame:CGRectZero andFile:imagePath];
		drawer.delegate = self;
		defaultSegmentIndex = 0;
	}
	return self;
}

- (id) initWithImage:(UIImage *) image title:(NSString *)aTitle state:(BOOL) isNew
{
	if(self = [super init])
    {
		self.title = aTitle;
		isNewState = isNew;
		self.renderImage = image;
		self.imagePath = nil;
		drawer = [[PPDrawer alloc] initWithFrame:[UIScreen mainScreen].bounds andImage:renderImage];
		drawer.delegate = self;
		defaultSegmentIndex = 0;
	}
	return self;
}


- (void) loadView
{
	[super loadView];
	
	
	hasChanged = NO;
	colorManager = nil;	
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	if(noteTitle == nil)
		noteTitle = _(@"no title");	
	hasSave = NO;
	//self.navigationController.navigationBar.tintColor = [UIColor brownColor];
	
	saveButton = [[UIBarButtonItem alloc] initWithTitle:_(@"Save") style:UIBarButtonItemStyleDone
												 target:self action:@selector(saveAction)];
	// init pen
	[self loadPenState];
	
	//init tools
	
	sizeManager = [[PPSizeMenuManager alloc] initWithFrame:CGRectMake(0, 0, 320, 250) color:penColor size:penSize];
	sizeManager.delegate = self;
	
	canvaView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)/*[UIScreen mainScreen].bounds*/];
	canvaView.backgroundColor = [UIColor grayColor];
	canvaView.clipsToBounds = YES;
	canvaView.scrollEnabled = NO;
	canvaView.bounces = NO;
	canvaView.showsVerticalScrollIndicator = NO;
	canvaView.showsHorizontalScrollIndicator = NO;
	canvaView.delegate = nil;
	canvaView.minimumZoomScale = 1;
	canvaView.maximumZoomScale = 15;
	canvaView.bouncesZoom = YES;
	canvaView.delaysContentTouches = NO;
	canvaView.contentSize = drawer.frame.size;
	[canvaView addSubview:drawer];
	[self.view addSubview:canvaView];

	
	[self createdSegment];
	[self initToolbarItems];
	
	colorManager = [[PPColorMenuManager alloc] initWithFrame:CGRectMake(0, 50, 320, 270) color:self.penColor];
	colorManager.delegate = self;
	[(NSNotificationCenter *)[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dimissMenu:) name:kDismissMenuNotification object:nil];
}

- (void)viewDidLoad
{   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissViewControllerDelay:) name:@"dismissviewcontroller" object:nil];
    
    
	[super viewDidLoad];
	if(drawer.frame.size.width>320 || drawer.frame.size.height>480)
		canvaView.contentOffset = CGPointMake(drawer.center.x/2,drawer.center.y/2);
}

- (void)viewWillAppear:(BOOL)animated
{
    
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
	const float * cc = CGColorGetComponents(penColor.CGColor);
	NSNumber * red = [NSNumber numberWithFloat:cc[0]];
	NSNumber * green = [NSNumber numberWithFloat:cc[1]];
	NSNumber * blue = [NSNumber numberWithFloat:cc[2]];
	
	NSDictionary * colorDict = [NSDictionary dictionaryWithObjectsAndKeys:red,@"red",green,@"green",blue,@"blue",nil];
	[pc writeToPlistWithKey:@"selectedColor" vlaue:colorDict];
	[pc writeToPlistWithKey:@"penSize" vlaue:[NSNumber numberWithFloat:penSize]];
	[pc writeToPlistWithKey:@"eraserSize" vlaue:[NSNumber numberWithFloat:eraserSize]];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}




#pragma mark  ~ scrollViewDelgate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return drawer;
}

#pragma mark ~ PPTextViewDeletgate
//- (void)PPTextViewDidPost:(PPTextView*)mtextView item:(UIBarButtonItem *)postItem
//{
//	[tv	postEnd];
//	NSString * mark = [[tv getText] copy];
//	
//	[tv removeFromSuperview];
//	[drawer setNeedsDisplay];
//	[mark   release];
//}

#pragma mark ~ DrawerDelegate
-(void) PPDrawer:(PPDrawer *) drawer didBeginDraw:(CGPoint) point
{
	
	if([Global GetDrawerState]!=STATE_MOVE)
	{
		self.navigationItem.rightBarButtonItem = saveButton;
		hasSave = NO;
		
	}
	
}

-(void) PPDrawer:(PPDrawer *) drawer didEndDraw:(CGPoint) point
{
	if(toolbar.alpha == 0)
		[[PPAnimation shareAnimation] fadeAnimation:toolbar visiable:YES];
}

-(void)	PPDrawer:(PPDrawer *) drawer didMoveToPoint:(CGPoint) point
{
	//printf("point y = %f\n",point.y);
	
	if([Global GetDrawerState] == STATE_MOVE) return;
	if((point.y > 350)&&toolbar.alpha == 1)
		[[PPAnimation shareAnimation] fadeAnimation:toolbar visiable:NO];
	
}


- (void)imagePickerController:(UIImagePickerController*)picker
    didFinishPickingImage:(UIImage*)image
    edingInfo:(NSDictionary*)editingInfo
{
    [drawer setBackImage:image];
	self.navigationItem.rightBarButtonItem = saveButton;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [drawer setBackImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
	self.navigationItem.rightBarButtonItem = saveButton;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag == 101)
	{
		if(buttonIndex == 0)
		{
			//[self showUploadView];
		}else
		{
			[itemId release];
			[noteId release];
			[contentImage release];
			[self dismissModalViewControllerAnimated: YES];
		}
	}
}

-(void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissviewcontroller" object:nil];
    
	NSLog(@"DrawerCtr dealloc");
	drawer.delegate = nil;
	canvaView.delegate = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	SAFE_DELETE(updata);
	[renderImage	release];
	[pc				release];
	[drawer			release];
	[penColor		release];
	[canvaView		release];
	[segment		release];
	[saveButton		release];
	[sizeManager	release];
	[colorManager	release];
	[toolbar		release];
	//	[singleChooseView release];
	[super dealloc];
	LOG_ERROR(@"DrawerCtr dealloc end");
}


#pragma mark -
#pragma mark NoteSaveDelegate
- (void)save:(NSString *)title starlevel:(int)level{

    /*
	GUID guidItem = [CommonFunc createGUID];
	GUID guidNote = [CommonFunc createGUID];
	itemId = [CommonFunc guidToNSString:guidItem];
	noteId = [CommonFunc guidToNSString:guidNote];
		
	NSString * savePath = [NSString stringWithFormat:@"%@/%@.jpg",[CommonFunc getTempDir],itemId];
	MLOG(@"保存图片路径: %@", savePath);
		
    // 本地保存
	int len = [drawer saveDataToPath:savePath EncryptType:m_noteInfo.nEncryptFlag Password:[Global getItemPassword]];
	
    NoteInfo noteInfo;
	ItemInfo itemInfo;
	[CommonFunc makeNoteInfo:&noteInfo noteID:guidNote title:title noteType:NOTE_CUST_DRAW size:len star:level fileExt:@"jpg" firstItemID:guidItem];
	[CommonFunc makeItemInfo:&itemInfo itemId:guidItem itemType:NI_PIC fileExt:@"jpg" size:len];
	if (![Business addNote:noteInfo firstItemInfo:itemInfo])
	{
		MLOG(@"addNote failed");
	}
	
    RecentNoteListCtr *viewer = [RecentNoteListCtr defaultView];
    [viewer.navigationController popViewControllerAnimated:NO];
    [self dismissModalViewControllerAnimated:NO];
    [[HomePageCtr shareHomeCtr] setSelectIndex:3];
	//[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
	MLOG(@"本地保存 图片 完成");
    */
}

- (void)save:(NSString *)title starlevel:(int)level encrypttype:(int)encrypttype password:(NSString *)passwor
{
    
/*    
    if(isNewState)// 是否新建
	{
        GUID guidItem = [CommonFunc createGUID];
        GUID guidNote = [CommonFunc createGUID];
        itemId = [CommonFunc guidToNSString:guidItem];
        noteId = [CommonFunc guidToNSString:guidNote];
        
        NSString * savePath = [NSString stringWithFormat:@"%@/%@.jpg",[CommonFunc getTempDir],itemId];
        int len = [drawer saveDataToPath:savePath EncryptType:encrypttype Password:password];

        NoteInfo noteInfo;
        ItemInfo itemInfo;
        [CommonFunc makeNoteInfo:&noteInfo noteID:guidNote title:title noteType:NOTE_CUST_DRAW size:len star:level fileExt:@"jpg" firstItemID:guidItem];
        noteInfo.nEncryptFlag = encrypttype;
        [CommonFunc makeItemInfo:&itemInfo itemId:guidItem itemType:NI_PIC fileExt:@"jpg" size:len];
        itemInfo.nEncryptFlag = encrypttype;
        [Business addNote:noteInfo firstItemInfo:itemInfo];
	}
    else
	{
		int len = [drawer saveDataToPath:imagePath EncryptType:m_noteInfo.nEncryptFlag Password:password];
        m_noteInfo.nEncryptFlag = encrypttype;
        m_noteInfo.dwSize = len;
        
        [Business updateItemLen:m_noteInfo.guidFirstItem newItemLen:len];
        [Business updateItem:m_noteInfo.guidFirstItem encrypttype:encrypttype];
        [Business updateNote:m_noteInfo];
		hasSave = YES;
        
        RecentNoteListCtr *viewer = [RecentNoteListCtr defaultView];
		[viewer.navigationController popViewControllerAnimated:NO];
		[self dismissModalViewControllerAnimated:NO];
		[[HomePageCtr shareHomeCtr] setSelectIndex:3];
		
	}
    
*/    
}

@end
