//
//  UIFolder.m
//  NoteBook
//
//  Created by cyl on 12-11-12.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "Global.h"
#import "BizLogicAll.h"
#import  "DBMngAll.h"
#import "UIAstroAlert.h"
#import "UIFolder.h"
#import "DataSync.h"
//#import "FlurryAnalytics.h"
#import "GlobalVar.h"
#import "UIFilePaiXuSelect.h"
#import "Common.h"
#import "UIProgress.h"
#import "CommonAll.h"

#define DRAG_SYNC_LENGTH  80

#pragma mark - FilesListDataOnMonth
@implementation FilesListDataOnMonth
-(id)init
{
    self = [super init];
    if ( self ) {
        self->m_FilesList
        = [[NSMutableArray alloc] initWithCapacity:0];
        assert( self->m_FilesList );
    }
    return self;
}

-(void)dealloc
{
    SAFEFREE_OBJECT( self->m_FilesList );
    
    [super dealloc];
}

-(void)FreeFileListUI
{
    UIFilesItem *fi = nil;
    if ( self->m_FilesList ) {
        for ( int i = 0; i < [self->m_FilesList count]; ++i) {
            fi = [self->m_FilesList objectAtIndex:i];
            assert( fi );
            [fi removeFromSuperview];
        }
    }
    SAFEFREE_OBJECT( self->m_FilesList );
}

-(void)addFilesItem:(UIFilesItem*)filesItem
{
    if ( filesItem ) {
        [self->m_FilesList addObject:filesItem];
    }
}

-(UIFilesItem *)getFilesItemWithIndex:(NSUInteger)index
{
    UIFilesItem *fileItem = nil;
    if ( self->m_FilesList && index < [self->m_FilesList count] ) {
        fileItem = [self->m_FilesList objectAtIndex:index];
    }
    return fileItem;
}

-(NSInteger)getCount
{
    return ( self->m_FilesList ? ([self->m_FilesList count]) : 0 );
}
@end

#pragma mark - UIFileItemCell
@implementation UIFileItemCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self->m_FilesItem = nil;
        self->m_Separator = nil;
    }
    return self;
}

//-(id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
//    if ( self ) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self->m_FilesItem = nil;
//        self->m_Separator = nil;
//    }
//    return self;
//}

-(void) dealloc
{
    SAFEFREE_OBJECT(self->m_FilesItem);
    SAFEFREE_OBJECT(self->m_Separator);
    [super dealloc];
}

-(void)setFilesItem:(UIFilesItem*)fileItem ShowSeparator:(BOOL)separator
{
    if ( self->m_FilesItem ) {
        CGRect fileItemFrame;
        fileItemFrame = self->m_FilesItem.frame;
        if( self->m_FilesItem != fileItem )
        {
            [self->m_FilesItem removeFromSuperview];
            [self->m_FilesItem release];
            self->m_FilesItem = [fileItem retain];
        }
        [self->m_FilesItem drawFileItem];
        self->m_FilesItem.frame = fileItemFrame;
        [self addSubview: self->m_FilesItem];
        self->m_Separator.hidden = !(separator);
        //[self bringSubviewToFront:self->m_Separator];
        return;
    }
    
    self->m_FilesItem = [fileItem retain];
    [self->m_FilesItem drawFileItem];
    UIImage *fengge = [UIImage imageNamed:@"BJNR_Fengge.png"];
    assert( fengge );
    CGRect r = self.frame;
    r.size.height = self->m_FilesItem.frame.size.height + fengge.size.height;
    //r.size.height = self->m_FilesItem.frame.size.height + 2;
    self.frame = r;
    UIView *viewBk
    = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, r.size.width, r.size.height)];
    [viewBk setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:244.0/255.0 blue:221.0/255.0 alpha:1.0]];
    [self addSubview: viewBk];
    [viewBk release]; //add 2013.1.12
    
    r = self->m_FilesItem.frame;
    r.origin.x = (self.frame.size.width - r.size.width) / 2;
    self->m_FilesItem.frame = r;
    [self addSubview: self->m_FilesItem];
    
    self->m_Separator
    = [[UIImageView alloc]  initWithFrame:\
       CGRectMake((self.frame.size.width - fengge.size.width)/2.0
                  , r.origin.y + r.size.height, fengge.size.width, 2)];
    self->m_Separator.image = fengge;
    [self addSubview:self->m_Separator];
    self->m_Separator.hidden = !(separator);
    
    //add by zd 2014-3-19
    //if( self->m_picture == nil )
    //{
        //CGSize size = self.frame.size ;
       //// CGSize size = self->m_FilesItem->m_scrollFileContent.frame.size ;
        //self->m_picture = [[UIImageView alloc] initWithFrame:CGRectMake( size.width + 110 /*-size.height + //10*/, 23, size.height - 25, size.height - 25 )] ;
        //[self->m_FilesItem->m_scrollFileContent addSubview:m_picture] ;
        //[self addSubview:m_picture] ;
        //[self->m_FilesItem->m_scrollFileContent addSubview:m_picture] ;
        //m_picture.backgroundColor = [UIColor greenColor] ;
        //[self->m_picture autorelease] ;
        //[self bringSubviewToFront:m_picture] ;
    //}
    //else
    //{
        //[self bringSubviewToFront:m_picture] ;
    //}
}
@end

