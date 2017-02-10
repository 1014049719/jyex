//
//  UINoteEdit.m
//  NoteBook
//
//  Created by susn on 12-11-15.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "UINoteEdit.h"

#import "PubFunction.h"
#import "UIAstroAlert.h"

#import "DBMngAll.h"
#import "CommonAll.h"
#import "BizLogicAll.h"
#import "Global.h"
//#import "UIDrawer.h"
#import "UIImage+Scale.h"
#import "DataSync.h"
//#import "UIPresentImage.h"
#import "UIImage+Scale.h"
#import "GlobalVar.h"

#import "CImagePicker.h"
#import "CPictureSelected.h"

//#import "FlurryAnalytics.h"

//#import "RTEGestureRecognizer.h"

#define LENGTH_SCROLL 70

@implementation UINoteEdit  

@synthesize msgParam;
@synthesize m_strNoteGuid;
@synthesize m_NoteInfo;
@synthesize m_ItemArr;
@synthesize m_arrItemGuid;
@synthesize m_arrPicItemGuid;
@synthesize imgBold1;
@synthesize imgBold2;
@synthesize imgUnderline1;
@synthesize imgUnderline2;
@synthesize imgItalic1;
@synthesize imgItalic2;
@synthesize arrayNoteTypeList;
@synthesize strCurNoteType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //LOG_ERROR(@"===>>>UINoteEdit(%p) initWithNibName",self);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    LOG_ERROR(@"###>>>UINoteEdit(%p) didReceiveMemoryWarning",self);
    
    // Release any cached data, images, etc that aren't in use.
    //MESSAGEBOX(@"出现内存不足告警，请关闭掉一些其它程序。");
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //LOG_ERROR(@"+++>>>UINoteEdit(%p) viewDidLoad",self);
       
    changeheigt = 0;
  
    //两个按钮的背景
    //[m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLan_Folder-1.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateNormal];
    //[m_btnNavCancel setBackgroundImage:[[UIImage imageNamed:@"btn_TouLan_Folder-2.png"]stretchableImageWithLeftCapWidth:15 topCapHeight:15] forState:UIControlStateHighlighted];
    //[m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLan_Folder-3.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    //[m_btnNavFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLan_Folder-4.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];

    self.imgBold1 = [UIImage imageNamed:@"TB9-1.png"];
    self.imgBold2 = [UIImage imageNamed:@"TB9-2.png"];
    self.imgUnderline1 = [UIImage imageNamed:@"TB8-1.png"];
    self.imgUnderline2 = [UIImage imageNamed:@"TB8-2.png"];
    self.imgItalic1 = [UIImage imageNamed:@"TB7-1.png"];
    self.imgItalic2 = [UIImage imageNamed:@"TB7-2.png"];
    
        
    //scrollview
    //CGRect viewframe = self.view.frame;
    CGRect frame = m_scrollview.frame;
    frame.size.height = self.view.frame.size.height - m_navView.frame.size.height + m_titleView.frame.size.height;
    m_scrollview.frame = frame;
    m_scrollview.contentSize = CGSizeMake(m_scrollview.frame.size.width, m_scrollview.frame.size.height+m_titleView.frame.size.height); //+20
    
    
    //初始化m_ItemArray;
    self.m_ItemArr = [NSMutableArray array];
    self.m_arrItemGuid = [NSMutableArray array]; //2014.9.23
    self.m_arrPicItemGuid = [NSMutableArray array]; //2014.9.23
    
    
    //设置代理
    m_tfTitleField.delegate = self;
    m_scrollview.delegate = self;
    
    //NSArray *aa = [NSArray arrayWithObjects:@"班级空间", @"个人空间", nil];
    self.arrayNoteTypeList = [NSMutableArray array];
    self->nNoteTypeIndex = 0;
    NSArray *arrLanmu = [BizLogic getLanmuList];
    for ( TJYEXLanmu *lanmuInfo in arrLanmu ) {
        [arrayNoteTypeList addObject:lanmuInfo.sLanmuName];
    }

    twNoteTypeList.dataSource = self;
    twNoteTypeList.delegate = self;
    //if ( [arrayNoteTypeList count] < 5 ) {
    CGRect rNoteTypeList = self->twNoteTypeList.frame;
    float fh = 44.0;//self->twNoteTypeList.rowHeight;
    int line = (int)[arrayNoteTypeList count] + 1;
    if ( line > 9 ) line = 9;
    fh = fh * line;
    rNoteTypeList.size.height = fh;
    self->twNoteTypeList.frame = rNoteTypeList;
    //}
    
    webviewheight = m_noteContentWebView.frame.size.height;
    _mywebview.scrollView.backgroundColor = [UIColor colorWithRed:247 green:244 blue:222 alpha:1.0];
        
    //----------------------------
#ifdef _USE_NOTEWEBVIEW
    _mywebview.delegate = self;
    _mywebview.scrollView.delegate = self;
    

    /*---2015.3.31
    // Setup image dragging/moving
    if ( _singleRecognizer ) {
        [_mywebview.scrollView removeGestureRecognizer:_singleRecognizer];
        _singleRecognizer = nil;
    }

    RTEGestureRecognizer *tapInterceptor = [[RTEGestureRecognizer alloc] init];
    
    tapInterceptor.touchesBeganCallback = ^(NSSet *touches, UIEvent *event) {
        // Here we just get the location of the touch
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:_mywebview];
        touchpoint = touchPoint;
        hintpoint = touchPoint;
        
        // What we do here is to get the element that is located at the touch point to see whether or not it is an image

        NSLog(@"touch begin.point=%@",NSStringFromCGPoint(touchpoint));
        //}
    };
    
    tapInterceptor.touchesEndedCallback = ^(NSSet *touches, UIEvent *event) {
        // Let's get the finished touch point
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:_mywebview];
        touchpoint = touchPoint;
        
        if ( ABS(touchPoint.x - hintpoint.x )<10 && ABS(touchPoint.y - hintpoint.y )<10 )
        {
            // What we do here is to get the element that is located at the touch point to see whether or not it is an image
            NSString *javascript = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).toString()", touchPoint.x, touchPoint.y];
            NSString *elementAtPoint = [_mywebview stringByEvaluatingJavaScriptFromString:javascript]; 
            NSLog(@"elementAtPoint=%@",elementAtPoint);
                
            if ([elementAtPoint rangeOfString:@"Image"].location != NSNotFound) 
            {
                NSString *javascript1 = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
                NSString *strNameAtPoint = [_mywebview stringByEvaluatingJavaScriptFromString:javascript1]; 
                NSLog(@"tap image.image name=%@",strNameAtPoint);
                [self performSelector:@selector(dispImage:) withObject:strNameAtPoint];

            // We set the inital point of the image for use latter on when we actually move it
            //initialPointOfImage = touchPoint;
            // In order to make moving the image easy we must disable scrolling otherwise the view will just scroll and prevent fully detecting movement on the image.            
            //    _mywebview.scrollView.scrollEnabled = YES;
            }        
        }
        // And move that image!
        //NSString *javascript = [NSString stringWithFormat:@"moveImageAtTo(%f, %f, %f, %f)", initialPointOfImage.x, initialPointOfImage.y, touchPoint.x, touchPoint.y];
        //     [webView stringByEvaluatingJavaScriptFromString:javascript];
        
        // All done, lets re-enable scrolling
        //_mywebview.scrollView.scrollEnabled = YES;
        
        NSLog(@"touch end.point=%@",NSStringFromCGPoint(touchpoint));
    };
    
    [_mywebview.scrollView addGestureRecognizer:tapInterceptor];  
    _singleRecognizer = tapInterceptor;
    [tapInterceptor release];
    */
 
