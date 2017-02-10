//
//  UIFolderPaiXu.m
//  NoteBook
//
//  Created by zd on 13-2-21.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "UIFolderPaiXu.h"
#import "PubFunction.h"
#import "GlobalVar.h"
#import "Global.h"
#import "BizLogicAll.h"
#import "NoteFolderOrder.h"

#pragma mark - UIFolderOrderItem
@interface UIFolderOrderItem()
@end

@implementation UIFolderOrderItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self->m_bOrderChange = NO;
     }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setOrder:(int)newOrder SetChengeFlag:(BOOL)bFlag
{
    if ( self->m_iOrder == newOrder ) {
        return;
    }
    self->m_iOrder = newOrder;
    if ( bFlag ) {
        self->m_bOrderChange = YES;
    }
}

-(BOOL)orderIsChage
{
    return self->m_bOrderChange;
}

-(void)drawBackground
{   
    NSString *imageName = nil;
    switch ( self->m_BackgroundIndex ) {
        case COLOR_1:
            imageName = @"folder_list_bk1.png";
            break;
        case COLOR_2:
            imageName = @"folder_list_bk2.png";
            break;
        case COLOR_3:
            imageName = @"folder_list_bk3.png";
            break;
        case COLOR_4:
            imageName = @"folder_list_bk4.png";
            break;
        case COLOR_5:
            imageName = @"folder_list_bk5.png";
            break;
        default:
            imageName = @"folder_list_bk1.png";
            break;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    assert( image );
    if ( self->m_ivBackground) {
        self->m_ivBackground.image = image;
        //self->m_ivBackgroundSelect.image = [image UpdateImageAlpha:0.6];
        return;
    }
    self->m_ivBackground = [[UIImageView alloc] initWithImage:image];
    assert( self->m_ivBackground );
    self->m_ivBackground.userInteractionEnabled = YES;
    //CGRect r = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect r = CGRectMake(0, 0, 320, 53);
    self->m_ivBackground.frame = r;
    
    r.origin.x = self.frame.origin.x;
    r.origin.y = self.frame.origin.y;
    r.size.width = ( (r.size.width < self.frame.size.width) ? self.frame.size.width : r.size.width);
    r.size.height = ( (r.size.height < self.frame.size.height) ? self.frame.size.height : r.size.height);
    self.frame = r;
    [self addSubview:self->m_ivBackground];
    //[self addSubview:self->m_ivBackgroundSelect];
}

-(void)drawFolderItem
{
    float x = 10.0;
    [self drawBackground];
    x += [self drawIconWitOringin:x];
    x += 10.0;
    //[self drawBtn2];
    //[self drawFileWithEndX:self->m_btn2.frame.origin.x WithType:0];
    //[self drawFileWithEndX:self->m_labelNumOfFile.frame.origin.x WithType:1];
    x += [self drawFolderNameWithOriginX:x];
    [self drawBtn1];
}

-(void)drawBtn1
{
    if ( self->m_btn1 ) {
        [self->m_btn1 removeFromSuperview];
        [self->m_btn1 release];
        self->m_btn1 = nil;
    }
    CGRect r = self.frame;
    r.origin.x = r.origin.y = 0.0;
    self->m_btn1 = [[UIButton alloc] initWithFrame:r];
    UIImage *imageSelect = [UIImage imageNamed:@"btn_FolderSelect.png"]; 
    r.size = imageSelect.size;
    [self->m_btn1 setImage:[UIImage imageNamed:@"btn_FolderSelect.png"] forState:UIControlStateHighlighted];
    [self addSubview:self->m_btn1];
}
@end

#pragma mark - UIFolderOrderCell
@interface UIFolderOrderCell(){
}
@end

@implementation UIFolderOrderCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self->m_FolderItem = nil;
    }
    return self;
}

-(void)setFolderItem:(UIFolderOrderItem*)item
{
    {
        if ( self->m_FolderItem ) {
            CGRect folderFrame = self->m_FolderItem.frame;
            if( self->m_FolderItem != item )
            {
                SAFEREMOVEANDFREE_OBJECT(self->m_FolderItem);
                self->m_FolderItem = [item retain];
            }
            [self->m_FolderItem drawFolderItem];
            self->m_FolderItem.frame = folderFrame;
            [self addSubview: self->m_FolderItem];
            return;
        }
        self->m_FolderItem = [item retain];
        [self->m_FolderItem drawFolderItem];
        CGRect r = self.frame;
        r.size.height = self->m_FolderItem.frame.size.height;
        //r.size.height = self->m_FilesItem.frame.size.height + 2;
        self.frame = r;
        r = self->m_FolderItem.frame;
        r.origin.x = (self.frame.size.width - r.size.width) / 2;
        self->m_FolderItem.frame = r;
        [self addSubview: self->m_FolderItem];
    }
}
@end