#pragma mark - UISysAndSearchCell
/*
@implementation UISysAndSearchCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setSynAndSearchView:(UIView*)view WithOriginY:(float)y
{
    self->m_viewSynAndSearch = [view retain];
    CGRect r = self->m_viewSynAndSearch.frame;
    r.origin.x = (self.frame.size.width - r.size.width) / 2.0;
    //r.origin.y = 0.0;
    r.origin.y = y;
    self->m_viewSynAndSearch.frame = r;
    
    r = self.frame;
    r.size.height = self->m_viewSynAndSearch.frame.size.height - y;
    self.frame = r;
    [self addSubview:self->m_viewSynAndSearch];
}
@end
*/

#pragma mark - EmptyCell
@implementation EmptyCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setBackgroundFram:(CGRect)r
{
    UIView *v = [[UIView alloc] initWithFrame:r];
    [v setBackgroundColor:[UIColor colorWithRed:246.0/255.0 \
                                          green:244.0/255.0 blue:221.0/255.0 alpha:1.0]];
    [self addSubview:v];
    [v release];  //add 2013.1.12
    CGRect rect = self.frame;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    self.frame = rect;
}
@end

#pragma mark - UIFolderListCell
@implementation UIFolderListCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self->m_Folder = nil;
        self->m_viewBackground = nil;
    }
    return self;
}

-(void)dealloc
{
    SAFEFREE_OBJECT(self->m_viewBackground);
    
    [super dealloc];
}

-(void)setFolderList:(UIFolderList*)folderList WithWidth:(int)width
{
    if ( self->m_Folder ) {
        [self->m_Folder removeFromSuperview];
        self->m_Folder = nil;
    }
    if ( !self->m_viewBackground ) {
        self->m_viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 0.0)];
        [self->m_viewBackground setBackgroundColor:[UIColor colorWithRed:246.0/255.0 \
                                                                   green:244.0/255.0 blue:221.0/255.0 alpha:1.0]];
        [self addSubview:self->m_viewBackground];
    }
    
    if ( folderList ) {
        self->m_Folder = folderList;
        CGRect r = folderList.frame;
        self->m_Folder.frame = CGRectMake(0.0, 0.0, width, folderList.frame.size.height);
        r.origin.x = (width - r.size.width) / 2.0;
        self->m_Folder.frame = r;
        [self addSubview:self->m_Folder];
        self->m_viewBackground.frame = CGRectMake(0.0, 0.0, width, folderList.frame.size.height);
    }
}
@end

#pragma mark - UIFolder
@implementation UIFolder

@synthesize vcMenu ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->m_FilesOnMonth = nil;
        self->m_strFolderGUID = nil;
        self->m_bHuadong = NO;
        self->m_uFilesCount = 0;
        self->m_Folder = nil;
        self->m_bFirstGetNavTitle = YES;
        self->vcMenu = nil ;
        [[NSNotificationCenter defaultCenter] \
         addObserver:self selector:@selector(reRoadTableView) \
         name:NOTIFICATION_UPDATE_NOTE object:nil];
        //NOTIFICATION_UPDATE_NOTE
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

