//
//  UIDrawer.m
//  NoteBook
//
//  Created by susn on 12-11-19.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "UIDrawer.h"

#import "PPAnimation.h"
#import "DrawerCtr.h"
#import "Global.h"
#import "Common.h"
#import "ObjEncrypt.h"
#import "Constant.h"
#import "logging.h"
#import "CfgMgr.h"


enum SETTING_TOOL {
	TOOL_COLOR,
	TOOL_SHAPE,
	TOOL_BUCKET
};

@interface UIAlertView (extended)
- (void) setNumberOfRows: (int) number;
@end

@interface UIDrawer()
- (void)undoAction;
- (void)redoAction;
- (void)loadPenState;
- (void)setBtnSelectStateWithType:(int)type Index:(int)selectIndex;
- (void) getFromAlbum;
@end

float s_fColor[ 12 ][ 3 ]
= { {0.0, 0.0, 0.0}
    , {0x77/255.0, 0x77/255.0, 0x77/255.07}
    , {0xFE/255.0, 1.0/255.0, 0.0}
    , {1.0, 1.0/255.0, 0xFC/255.0}
    , {0xFE/255.0, 0x87/255.0, 0.0}
    , {0xFB/255.0, 1.0, 0.0}
    , {0x59/255.0, 1.0/255.0, 0xFE/255.0}
    , {0.0, 0x79/255.0, 1.0}
    , {0.0, 0xBB/255.0, 0xFE/255.0}
    , {0x14/255.0, 0xA9/255.0, 0.0}
    , {0x6A/255.0, 0x14/255.0, 0x12/255.0}
    , {0x80/255.0, 0x53/255.0, 0x24/255.0} };

float s_fPenSize[ 5 ] = { 1.0, 10.0, 20.0, 30.0, 40.0 };