#pragma mark - UIFolderPaiXu
@implementation UIFolderPaiXu

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(m_btnFinish);
    SAFEREMOVEANDFREE_OBJECT(m_tvFolderList);
    SAFEFREE_OBJECT(self->m_strFolderGuid);
    SAFEFREE_OBJECT(m_FolderList);
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->m_FolderList = nil;
        self->m_strFolderGuid = [[_GLOBAL getParentFolderID] retain]; 
        self->m_bNeedUpdata = NO;
        //[[NSNotificationCenter defaultCenter] \
         addObserver:self selector:@selector(reRoadTableView) \
         name:NOTIFICATION_UPDATE_NOTE object:nil];
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
    [m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    
    NSString *strNavTitle = [TheGlobal getNavTitle];
    float fNavBackBtnWidth = [PubFunction getNavBackButtonWidth:strNavTitle];
    CGRect rect = self->m_btnBack.frame;
    rect.size.width = fNavBackBtnWidth;
    self->m_btnBack.frame = rect;
    [self->m_btnBack setTitle:strNavTitle forState:UIControlStateNormal];
    
    [self getFolderListFromDB];
    self->m_tvFolderList.delegate = self;
    self->m_tvFolderList.dataSource = self;
    [self->m_tvFolderList setEditing:YES];
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

-(IBAction)OnBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnFinish:(id)sender
{
    [self updataFolderOrder];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_NOTE object:nil userInfo:nil];
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(int) getFolderListFromDB
{
    if ( self->m_FolderList ) {
        [self->m_FolderList removeAllObjects];
    }
    SAFEFREE_OBJECT( self->m_FolderList );
    
    NSArray *arrCate = [BizLogic getCateList:self->m_strFolderGuid];
    if( !arrCate || [arrCate count] == 0) {
        return 0;
    }
    
    
    NSMutableArray *cateOrderArray = [[NSMutableArray alloc] init];
    [NoteFolderOrder OrderWithCateArray:arrCate DesArray:cateOrderArray];
    [NoteFolderOrder SetOrderWithCateArray:cateOrderArray];
    
    self->m_FolderList = [[NSMutableArray alloc] init];
    assert( self->m_FolderList );
    int i = 0;
    for ( ; i < [cateOrderArray count]; ++i ) {
        TCateInfo *info = (TCateInfo*)[cateOrderArray objectAtIndex:i];
        UIFolderOrderItem *orderItem = [[UIFolderOrderItem alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        [orderItem setInforWithCateInfor:info];
        //[orderItem drawFolderItem];
        [self->m_FolderList addObject:orderItem];
        [orderItem release];
    }
    [cateOrderArray removeAllObjects];
    SAFEFREE_OBJECT(cateOrderArray);
    return [self->m_FolderList count];
}

-(void)resetOrder
{
    if ( self->m_FolderList ) {
        int c = [self->m_FolderList count];
        UIFolderItemView *info = nil;
        for ( int i = 0; i < c; ++i ) {
            info = (UIFolderItemView *)[self->m_FolderList objectAtIndex:i];
            info->m_iOrder = (c--);
        }
    }
}

- (void) reRoadTableView
{
    [self getFolderListFromDB];
    [self->m_tvFolderList reloadData];
    //[self drawFilesListAnimation:NO];
}

-(BOOL)updataFolderOrder
{
    if ( self->m_FolderList ) {
        UIFolderOrderItem *updataItem = nil;
        for ( int i = 0; i < [self->m_FolderList count]; ++i ) {
            updataItem = [self->m_FolderList objectAtIndex:i];
            int o = updataItem->m_iOrder;
            //+(BOOL)updataCateOrder:(NSString*)cateGuid Order:(int)newOrder
            [BizLogic updataCateOrder:updataItem->m_strFolderId Order:o];
        }
    }
    return YES;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFolderOrderCell *	cell = nil;
    if (  self->m_FolderList && [self->m_FolderList count ] ) {
        UIFolderOrderItem *folderItem
        = (UIFolderOrderItem *) [self->m_FolderList objectAtIndex:indexPath.row];        
        if ( folderItem ) {
            cell = (UIFolderOrderCell*)[self->m_tvFolderList dequeueReusableCellWithIdentifier:@"FolderOrderCell"];
            if (cell == nil) {
                cell = [[[UIFolderOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FolderOrderCell"] autorelease];
                //cell = [[[UIFileItemCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, tableView.rowHeight reuseIdentifier:@"fileItemcell"] autorelease];
                assert(cell != nil);
            }
            [cell setFolderItem:folderItem];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self->m_FolderList ) {
        return [self->m_FolderList count];
    }
    return 0;
}


#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self->m_tvFolderList.rowHeight;
}

-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
	if (oldPath.row == newPath.row) return;
	
	UIFolderOrderItem *item = [[self->m_FolderList objectAtIndex:oldPath.row] retain];
	[self->m_FolderList removeObjectAtIndex:oldPath.row];
	[self->m_FolderList insertObject:item atIndex:newPath.row];
	[item release];
    [self resetOrder];
    
	[self->m_tvFolderList performSelector:@selector(reloadData) withObject:nil afterDelay:0.25f];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