#endif    
    
    
    [self.view bringSubviewToFront:m_titleView];
    [self.view bringSubviewToFront:m_toolView];  
    [self.view bringSubviewToFront:m_btnToolShow];
    //----------------------------
    
    [m_toolView removeFromSuperview];
    CGRect rect = m_toolView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    m_toolView.frame = rect;
     
    [self flashContent];
    
    //[m_tfTitleField becomeFirstResponder];
    
    // Add ourselves as observer for the keyboard will show notification so we can remove the toolbar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //定时器
    if ( timer ) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSelection:) userInfo:nil repeats:YES];

    
    //处理随意画、录、拍
    if ( [_GLOBAL getEditFlag] == NEWNOTE_CAMERA )
    {
        bFirst = YES;
        [self onNavCamera:nil];
    }
    
    else if ( [_GLOBAL getEditFlag] == NEWNOTE_RECORD)
    {
        bFirst = YES;
        [self onNavRecord:nil];
    }
    else if ( [_GLOBAL getEditFlag] == NEWNOTE_DRAW )
    {
        bFirst =YES;
        [self onNavDraw:nil];
    }
    
    if ( self.m_NoteInfo ) {
        self.strCurNoteType = self.m_NoteInfo.strNoteClassId;
    }
    else
    {
        NSString *strLanMu = [_GLOBAL getLanMu];
        if ( strLanMu && [strLanMu length]>0 ) {
            int jj = 0;
            for (jj=0;jj<[arrayNoteTypeList count];jj++) {
                NSString *str = [arrayNoteTypeList objectAtIndex:jj];
                if ( [str isEqualToString:strLanMu] ) break;
            }
            if ( jj == [arrayNoteTypeList count]) {
                for (int kk=0;kk<[arrayNoteTypeList count];kk++) {
                    NSString *str = [arrayNoteTypeList objectAtIndex:kk];
                    NSRange range;
                    range = [str rangeOfString:strLanMu];
                    if ( range.length > 0 ) {
                        jj = kk;
                        break;
                    }
                }
            }
            if ( jj < [arrayNoteTypeList count]) { //存在
                self->nNoteTypeIndex = jj;
            }
        }
        
        self.strCurNoteType = [self.arrayNoteTypeList objectAtIndex:self->nNoteTypeIndex];
    }
    self->labelNoteType.text = self.strCurNoteType;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataNoteStar:) name:NOTIFICATION_UPDATE_NOTE_STAR object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect rNoteTypeList = self->twNoteTypeList.frame;
    float fh = 44.0;//self->twNoteTypeList.rowHeight;
    int line = (int)[arrayNoteTypeList count] + 1;
    if ( line > 9 ) line = 9;
    fh = fh * line;
    rNoteTypeList.size.height = fh;
    self->twNoteTypeList.frame = rNoteTypeList;
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) dealloc
{
    //LOG_ERROR(@"---->>>UINoteEdit(%p) dealloc",self);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
 
    //去掉代理
    m_scrollview.delegate = nil;
    m_noteContentWebView.delegate = nil;
    m_noteContentWebView.scrollView.delegate = nil;
  
#ifdef _USE_NOTEWEBVIEW
    _mywebview.delegate = nil;
    _mywebview.scrollView.delegate = nil;
    [_mywebview stopLoading];
    
    
/*    
#else
    _mywebview.delegate = nil;
    _mywebview.mydelegate = nil;
    _mywebview.scrollView.delegate = nil;
    [_mywebview stopLoading];
    [_mywebview removeFromSuperview];
 */
#endif
    
    
    [self.m_ItemArr removeAllObjects];
    self.m_ItemArr = nil;
    [self.m_arrItemGuid removeAllObjects]; //add 2014.9.23
    self.m_arrItemGuid = nil;
    [self.m_arrPicItemGuid removeAllObjects]; //add 2014.9.23
    self.m_arrPicItemGuid = nil;
    
    self.msgParam = nil;
    self.m_strNoteGuid = nil;
    self.m_NoteInfo = nil;
    SAFEFREE_OBJECT(self->m_TempNoteInfo);
    
    self.imgBold1 = nil;
    self.imgBold2 = nil;
    self.imgUnderline1 = nil;
    self.imgUnderline2 = nil;
    self.imgItalic1 = nil;
    self.imgItalic2 = nil; 
    

    //用到有代理的视图释放，要在前面释放掉。
    [m_RecordView stopRecording];
    [m_RecordView removeFromSuperview];
    m_RecordView.delegate = nil;
    [m_RecordView release];
    m_RecordView = nil;
    
    [m_PlayView exitPlaying];
    [m_PlayView removeFromSuperview];
    m_PlayView.delegate = nil;
    [m_PlayView release];
    m_PlayView = nil;    
    
    
    //导航栏
    SAFEREMOVEANDFREE_OBJECT(m_btnNavFinish);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavRecord);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavDraw);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavPhoto);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavCamera);
    SAFEREMOVEANDFREE_OBJECT(m_btnNavCancel);
    SAFEREMOVEANDFREE_OBJECT(m_navView);
    
    //工具栏
    SAFEREMOVEANDFREE_OBJECT(m_btnToolShow);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolHide);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolInfo);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolItalic);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolUnderline);
    SAFEREMOVEANDFREE_OBJECT(m_btnToolBold);
    SAFEREMOVEANDFREE_OBJECT(m_toolView);
    
    SAFEREMOVEANDFREE_OBJECT(m_tfTitleField);
    SAFEREMOVEANDFREE_OBJECT(m_titleView);
    SAFEREMOVEANDFREE_OBJECT(m_noteContentWebView); 
    SAFEREMOVEANDFREE_OBJECT(m_scrollview);
    
    SAFEREMOVEANDFREE_OBJECT(labelNoteType);
    SAFEREMOVEANDFREE_OBJECT(btnDropNoteList);
    SAFEREMOVEANDFREE_OBJECT(vwNoteType);
    SAFEREMOVEANDFREE_OBJECT(twNoteTypeList);
    SAFEREMOVEANDFREE_OBJECT(btnHideNoteTypeList);
    self.arrayNoteTypeList = nil;
    self.strCurNoteType = nil;
    
    [super dealloc];
    
}

/*
-(void)dispImage:(NSString *)strFileName
{
    NSRange range = [strFileName rangeOfString:@"/" options:NSBackwardsSearch];
    if ( range.length <= 0 ) return;
    
    NSString *str1 = [strFileName substringFromIndex:range.location + range.length];
    range = [str1 rangeOfString:@"."];
    if ( range.length <= 0 ) return;
    
    NSString *strItem = [str1 substringToIndex:range.location];
    NSString *strExt = [str1 substringFromIndex:range.location+range.length];
    
    NSString *strFileName1 = [CommonFunc getItemPathAddSrc:strItem fileExt:strExt];
    if ( ![CommonFunc isFileExisted:strFileName1])
        strFileName1 = [CommonFunc getItemPath:strItem fileExt:strExt];
    
    NSArray *arr = [NSArray arrayWithObject:strFileName1];
    
    UIPresentImage *vc = [[UIPresentImage alloc] initWithNibName:@"UIPresentImage" bundle:nil];
    vc.m_pos = 0;
    vc.m_arrItem = arr;
    [self.navigationController pushViewController:vc animated:NO];
    [vc release];	
}
*/

-(void)backProc:(BOOL)bSaveflag
{
    //退出前做清除工作
    
    //退出时，删除日志相册的文件,2014.9.23
    if (!bSaveflag) {
        for (int jj=0;jj<[m_arrItemGuid count];jj++) {
            NSString *strItemGuid = [m_arrItemGuid objectAtIndex:jj];
            NSString *strPicItemGuid = [m_arrPicItemGuid objectAtIndex:jj];
        
            //删除文件
            [CommonFunc deleteFile:[CommonFunc getItemPath:strItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]]];
            //删除图片原文件
            [CommonFunc deleteFile:[CommonFunc getItemPathAddSrc:strItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]]];
            
            //删除文件
            [CommonFunc deleteFile:[CommonFunc getItemPath:strPicItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]]];
            //删除图片原文件
            [CommonFunc deleteFile:[CommonFunc getItemPathAddSrc:strPicItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]]];
        }

    }
    
    if ( timer ) {
        [timer invalidate];
        timer = nil;
    }
    
    //commit 2015.3.31
    //_singleRecognizer.touchesBeganCallback = nil;
    //_singleRecognizer.touchesEndedCallback = nil;
    //[_mywebview.scrollView removeGestureRecognizer:_singleRecognizer];
    //_singleRecognizer = nil;
    
    	
    if ( [_GLOBAL getEditFlag] == NEWNOTE_EDIT_FROM_READ)
    {
        NSLog(@"NoteEdit exit, into NoteRead");
        [self.navigationController popViewControllerAnimated:NO];
        [TheGlobal popNavTitle];
        
        [PubFunction SendMessageToViewCenter:NMNoteRead :0 :1 :nil];
    }
    else {
        [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
    }
}