@implementation UIDrawer
@synthesize penColor,renderImage,imagePath,defaultSegmentIndex;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.renderImage = nil;
        self.imagePath = nil;
        isNewState = NO;
        self.hidesBottomBarWhenPushed = YES;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //两个按钮的背景
    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateHighlighted];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];

    
	hasChanged = NO;
	//colorManager = nil;
	hasSave = NO;
	
	//saveButton = [[UIBarButtonItem alloc] initWithTitle:_(@"Save") style:UIBarButtonItemStyleDone
												// target:self action:@selector(saveAction)];
    
	//init tools
	//sizeManager = [[PPSizeMenuManager alloc] initWithFrame:CGRectMake(0, 0, 320, 250) color:penColor size:penSize];
	//sizeManager.delegate = self;
	
    CGRect mainframe = [UIScreen mainScreen].bounds;
    drawer = [[PPDrawer alloc] initWithFrame:mainframe andFile:nil];
    drawer.delegate = self;
    
    NSLog(@"mainframe:%@",NSStringFromCGRect(mainframe));
    
    // init pen
	[self loadPenState];
    
    self->m_btnColorArray[ 0 ] = self->m_btnColor0;
    self->m_btnColorArray[ 1 ] = self->m_btnColor1;
    self->m_btnColorArray[ 2 ] = self->m_btnColor2;
    self->m_btnColorArray[ 3 ] = self->m_btnColor3;
    self->m_btnColorArray[ 4 ] = self->m_btnColor4;
    self->m_btnColorArray[ 5 ] = self->m_btnColor5;
    self->m_btnColorArray[ 6 ] = self->m_btnColor6;
    self->m_btnColorArray[ 7 ] = self->m_btnColor7;
    self->m_btnColorArray[ 8 ] = self->m_btnColor8;
    self->m_btnColorArray[ 9 ] = self->m_btnColor9;
    self->m_btnColorArray[ 10 ] = self->m_btnColor10;
    self->m_btnColorArray[ 11 ] = self->m_btnColor11;
    [self setBtnSelectStateWithType:0 Index:self->m_uColorIndex];
    
    self->m_btnPenSizeArray[ 0 ] = self->m_btnPenSize0;
    self->m_btnPenSizeArray[ 1 ] = self->m_btnPenSize1;
    self->m_btnPenSizeArray[ 2 ] = self->m_btnPenSize2;
    self->m_btnPenSizeArray[ 3 ] = self->m_btnPenSize3;
    self->m_btnPenSizeArray[ 4 ] = self->m_btnPenSize4;
    [self setBtnSelectStateWithType:1 Index:self->m_uPenSizeIndex];
    
    self->m_btnEraserSizeArray[ 0 ] = self->m_btnEraserSize0;
    self->m_btnEraserSizeArray[ 1 ] = self->m_btnEraserSize1;
    self->m_btnEraserSizeArray[ 2 ] = self->m_btnEraserSize2;
    self->m_btnEraserSizeArray[ 3 ] = self->m_btnEraserSize3;
    self->m_btnEraserSizeArray[ 4 ] = self->m_btnEraserSize4;
    [self setBtnSelectStateWithType:2 Index:self->m_uEraserSizeIndex];
    [self->m_btnColorAndSize setSelected:YES];
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = m_NavView.frame.size.height;
    frame.size.width = mainframe.size.width;
    frame.size.height = mainframe.size.height - m_NavView.frame.size.height - m_viewToolbar.frame.size.height - 20;
    NSLog(@"canvaView frame: %@",NSStringFromCGRect(frame));
	//canvaView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-self->m_viewToolbar.frame.size.height - 44)/*[UIScreen mainScreen].bounds*/];
    canvaView = [[UIScrollView alloc] initWithFrame:frame];
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
    
	if(drawer.frame.size.width>canvaView.frame.size.width || drawer.frame.size.height>canvaView.frame.size.height) {
        CGPoint point = CGPointMake((drawer.frame.size.width-canvaView.frame.size.width)/2,(drawer.frame.size.height-canvaView.frame.size.height)/2);
        NSLog(@"contentsize=%@",NSStringFromCGPoint(point));
        
		//canvaView.contentOffset = CGPointMake(drawer.center.x/2,drawer.center.y/2);
        canvaView.contentOffset = point;
    }
	
    
	//[self createdSegment];
	//[self initToolbarItems];
    //{{Add chenyl UI修改,此toolbar不要了
    //self->toolbar.hidden = YES;
    //}}
	
	//colorManager = [[PPColorMenuManager alloc] initWithFrame:CGRectMake(0, 50, 320, 270) color:self.penColor];
	//colorManager.delegate = self;
    
    [self.view bringSubviewToFront:self->m_viewColorAndSize];
    [self.view bringSubviewToFront:self->m_viewEraserSize];
    
	//[(NSNotificationCenter *)[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dimissMenu:) name:kDismissMenuNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissViewControllerDelay:) name:@"dismissviewcontroller" object:nil];
      
    if ( STATE_DRAW != [_GLOBAL GetDrawerState] ) {
        [_GLOBAL SetDrawerState:STATE_DRAW];
        [drawer setPenSize:penSize];
        [drawer setBlendMode:kCGBlendModeNormal];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    
	NSLog(@"DrawerCtr dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.delegate = nil;  //add 2012.11.19
    
	drawer.delegate = nil;
	canvaView.delegate = nil;

    self.imagePath = nil;
    
    //	SAFE_DELETE(updata);
	[renderImage	release];
	//[pc				release];
	[drawer			release];
	[penColor		release];
	[canvaView		release];
	//[segment		release];
	//[saveButton		release];
	//[sizeManager	release];
	//[colorManager	release];
	//[toolbar		release];
	//	[singleChooseView release];
    
    SAFEREMOVEANDFREE_OBJECT(m_btnEraserSize0);
    SAFEREMOVEANDFREE_OBJECT(m_btnEraserSize1);
    SAFEREMOVEANDFREE_OBJECT(m_btnEraserSize2);
    SAFEREMOVEANDFREE_OBJECT(m_btnEraserSize3);
    SAFEREMOVEANDFREE_OBJECT(m_btnEraserSize4);
    
    SAFEREMOVEANDFREE_OBJECT(m_btnPenSize0);
    SAFEREMOVEANDFREE_OBJECT(m_btnPenSize1);
    SAFEREMOVEANDFREE_OBJECT(m_btnPenSize2);
    SAFEREMOVEANDFREE_OBJECT(m_btnPenSize3);
    SAFEREMOVEANDFREE_OBJECT(m_btnPenSize4);
    
    SAFEREMOVEANDFREE_OBJECT(m_btnColor0);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor1);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor2);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor3);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor4);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor5);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor6);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor7);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor8);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor9);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor10);
    SAFEREMOVEANDFREE_OBJECT(m_btnColor11);
    
    SAFEREMOVEANDFREE_OBJECT(m_viewEraserSize);
    
    SAFEREMOVEANDFREE_OBJECT(m_btnRedo);
    SAFEREMOVEANDFREE_OBJECT(m_btnUndo);
    SAFEREMOVEANDFREE_OBJECT(m_btnEraser);
    SAFEREMOVEANDFREE_OBJECT(m_btnColorAndSize);
    SAFEREMOVEANDFREE_OBJECT(m_viewToolbar);
    
    SAFEREMOVEANDFREE_OBJECT(m_viewColorAndSize);
    SAFEREMOVEANDFREE_OBJECT(m_btnPhoto);
    SAFEREMOVEANDFREE_OBJECT(m_btnDelete);
    SAFEREMOVEANDFREE_OBJECT(m_btnMove);
    
    SAFEREMOVEANDFREE_OBJECT(m_btnNavCancel);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavFinish);
    SAFEREMOVEANDFREE_OBJECT(m_segment);
    SAFEREMOVEANDFREE_OBJECT(m_NavView);
 
	[super dealloc];
    
	//LOG_ERROR(@"DrawerCtr dealloc end");
}




