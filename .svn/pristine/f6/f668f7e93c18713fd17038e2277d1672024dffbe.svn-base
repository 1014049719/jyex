//
//  UINoteSearch.m
//  NoteBook
//
//  Created by cyl on 12-11-21.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "Global.h"
#import "PubFunction.h"
#import "Global.h"
#import "GlobalVar.h"
#import "BizLogicAll.h"
#import  "DBMngAll.h"
#import "UIAstroAlert.h"
#import "UINoteSearch.h"

@implementation SearchFolderList

- (void) dealloc
{
    [m_strSearchString release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame Search:(NSString *)str
{
    self = [super initWithFrame:frame];
    if ( self ) {
        if ( str ) {
            self->m_strSearchString = [str copy];
        }
        else
        {
            self->m_strSearchString = nil;
        }
    }
    return self;
}

-(NSArray *)getFolderListData
{
    if ( self->m_strSearchString
        && self->m_strSearchString.length > 0 ) {
        return [BizLogic getCateListBySearch_CateMgr:self->m_strSearchString catalog:[_GLOBAL getSearchCatalog]];
    }
    return nil;
}

-(void)setSearchString:(NSString *)str
{
    if ( str ) {
        self->m_strSearchString = [str copy];
    }
    else
    {
        self->m_strSearchString = nil;
    }
}
@end

@interface UINoteSearch()
-(void)getSearchString;
-(void)searchFiles;
-(void)drawFolder;
-(void)drawSearch;
- (void) reRoadTableView;
@end

@implementation UINoteSearch

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->m_bChehua = NO;
        m_Folder = nil;
        m_FilesListArray = nil;
        m_strSearchString = nil;
        m_bSearchOrBack = NO;
        [[NSNotificationCenter defaultCenter] \
         addObserver:self selector:@selector(reRoadTableView) \
         name:NOTIFICATION_UPDATE_NOTE object:nil];
    }
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFEREMOVEANDFREE_OBJECT(m_btnSearch);
    SAFEREMOVEANDFREE_OBJECT(m_btnDelSearchStr);
    SAFEREMOVEANDFREE_OBJECT(m_ivSearchBk);
    SAFEREMOVEANDFREE_OBJECT(m_btnCancel);
    SAFEREMOVEANDFREE_OBJECT(m_tfSearchStrInput);
    SAFEREMOVEANDFREE_OBJECT(m_tvFilesList);
    SAFEREMOVEANDFREE_OBJECT(m_MainView1);
    SAFEREMOVEANDFREE_OBJECT(m_scrollMainView);
    SAFEREMOVEANDFREE_OBJECT(m_subViewMain1);
    SAFEREMOVEANDFREE_OBJECT(m_btnScrollBtn);
    SAFEREMOVEANDFREE_OBJECT(m_MainView2);
    SAFEREMOVEANDFREE_OBJECT(m_ivCheHuaBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivBtnSelectBk);
    SAFEREMOVEANDFREE_OBJECT(m_btnMainPage);
    SAFEREMOVEANDFREE_OBJECT(m_lUserName);
    SAFEREMOVEANDFREE_OBJECT(m_btnUserName);
    
    SAFEREMOVEANDFREE_OBJECT(m_btnSSJ);
    SAFEREMOVEANDFREE_OBJECT(m_btnSSH);
    SAFEREMOVEANDFREE_OBJECT(m_btnSSL);
    SAFEREMOVEANDFREE_OBJECT(m_btnSSP);
    SAFEREMOVEANDFREE_OBJECT(m_btnZJBJ);
    SAFEREMOVEANDFREE_OBJECT(m_btnSetting);
    SAFEREMOVEANDFREE_OBJECT(m_btnShare);
    SAFEREMOVEANDFREE_OBJECT(m_ivZhongFeng);
    SAFEREMOVEANDFREE_OBJECT(m_ivSSJBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivSSHBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivSSLBk);
    SAFEREMOVEANDFREE_OBJECT(m_ivSSPBk);
    SAFEREMOVEANDFREE_OBJECT(m_vwSubView1);
    SAFEREMOVEANDFREE_OBJECT(m_vwSubView2);
    
    if (self->m_FilesListArray) {
        [self->m_FilesListArray FreeFileListUI];
        SAFEFREE_OBJECT(self->m_FilesListArray);
    }
    
    SAFEFREE_OBJECT(self->m_Folder);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)getSearchString
{
    self->m_strSearchString = [_GLOBAL getSearchString];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self->m_rectFolderList = self->m_svFolderList.frame;
    self->m_rectFilesList = self->m_tvFilesList.frame;
    [self->m_ivBtnSelectBk setImage:[[UIImage imageNamed:@"chechuang_select.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0]];
    [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    
    UIImage *bk
    = [UIImage imageNamed:@"search_input.png"];
    assert( bk );
    [self->m_ivSearchBk setImage:[bk stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
    [self drawSearch];
    self->m_tfSearchStrInput.delegate = self;
    self->m_tvFilesList.delegate = self;
    self->m_tvFilesList.dataSource = self;
    // Do any additional setup after loading the view from its nib.
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
    [self->m_tfSearchStrInput resignFirstResponder];
    [self drawMainPage];
}

-(void)drawMainPage
{
    [self getUserName];
    CGRect r = self->m_ivCheHuaBk.frame;
    self->m_fMainViewOffset = r.size.width;
    r = self->m_subViewMain1.frame;
    r.origin.x = self->m_fMainViewOffset;
    self->m_subViewMain1.frame = r;
    
    self->m_ScrollMainViewContentSize = CGSizeMake(self->m_scrollMainView.frame.size.width, self->m_scrollMainView.frame.size.height);
    self->m_ScrollMainViewContentSize.width += self->m_fMainViewOffset;
    [self->m_scrollMainView setContentSize:self->m_ScrollMainViewContentSize];
    [self->m_scrollMainView setContentOffset:CGPointMake(self->m_fMainViewOffset, 0)];
    self->m_scrollMainView.delegate = self;
    self->m_scrollMainView.directionalLockEnabled = YES;
    //[self drawFolder];
}

-(void)drawFolder
{
    if (self->m_Folder) {
        //[self->m_Folder removeFromSuperview];
        [self->m_Folder release];
        self->m_Folder = nil;
    }
    self->m_Folder
    = [[SearchFolderList alloc] initWithFrame:CGRectMake(0, 0, 0, 0) \
    Search:self->m_strSearchString];
    [self->m_Folder drawFolderList];
}

-(void)drawSearch
{
    [self getSearchString];
    self->m_tfSearchStrInput.text = self->m_strSearchString;
    [self drawFolder];
//    if (self->m_svFolderList.hidden == YES) {
//        CGRect r = self->m_rectFilesList;
//        r.origin.y = self->m_rectFolderList.origin.y;
//        r.size.height = r.size.height + (self->m_rectFilesList.origin.y - r.origin.y);
//        self->m_tvFilesList.frame = r;
//    }
//    else
//    {
//        self->m_tvFilesList.frame = self->m_rectFilesList;
//    }
    [self searchFiles];
//     if ( !self->m_FilesListArray || ![self->m_FilesListArray getCount] ) 
//     {
//         self->m_tvFilesList.hidden = YES;
//     }
//    else
//    {
//        self->m_tvFilesList.hidden = NO;
//    }
    [self showNoSearchResult];
}

-(void)showNoSearchResult
{
    if ( ( !self->m_Folder || ![self->m_Folder getFolderCount] )
        && ( !self->m_FilesListArray || ![self->m_FilesListArray getCount] ) ) {
        //无符合条件的搜索结果
        [UIAstroAlert info:@"无符合条件的搜索结果" :2.0 :NO :LOC_MID :NO];
    }
}

-(void)drawMainPageAnimation
{
    float newX;
    CGRect rectOld = self->m_MainView1.frame;
    
    if ( self->m_bChehua ) {
        newX = 0;
        //self->m_ivZhongFeng.hidden = YES;
    }
    else
    {
        newX = self->m_fMainViewOffset;
        CGSize s = self->m_ScrollMainViewContentSize;
        s.width += self->m_fMainViewOffset;
        [self->m_scrollMainView setContentSize:s];
    }
    self->m_bChehua = !(self->m_bChehua);
    CGRect r2 = self->m_ivZhongFeng.frame;
    r2.origin.x = newX - r2.size.width / 2.0;
    CGContextRef contex = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:contex];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    [self->m_MainView1 setFrame:CGRectMake(newX
                                           , rectOld.origin.y, rectOld.size.width, rectOld.size.height )];
    [self->m_ivZhongFeng setFrame:r2];
    [UIView commitAnimations];
    
}

- (void) animationFinished: (id) sender
{
    if ( self->m_bChehua ) {
        self->m_ivZhongFeng.hidden = NO;
    }
}

-(void)getUserName
{
    if ( TheCurUser==nil
        || TheCurUser==NULL
        || [PubFunction stringIsNullOrEmpty:TheCurUser.sUserName]
        || [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME]
        )
    {
        self->m_lUserName.text = @"点击这里登录";
    }
    else if ( !TheCurUser.sNickName || [TheCurUser.sNickName length] <= 0 )
    {
        self->m_lUserName.text = TheCurUser.sUserName;
    }
    else
    {
        self->m_lUserName.text = TheCurUser.sNickName;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)searchFiles
{
    if ( self->m_FilesListArray ) {
        [self->m_FilesListArray FreeFileListUI];
        SAFEFREE_OBJECT( self->m_FilesListArray );
    }
    NSArray *arrayFiles = [BizLogic getNoteListBySearch:self->m_strSearchString catalog:[_GLOBAL getSearchCatalog]];
    TNoteInfo *noteInfo = nil;
    UIFilesItem *filesItem = nil;
    if ( arrayFiles && ([arrayFiles count] > 0 )) {
        self->m_FilesListArray
        = [[FilesListDataOnMonth alloc] init];
        assert( self->m_FilesListArray );
        for ( int uFilesCount = 0; uFilesCount < [arrayFiles count]; ++uFilesCount ) {
            noteInfo  = (TNoteInfo *)[arrayFiles objectAtIndex:uFilesCount];
            assert( noteInfo );
            filesItem = [[UIFilesItem alloc] \
                         initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0) FilesInfo:noteInfo];
            [self->m_FilesListArray addFilesItem:filesItem];
            [filesItem release]; filesItem = nil;
        }
    }
}

- (void) reRoadTableView
{
    [self drawSearch];
    [self->m_tvFilesList reloadData];
    [self getUserName];
}

- (void) selectBusinessType:(int)type
{
    NSString *defaultCateID = [_GLOBAL defaultCateID];
    [_GLOBAL setEditorAddNoteInfo:type catalog:defaultCateID noteinfo:nil];
    [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    [PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
}

#pragma mark - on function
-(IBAction)onBack:(id)sender
{
    //[PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    [self->m_tfSearchStrInput resignFirstResponder];
    NSString *strSearch = self->m_tfSearchStrInput.text;
    if ( !m_bSearchOrBack || !strSearch || strSearch.length == 0 ) {
        //[UIAstroAlert askWait:@"请先输入搜索内容" :[NSArray arrayWithObjects:@"确定", nil]];
        //关闭，返回
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    }
    else
    {
        [_GLOBAL setSearchString:strSearch];
        [self drawSearch];
        [self->m_tvFilesList reloadData];
    }   
}

-(IBAction)onSearch:(id)sender
{
    [self->m_tfSearchStrInput resignFirstResponder];
    NSString *strSearch = self->m_tfSearchStrInput.text;
    if ( !m_bSearchOrBack || !strSearch || strSearch.length == 0 ) {
        //[UIAstroAlert askWait:@"请先输入搜索内容" :[NSArray arrayWithObjects:@"确定", nil]];
        //关闭，返回
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    }
    else
    {
        [_GLOBAL setSearchString:strSearch];
        [self drawSearch];
        [self->m_tvFilesList reloadData];
    }
}

-(IBAction)onCleanSearchString:(id)sender
{
    self->m_tfSearchStrInput.text = nil;
    self->m_btnDelSearchStr.hidden = YES;
}

- (IBAction) onCheHua :(id)sender
{
    [self drawMainPageAnimation];
}

- (IBAction) onDownBtnOnMainView2:(id)sender
{
    static UIButton *s_btn = nil;
    UIButton *btn = (UIButton*)sender;
    assert(btn);
    if ( btn != s_btn ) {
        if( btn == self->m_btnSSH )
            [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];
        else if( btn == self->m_btnSSJ )
            [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];
        else if( btn == self->m_btnSSL )
            [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];
        else if( btn == self->m_btnSSP )
            [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x34/255.0 green:0x2e/255.0 blue:0x26/255.0 alpha:1.0]];
        
//        if( s_btn == self->m_btnSSH )
//            [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
//        else if( s_btn == self->m_btnSSJ )
//            [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
//        else if( s_btn == self->m_btnSSL )
//            [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
//        else if( s_btn == self->m_btnSSP )
//            [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
    }
    CGRect r = btn.frame;
    if( btn == self->m_btnSSH
       || btn == self->m_btnSSJ
       || btn == self->m_btnSSL
       || btn == self->m_btnSSP)
    {
        r.origin.x += self->m_vwSubView2.frame.origin.x;
        r.origin.y += self->m_vwSubView2.frame.origin.y;
    }
    else if( btn == self->m_btnShare
            || btn == self->m_btnSetting
            || btn == self->m_btnZJBJ)
    {
        r.origin.x += self->m_vwSubView1.frame.origin.x;
        r.origin.y += self->m_vwSubView1.frame.origin.y;
    }
    self->m_ivBtnSelectBk.frame = r;
    s_btn = btn;
}

- (IBAction) onUpBtnOnMainView2:(id)sender
{
    //self->m_ivBtnSelectBk.hidden = YES;
    UIButton *btn = (UIButton *)sender;
    if( btn == self->m_btnSSH )
    {
        [self->m_ivSSHBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        [self selectBusinessType:NEWNOTE_DRAW];
    }
    else if( btn == self->m_btnSSJ )
    {
        [self->m_ivSSJBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        [self selectBusinessType:NEWNOTE_EDIT];
    }
    else if( btn == self->m_btnSSL )
    {
        [self->m_ivSSLBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        [self selectBusinessType:NEWNOTE_RECORD];
    }
    else if( btn == self->m_btnSSP )
    {
        [self->m_ivSSPBk setBackgroundColor:[UIColor colorWithRed:0x3d/255.0 green:0x36/255.0 blue:0x2e/255.0 alpha:1.0]];
        [self selectBusinessType:NEWNOTE_CAMERA];
    }
    else if( btn == self->m_btnShare )
    {
        return;
    }
    else if( btn == self->m_btnMainPage )
    {
        [TheGlobal brushNavTitle];
        [TheGlobal setNavTitle:@"首页"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        int tag = btn.tag;
        [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
        [PubFunction SendMessageToViewCenter:tag :0 :1 :nil];
    }
}


-(IBAction)OnBtnFullScreen:(id)sender
{
    [m_tfSearchStrInput resignFirstResponder];
}



#pragma mark - srcoll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if( scrollView == self->m_scrollMainView )
    {
        CGPoint p = scrollView.contentOffset;
        //NSLog(@"offset1:%f\r\n", p.x);
        CGRect r = self->m_MainView1.frame;
        r.origin.x += (self->m_fMainViewOffset - p.x);
        
        p.x = self->m_fMainViewOffset;
        scrollView.contentOffset = p;
        if ( r.origin.x >= self->m_fMainViewOffset || r.origin.x < 0 ) {
            r.origin.x = self->m_fMainViewOffset;
            return;
        }
        //self->m_ivZhongFeng.hidden = YES;
        [self->m_MainView1 setFrame:r];
        CGRect r2 = self->m_ivZhongFeng.frame;
        r2.origin.x = r.origin.x - r2.size.width / 2.0;
        self->m_ivZhongFeng.frame = r2;
        CGSize s = self->m_ScrollMainViewContentSize;
        s.width += r.origin.x;
        [scrollView setContentSize:s];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //CGPoint pt = scrollView.contentOffset;
    //NSLog(@"EndDragging: (%f, %f)", pntNow.x, pntNow.y);
    
    if( scrollView == self->m_scrollMainView ) {
        if (decelerate == NO)
            [self scrollViewDidEndDecelerating:scrollView];
    }
    
    //    if (pt.x<-50.0)
    //        [self switchYunshiInfo:ETSD_RIGHT];
    //    else if (pt.x>50.0)
    //        [self switchYunshiInfo:ETSD_LEFT];
}  

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    CGPoint pt = scrollView.contentOffset;
    //    pt.x = 0.0f;
    //    scrollView.contentOffset = pt;
    if( scrollView == self->m_scrollMainView ) {
        CGRect rectOld = self->m_MainView1.frame;
        if ( (!self->m_bChehua) && (rectOld.origin.x < 50) )
        {
            self->m_bChehua = YES;
        }
        else if( self->m_bChehua && (rectOld.origin.x + 50 >= self->m_fMainViewOffset) )
        {
            self->m_bChehua = NO;
        }
        [self drawMainPageAnimation];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFileItemCell *	cell = nil;
    assert( tableView == self->m_tvFilesList );
    if ( self->m_Folder && [self->m_Folder getFolderCount ]) {
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
    NSInteger i = 0;
    if ( self->m_Folder && [self->m_Folder getFolderCount] ) {
       ++i;
    }
    if ( self->m_FilesListArray
        && [self->m_FilesListArray getCount] > 0 ) {
        ++i;
    }
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    assert( tableView == self->m_tvFilesList );
    if ( self->m_Folder && [self->m_Folder getFolderCount] )
    {
        if ( 0 == section ) {
            return 1;
        }
    }
    if ( self->m_FilesListArray ) {
        return [self->m_FilesListArray getCount];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( self->m_Folder && [self->m_Folder getFolderCount] )
    {
        if ( 0 == section ) {
            return @"相关文件夹";
        }
    }
    return @"相关文件";
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    assert( tableView == self->m_tvFilesList );
    if ( self->m_Folder && [self->m_Folder getFolderCount] )
    {
        if ( 0 == indexPath.section ) {
            return self->m_Folder.frame.size.height;
        }
    }
    return self->m_tvFilesList.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%d.%d\r\n", indexPath.section, indexPath.row);
    if ( self->m_Folder && [self->m_Folder getFolderCount] )
    {
        if ( 0 == indexPath.section ) {
            return;
        }
    }

    UIFilesItem *fileItem
    = [self->m_FilesListArray getFilesItemWithIndex:indexPath.row];
    assert( fileItem );
    TNoteInfo *ni = fileItem->m_noteInfor;
    assert( ni );
    [_GLOBAL setEditorAddNoteInfo:1 catalog:ni.strNoteIdGuid noteinfo:ni];
    [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
	//[PubFunction SendMessageToViewCenter:NMNoteEdit :0 :1 :nil];
    [PubFunction SendMessageToViewCenter:NMNoteRead :0 :1 :nil];
    return;
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    [self onSearch:self->m_btnSearch];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strSearch = textField.text;
    if ( (!string || string.length == 0)
        && ( !strSearch || strSearch.length <= 1 )) {
        //self->m_btnDelSearchStr.hidden = YES;
        //m_btnCancel.titleLabel.text = @"取消";
        [m_btnCancel setTitle:@"取消" forState:nil];
        m_bSearchOrBack = NO;
    }
    else
    {
        //self->m_btnDelSearchStr.hidden = NO;
        //m_btnCancel.titleLabel.text = @"搜索";
        [m_btnCancel setTitle:@"搜索" forState:nil];
        m_bSearchOrBack = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    m_btnCancel.titleLabel.text = @"取消";
    m_bSearchOrBack = NO;
    return TRUE;
}


@end