//控件响应函数
- (IBAction) onNavCancel :(id)sender
{    
    NSString *contentText = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").innerText"];
    contentText = [contentText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    contentText = [contentText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
    //先检查标题和内容是否为空
    if ( !self.m_NoteInfo ) { //新建的
        if ( ![contentText isEqualToString:@""] || ![m_tfTitleField.text isEqualToString:@""] ) 
        {
            //UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认不保存笔记吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不保存",nil];
            UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"是否放弃日志编辑" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
            [alertview show];
            [alertview release]; 
            return;
        }
    }
    else {
        if ( ![contentText isEqualToString:m_NoteInfo.strContent] || ![m_tfTitleField.text isEqualToString:m_NoteInfo.strNoteTitle] ) //内容有修改
        {
            //UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确认不保存笔记吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不保存",nil];
            UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"是否放弃日志编辑" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
            [alertview show];
            [alertview release];
            return;
        }
    }

    [self backProc:NO];
}

//UIAlertView的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) { //取消
        return;
    }
    else { //放弃, 返回
        
        [self backProc:NO];
    }
}


- (IBAction) onNavCamera :(id)sender
{
    [self loadCamera];
    
}
- (IBAction) onNavPhoto:(id)sender
{
    [self loadPhoto];
}
- (IBAction) onNavDraw:(id)sender
{
    /*
    [_mywebview stringByEvaluatingJavaScriptFromString:@"onblurEX()"];
    
    UIDrawer *vc = [[UIDrawer alloc] initWithNibName:@"UIDrawer" bundle:nil];
    vc.delegate = self;
    vc.imagePath = [CommonFunc getDrawTmpFile];
    
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
    
    //要设路径。。。
    */
}


- (IBAction) onNavRecord:(id)sender
{
    [m_RecordView stopRecording];
    [m_RecordView removeFromSuperview];
    m_RecordView.delegate = nil;
    [m_RecordView release];
    m_RecordView = nil;
    
    m_RecordView = [[RecordView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) andFile:[CommonFunc getRecordTmpFile] ];
    m_RecordView.delegate = self;
    [self.view addSubview:m_RecordView];
    [m_RecordView startRecord];
    
}

- (IBAction) onNavFinish:(id)sender
{
    //NSString *title = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.title"];
    //NSString *currentURL = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString *allHTML = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"body:%@",allHTML);
    NSString *contentHTML = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").innerHTML"]; 
    NSString *contentText = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").innerText"];
    contentText = [contentText stringByReplacingOccurrencesOfString:@" " withString:@""];
    contentText = [contentText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    contentText = [contentText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    
    //保存项目文件
    
    //先检查标题和内容是否为空
    if ( [contentText isEqualToString:@""]
        && [contentHTML rangeOfString:@"img src"].location == NSNotFound) {
            [UIAstroAlert info:@"请编辑内容" :3.0 :NO :LOC_MID :NO];
            return;
    }
    
    if ( [m_tfTitleField.text isEqualToString:@""] ) {
        NSString *strDate = [CommonFunc getCurrentDate];
        m_tfTitleField.text = [NSString stringWithFormat:@"%@ %@",self.strCurNoteType,strDate];
    }
    
    
    TItemInfo *firstItemInfo=nil;
    
    //如果原来不存在，先生成
    if ( !self.m_NoteInfo ) {
        //初始化一条笔记,输入参数为父目录GUID，自动生成笔记编号和第一条项目不编号
        NSString *strCatalogGuid = [_GLOBAL getEditCatalogGuid];
        if ( !strCatalogGuid ) strCatalogGuid = [_GLOBAL defaultCateID];
        self.m_NoteInfo = [BizLogic createNoteInfo:strCatalogGuid];
        
        firstItemInfo = [BizLogic CreateItemInfo:NI_HTML itemguid:self.m_NoteInfo.strFirstItemGuid noteguid:self.m_NoteInfo.strNoteIdGuid];
        //添加到Array
        [self.m_ItemArr addObject:firstItemInfo];
    }
    else {
        //取出HTML item
        for (id obj in self.m_ItemArr ) {
            firstItemInfo = (TItemInfo *)obj;
            if ( [self.m_NoteInfo.strFirstItemGuid isEqualToString:firstItemInfo.strItemIdGuid] )
                break;
            else firstItemInfo = nil;
        }
        if ( !firstItemInfo ) {
            //不应该到这里,缺少了数据，用新的firstItemGuid
            self.m_NoteInfo.strFirstItemGuid = [CommonFunc createGUIDStr];  //不用新的GUID，服务端会有可能认为冲突
            firstItemInfo = [BizLogic CreateItemInfo:NI_HTML itemguid:self.m_NoteInfo.strFirstItemGuid noteguid:self.m_NoteInfo.strNoteIdGuid];
            //添加到Array
            [self.m_ItemArr addObject:firstItemInfo];
        }
        
        //first item的扩展名固定为HTML(从其它同步过来的，也改为)
        firstItemInfo.strItemExt = [CommonFunc getItemTypeExt:NI_HTML];  //第一项的扩展名总是HTML
        firstItemInfo.nItemType = NI_HTML;
    }
    
    //保存HTML文件
    [CommonFunc replaceHTMLBody:[CommonFunc getItemPath:self.m_NoteInfo.strFirstItemGuid fileExt:[CommonFunc getItemTypeExt:NI_HTML]] content:contentHTML];
    //如果是新增，首先生成HTML item
    
    //修改html item的属性
    NSString *strFileName = [CommonFunc getItemPath:self.m_NoteInfo.strFirstItemGuid fileExt:[CommonFunc getItemTypeExt:NI_HTML]];
    firstItemInfo.nItemSize = (int)[CommonFunc GetFileSize:strFileName];
    firstItemInfo.strItemTitle = [NSString stringWithFormat:@"%@.%@",self.m_NoteInfo.strFirstItemGuid,[CommonFunc getItemTypeExt:NI_HTML]];   // item名称
    
    //修改笔记的各项属性
    self.m_NoteInfo.strNoteClassId = self.strCurNoteType; //笔记类型
    self.m_NoteInfo.strNoteTitle = m_tfTitleField.text;    // NOTE的名称 
    self.m_NoteInfo.nNoteSize = (int)[CommonFunc GetFileSize:[CommonFunc getItemPath:self.m_NoteInfo.strFirstItemGuid fileExt:@"html"]];              // NOTE包含的所有ITEM总长度，不包含自身(先赋第一个)
    int length = (int)[contentText length];
    if ( length > 200 ) length = 200;
    if ( length > 0 ) self.m_NoteInfo.strContent = [contentText substringToIndex:length];
    else self.m_NoteInfo.strContent = @"";
    self.m_NoteInfo.strFileExt = [CommonFunc getItemTypeExt:NI_HTML];  //第一项的扩展名总是HTML
    self.m_NoteInfo.nNoteType = NOTE_WEB;
    
    //通过和数组比较，看是否增加或删除了一些item
    for ( int jj=0;jj<[m_ItemArr count];jj++)
    {
        TItemInfo *pItemInfo = [m_ItemArr objectAtIndex:jj];
        pItemInfo.strNoteIdGuid =  self.m_NoteInfo.strNoteIdGuid;
        
        if ( ![pItemInfo.strItemIdGuid isEqualToString:self.m_NoteInfo.strFirstItemGuid] ) {  //非第一项
            //查找是否在HTML中
            NSRange range = [contentHTML rangeOfString:pItemInfo.strItemIdGuid];
            if ( range.length > 0 ) { //存在
            }
            else 
            { 
                //按小写的方式查找
                NSString *strGuidLowCase = [pItemInfo.strItemIdGuid lowercaseString];
                range = [contentHTML rangeOfString:strGuidLowCase];
                if ( range.length <= 0 )
                {
                    //不存在，除去，并删除文件(新增加的才能删除文件)
                    if ( pItemInfo.tHead.nEditState == EDITSTATE_EDITED) {//新增的
                        [CommonFunc deleteFile:[CommonFunc getItemPath:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt]];
                        if ([CommonFunc isImageFile:pItemInfo.strItemExt]) {
                            //删除图片原文件
                            [CommonFunc deleteFile:[CommonFunc getItemPathAddSrc:pItemInfo.strItemIdGuid fileExt:pItemInfo.strItemExt]];
                        }
                    }
                    [self.m_ItemArr removeObject:pItemInfo];
                    jj--;//由于删除了一项，要回退一个
                }
            }
        }
    }
    
    if( self->m_TempNoteInfo )
    {
        self.m_NoteInfo.nStarLevel = self->m_TempNoteInfo.nStarLevel;
    }
    
    NSLog(@"noteEdit:save note");
    //增加或修改一条笔记
    [BizLogic addNote:self.m_NoteInfo ItemInfo:m_ItemArr];
    
    
    //处理日志相册,2014.9.23
    for (int jj=0;jj<[m_arrItemGuid count];jj++) {
        NSString *strItemGuid = [m_arrItemGuid objectAtIndex:jj];
        NSString *strPicItemGuid = [m_arrPicItemGuid objectAtIndex:jj];
        
        int nExistFlag = 0;
        for ( TItemInfo *pItem in m_ItemArr) {
            if ( [pItem.strItemIdGuid isEqual:strItemGuid] ) {
                nExistFlag = 1;
                break;
            }
        }
        
        nExistFlag = 0; //2015.2.3, 暂时不处理
        if ( 1 == nExistFlag ) {
            //存在，则保存到数据库
            NSString *strTitle = [NSString stringWithFormat:@"%@ 图片%d",m_tfTitleField.text,jj+1];
            [BizLogic addPic:strPicItemGuid title:strTitle albumname:@"日志相册" albumid:@"0" uid:TheCurUser.sUserID username:TheCurUser.sUserName];
        }
        else {
            //删除文件
            [CommonFunc deleteFile:[CommonFunc getItemPath:strPicItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]]];
            //删除图片原文件
            [CommonFunc deleteFile:[CommonFunc getItemPathAddSrc:strPicItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]]];
        }
    }
    
    
    NSLog(@"noteEdit:back proc");
    [self backProc:YES];
    
}