//控件响应函数
- (IBAction) onNavCancel :(id)sender
{    
    if ( YES == self->m_btnNavFinish.enabled) {
        UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认不保存笔记吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不保存",nil];
        alertview.tag = 50;
        [alertview show];
        [alertview release]; 
        return;
    }
    else
    {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(Drawer_ClickCancel:)] )
        {
            [self.delegate Drawer_ClickCancel:self];
        }
    }
}

- (IBAction) onNavFinish:(id)sender
{
    //图片保存
	//[curMenu dismiss];

    //int len = [drawer saveDataToPath:imagePath EncryptType:m_noteInfo.nEncryptFlag Password:[Global getItemPassword]];
    [drawer saveDataToPath:imagePath EncryptType:EF_NOT_ENCRYPTED Password:nil];
         
    hasSave = YES;
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(Drawer_ClickFinish:)] )
    {
        [self.delegate Drawer_ClickFinish:self];
    }

}

- (IBAction)onToolBar:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if ( btn == self->m_btnColorAndSize ) {
        [self->m_btnEraser setSelected:NO];
        [self->m_btnMove setSelected:NO];
        [btn setSelected:YES];
        self->m_viewEraserSize.hidden = YES;
        if ( STATE_DRAW != [_GLOBAL GetDrawerState] ) {
            [_GLOBAL SetDrawerState:STATE_DRAW];
			[drawer setPenSize:penSize];
			[drawer setBlendMode:kCGBlendModeNormal];
			canvaView.delegate = nil;
			canvaView.scrollEnabled = NO;
        }
        else
        {
            self->m_viewColorAndSize.hidden
                = !(self->m_viewColorAndSize.hidden);
        }
    }
    else if( btn == self->m_btnUndo )
    {
        [self undoAction];
    }
    else if( btn == self->m_btnRedo )
    {
        [self redoAction];
    }
    else if( btn == self->m_btnEraser )
    {
        [self->m_btnColorAndSize setSelected:NO];
        [self->m_btnMove setSelected:NO];
        [btn setSelected:YES];
        self->m_viewColorAndSize.hidden = YES;
        if ( STATE_ERASE != [_GLOBAL GetDrawerState] ) {
            [_GLOBAL SetDrawerState:STATE_ERASE];
			[drawer setBlendMode:kCGBlendModeClear];
			[drawer setPenSize:eraserSize];
			canvaView.delegate = nil;
			canvaView.scrollEnabled = NO;
        }
        else
        {
            self->m_viewEraserSize.hidden
                = !(self->m_viewEraserSize.hidden);
        }
    }
    else if( btn == self->m_btnMove )
    {
        [self->m_btnEraser setSelected:NO];
        [self->m_btnColorAndSize setSelected:NO];
        //[self->m_btnMove setSelected:YES];
        self->m_viewEraserSize.hidden = YES;
        self->m_viewColorAndSize.hidden = YES;
        canvaView.scrollEnabled = YES;
        [drawer setBlendMode:kCGBlendModeNormal];
        [_GLOBAL SetDrawerState:STATE_MOVE];
        canvaView.delegate = self;
    }
    else if( btn == self->m_btnDelete ) {
        if(isNewState == YES)
        {
            //if(self.navigationItem.rightBarButtonItem!=nil)
            if ( m_btnNavFinish.enabled )  //没有隐藏
            {
                /*
                 UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Hint")
                 message:_(@"DRAWER_CHANGE_FOR_CLEAN_NEW") 
                 delegate:self
                 cancelButtonTitle:_(@"Cancel") 
                 otherButtonTitles:_(@"Yes"),nil];
                 */
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                    message:@"确认清空画板吗"
                    delegate:self
                    cancelButtonTitle:@"取消"
                    otherButtonTitles:@"清空",nil];
                
                alert.tag = 1;
                [alert show];
                [alert release];
            }else {
                //[drawer setCanvasColor:[UIColor whiteColor]];
                //[drawer renderCanvas:YES];
                [drawer resetCanvas];
            }
        }
        else
        {
            /*
             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Hint")
             message:_(@"DRAWER_CHANGE_FOR_CLEAN_EDIT") 
             delegate:self
             cancelButtonTitle:_(@"Cancel") 
             otherButtonTitles:_(@"Yes"),nil];
             */
            if([drawer canUndo]) {  //add 2013.1.6
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"确认清空画板吗"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"清空",nil];
            
                alert.tag = 2;
                [alert show];
                [alert release];
            }
        }
    }
    else if( btn == self->m_btnPhoto ) {
        [self getFromAlbum];
    }
}