-(void)dealloc
{
    NSLog(@"---->UIFolder dealloc");
    
    //[_refreshHeaderView stopTimer];
    [_refreshHeaderView removeFromSuperview];
    SAFEREMOVEANDFREE_OBJECT(m_tvFilesList);
    SAFEREMOVEANDFREE_OBJECT(m_ivHead);
    SAFEREMOVEANDFREE_OBJECT(m_labelFolderName);
    SAFEREMOVEANDFREE_OBJECT(m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(m_btnNewFiles);
    
    self.vcMenu = nil ;
    
    if ( syncid > 0 )
        [[DataSync instance] cacelSyncRequest:syncid];  //取消同步回调
    
    [UIAstroAlert infoCancel];
        
    [self FreeFilesList];//-----
    
    SAFEFREE_OBJECT( self->m_strFolderGUID);
    
    [self->m_Folder release];
    self->m_Folder = nil;
    SAFEREMOVEANDFREE_OBJECT(m_TouLanMenu) ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //SAFEFREE_OBJECT( self->m_FilesOnMonth );
    [super dealloc];
}

- (void) reRoadTableView
{
    if ( syncflag == 1 ) return;  //在同步过程中不更新
    
    self->m_uFilesCount = [self getFilesListData];
    //[self drawHeadBk];
    [self drawFolderList];
    [self->m_tvFilesList reloadData];
    //[self drawFilesListAnimation:NO];
}

-(void)FreeFilesList
{
    FilesListDataOnMonth *filesMonth = nil;
    if ( self->m_FilesOnMonth ) {
        for ( int i = 0; i < [self->m_FilesOnMonth count]; ++i ) {
            filesMonth = [self->m_FilesOnMonth objectAtIndex:i];
            [filesMonth FreeFileListUI];
        }
        SAFEFREE_OBJECT(self->m_FilesOnMonth);
    }
}
#pragma mark - View lifecycle
-(NSUInteger)getFilesListData
{
    if ( self->m_FilesOnMonth ) {
        [self FreeFilesList];
    }
    self->m_FilesOnMonth
    = [[NSMutableArray alloc] initWithObjects:nil];
    NSUInteger uFilesCount = 0;
    if ( !self->m_strFolderGUID ) {
        self->m_strFolderGUID = [[_GLOBAL getCurrentCateGUID] copy];
    }
    NSArray *arrayFiles =  [BizLogic getAllNoteByCateGuid:self->m_strFolderGUID];
    
    TNoteInfo *noteInfo = nil;
    UIFilesItem *filesItem = nil;
    FilesListDataOnMonth *fileListMonth = nil;
    if ( arrayFiles && ([arrayFiles count] > 0 )) {
        fileListMonth
        = [[FilesListDataOnMonth alloc] init];
        assert( fileListMonth );
        for ( ; uFilesCount < [arrayFiles count]; ++uFilesCount ) {
            noteInfo  = (TNoteInfo *)[arrayFiles objectAtIndex:uFilesCount];
            assert( noteInfo );
            filesItem = [[UIFilesItem alloc] \
                         initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0) FilesInfo:noteInfo];
            
             if ( 0 == uFilesCount ) {
                fileListMonth->m_Year = filesItem->m_Year;
                fileListMonth->m_Month = filesItem->m_Month;
                [fileListMonth addFilesItem:filesItem];
                [filesItem release]; filesItem = nil;
            }
            else if( fileListMonth->m_Year == filesItem->m_Year
                    && fileListMonth->m_Month == filesItem->m_Month )
            {
                [fileListMonth addFilesItem:filesItem];
                [filesItem release]; filesItem = nil;
            }
            else
            {
                [self->m_FilesOnMonth addObject:fileListMonth];
                [fileListMonth release]; fileListMonth = nil;
                
                fileListMonth
                = [[FilesListDataOnMonth alloc] init];
                assert( fileListMonth );
                fileListMonth->m_Year = filesItem->m_Year;
                fileListMonth->m_Month = filesItem->m_Month;
                [fileListMonth addFilesItem:filesItem];
                [filesItem release]; filesItem = nil;
            }
        }
        [self->m_FilesOnMonth addObject:fileListMonth];
        [fileListMonth release]; fileListMonth = nil;
    }
    return uFilesCount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->m_filesListOffset =  10.0;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self->m_uMiniFiles = 1 + ((bounds.size.height-20-self->m_tvFilesList.frame.origin.y) / self->m_tvFilesList.rowHeight);
    NSLog(@"miniFiles=%d frameheight=%.0f rowheight=%.0f screenheight=%.0f",(int)m_uMiniFiles,self->m_tvFilesList.frame.size.height,self->m_tvFilesList.rowHeight,bounds.size.height);
    
    
    self->m_uFilesCount = [self getFilesListData];

    [self drawFolderList];
    self->m_tvFilesList.dataSource = self;
    self->m_tvFilesList.delegate = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self->m_tfSearchInput resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //     if ( [self->m_FilesOnMonth count] == 0 )
    //     {
    //    [self drawFilesListAnimation:NO];
    //     }
    //    self->m_viewSynAndSearch.hidden = NO;
}