- (IBAction) onToolBold:(id)sender
{
    [timer invalidate];
    //NSString *strRet = 
    [_mywebview stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Bold\")"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSelection:) userInfo:nil repeats:YES];
    
}
- (IBAction) onToolUnderline:(id)sender
{
    [timer invalidate];
    //NSString *strRet =  
    [_mywebview stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Underline\")"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSelection:) userInfo:nil repeats:YES];
    
}
- (IBAction) onToolItalic:(id)sender
{
    [timer invalidate];
    //NSString *strRet = 
    [_mywebview stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Italic\")"];  
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkSelection:) userInfo:nil repeats:YES];
    
}
- (IBAction) onToolInfo:(id)sender
{
    //调用笔记信息页面
    //[FlurryAnalytics logEvent:@"笔记信息"];
    
    //笔记信息
    if ( self->m_TempNoteInfo ) {
        [PubFunction SendMessageToViewCenter: NMNoteInfor:0 :1 :self->m_TempNoteInfo];
    }
    else
    {
        [PubFunction SendMessageToViewCenter: NMNoteInfor:0 :1 :self->m_NoteInfo];
    }
    
}
- (IBAction) onToolHide:(id)sender
{
    m_btnToolShow.hidden = NO;
    //m_toolView.hidden =  YES;
    
    //收回键盘
    //[m_tfTitleField resignFirstResponder];
    nNotProcessKeyboard = 1;
    [m_tfTitleField becomeFirstResponder];
    [m_tfTitleField resignFirstResponder];
}


- (IBAction) onToolShow:(id)sender
{
    m_btnToolShow.hidden = YES;
    //m_toolView.hidden =  NO;
    
    [m_tfTitleField becomeFirstResponder];
    //[_mywebview becomeFirstResponder]; 
    
}

-(IBAction)onDispOrHideNoteType:(id)sender
{
    if ( sender == self->btnDropNoteList ) {
        self->vwNoteType.hidden = NO;
        
        [self onToolHide:sender];
    }
    else if( sender == self->btnHideNoteTypeList )
    {
        self->vwNoteType.hidden = YES;
    }
}
-(void) flashContent
{
    NSString *strContext = nil;
    
    if ( [_GLOBAL getEditFlag] == NEWNOTE_EDIT || [_GLOBAL getEditFlag] == NEWNOTE_EDIT_FROM_READ ) { //编辑
        self.m_NoteInfo = [_GLOBAL getEditNoteInfo];
  
        if ( m_NoteInfo ) {
            //标题
            m_tfTitleField.text = self.m_NoteInfo.strNoteTitle;
            
            //加载内容
            //文件名
            NSString *strEditFileName = [CommonFunc getItemPath:self.m_NoteInfo.strFirstItemGuid fileExt:@"html"];
            //文件<body>内容
            NSString *strEditFileContent = [CommonFunc getHTMLFileBody:strEditFileName];
            //替换到编辑模版
            strContext = [CommonFunc replaceDemoContent:[CommonFunc getEditModelFile] content:strEditFileContent];
            
            //取项目，并保存到数组中。
            NSArray *arrItem = [BizLogic getAllItemByNoteGuid:self.m_NoteInfo.strNoteIdGuid];
            [self.m_ItemArr addObjectsFromArray:arrItem];
        }
    }
    
    if ( !strContext ) {
        //不存在文件或新增加, 直接加载模版
        strContext = [NSString stringWithContentsOfFile:[CommonFunc getEditModelFile] encoding:NSUTF8StringEncoding error:nil];
         self->m_TempNoteInfo = [[BizLogic createNoteInfo:nil] retain]; //新建一个临时的笔记结构
    }
    else
    {
        self->m_TempNoteInfo = nil;
    }
    
    
    NSURL *baseURL = [NSURL fileURLWithPath:[CommonFunc getTempDir] isDirectory:YES];
    [_mywebview loadHTMLString:strContext baseURL:baseURL];
     
    
    
    //先写到文件，不然后面增加图片似乎不对
    /*
    NSString *strTmpHTMLFile = [[CommonFunc getTempDir] stringByAppendingString:@"/tmpedit.html"];
    //再写回文件,用UTF8
    NSData * data = [NSData dataWithBytes:[strContext UTF8String] length:strlen([strContext UTF8String])];
    BOOL ret = [data writeToFile:strTmpHTMLFile atomically:NO]; 
    
    NSURL *baseURL = [NSURL fileURLWithPath:strTmpHTMLFile];  
    NSURLRequest* request = [NSURLRequest requestWithURL:baseURL];
    [_mywebview loadRequest:request];
    */
    
    /*
    NSString *strTmpHTMLFile = [[CommonFunc getTempDir] stringByAppendingString:@"/tmpedit.html"];
    //再写回文件,用UTF8
    NSData * data = [NSData dataWithBytes:[strContext UTF8String] length:strlen([strContext UTF8String])];
    BOOL ret = [data writeToFile:strTmpHTMLFile atomically:NO]; 
    //NSString *url = [NSString stringWithFormat:@"file://%@",[CommonFunc getTempDir]];
    NSURL *baseURL1 = [NSURL fileURLWithPath:[CommonFunc getTempDir] isDirectory:YES];
    NSURL *baseURL = [NSURL URLWithString:@"tmpedit.html" relativeToURL:baseURL1];
    NSURLRequest* request = [NSURLRequest requestWithURL:baseURL];
    [_mywebview loadRequest:request];
    */
    
}

-(void)updataNoteStar:(NSNotification *)note
{
    if ( note ) {
        NSString *guid = (NSString*)[[note userInfo] objectForKey:@"note_guid"];
        NSInteger star = [[[note userInfo] objectForKey:@"note_star"]integerValue];
        TNoteInfo * info = (self->m_TempNoteInfo ? self->m_TempNoteInfo : self->m_NoteInfo);
        if ( [guid isEqualToString:info.strNoteIdGuid]
            && info.nStarLevel != star ) {
            info.nStarLevel = (int)star;
        }
    }
}

-(int)getImgNumOfHtml
{
    NSString *contentHTML = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").innerHTML"];
    
    int num = 0;
    for (; ; ) {
        NSRange range = [contentHTML rangeOfString:@"<img"];
        if ( range.length > 0 ) {
            contentHTML = [contentHTML substringFromIndex:(range.location+5)];
            num++;
        }
        else
            break;
    }
    return num;
}

- (void)loadCamera
{
    if ( [self getImgNumOfHtml] >= 20 ) {
        [UIAstroAlert info:@"日志内的图片已达到20张，不能再增加。" :2.0 :NO :0 :NO];
        return;
        
    }
    
    [_mywebview stringByEvaluatingJavaScriptFromString:@"onblurEX()"];
    
#if TARGET_IPHONE_SIMULATOR
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
        
        return;
    }
#else
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES]; //隐藏状态栏
        return;
    }
#endif
    
    
}

/*
- (void)loadPhoto
{
    [_mywebview stringByEvaluatingJavaScriptFromString:@"onblurEX()"];
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    [self presentViewController:picker animated:NO completion:nil];
    [picker release];
}
*/