- (IBAction)onPenSize:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    assert( btn );
    self->m_uPenSizeIndex = btn.tag;
    penSize = s_fPenSize[ self->m_uPenSizeIndex ];
    [self setBtnSelectStateWithType:1 Index:self->m_uPenSizeIndex];
    [drawer setPenSize:penSize];
    self->m_viewColorAndSize.hidden = YES;
}

- (IBAction) onEraserSize:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    assert( btn );
    self->m_uEraserSizeIndex = btn.tag;
    eraserSize = s_fPenSize[ self->m_uEraserSizeIndex ];
    [self setBtnSelectStateWithType:2 Index:self->m_uEraserSizeIndex];
    [drawer setPenSize:eraserSize];
    self->m_viewEraserSize.hidden = YES;
}

- (IBAction) onColor:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    assert( btn );
    self->m_uColorIndex = btn.tag;
    [self setBtnSelectStateWithType:0 Index:self->m_uColorIndex];
    [self setPenColor:[UIColor colorWithRed:s_fColor[self->m_uColorIndex][0] \
            green:s_fColor[self->m_uColorIndex][1] \
            blue:s_fColor[self->m_uColorIndex][2] alpha:1.0]];
    [drawer setPenColor:penColor];
    self->m_viewColorAndSize.hidden = YES;
}

- (void)setBtnSelectStateWithType:(int)type Index:(int)selectIndex
{
    static int s_index[ 3 ] = { 0, 0, 0 };
    if ( 0 == type ) {  // 颜色
        assert( selectIndex >= 0 && selectIndex < 12 );
        [self->m_btnColorArray[ s_index[ 0 ] ] setSelected:NO];
        [self->m_btnColorArray[ selectIndex ] setSelected:YES];
        s_index[ type ] = selectIndex;
    }
    else if( 1 == type ) { //画笔
        assert( selectIndex >= 0 && selectIndex < 5 );
        [self->m_btnPenSizeArray[ s_index[ type ] ] setSelected:NO];
        [self->m_btnPenSizeArray[ selectIndex ] setSelected:YES];
        s_index[ type ] = selectIndex;
    }
    else if( 2 == type ) { // 橡皮
        assert( selectIndex >= 0 && selectIndex < 5 );
        [self->m_btnEraserSizeArray[ s_index[ type ] ] setSelected:NO];
        [self->m_btnEraserSizeArray[ selectIndex ] setSelected:YES];
        s_index[ type ] = selectIndex;
    }
}
#pragma mark Actions
// all menus actions
/*
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
*/

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
    [self presentViewController:picker animated:YES completion:nil];
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"选取照片会替换当前画板，确认吗"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"选取照片",nil];
        
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
	//[self dismissViewControllerAnimated:YES completion:nil];
    
    //要修改。。
}


