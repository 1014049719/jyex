//
//  UILastNote.m
//  NoteBook
//
//  Created by cyl on 12-11-23.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//


#import "GlobalVar.h"
#import "Global.h"
#import "PubFunction.h"
#import "BizLogicAll.h"
#import  "DBMngAll.h"
#import "UIAstroAlert.h"
#import "UILastNote.h"
#import "DataSync.h"
//#import "FlurryAnalytics.h"

@interface UILastNote()
- (void) reRoadTableView;
-(int) getLastNote;
-(void)drawFilesListAnimation:(BOOL)animated;
@end

#define DRAG_SYNC_LENGTH  80
@implementation UILastNote

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_FilesListArray = nil;
        self->m_uFilesCount = 0;
        self->m_bHuadong = NO;
        [[NSNotificationCenter defaultCenter] \
         addObserver:self selector:@selector(reRoadTableView) \
         name:NOTIFICATION_UPDATE_NOTE object:nil];
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"---->UILastNote dealloc");
    
    //[_refreshHeaderView stopTimer];
    [_refreshHeaderView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SAFEREMOVEANDFREE_OBJECT(m_ivHead);
    SAFEREMOVEANDFREE_OBJECT(m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(m_tvFilesList);
    
    if ( self->m_FilesListArray ) {
        [self->m_FilesListArray FreeFileListUI];
        SAFEFREE_OBJECT(self->m_FilesListArray);
    }
    
    [super dealloc];
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
    self->m_filesListOffset = 10.0;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    //self->m_uMiniFiles = 1 + self->m_tvFilesList.frame.size.height / self->m_tvFilesList.rowHeight;
    self->m_uMiniFiles = 1 + ((bounds.size.height-20-self->m_tvFilesList.frame.origin.y) / self->m_tvFilesList.rowHeight);
    NSLog(@"miniFiles=%d frameheight=%.0f rowheight=%.0f screenheight=%.0f",(int)m_uMiniFiles,self->m_tvFilesList.frame.size.height,self->m_tvFilesList.rowHeight,bounds.size.height);
    
    UIImage *ReturnBk = [UIImage imageNamed:@"btn_TouLanA-1.png"];
    assert( ReturnBk );
    [self->m_btnBack setBackgroundImage:[ReturnBk stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    
    NSString *strNavTitle = [TheGlobal getNavTitle];
    float fNavBackBtnWidth = [PubFunction getNavBackButtonWidth:strNavTitle];
    CGRect rect = self->m_btnBack.frame;
    rect.size.width = fNavBackBtnWidth;
    self->m_btnBack.frame = rect;
    [self->m_btnBack setTitle:strNavTitle forState:UIControlStateNormal];

    rect = CGRectMake(0, -200, self.view.frame.size.width, 200);
    EGORefreshTableHeaderView *headView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
    headView.delegate = self;
    [m_tvFilesList addSubview:headView];
    _refreshHeaderView = headView;
    [headView release];


    m_uFilesCount = [self getLastNote];
    self->m_tvFilesList.delegate = self;
    self->m_tvFilesList.dataSource = self;
    //[self drawFilesListAnimation:NO]; 
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

- (void) reRoadTableView
{
    [self getLastNote];
    [self->m_tvFilesList reloadData];
    //[self drawFilesListAnimation:NO];
}

-(int) getLastNote
{
    if ( self->m_FilesListArray ) {
        [self->m_FilesListArray FreeFileListUI];
        SAFEFREE_OBJECT( self->m_FilesListArray );
    }
    int uFilesCount = 0;
    NSArray *arrayFiles = [NSArray array];// = [BizLogic getLatestNoteList:10];
    TNoteInfo *noteInfo = nil;
    UIFilesItem *filesItem = nil;
    if ( arrayFiles && ([arrayFiles count] > 0 )) {
        self->m_FilesListArray
        = [[FilesListDataOnMonth alloc] init];
        assert( self->m_FilesListArray );
        for ( ; uFilesCount < [arrayFiles count]; ++uFilesCount ) {
            noteInfo  = (TNoteInfo *)[arrayFiles objectAtIndex:uFilesCount];
            assert( noteInfo );
            filesItem = [[UIFilesItem alloc] \
                         initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0) FilesInfo:noteInfo];
            [self->m_FilesListArray addFilesItem:filesItem];
            [filesItem release]; filesItem = nil;
        }
    }
    return uFilesCount;
}
#pragma mark - on function
-(IBAction)onBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFileItemCell *	cell = nil;
    assert( tableView == self->m_tvFilesList );
    //    if ( 0 == indexPath.section ) {
    //        UISysAndSearchCell *topCell
    //        = (UISysAndSearchCell*)[self->m_tvFilesList dequeueReusableCellWithIdentifier:@"UISysAndSearchCell"];
    //        if ( !topCell ) {
    //            topCell = [[[UISysAndSearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UISysAndSearchCell"] autorelease];
    //            [topCell setSynAndSearchView:self->m_viewSynAndSearch \
    //                             WithOriginY:-(self->m_filesListOffset)];
    //        }
    //        return topCell;
    //    }
    
    if ( (self->m_uMiniFiles > self->m_uFilesCount)
        && ( 1 == indexPath.section 
            || (0 == indexPath.section && 0 == [self->m_FilesListArray getCount])))
    {
        EmptyCell *emptyCell
        = (EmptyCell*)[self->m_tvFilesList dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if ( !emptyCell ) {
            emptyCell = [[[EmptyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EmptyCell"] autorelease];
            
            CGRect rect = [[UIScreen mainScreen] bounds];
            rect.size.height -= 20 + m_ivHead.frame.size.height;
            NSLog(@"empty cell rect:%@",NSStringFromCGRect(rect));
            [emptyCell setBackgroundFram:rect];
            //[emptyCell setBackgroundFram:CGRectMake(0.0, 0.0, tableView.frame.size.width, tableView.rowHeight)];
        }
        return emptyCell;
    }
    
    if ( self->m_FilesListArray ) {
        UIFilesItem *fileItem
        = [self->m_FilesListArray getFilesItemWithIndex:indexPath.row];
        if ( fileItem ) {
            cell = (UIFileItemCell*)[self->m_tvFilesList dequeueReusableCellWithIdentifier:@"fileItemcell"];
            if (cell == nil) {
                cell = [[[UIFileItemCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"fileItemcell"] autorelease];
                assert(cell != nil);
            }
            BOOL showSeparator =
            ( indexPath.row != ([self->m_FilesListArray getCount] - 1));
            [cell setFilesItem:fileItem ShowSeparator:showSeparator];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    assert( tableView == self->m_tvFilesList );
    int i = 0;
    if ( self->m_FilesListArray
        && [self->m_FilesListArray getCount] > 0 ) {
        ++i;
    }
    if ( (self->m_uFilesCount < self->m_uMiniFiles) ) {
        ++i;
    }
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    assert( tableView == self->m_tvFilesList );
    //    if ( 0 == section ) {
    //        return 1;
    //    }
    if ([self->m_FilesListArray getCount] && section == 0 ) {
        return [self->m_FilesListArray getCount];
    }
    if ( self->m_uMiniFiles > self->m_uFilesCount ) {
        return (self->m_uMiniFiles - self->m_uFilesCount);
    }
    return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"最新笔记";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    assert( tableView == self->m_tvFilesList );
    //    if ( 0 == indexPath.section ) {
    //        CGFloat height = self->m_viewSynAndSearch.frame.size.height - self->m_filesListOffset;
    //        return height;
    //    }
    
    return self->m_tvFilesList.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    assert( tableView == self->m_tvFilesList );
    //    if ( 0 == section) {
    //        return 0;
    //    }
    
    if ( 1 == section && self->m_uMiniFiles > self->m_uFilesCount ) {
        return 0;
    }
    if ( 0 == section
        && [self->m_FilesListArray getCount] == 0
        && self->m_uMiniFiles > self->m_uFilesCount ) {
        return 0;
    }
    return self->m_tvFilesList.sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    assert( tableView == self->m_tvFilesList );
    //assert( section < ([self->m_FilesOnMonth count] + 1));
    //    if ( 0 == section ) {
    //        return nil;
    //    }
    if ( 1 == section && self->m_uMiniFiles > self->m_uFilesCount ) {
        return nil;
    }
    if ( 0 == section
        && [self->m_FilesListArray getCount] == 0
        && self->m_uMiniFiles > self->m_uFilesCount ) {
        return nil;
    }
    NSString *title = [NSString stringWithFormat:@"最新笔记"];    
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

-(void)drawFilesListAnimation:(BOOL)animated
{
    self->m_bHuadong = NO;
    //    if ( [self->m_FilesOnMonth count] ) {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
    [self->m_tvFilesList scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:animated];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section != 0 ) return;
    
    UIFilesItem *fileItem
    = [self->m_FilesListArray getFilesItemWithIndex:indexPath.row];
    assert( fileItem );
    TNoteInfo *ni = fileItem->m_noteInfor;
    assert( ni );
    [_GLOBAL setEditorAddNoteInfo:1 catalog:ni.strNoteIdGuid noteinfo:ni];
    [PubFunction SendMessageToViewCenter:NMNoteRead :0 :1 :nil];
    return;
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
    
    if ( self->m_bHuadong == YES ) {
        [self drawFilesListAnimation:YES];
    }
    
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
    
    //    //    CGPoint pt = scrollView.contentOffset;
    //    //    pt.x = 0.0f;
    //    //    scrollView.contentOffset = pt;
    //    CGRect rectOld = scrollView.frame;
    //    if ( rectOld.origin.y < (self->m_viewSynAndSearch.frame.origin.y + 0.1)) {
    //        return;
    //    }
    //    float f1 =
    //    self->m_viewSynAndSearch.frame.origin.y
    //    + self->m_labelSysString.frame.origin.y
    //    + self->m_labelSysString.frame.size.height;
    //    float f2 = 
    //    self->m_viewSynAndSearch.frame.origin.y
    //    + self->m_viewSynAndSearch.frame.size.height;
    //    if ( (!self->m_bHuadong) && (rectOld.origin.y >= (f1 - 10)) )
    //    {
    //        self->m_bHuadong = YES;
    //        
    //    }
    //    else if( self->m_bHuadong && (rectOld.origin.y < (f2 - 20)) )
    //    {
    //        self->m_bHuadong = NO;
    //    }
    //[self drawFilesListAnimation];
}
*/

//#pragma mark- UIScrollViewDelegate


-(void)restoreRefleshHeadView
{
    //结束同步界面
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tvFilesList];
}


-(void)sendSyncCommand
{
    //[FlurryAnalytics logEvent:@"最新笔记-刷新"];
    
    syncflag = 1;
    //m_btnBack.enabled = NO;  //屏蔽退出
    //[UIAstroAlert info:@"正在同步，请稍候" :0.0 :NO :LOC_MID :YES]; //一直等待，不允许操作
    syncid = [[DataSync instance] syncRequest:BIZ_SYNC_AllCATALOG_NOTE :self :@selector(syncCallback:) :nil];
    
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
    [AstroDBMng getCfg_cfgMgr:@"SyncTime" name:@"LatestNoteList" value:strValue];
    return strValue;
}

- (void)egoRefreshTableHeaderDidSearch:(EGORefreshTableHeaderView*)view text:(NSString *)text
{
    [_GLOBAL setSearchString:text];
    [_GLOBAL setSearchCatalog:nil];
    [PubFunction SendMessageToViewCenter:NMNoteSearch :0 :1 :nil];
}



@end