//-------------------------------------
- (void)loadPhoto
{
    int maxcount = [self getImgNumOfHtml];
    if (  maxcount >= 20 ) {
        [UIAstroAlert info:@"日志内的图片已达到20张，不能再增加。" :2.0 :NO :0 :NO];
        return;
        
    }
    
    /*
    [[GlobalPictureCounter getGlobalPictureCounterInstance] setPictureCount:(int)[self.pictureList count]];
    if( [self.pictureList count] >=  MAXCOUNT_PICTURESELECTED)
    {
        [UIAstroAlert info:@"不能增加照片了，所选相片数量已达最大限制" :2.0 :NO :0 :NO];
        return ;
    }
    */
    NSLog( @"添加照片" ) ;
    
    [_mywebview stringByEvaluatingJavaScriptFromString:@"onblurEX()"];
     
  
    CImagePicker *imagepicker = [CImagePicker sharedInstance] ;
    //imagepicker.maxCount = MAXCOUNT_PICTURESELECTED ;
    //imagepicker.maxCount = MAXCOUNT_PICTURESELECTED - (int)[self.pictureList count] ;
    imagepicker.maxCount = 20 - maxcount ;
    imagepicker.callObject = self ;
    imagepicker.callBack = @selector(pictureSelect:) ;
    [imagepicker selectImage:self];
}



- (void)pictureSelect:(NSMutableArray*)pictureArray
{
    UIImage *image = nil ;
    CGImageRef ref = nil ;
    

    for(ALAsset *obj in pictureArray )
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init] ;
        
        ALAssetRepresentation *assetRep = [obj defaultRepresentation];
        ref = [assetRep fullResolutionImage];
        image = [UIImage imageWithCGImage:ref scale:assetRep.scale orientation:assetRep.orientation];
        image = [CImagePicker fixOrientation:image] ;//add by zd 2014-3-26
            
        NSString *strGuid = [CommonFunc createGUIDStr];
        [CommonFunc saveJYEXPic:image fileguid:strGuid mode:@"L"];
        
        //老师和园长另外保存在日志相册的图片 //2014.9.23
        /*
        TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
        if ( [u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] || [u isInfantsSchoolTeacher] ||
            [u isMiddleSchoolTeacher]) {
            //是老师是园长
            NSString *strPicGuid = [CommonFunc createGUIDStr];
            [CommonFunc saveJYEXPic:image fileguid:strPicGuid mode:@"H"];
            [self.m_arrItemGuid addObject:strGuid];
            [self.m_arrPicItemGuid addObject:strPicGuid];
        }
        */
        
        [self performSelectorOnMainThread:@selector(insertImage:) withObject:strGuid waitUntilDone:YES];
        
        [pool drain] ;
    }
    
   
    
    //将选择的相片显示出来
    //NSLog( @"%@", self.pictureList ) ;
    
    //更新显示
    //NSLog( @"start update view" ) ;
    //[self performSelectorOnMainThread:@selector(updateImageViewAfterSelect) withObject:nil waitUntilDone:NO];
    
}

/*
- (void)saveSelectPicture:(CPictureSelected*)pic
{
    UIImage *image = nil ;
    //NSData *data = nil ;
    CGImageRef ref = nil ;
    //BOOL ret = YES ;
    
    CPictureSelected *obj = nil ;
    
    if( pic == nil ) return ;
    
    obj = pic ;
    
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init] ;
    
    if( !pic.editFlag )
    {
        ALAssetRepresentation *assetRep = [obj.picAlasset defaultRepresentation];
        ref = [assetRep fullResolutionImage];
        image = [UIImage imageWithCGImage:ref scale:assetRep.scale orientation:assetRep.orientation];
        image = [CImagePicker fixOrientation:image] ;//add by zd 2014-3-26
        
        NSString *strGuid = [CommonFunc createGUIDStr];
        [CommonFunc saveJYEXPic:image fileguid:strGuid mode:@"L"];
        
        [self insertImage:strGuid];
        
    }
    
    [pool drain] ;
}
*/


//--------------------------------------



//播放文件
- (void) playFile:(NSString *)strFileName
{
    [m_PlayView exitPlaying];
    [m_PlayView removeFromSuperview];
    m_PlayView.delegate = nil;
    [m_PlayView release];
    m_PlayView = nil;
    
    if ( !m_PlayView ) {
        m_PlayView = [[PlayView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) ];
        m_PlayView.delegate = self;
        [self.view addSubview:m_PlayView];
    }
    
    [m_PlayView startPlay:strFileName];
}


//设置高度
-(void)setWebViewHeight
{
    /*
    CGSize size = [_mywebview.scrollView contentSize];
    NSLog(@"webview.scrollview contentsize=%@",NSStringFromCGSize(size));
    
    CGFloat height = size.height - heightInterval;
    if ( height < 600 ) height = 600;
    
    NSString *newContentHTML = [NSString stringWithFormat:@"document.getElementById(\"content\").style.height='%.0fpx'",height];
    NSLog(@"string:%@",newContentHTML);
    NSString *strRet = [_mywebview stringByEvaluatingJavaScriptFromString:newContentHTML];
    NSLog(@"设置高度结果:%@",strRet);
    */
}