- (void)redoAction
{
	//[curMenu dismiss];
	if([_GLOBAL GetDrawerState]!=STATE_MOVE&&[drawer redoAction])
	{
		//self.navigationItem.rightBarButtonItem = saveButton;
        //m_btnNavFinish.hidden = NO;
        m_btnNavFinish.enabled = YES;
	}
}

- (void)undoAction
{
	//[curMenu dismiss];
	if([_GLOBAL GetDrawerState]!=STATE_MOVE)
	{
		[drawer undoAction];
		
		if([drawer.drawerList count] == 0 && !hasChanged) {
			//self.navigationItem.rightBarButtonItem = nil;
            //m_btnNavFinish.hidden = YES;
            m_btnNavFinish.enabled = NO;
        }
	}
}
//  redo and und end 



//  create and save actions 
- (IBAction) segmentAction:(id)sender
{
	//if([Global GetDrawerState]%2 == 0)
	//{
	//	[self dimissMenu:nil];
	//}
	
	int toolKind = m_segment.selectedSegmentIndex;
	
	switch (toolKind) {
		case 0:
			[_GLOBAL SetDrawerState:STATE_DRAW];
			[drawer setPenSize:penSize];
			[drawer setBlendMode:kCGBlendModeNormal];
			canvaView.delegate = nil;
			canvaView.scrollEnabled = NO;
			break;
		case 1:
			[_GLOBAL SetDrawerState:STATE_ERASE];
			[drawer setBlendMode:kCGBlendModeClear];
			[drawer setPenSize:eraserSize];
			canvaView.delegate = nil;
			canvaView.scrollEnabled = NO;
			break;
		case 2:
			canvaView.scrollEnabled = YES;
			[drawer setBlendMode:kCGBlendModeNormal];
			[_GLOBAL SetDrawerState:STATE_MOVE];
			canvaView.delegate = self;
			break;
		default:
			break;
	}
	//[self initToolbarItems];
}

- (void) saveAction
{
	//[curMenu dismiss];
    
	if(isNewState)// 是否新建
	{
        /*
         PlayerViewController * record = [[PlayerViewController alloc] initWithNoteInfo:NULL lastViewController:self];
         record.m_delegateSaveNew = self;
         record.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
         style:UIBarButtonItemStyleBordered 
         target:record action:@selector(canelAction:)] autorelease];
         UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:record];
         [self presentViewController:nav animated:YES completion:nil];
         
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
         [self dismissViewControllerAnimated:YES completion:nil];
         [[HomePageCtr shareHomeCtr] setSelectIndex:3];
         */
	}
}
//  create and save actions  end



- (void)cleanAction
{
	//[curMenu dismiss];
	if(isNewState == YES)
	{
		//if(self.navigationItem.rightBarButtonItem!=nil)
        if ( /*!m_btnNavFinish.hidden*/m_btnNavFinish.enabled )  //没有隐藏
		{
            /*
             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Hint")
             message:_(@"DRAWER_CHANGE_FOR_CLEAN_NEW") 
             delegate:self
             cancelButtonTitle:_(@"Cancel") 
             otherButtonTitles:_(@"Yes"),nil];
             */
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"确认清空画板吗"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"清空",nil];
            
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
        if([drawer canUndo]) {  //add 2013.1.6
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"确认清空画板吗"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"清空",nil];
		
            alert.tag = 2;
            [alert show];
            [alert release];
        }
	}
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		if(alertView.tag == 1)
		{
			//self.navigationItem.rightBarButtonItem = nil;
            
            //m_btnNavFinish.hidden = YES;
            m_btnNavFinish.enabled = NO;
			[drawer resetCanvas];
		}
        else if(alertView.tag == 2)
		{
			//self.navigationItem.rightBarButtonItem = saveButton;
            //m_btnNavFinish.hidden = NO;
            m_btnNavFinish.enabled = YES;
            
			[drawer resetCanvas];
		}
        else if(alertView.tag == 3)
		{
			
		}
        else if (alertView.tag == 102)
		{
			[self showAlbum];
		}
        else if (alertView.tag == 122)
		{
			//self.navigationItem.rightBarButtonItem = saveButton;
            //m_btnNavFinish.hidden = NO;
            m_btnNavFinish.enabled = YES;
		}
        else if(alertView.tag == 50 )
        {
            if ( self.delegate && [self.delegate respondsToSelector:@selector(Drawer_ClickCancel:)] )
            {
                [self.delegate Drawer_ClickCancel:self];
            }
        }
		//[drawer renderCanvas:YES];
		
	}
}