-(void)drawFolderList
{
    if (self->m_Folder) {
        //[self->m_Folder removeFromSuperview];
        [self->m_Folder release];
        self->m_Folder = nil;
    }
    self->m_Folder = [[UIFolderList alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    if ( !self->m_strFolderGUID ) {
        self->m_strFolderGUID = [[_GLOBAL getCurrentCateGUID] copy];
    }
    [self->m_Folder drawFolderListWithGUID:self->m_strFolderGUID];
    if ( self->m_FilesOnMonth && [self->m_FilesOnMonth count] ) {
        self->m_btnNewFiles.hidden = NO;
    }
    else
    {
        self->m_btnNewFiles.hidden = YES;
    }
}

-(void)drawFolderContent
{
    self->m_uFilesCount = [self getFilesListData];
    [self drawHeadBk];
}

-(void)drawHeadBk
{  
    NSString *imageName = nil;
    TCateInfo *cateInfo = [BizLogic getCate:self->m_strFolderGUID];
    assert( cateInfo );
    switch ( cateInfo.nCatalogColor ) {
        case COLOR_1:
            imageName = @"TouLan-1.png";
            break;
        case COLOR_2:
            imageName = @"TouLan-2.png";
            break;
        case COLOR_3:
            imageName = @"TouLan-3.png";
            break;
        case COLOR_4:
            imageName = @"TouLan-4.png";
            break;
        case COLOR_5:
            imageName = @"TouLan-5.png";
            break;
        default:
            imageName = @"TouLan-1.png";
            break;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    assert( image );
    self->m_ivHead.image = image;
    self->m_labelFolderName.text = cateInfo.strCatalogName;
    if ( self->m_bFirstGetNavTitle ) {
        [TheGlobal setNavTitle:cateInfo.strCatalogName];
        self->m_bFirstGetNavTitle = NO;
    }
    
    UIFont *titleFont = m_labelFolderName.font;
    CGSize lineSize = CGSizeMake(0.0, 0.0);
    lineSize = [cateInfo.strCatalogName sizeWithFont:titleFont  \
                       constrainedToSize:CGSizeMake(1000, 30) \
                           lineBreakMode: NSLineBreakByTruncatingTail];
    CGRect rc = self->m_TouLanMenu.frame;
    rc.origin.x = 160 + lineSize.width / 2 ;
    self->m_TouLanMenu.frame = rc ;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)onBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
	
}
-(IBAction)onAddFile:(id)sender
{
//    [FlurryAnalytics logEvent:@"文件夹-新建文件夹"];
//    
//    [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
//    [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT catalog:self->m_strFolderGUID noteinfo:nil];
//	[PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
    
    [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_JYEX_NOTE :nil :nil :nil];
}

-(IBAction)onFilePaiXuSelect:(id)sender
{
   //[PubFunction SendMessageToViewCenter:NMFilePaiXuSelect :0 :0 :nil];
    /*
    UIFilePaiXuSelect *vc = [[UIFilePaiXuSelect alloc] initWithNibName:@"UIFilePaiXuSelect" bundle:nil];
    [self.view addSubview:vc.view];
     */
    self.vcMenu = [UIFilePaiXuSelect addToWnd :self :@selector(onChildClose::)];
}


-(IBAction)onDisplay:(id)sender
{
    if ( ![[DataSync instance] isExecuting]) {
        [UIAstroAlert info:@"当前没有上传日志或照片" :2.0 :NO :0 :NO];
        return;
    }
    [UIProgress dispProgress];
}



#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int i = 0;
    if ( self->m_Folder && [self->m_Folder getFolderCount ]) {
        i = 1;
        if ( 0 == indexPath.section ) {
            UIFolderListCell *folderListCell
            = (UIFolderListCell*)[self->m_tvFilesList dequeueReusableCellWithIdentifier:@"FolderListCell"];
            
            if ( !folderListCell ) {
                folderListCell = [[[UIFolderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FolderListCell"] autorelease];
            }
            [folderListCell setFolderList:self->m_Folder WithWidth:tableView.frame.size.width];
            return folderListCell;
        }
    }
    
    if ( ( (!self->m_FilesOnMonth)
          || ([self->m_FilesOnMonth count] + i) <= indexPath.section)
        && (self->m_uMiniFiles > self->m_uFilesCount) )
    {
        EmptyCell *emptyCell
        = (EmptyCell*)[self->m_tvFilesList dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if ( !emptyCell ) {
            emptyCell = [[[EmptyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EmptyCell"] autorelease];
            
            CGRect rect = [[UIScreen mainScreen] bounds];
            rect.size.height -= 20 + m_ivHead.frame.size.height;
            //NSLog(@"empty cell rect:%@",NSStringFromCGRect(rect));
            [emptyCell setBackgroundFram:rect];//CGRectMake(0.0, 0.0, tableView.frame.size.width, tableView.rowHeight)];
        }
        return emptyCell;
    }
    
    
    UIFileItemCell *	cell = nil;
    if ( self->m_FilesOnMonth
        && [self->m_FilesOnMonth count] > (indexPath.section - i) ) {
        FilesListDataOnMonth *filesList = [self->m_FilesOnMonth objectAtIndex:(indexPath.section - i)];
        
        UIFilesItem *fileItem = [filesList getFilesItemWithIndex:indexPath.row];
        if ( fileItem ) {
            cell = (UIFileItemCell*)[self->m_tvFilesList dequeueReusableCellWithIdentifier:@"fileItemcell"];
            if (cell == nil) {
                cell = [[[UIFileItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"fileItemcell"] autorelease];
            }
            
            [cell setFilesItem:fileItem ShowSeparator:YES];
            
            if( fileItem->m_noteInfor.nNoteType == 0 )
            {
                NSString *strPicFile = [CommonFunc getItemPath:fileItem->m_noteInfor.strFirstItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];

                NSLog( @"%@", strPicFile ) ;
                cell->m_FilesItem->m_picture.image = [UIImage imageWithContentsOfFile:strPicFile ] ;
                cell->m_FilesItem->m_picture.hidden = NO ;
                //[cell bringSubviewToFront:cell->m_picture] ;
            }
            else
            {
                cell->m_FilesItem->m_picture.hidden = YES ;
            }
        }
    }
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger c = ( self->m_FilesOnMonth ?  [self->m_FilesOnMonth count] : 0 );
    int h = [UIScreen mainScreen].bounds.size.height;
    if ( (self->m_uFilesCount < self->m_uMiniFiles)
        && (!self->m_Folder || ![self->m_Folder getFolderCount] || self->m_Folder.frame.size.height < h ) ) {
        ++c;
    }
    if ( self->m_Folder && [self->m_Folder getFolderCount] ) {
        ++c;
    }
    return c;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( 0 == section && self->m_Folder && [self->m_Folder getFolderCount] ) {
        return 1;
    }
    else if( !self->m_Folder || ![self->m_Folder getFolderCount] )
    {
        if ( ([self->m_FilesOnMonth count]) <= section
            && (self->m_uMiniFiles > self->m_uFilesCount) ) {
            return (self->m_uMiniFiles - self->m_uFilesCount);
        }
    }
    else
    {
        if ( ([self->m_FilesOnMonth count] + 1) <= section
            && (self->m_uMiniFiles > self->m_uFilesCount) ) {
            return (self->m_uMiniFiles - self->m_uFilesCount);
        }
        --section;
    }
    FilesListDataOnMonth * fd
    = (FilesListDataOnMonth*) [self->m_FilesOnMonth objectAtIndex:section];
    return [fd getCount];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( 0 == indexPath.section && self->m_Folder && [self->m_Folder getFolderCount] ) {
        return self->m_Folder.frame.size.height;
    }
    return self->m_tvFilesList.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self->m_Folder && [self->m_Folder getFolderCount] ) {
        if (([self->m_FilesOnMonth count] + 1) <= section) {
            return 0;
        }
    }
    else
    {
        if (([self->m_FilesOnMonth count]) <= section) {
            return 0;
        }
    }
    return self->m_tvFilesList.sectionFooterHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if ( 0 == section
        && self->m_Folder
        && [self->m_Folder getFolderCount] ) {
        title = [NSString stringWithFormat:@"子文件夹"]; 
    }
    else if( self->m_Folder
            && [self->m_Folder getFolderCount] )
    {
        if(([self->m_FilesOnMonth count] + 1) <= section)
            return nil;
        
        section -= 1;
        FilesListDataOnMonth * fd
        = (FilesListDataOnMonth*) [self->m_FilesOnMonth objectAtIndex:section];
        assert( fd );
        title
        = [NSString stringWithFormat:@"%d年%d月"
           , fd->m_Year, fd->m_Month];
    }
    else
    {
        if(([self->m_FilesOnMonth count]) <= section)
            return nil;
        
        FilesListDataOnMonth * fd
        = (FilesListDataOnMonth*) [self->m_FilesOnMonth objectAtIndex:section];
        assert( fd );
        title
        = [NSString stringWithFormat:@"%d年%d月"
           , fd->m_Year, fd->m_Month];
    }
    
    CGRect r = CGRectMake(0.0, 0.0, tableView.frame.size.width, tableView.sectionHeaderHeight);
    UILabel *l = [[[UILabel alloc] initWithFrame:r] autorelease];
    assert( l );
    l.backgroundColor
    = [UIColor colorWithRed:130.0/255.0 green:122.0/255.0 \
                       blue:105.0/255.0 alpha:1.0];
    UILabel *lableTitle
    = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    assert( lableTitle );
    [PubFunction getLableWithString:title lable:lableTitle contentfont:FONT_30PX maxsize:CGSizeMake(tableView.frame.size.width - 10, tableView.sectionHeaderHeight) origin:CGPointMake(10.0, 0.0)];
    lableTitle.textColor = [UIColor whiteColor];
    r.origin.x = 10.0;
    r.origin.y = (r.size.height - lableTitle.frame.size.height) / 2.0;
    r.size = lableTitle.frame.size;
    lableTitle.frame = r;
    [l addSubview:lableTitle];
    [lableTitle release];
    return l;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%d.%d\r\n", indexPath.section, indexPath.row);
    //    if ( 0 == indexPath.section ) {
    //        return;
    //    }
    
    
    FilesListDataOnMonth *filesList = nil;
    if ( self->m_Folder && [self->m_Folder getFolderCount] ) {
        if ( 0 == indexPath.section 
            || ([self->m_FilesOnMonth count] + 1) <= indexPath.section) {
            return;
        }
        
        filesList = [self->m_FilesOnMonth objectAtIndex:(indexPath.section - 1)];
    }
    else
    {
        if (([self->m_FilesOnMonth count]) <= indexPath.section) {
            return;
        }
        
        filesList = [self->m_FilesOnMonth objectAtIndex:(indexPath.section)];
    }
    
    UIFilesItem *fileItem = [filesList getFilesItemWithIndex:indexPath.row];
    TNoteInfo *ni = fileItem->m_noteInfor;
    
    if ( ni.nNoteType == NOTE_PIC) { //照片不允许编辑
        return;
    }
    
    [_GLOBAL setEditorAddNoteInfo:NEWNOTE_EDIT catalog:ni.strNoteIdGuid noteinfo:ni];
	//[PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
    //[PubFunction SendMessageToViewCenter:NMNoteRead :0 :1 :nil];
    [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
    
    
    //return;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleInsert;
//}

-(void)drawFilesListAnimation:(BOOL)animated
{
    self->m_bHuadong = NO;
    //    if ( [self->m_FilesOnMonth count] ) {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    [self->m_tvFilesList scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:animated];
    //    }
    //    else
    //    {
    //        float f = self->m_viewSynAndSearch.frame.size.height
    //        - self->m_filesListOffset;
    //       [self->m_tvFilesList setContentOffset:CGPointMake(0.0
    //        , f) animated:animated];
    //    }
    //    [self->m_tvFilesList setContentOffset:CGPointMake(0.0, -98.0)];
    //    return;
    //    
    //    float newY;
    //    CGRect rectOld = self->m_tvFilesList.frame;
    //    
    //    if ( !self->m_bHuadong ) {
    //        newY = self->m_ivHead.frame.size.height;
    //        //self->m_tvFilesList.bounces = YES;
    //    }
    //    else
    //    {
    //        newY = self->m_filesListOffset + 0.1;
    //        //self->m_tvFilesList.bounces = NO;
    //    }
    //    
    //    CGContextRef contex = UIGraphicsGetCurrentContext();
    //    [UIView beginAnimations:nil context:contex];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationDuration:0.2];
    //    [self->m_tvFilesList setFrame:CGRectMake(rectOld.origin.x
    //                                             , newY, rectOld.size.width, rectOld.size.height )];
    //    [UIView commitAnimations];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    /*
    CGPoint offset1 = scrollView.contentOffset;
    //NSLog(@"scrollViewDidScroll: (%f, %f)", offset1.x, offset1.y);
    
    if ( syncflag == 0 ) 
    {
        if ( offset1.y > - DRAG_SYNC_LENGTH ) m_labelSysString.text = @"下拉同步";
        else m_labelSysString.text = @"松开后开始同步";
    }
    */
}

/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    NSLog(@"WillEndDragging: (%f, %f, %f, %f)\r\n"
          , velocity.x, velocity.y, targetContentOffset->x, targetContentOffset->y);
    
    CGPoint pt = scrollView.contentOffset;
    NSLog(@"WillEndDragging offset: (%f, %f)\r\n", pt.x, pt.y);
    targetContentOffset->y = -105;
    targetContentOffset->x = 0;
    
    //[scrollView setContentOffset:CGPointMake(0,-105)];
    //[scrollView setDecelerationRate:0.001];
}
*/


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    /*
    CGPoint pt = scrollView.contentOffset;
    NSLog(@"EndDragging offset: (%f, %f)\r\n", pt.x, pt.y);
    //float f = self->m_ivSearchBk.frame.origin.y - self->m_btnSyn.frame.origin.y;
    //f -= 15;
    //if( pt.y <= (-f) )
    if ( pt.y <= - DRAG_SYNC_LENGTH )
    {
        //同步本文件列表
        nNeedSyncFlag = 1;
        offset = pt;
        self->m_bHuadong = YES;
    }
    
    //if (decelerate == NO)
    //[self scrollViewDidEndDecelerating:scrollView];
    //[self drawFilesListAnimation];
    //    if (pt.x<-50.0)
    //        [self switchYunshiInfo:ETSD_RIGHT];
    //    else if (pt.x>50.0)
    //        [self switchYunshiInfo:ETSD_LEFT];
    */
}  

/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint pt = scrollView.contentOffset;
    NSLog(@"----EndDecelerating offset: (%f, %f)\r\n", pt.x, pt.y);
    
//    if ( self->m_bHuadong == YES ) {
//        [self drawFilesListAnimation:YES];
//    }
    
    if ( nNeedSyncFlag == 1 && syncflag == 0 )
    {
        nNeedSyncFlag = 0;
        [scrollView setContentOffset:CGPointMake(0,-105)];//offset
        m_labelSysString.text = @"同步中";
        //[scrollView setContentOffset:CGPointMake(0,-105) animated:YES];
        [self syncCatalog];   
    }
    
    pt = scrollView.contentOffset;
    NSLog(@"EndDecelerating offset: (%f, %f)\r\n", pt.x, pt.y);
    
}
*/


-(void)restoreRefleshHeadView
{
    //结束同步界面
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tvFilesList];
}


-(void)sendSyncCommand
{
    //[FlurryAnalytics logEvent:@"文件夹-刷新"];
    
    syncflag = 1;
    //m_btnBack.enabled = NO;  //屏蔽退出
    
    //[UIAstroAlert info:@"正在同步，请稍候" :0.0 :NO :LOC_MID :YES]; //一直等待，不允许操作
    syncid = [[DataSync instance] syncRequest:BIZ_SYNC_DOWNCATALOG_NOTE_UPLOADNOTE :self :@selector(syncCallback:) :m_strFolderGUID];

}

//同步当前文件夹
-(BOOL)syncCatalog
{    
    //查看网络是否正常
    if ([[Global instance] getNetworkStatus] == NotReachable)  
    { //网络不正常
        //NSString *strMsg = @"网络无法连接，请检查网络设置";
        //[UIAstroAlert info:strMsg :3.0 :NO :LOC_MID :NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_FINISH object:@"网络无法连接，请检查网络设置" userInfo:nil];
        
        //[self drawFilesListAnimation:YES];
        return NO;
    }
    
    if ( [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME] || ( !TheCurUser.isLogined && TheCurUser.iSavePasswd != 1) )
    {
        //发送登录消息
        //[UIAstroAlert info:@"请先登录再同步" :2.0 :NO :LOC_MID :NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SYNC_FINISH object:@"请先登录再同步" userInfo:nil];
        
        loginflag = 1;
        [PubFunction SendMessageToViewCenter:NMNoteLogin :0 :1 :[MsgParam param:self :@selector(loginCallback:) :nil :0]];
        
        return YES;
    }
    
    //同步，但不下载内容
    [self sendSyncCommand];
    return YES;
}

//登录回调
- (void) loginCallback :(TBussStatus*)sts
{
    loginflag = 0;
    
	if (sts && sts.iCode == 1)  //成功
	{
        [self sendSyncCommand];
	}
    else
    {
        //[self drawFilesListAnimation:YES];
        //结束同步界面
        [self restoreRefleshHeadView];
    }
}


//同步的回调
- (void)syncCallback:(TBussStatus*)sts
{
    NSLog(@"------同步返回了");
    
    syncflag = 0;
    //m_btnBack.enabled = YES;  //恢复退出按钮
    
    //结束同步界面
    [self restoreRefleshHeadView];
    
    
 	if ( sts.iCode == 200) //成功
	{
		//[UIAstroAlert info:@"同步成功" :2.0 :NO :LOC_MID :NO];
	}
	else
	{
        //失败了
		[UIAstroAlert info:sts.sInfo :2.0 :NO :LOC_MID :NO];
	}
    
    
    //更新数据
    [self reRoadTableView];
}



//EGORefreshTableHeaderView的代理
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    if ( ![self syncCatalog ])
    {
        [self performSelector:@selector(restoreRefleshHeadView) withObject:nil afterDelay:0.5];
    }
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	//return _reloading; // should return if data source model is reloading
    return syncflag;
	
}

- (NSString *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
    //更新同步时间
    NSString *strValue=@"";
    [AstroDBMng getCfg_cfgMgr:@"SyncTime" name:m_strFolderGUID value:strValue];
    return strValue;
}

- (void)egoRefreshTableHeaderDidSearch:(EGORefreshTableHeaderView*)view text:(NSString *)text
{
    [_GLOBAL setSearchString:text];
    [_GLOBAL setSearchCatalog:m_strFolderGUID];
    [PubFunction SendMessageToViewCenter:NMNoteSearch :0 :1 :nil];
}

- (void) onChildClose :(id)child :(id)state
{
	if ([child isEqual:vcMenu])
	{
		[vcMenu.view removeFromSuperview];
		self.vcMenu = nil;
	}
	
}

@end