//插入图片
-(void)insertImage:(NSString *)strItemGuid
{
    //图像还可以压缩
    NSString *imagePathSrc = [CommonFunc getItemPathAddSrc:strItemGuid fileExt:[CommonFunc getItemTypeExt:NI_PIC]];
    NSString *urlPath =[NSString stringWithFormat:@"%@.%@",strItemGuid,[CommonFunc getItemTypeExt:NI_PIC]];
    

    NSString* strResponse = [_mywebview stringByEvaluatingJavaScriptFromString:@"reAddCreateSelection()"];
    NSLog(@"insert image response = %@",strResponse);
    strResponse = [_mywebview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('insertImage', false, '%@')", urlPath]];
    NSLog(@"insert image response = %@",strResponse);
    
    if ([strResponse isEqualToString:@"false"] || [strResponse isEqualToString:@"FALSE"] ) 
    {
        NSString *requeststr =[NSString stringWithFormat:@"<div><img src=\'%@\'></div><br><br> ",urlPath];
        //NSString *requeststr =[NSString stringWithFormat:@"<div><img src=\'%@\' onload=\"if (this.width>320 || this.height>460){ if (this.width/this.height>320/460) this.width=320; else this.height=460;}\"></div><br><br> ",urlPath];
 
        NSString *contentHTML = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").innerHTML"]; 
        contentHTML = [contentHTML stringByAppendingString:requeststr];
    
        contentHTML = [contentHTML stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        contentHTML = [contentHTML stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        contentHTML = [contentHTML stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];    
    
        NSString *newContentHTML = [NSString stringWithFormat:@"document.getElementById(\"content\").innerHTML=\"%@\"",contentHTML];
        NSString *strRet = [_mywebview stringByEvaluatingJavaScriptFromString:newContentHTML];
        NSLog(@"插入图片结果:%@",strRet);
    }
    
    //重新设置高度
    [self setWebViewHeight];
    
    //生成Item
    TItemInfo *pItemInfo = [BizLogic CreateItemInfo:NI_PIC itemguid:strItemGuid noteguid:self.m_NoteInfo.strNoteIdGuid];
    //更新属性
    pItemInfo.nItemSize = (int)[CommonFunc GetFileSize:imagePathSrc];
    pItemInfo.strItemTitle = urlPath;  //文件名
    
    //添加到Array
    [self.m_ItemArr addObject:pItemInfo];
    
    
}


//生成、插入录音文件到HTML
-(void)insertRecordFile:(NSString *)strRecordFile
{
    NSString *strItemGuid  = [CommonFunc createGUIDStr];
    NSString *recordPath = [CommonFunc getItemPath:strItemGuid fileExt:[CommonFunc getItemTypeExt:NI_AUDIO]];
    BOOL ret = [CommonFunc CopySouceToTarget:strRecordFile Target:recordPath];
    if ( !ret ) {
        MESSAGEBOX(@"拷贝录音文件不成功");
        return;
    }
    
    //文件大小
    long long nFileSize = [CommonFunc GetFileSize:recordPath];
    
    NSString *urlPath = [NSString stringWithFormat:@"%@.%@",strItemGuid,[CommonFunc getItemTypeExt:NI_AUDIO]];
    
    
    CGFloat fsize=nFileSize;
    NSString *curDate = [CommonFunc getCurrentTime];  //yyyy-MM-dd HH:mm:ss
    curDate = [curDate substringToIndex:16];
    curDate = [curDate stringByReplacingOccurrencesOfString:@"-" withString:@""]; //yyyyMMdd HH:mm
    NSString *strLabel =[NSString stringWithFormat:@"<a href=\"%@\">录音文件-%@</a><br><font color='blue'>%.1fK</font>",urlPath,curDate,fsize/1024];
    //recordicon.png
    
    NSString *requeststr =[NSString stringWithFormat:\
            @"<div><table><tr><td><a href=\"%@\"><img src='recordicon.png' border='0'></a></td><td valign='middle'>%@</td></tr></table></div><br><br>",
            urlPath,strLabel];
    
    //NSString *requeststr =[NSString stringWithFormat:@"<div style='vertical-align:top;'><a href=\"%@\"><img src='recordicon.png'>%@</a></div><br><br><br> ",urlPath,strLabel];
    //NSURL *baseURL = [NSURL fileURLWithPath:requeststr];
    
    NSString *contentHTML = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").innerHTML"]; 
    contentHTML = [contentHTML stringByAppendingString:requeststr];
    
    contentHTML = [contentHTML stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    contentHTML = [contentHTML stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    contentHTML = [contentHTML stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];    
    
    NSString *newContentHTML = [NSString stringWithFormat:@"document.getElementById(\"content\").innerHTML=\"%@\"",contentHTML];
    NSString *strRet = [_mywebview stringByEvaluatingJavaScriptFromString:newContentHTML];
    NSLog(@"插入录音结果:%@",strRet);
    
    //重新设置高度
    [self setWebViewHeight];
    
    //生成Item
    TItemInfo *pItemInfo = [BizLogic CreateItemInfo:NI_AUDIO itemguid:strItemGuid noteguid:self.m_NoteInfo.strNoteIdGuid];
    //更新属性
    pItemInfo.nItemSize = (int)nFileSize;
    pItemInfo.strItemTitle = urlPath;  //文件名
    
    //添加到Array
    [self.m_ItemArr addObject:pItemInfo];
    
}


//拍照的代理
#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController*)picker
        didFinishPickingImage:(UIImage*)image
                    edingInfo:(NSDictionary*)editingInfo
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO]; //恢复状态栏
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO]; //恢复状态栏

    [self dismissViewControllerAnimated:NO completion:nil];
    
    if ( bFirst) {
        [self backProc:NO];
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    bFirst = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];  //恢复状态栏
   
    [self dismissViewControllerAnimated:YES completion:nil];  //原来在后面
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];   
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *strGuid = [CommonFunc createGUIDStr];
        [CommonFunc saveJYEXPic:image fileguid:strGuid mode:@"L"];
        
        [self insertImage:strGuid];
        
        //老师和园长另外保存在日志相册的图片 //2014.9.23
        /*
        TJYEXLoginUserInfo *u = (TJYEXLoginUserInfo*)TheCurUser;
        if ( [u isInfantsSchoolMaster] || [u isMiddleSchoolMaster] || [u isInfantsSchoolTeacher] ||
            [u isMiddleSchoolTeacher]) {
            //是老师是园长
            NSString *strPicGuid = [CommonFunc createGUIDStr];
            [CommonFunc saveJYEXPic:image fileguid:strPicGuid mode:@"H"];
            [self.m_arrItemGuid addObject:strGuid];
            [self.m_arrPicItemGuid addObject:strPicGuid];
        }
        */

        /*
        if ( [_GLOBAL getEditFlag] == NEWNOTE_CAMERA && [m_tfTitleField.text isEqualToString:@""]) {
            NSString *date = [CommonFunc getCurrentDate];
            //NSString *year = [date substringToIndex:4];
            NSString *month = [date substringFromIndex:5];
            month = [month substringToIndex:2];
            //NSString *day = [date substringFromIndex:8];
            //m_tfTitleField.text = [NSString stringWithFormat:@"随手拍_%@.%@.%@",month,day,year];
        }
        */
    }

}

//CameraOverlayView的代理
-(void) didCancel
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO]; //恢复状态栏
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if ( bFirst) {
        [self backProc:NO];
    }
}


//UICameraOverlay拍照的代理
-(void) Camera_ClickCancel
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if ( bFirst) {
        [self backProc:NO];
    }
}

-(void) Camera_ClickFinish:(UIImage *)image
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-------------


//随手画的代理
//UIDrawerDelegate
/*
-(void) Drawer_ClickCancel:(UIDrawer *)drawerCtl
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if ( bFirst) {
        [self backProc:NO];
    }
}

-(void) Drawer_ClickFinish:(UIDrawer *)drawerCtl
{
    bFirst = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
     //处理文件
    UIImage *image = [UIImage imageWithContentsOfFile:[CommonFunc getDrawTmpFile]];
    
    NSString *strGuid = [CommonFunc createGUIDStr];
    [CommonFunc saveJYEXPic:image fileguid:strGuid  mode:@"H"];
    
    [self insertImage:strGuid];
 
    
    if ( [_GLOBAL getEditFlag] == NEWNOTE_DRAW && [m_tfTitleField.text isEqualToString:@""]) {
        NSString *date = [CommonFunc getCurrentDate];
        NSString *year = [date substringToIndex:4];
        NSString *month = [date substringFromIndex:5];
        month = [month substringToIndex:2];
        NSString *day = [date substringFromIndex:8];
        m_tfTitleField.text = [NSString stringWithFormat:@"随手画_%@.%@.%@",month,day,year];
    }

}
*/


//录音的代理
-(void) RecordFinish:(RecordView *) RecordView successfully:(BOOL)flag
{
    bFirst = NO;
    
    if ( flag ) {
        //保存文件
        //[self playFile:[CommonFunc getRecordTmpFile]];
        [self insertRecordFile:[CommonFunc getRecordTmpFile]];
        
        if ( [_GLOBAL getEditFlag] == NEWNOTE_RECORD && [m_tfTitleField.text isEqualToString:@""]) {
            NSString *date = [CommonFunc getCurrentDate];
            NSString *year = [date substringToIndex:4];
            NSString *month = [date substringFromIndex:5];
            month = [month substringToIndex:2];
            NSString *day = [date substringFromIndex:8];
            m_tfTitleField.text = [NSString stringWithFormat:@"随手录_%@.%@.%@",month,day,year];
        }

    }
    else {
        MESSAGEBOX(@"录音失败");
    }
    
    //释放
    m_RecordView.hidden = YES;
    [self performSelector:@selector(releaseRecordView) withObject:self afterDelay:0.5];
}


-(void) releaseRecordView
{
    [m_RecordView removeFromSuperview];
    m_RecordView.delegate = nil;
    [m_RecordView release];
    m_RecordView = nil;
}

//播放的代理
-(void) PlayFinish
{
    [m_PlayView exitPlaying];
    [m_PlayView removeFromSuperview];
    m_PlayView.delegate = nil;
    [m_PlayView release];
    m_PlayView = nil;    
}


//手势的回调函数
/*
-(void) hangleSingleTapFrom
{
    CGPoint point = [_singleRecognizer locationInView:_mywebview];
    NSLog(@"tab point=%@",NSStringFromCGPoint(point));
}


//mywebview的代理
- (void)touchEnd:(NSSet *)touches
{
    CGRect frame = m_scrollview.frame;
    CGPoint point = m_scrollview.contentOffset;
    //NSLog(@"==外部scrollview: frame:%@ offset:%@",NSStringFromCGRect(frame),NSStringFromCGPoint(point));
    //frame = _mywebview.frame;
    //NSLog(@"==webview:origin: frame:%@",NSStringFromCGRect(frame));
    frame = _mywebview.scrollView.frame;
    point = _mywebview.scrollView.contentOffset;
    NSLog(@"==web内部scrollview:frame:%@ offset:%@",NSStringFromCGRect(frame),NSStringFromCGPoint(point));
    
    CGPoint point1 = [[touches anyObject] locationInView:_mywebview.scrollView];
    CGPoint point2 = [[touches anyObject] locationInView:_mywebview];
    touchpoint = point1;
    
    NSLog(@"++touch point: inWebView:%@ inWebScrollView:%@",NSStringFromCGPoint(point2),NSStringFromCGPoint(point1));
    if ( touchpoint.y > 0 && touchpoint.y <= _mywebview.scrollView.frame.size.height )
    {
        //[_mywebview stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').focus();"] ;
        
        //[self performSelector:@selector(setWebScrollViewOffset) withObject:self afterDelay:1.0];
    }
}
*/