#pragma mark view Created
/*
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
	if(m_segment.selectedSegmentIndex == 0)
	{
		items = [NSArray arrayWithObjects:
				 undoItem,flexItem,redoItem,flexItem,colorItem,flexItem,sizeItem,flexItem,albumItem,flexItem,discardItem, nil];
		[toolbar setItems:items animated:NO];
	}else if(m_segment.selectedSegmentIndex == 1)
	{
		items = [NSArray arrayWithObjects:flexItem,undoItem,flexItem,sizeItem,flexItem,redoItem,flexItem,nil];
		[toolbar setItems:items animated:NO];
	}else if(m_segment.selectedSegmentIndex == 2){
		UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,44)];
		lb.text = @"MOVE_NOTICE";
		lb.textColor = [UIColor whiteColor];
		lb.shadowColor = [UIColor grayColor];
		lb.shadowOffset = CGSizeMake(1, 1);
		lb.highlighted = YES;
		lb.textAlignment = NSTextAlignmentCenter;
		lb.backgroundColor = [UIColor clearColor];
		[toolbar addSubview:lb];
		[lb release];
	}
	
	
	//[toolbar addSubview:segment];
	//self.navigationItem.titleView = segment;
	//self.navigationItem.titleView = segment;
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
*/
 
- (void)dismissViewControllerDelay:(NSNotification *)notification {
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:0.5];
}
- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
	//pc = [[PlistController alloc] initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:CONFIGURE_FILE_PATH]];
	//NSMutableDictionary *dic = [pc readDicPlist];
//	NSNumber * pSize = [dic objectForKey:@"penSize"];
//	NSNumber * eSize = [dic objectForKey:@"eraserSize"];
//    NSNumber *penSizeIndex = [dic objectForKey:@"penSizeIndex"];
//    NSNumber *eSizeInex = [dic objectForKey:@"eraserSizeIndex"];
//    if ( !penSizeIndex ) {
//        self->m_uPenSizeIndex = 0;
//    }
//    else
//    {
//        self->m_uPenSizeIndex = [penSizeIndex intValue];
//    }
    
    NSString *strValue = nil;
    BOOL b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"PenSizeIndex" value:strValue];
    if ( !b || !strValue || strValue.length == 0 ) {
        self->m_uPenSizeIndex = 1;
    }
    else
    {
        self->m_uPenSizeIndex = [strValue integerValue];
    }
    assert( self->m_uPenSizeIndex >= 0 && self->m_uPenSizeIndex < 5);
	penSize = s_fPenSize[ self->m_uPenSizeIndex ];
    [drawer setPenSize:penSize];
    
    strValue = nil;
    b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"EraserSizeIndex" value:strValue];
    if ( !b || !strValue || strValue.length == 0 ) {
        self->m_uEraserSizeIndex = 1;
    }
    else
    {
        self->m_uEraserSizeIndex = [strValue integerValue];
    }

//    if ( !eSizeInex ) {
//        self->m_uEraserSizeIndex = 0;
//    }
//    else
//    {
//        self->m_uEraserSizeIndex = [eSizeInex intValue];
//    }
    assert( self->m_uEraserSizeIndex >= 0 && self->m_uEraserSizeIndex < 5);
	eraserSize = s_fPenSize[ self->m_uEraserSizeIndex ];
	
//	NSDictionary *color = [dic objectForKey:@"selectedColor"];
//	NSNumber * red = [color objectForKey:@"red"];
//	NSNumber * blue= [color objectForKey:@"blue"];
//	NSNumber * green=[color objectForKey:@"green"];
//	NSNumber *colorIndex = [dic objectForKey:@"selectedColorIndex"];
//    if ( !colorIndex ) {
//        self->m_uColorIndex = 0;
//    }
//    else
//    {
//        self->m_uColorIndex = [colorIndex intValue];
//    }
    strValue = nil;
    b = [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"SelectedColorIndex" value:strValue];
    if ( !b || !strValue || strValue.length == 0 ) {
        self->m_uColorIndex = 0;
    }
    else
    {
        self->m_uColorIndex = [strValue integerValue];
    }

    assert( self->m_uColorIndex >= 0 && self->m_uColorIndex < 12 );
	penColor = [[UIColor alloc] initWithRed:s_fColor[self->m_uColorIndex][0] \
            green:s_fColor[self->m_uColorIndex][1] \
            blue:s_fColor[self->m_uColorIndex][2] alpha:1];
	
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



- (void)viewWillDisappear:(BOOL)animated
{
   /*  要打开
	const float * cc = CGColorGetComponents(penColor.CGColor);
	NSNumber * red = [NSNumber numberWithFloat:cc[0]];
	NSNumber * green = [NSNumber numberWithFloat:cc[1]];
	NSNumber * blue = [NSNumber numberWithFloat:cc[2]];
	
	NSDictionary * colorDict = [NSDictionary dictionaryWithObjectsAndKeys:red,@"red",green,@"green",blue,@"blue",nil];
	[pc writeToPlistWithKey:@"selectedColor" vlaue:colorDict];
	[pc writeToPlistWithKey:@"penSize" vlaue:[NSNumber numberWithFloat:penSize]];
	[pc writeToPlistWithKey:@"eraserSize" vlaue:[NSNumber numberWithFloat:eraserSize]];
   */
//    NSNumber *penSizeIndex = [NSNumber numberWithInt:self->m_uPenSizeIndex];
//    NSNumber *eSizeInex = [NSNumber numberWithInt:self->m_uEraserSizeIndex];
//	NSNumber *colorIndex = [NSNumber numberWithInt:self->m_uColorIndex];
//    [pc writeToPlistWithKey:@"penSizeIndex" vlaue:penSizeIndex];
//    [pc writeToPlistWithKey:@"eraserSizeIndex" vlaue:eSizeInex];
//    [pc writeToPlistWithKey:@"selectedColorIndex" vlaue:colorIndex];
    NSString *strValue = [NSString stringWithFormat:@"%d", self->m_uPenSizeIndex];
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"PenSizeIndex" value:strValue];
    
    strValue = [NSString stringWithFormat:@"%d", self->m_uEraserSizeIndex];
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"EraserSizeIndex" value:strValue];
    
    strValue = [NSString stringWithFormat:@"%d", self->m_uColorIndex];
    [AstroDBMng setCfg_cfgMgr:@"CommonCfg" name:@"SelectedColorIndex" value:strValue];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	//self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
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
	
	if([_GLOBAL GetDrawerState]!=STATE_MOVE)
	{
		//self.navigationItem.rightBarButtonItem = saveButton;
        //m_btnNavFinish.hidden = NO;
        m_btnNavFinish.enabled = YES;
		hasSave = NO;
		
	}
	
}

-(void) PPDrawer:(PPDrawer *) drawer didEndDraw:(CGPoint) point
{
	//if(toolbar.alpha == 0)
	//	[[PPAnimation shareAnimation] fadeAnimation:toolbar visiable:YES];
}

-(void)	PPDrawer:(PPDrawer *) drawer didMoveToPoint:(CGPoint) point
{
	//printf("point y = %f\n",point.y);
	
	//if([Global GetDrawerState] == STATE_MOVE) return;
	//if((point.y > 350)&&toolbar.alpha == 1)
	//	[[PPAnimation shareAnimation] fadeAnimation:toolbar visiable:NO];
	
}


- (void)imagePickerController:(UIImagePickerController*)picker
        didFinishPickingImage:(UIImage*)image
                    edingInfo:(NSDictionary*)editingInfo
{
    [drawer setBackImage:image];
	//self.navigationItem.rightBarButtonItem = saveButton;
    //m_btnNavFinish.hidden = NO;
    m_btnNavFinish.enabled = YES;
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ( !image )
        image = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSLog(@"image size:%@ orientation:%d",NSStringFromCGSize(image.size),image.imageOrientation);
    
    [drawer setBackImage:image];
	//self.navigationItem.rightBarButtonItem = saveButton;
    //m_btnNavFinish.hidden = NO;
    m_btnNavFinish.enabled = YES;
    
	[self dismissViewControllerAnimated:YES completion:nil];
}



@end