-(void)setWebScrollViewOffset
{
    CGPoint point = [_mywebview.scrollView convertPoint:CGPointZero fromView:m_toolView];
    NSLog(@"keyboard pos in webscollview:%@",NSStringFromCGPoint(point));

    CGPoint offset;
    offset.x = 0;
    offset.y = touchpoint.y - point.y + 30;
    if ( offset.y > 0 ) {
        _mywebview.scrollView.contentOffset = offset;
        
        NSLog(@"WebScrollView new offset:%@",NSStringFromCGPoint(offset));
    }
}


//UIWebView的代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( request ) {
        NSURL *newUrl = [request URL];
        //NSString *relativeString = [newUrl relativeString];
        NSString *absoluteString = [newUrl absoluteString];
        NSRange wavRange = [absoluteString rangeOfString:@".wav"];
        NSRange amrRange = [absoluteString rangeOfString:@".amr"];
        NSRange fileRange = [absoluteString rangeOfString:@"file://"];
        NSRange touchRange = [absoluteString rangeOfString:@"touch://"];
        NSRange keyRange = [absoluteString rangeOfString:@"pressreturn://"];
        
        //NSRange hostRange = [absoluteString rangeOfString:@"localhost:"];
        if ( (wavRange.length>0 ||amrRange.length>0) && (fileRange.length>0 ))//|| hostRange.length>0) )
        {
            NSString *path = [absoluteString stringByReplacingCharactersInRange:fileRange withString:@""];
            
            //本地的WAV文件，播放WAV文件
            [self playFile:path];
            return NO;
        }
        else if (touchRange.length > 0)
        {
            //touch://x+y
            NSString *strTmp = [absoluteString substringFromIndex:touchRange.location+touchRange.length];
            NSRange range= [strTmp rangeOfString:@"+"];
            if ( range.length > 0  && bWebIsEdit) {  //在编辑状态
                NSString *strX = [strTmp substringToIndex:range.location];
                NSString *strY = [strTmp substringFromIndex:range.location + range.length];
                //设置偏移
                
                NSLog(@"pos x=%@, y=%@",strX,strY);
                //CGFloat cury = [strY floatValue];
                
                /* -- 6.0没问题
                CGPoint myPoint = [_mywebview.scrollView convertPoint:CGPointZero fromView:m_toolView];
                NSLog(@"myPoint=%@",NSStringFromCGPoint(myPoint));
                
                CGSize contentSize = _mywebview.scrollView.contentSize;
                NSLog(@"contentSize=%@",NSStringFromCGSize(contentSize));
                
                CGPoint offset;
                offset.x = 0;
                offset.y = cury - _mywebview.frame.size.height-40;
                if ( offset.y > 0) {
                    _mywebview.scrollView.contentOffset = offset;
                }*/
                
                /*
                CGPoint myPoint = [m_scrollview convertPoint:CGPointZero fromView:m_toolView];
                CGPoint myPoint1 = [_mywebview convertPoint:CGPointZero fromView:m_toolView];
                CGPoint myPoint2 = [_mywebview.scrollView convertPoint:CGPointZero fromView:m_toolView];
                NSLog(@"Point: ScrollView=%@  InWebView=%@ InWebScroll=%@",NSStringFromCGPoint(myPoint),NSStringFromCGPoint(myPoint1),NSStringFromCGPoint(myPoint2));
                 
                if ( cury + m_titleView.frame.size.height - m_scrollview.contentOffset.y > myPoint.y )
                {
                    CGPoint offset = weboffset;
                    NSLog(@"WebScrollview offset=%@",NSStringFromCGPoint(offset) );
                    offset.y += cury + m_titleView.frame.size.height - m_scrollview.contentOffset.y - myPoint.y + 40;
                    _mywebview.scrollView.contentOffset = offset;
                    NSLog(@"WebScrollview new offset=%@",NSStringFromCGPoint(offset) );
                }*/
            }
            
            return NO;
        }
        else if ( keyRange.length > 0 )
        {
            //-----
            CGPoint contentOffset = _mywebview.scrollView.contentOffset;
            CGSize  contentSizeNow = _mywebview.scrollView.contentSize;
            CGFloat offset = 20;
            int adjustflag = 0;
            if ( contentSizeNow.height > m_contentSize.height ) {
                offset = contentSizeNow.height - m_contentSize.height;
            }
            
            if ( m_returnKeyNum*offset + touchpoint.y > LENGTH_SCROLL ) {
                contentOffset.y += offset;
                _mywebview.scrollView.contentOffset = contentOffset;
                
                NSLog(@"setOffset:touchpoint=%@ contentOffset=%@ offset=%.0f",NSStringFromCGPoint(touchpoint),NSStringFromCGPoint(contentOffset),offset);
                
                adjustflag = 1;
            } 
            else if (m_returnKeyNum >= 2 ) {
                adjustflag = 1;
            }
            
            if ( 1 == adjustflag ) {
                CGPoint scrolloffset = m_scrollview.contentOffset;
                CGSize  scrollSize = m_scrollview.contentSize;
                if ( scrolloffset.y < scrollSize.height - m_scrollview.frame.size.height -1 ) 
                {
                    scrolloffset.y = scrollSize.height - m_scrollview.frame.size.height;
                    m_scrollview.contentOffset = scrolloffset;
                }
            }
            
            m_returnKeyNum++;
            m_contentSize = contentSizeNow;
            
            /*
            if ( contentSize.height > s_contentSize.height && bWebIsEdit) { //编辑状态
                contentOffset.y += contentSize.height - s_contentSize.height + 20;
                _mywebview.scrollView.contentOffset = contentOffset;
                NSLog(@"--set new contentOffset=%@",NSStringFromCGPoint(contentOffset));
            }*/
            
            return NO;
        }
        
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *newContentHTML = @"document.getElementById(\"content\").style.height";
    NSString *strRet = [_mywebview stringByEvaluatingJavaScriptFromString:newContentHTML];
    NSLog(@"height:%@",strRet);
   
    int contentHeight = _mywebview.scrollView.contentSize.height;
    heightInterval = contentHeight - [strRet intValue];
    NSLog(@"heightinterval:%d",heightInterval);

    
    //NSString *newContentHTML = [NSString stringWithString:@"document.getElementById(\"content\").style.height='300px'"];
    //NSString *strRet = [_mywebview stringByEvaluatingJavaScriptFromString:newContentHTML];
    //NSLog(@"输入结果:%@",strRet);
    
    /*
    int size = [[_mywebview stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('fontSize')"] intValue];
    NSLog(@"FontSize:%d",size);
    //设置字体大小
    NSString *strFontSize = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.execCommand('fontSize',false,'6')"];
    NSLog(@"strFontSize:%@",strFontSize);
    */
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


//scrollview的代理 velocity为滚动速率 targetContentOffset为输入输出参数
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ( scrollView == _mywebview.scrollView ) {
        //CGPoint point1 = velocity;
        CGPoint point2 = *targetContentOffset;
        NSLog(@"targetContentoffset:[%.0f,%0.0f]",point2.x,point2.y);
        
        //同时滚动外部的scroll
        if ( point2.y > m_scrollview.contentSize.height - m_scrollview.frame.size.height )
            point2.y = m_scrollview.contentSize.height - m_scrollview.frame.size.height;
        point2.x = 0; //横向不滚动
        [m_scrollview setContentOffset:point2];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView     // called when scroll view grinds to a halt
{    

}


- (void)webViewhideKeyBoard
{
    [_mywebview stringByEvaluatingJavaScriptFromString:@"onReset()"];
    [_mywebview setUserInteractionEnabled:NO];
    [_mywebview setUserInteractionEnabled:YES];
}

//-----消息通知------------
#pragma mark Removing toolbar
- (void)keyboardWillHidden:(NSNotification *)note {
    
    NSLog(@"keyboardWillHidden");
    keyboardShowNum = 0;
    
    //重新显示工具栏
    //m_toolView.hidden = YES;
    m_btnToolShow.hidden = NO;
    bWebIsEdit = NO;  //非编辑状态
    
    //CGRect rect1 = _mywebview.frame;
    //if ( rect1.size.height < webviewheight - 1) {
    //}
}


//除去Web本身的Done按钮
- (void)keyboardWillShow:(NSNotification *)note {
    
    NSLog(@"keyboardWillShow");
    weboffset = _mywebview.scrollView.contentOffset; 
    m_contentSize = _mywebview.scrollView.contentSize;
    m_returnKeyNum = 0;
    keyboardShowNum++;
    
    //重新显示工具栏
    //m_toolView.hidden = NO;
    m_btnToolShow.hidden = YES;
    
    CGRect rect1 = _mywebview.frame;
    if ( ![m_tfTitleField isFirstResponder] && rect1.size.height > webviewheight-1) {
 
    }
        
    [self performSelector:@selector(removeBar) withObject:nil afterDelay:0];
    
}


- (void)removeBar {
    // Locate non-UIWindow.
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
  
    // Locate UIWebFormView.
    for (UIView *possibleFormView in [keyboardWindow subviews]) {       
        // iOS 5 sticks the UIWebFormView inside a UIPeripheralHostView.
        if ([[possibleFormView description] rangeOfString:@"UIPeripheralHostView"].location != NSNotFound) {
            for (UIView *subviewWhichIsPossibleFormView in [possibleFormView subviews]) {
                if ([[subviewWhichIsPossibleFormView description] rangeOfString:@"UIWebFormAccessory"].location != NSNotFound) {
                    //[subviewWhichIsPossibleFormView removeFromSuperview];
                    
                    //NSLog(@"toolview retaincount=%d",[m_toolView retainCount]);
                    [subviewWhichIsPossibleFormView addSubview:m_toolView];
                    //NSLog(@"toolview retaincount=%d",[m_toolView retainCount]);
                    bWebIsEdit = YES; //编辑状态
                    
                    //定位编辑位置
                    if ( keyboardShowNum == 1 ) {
                        [self performSelector:@selector(setEditPosition) withObject:nil afterDelay:0.5];
                    }
                }
            }
        }
    }
    
}

- (void) setEditPosition
{
    CGPoint contentOffset = _mywebview.scrollView.contentOffset;
    //CGSize contentSize = [_mywebview.scrollView contentSize];
    
    NSLog(@"setPosition:saveOffset=%@ nowOffset=%@",NSStringFromCGPoint(weboffset),NSStringFromCGPoint(contentOffset));
    
    if ( weboffset.y + touchpoint.y > LENGTH_SCROLL ) {
        contentOffset.y = weboffset.y + touchpoint.y - LENGTH_SCROLL;
        _mywebview.scrollView.contentOffset = contentOffset;
        NSLog(@"setPosition:touchpoint=%@ contentOffset=%@",NSStringFromCGPoint(touchpoint),NSStringFromCGPoint(contentOffset));
    }
    
    m_contentSize = _mywebview.scrollView.contentSize;
    
    //设置字体
    if ( !bSetFontSize ) {
        bSetFontSize = YES;
        
        NSString *strFont = @"4";
        if ( [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"NoteFontSizeIndex" value:strFont] ) 
        {
             NSLog(@"NoteFontSizeIndex:%@",strFont);
            int size = [strFont intValue];
            if ( size < 1 )  size = 1;
            else if ( size > 7 ) size = 7;
            NSString *js = [NSString stringWithFormat:@"document.execCommand('fontSize',false,'%d')",size];
            NSString *strFontSize = [_mywebview stringByEvaluatingJavaScriptFromString:js];
            NSLog(@"strFontSize:%@",strFontSize);
        }
    }
    
}


- (void)keyboardDidChangeFrame:(NSNotification *)note
{
    //textview的时候很准确，webview不准
    /*
    NSDictionary *dict = [note userInfo];
    NSLog(@"%@",dict);
    
    NSValue *keyframe1 = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyframe;
    [keyframe1 getValue:&keyframe];
    
    CGRect frame = m_toolView.frame;
    frame.origin.y = self.view.frame.size.height -frame.size.height - keyframe.size.height;
    m_toolView.frame = frame;
    */
}


//定时器执行的线程
- (void)checkSelection:(id)sender
{
    //static NSInteger s_heightoffset = 0;
    static CGSize s_contentSize = CGSizeZero;
    static CGPoint s_contentOffset = CGPointZero;
    static CGPoint s_contentOffset_last = CGPointZero;
    
    NSString *strBold = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.queryCommandState('Bold')"] ;
    NSString *strUnderline = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.queryCommandState('Underline')"];
    NSString *strItalic = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.queryCommandState('Italic')"];
    
    NSString *strHTML = @"document.getElementById(\"content\").style.height";
    NSString *strHeight = [_mywebview stringByEvaluatingJavaScriptFromString:strHTML];
    //NSLog(@"height:%@  %d",strHeight,[strHeight intValue]);
    
    //NSString *strFontSize = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.queryCommandValue('fontSize')"];
    //NSLog(@"FontSize:%@",strFontSize);
    
    BOOL boldEnabled = [strBold boolValue];
    BOOL underlineEnabled = [strUnderline boolValue];
    BOOL italicEnabled = [strItalic boolValue];
    
    
    if ( boldEnabled != bBold ) {
        bBold = boldEnabled;
        if ( boldEnabled ) 
            [m_btnToolBold setImage:imgBold2 forState:UIControlStateNormal];
        else 
            [m_btnToolBold setImage:imgBold1 forState:UIControlStateNormal];
    }
    if ( underlineEnabled != bUnderline )
    {
        bUnderline = underlineEnabled;
        if ( underlineEnabled )
            [m_btnToolUnderline setImage:imgUnderline2 forState:UIControlStateNormal];
        else
            [m_btnToolUnderline setImage:imgUnderline1 forState:UIControlStateNormal];
    }
    if ( italicEnabled != bItalic )
    {
        bItalic = italicEnabled;
        if ( italicEnabled )
            [m_btnToolItalic setImage:imgItalic2 forState:UIControlStateNormal];
        else
            [m_btnToolItalic setImage:imgItalic1 forState:UIControlStateNormal];
    }

    //取偏移高度
    /*
    NSString *str = [_mywebview stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    NSInteger offsetHeight = [str integerValue];
    if ( s_heightoffset != offsetHeight )
    {
        s_heightoffset = offsetHeight;
        NSLog(@"heightoffset=%d",s_heightoffset);
    }*/
    
    CGPoint contentOffset = _mywebview.scrollView.contentOffset;
     CGSize contentSize = [_mywebview.scrollView contentSize];
    
    if ( ABS(s_contentOffset.x - contentOffset.x ) > 0.5 || ABS(s_contentOffset.y - contentOffset.y)>0.5 )
    {
        NSLog(@"**contentSize=%@ contentOffset=%@",NSStringFromCGSize(contentSize),NSStringFromCGPoint(contentOffset));
        
        s_contentOffset_last = s_contentOffset;
        s_contentOffset = contentOffset;
        //weboffset = s_contentOffset_last;  //另外一种方法用
        //weboffset = contentOffset; 
    }
   
    if ( ABS(s_contentSize.width - contentSize.width) > 0.5 || ABS(s_contentSize.height != contentSize.height) > 0.5 )
    {
        NSLog(@"++contentSize=%@ contentOffset=%@",NSStringFromCGSize(contentSize),NSStringFromCGPoint(contentOffset));
        NSLog(@"content height:%@",strHeight);
        
        //CGPoint myPoint = [_mywebview.scrollView convertPoint:CGPointZero fromView:m_toolView];
        //NSLog(@"myPoint=%@",NSStringFromCGPoint(myPoint));
        
        /* --暂时屏蔽
        if ( contentSize.height > s_contentSize.height && bWebIsEdit) { //编辑状态
            contentOffset.y += contentSize.height - s_contentSize.height + 20;
            _mywebview.scrollView.contentOffset = contentOffset;
             NSLog(@"--set new contentOffset=%@",NSStringFromCGPoint(contentOffset));
        }*/
        
        s_contentSize = contentSize;
        
    }

    int height = [strHeight intValue];
    int contentheight = contentSize.height; 
    if ( contentheight - height > heightInterval + 1 ) {
        [self setWebViewHeight];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self->twNoteTypeList ) {
        UITableViewCell *noteTypeCell
        = (UITableViewCell*)[self->twNoteTypeList dequeueReusableCellWithIdentifier:@"cell"];
        
        if ( !noteTypeCell ) {
            noteTypeCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
        }
        noteTypeCell.textLabel.text = [self->arrayNoteTypeList objectAtIndex:indexPath.row];
        return noteTypeCell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( tableView == self->twNoteTypeList ) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self->twNoteTypeList && self.arrayNoteTypeList ) {
        return [self->arrayNoteTypeList count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( tableView == self->twNoteTypeList) {
        return @"栏目";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self->twNoteTypeList && indexPath.row < [self.arrayNoteTypeList count]) {
        self->nNoteTypeIndex = indexPath.row;
        self.strCurNoteType = [self.arrayNoteTypeList objectAtIndex:indexPath.row];
        self->labelNoteType.text  = self.strCurNoteType;
        self->vwNoteType.hidden = YES;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onToolHide:nil];
    return YES;
}

@end
