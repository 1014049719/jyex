//
//  UIFolderSetting.m
//  NoteBook
//
//  Created by zd on 13-2-21.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import "UIFolderSetting.h"
#import "PubFunction.h"
#import "UIImage+Scale.h"
#import "GlobalVar.h"
#import "BizLogic_Note.h"
#import "DbMngDataDef.h"

@implementation UIFolderSetting

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnBack);
    SAFEREMOVEANDFREE_OBJECT(m_btnFinish);
    SAFEREMOVEANDFREE_OBJECT(m_btnFolderIcon);
    SAFEREMOVEANDFREE_OBJECT(m_btnFolderColor);
    SAFEREMOVEANDFREE_OBJECT(m_btnLock);
    SAFEREMOVEANDFREE_OBJECT(m_btnTBWJJ);
    SAFEREMOVEANDFREE_OBJECT(m_viFolderIcon);
    SAFEREMOVEANDFREE_OBJECT(m_viFolderColor);
    SAFEREMOVEANDFREE_OBJECT(m_btnShareManage);
    SAFEREMOVEANDFREE_OBJECT(m_txfFolderTitle);
    
    SAFEFREE_OBJECT(m_FolderTitle);
    SAFEFREE_OBJECT(m_FolderID) ;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_FolderTitle = nil ;
        m_FolderID = nil ;
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
    
    TCateInfo *CateInfotemp = nil ;
    
    [m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-1.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanB-2.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [m_btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    /*
     UIImage *imgFirst = [UIImage imageNamed:@"BiaoGeKuang2.png"];
     UIImage *imgEnd = [UIImage imageNamed:@"BiaoGeKuang3.png"];*/
    UIImage *imgInter = [UIImage imageNamed:@"BiaoGeKuang1.png"];
    
    UIImage *imgInter2 = [UIImage imageNamed:@"BiaoGeKuang.png"];
    
    [m_btnFolderIcon setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnFolderIcon setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    
    [m_btnFolderColor setBackgroundImage:[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnFolderColor setBackgroundImage:[[imgInter stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    
    [m_btnShareManage setBackgroundImage:[imgInter2 stretchableImageWithLeftCapWidth:40 topCapHeight:20] forState:UIControlStateNormal];
    [m_btnShareManage setBackgroundImage:[[imgInter2 stretchableImageWithLeftCapWidth:40 topCapHeight:20] UpdateImageAlpha:0.6]forState:UIControlStateHighlighted];
    
    NSString *strNavTitle = [TheGlobal getNavTitle];
    float fNavBackBtnWidth = [PubFunction getNavBackButtonWidth:strNavTitle];
    CGRect rect = self->m_btnBack.frame;
    rect.size.width = fNavBackBtnWidth;
    self->m_btnBack.frame = rect;
    [self->m_btnBack setTitle:strNavTitle forState:UIControlStateNormal];
    
    CateInfotemp = [BizLogic getCate:m_FolderID];
    
    if(CateInfotemp != nil)
    {
        m_txfFolderTitle.text = CateInfotemp.strCatalogName ;
        m_FolderTitle = [[NSString alloc]initWithString:CateInfotemp.strCatalogName];
        NSString *iconName = nil;
        switch ( CateInfotemp.nCatalogIcon ) {
            case ICON_DEFAULT:
                iconName = @"btn_folder1.png";
                break;
            case ICON_WORK:
                iconName = @"btn_folder2.png";
                break;
            case ICON_TODOLIST:
                iconName = @"btn_folder3.png";
                break;
            case ICON_AFFLATUS:
                iconName = @"btn_folder4.png";
                break;
            case ICON_PERSONAL:
                iconName = @"btn_folder5.png";
                break;
            default:
                iconName = @"btn_folder5.png";
                break;
        }
        m_IconIndex = CateInfotemp.nCatalogIcon;
        UIImage *image = [UIImage imageNamed:iconName];
        m_viFolderIcon.image = image;
        NSString *imageName = nil;
        switch ( CateInfotemp.nCatalogColor ) {
            case COLOR_1:
                imageName = @"ChoseColor_Yellow.png";
                break;
            case COLOR_2:
                imageName = @"ChoseColor_Purple.png";
                break;
            case COLOR_3:
                imageName = @"ChoseColor-Blue.png";
                break;
            case COLOR_4:
                imageName = @"ChoseColor_TBule.png";
                break;
            case COLOR_5:
                imageName = @"ChoseColor_DBule.png";
                break;
            default:
                imageName = @"ChoseColor_Yellow.png";
                break;
        }
        m_ColorIndex = CateInfotemp.nCatalogColor;
        image = [UIImage imageNamed:imageName];
        m_viFolderColor.image = image;
        if(CateInfotemp.nEncryptFlag == 1)
        {  m_btnLock.selected = YES;  m_Lock = YES ; }
        else
        {  m_btnLock.selected = NO; m_Lock = NO ; }
        
        if(CateInfotemp.tHead.nNeedUpload == 0)  //0是需要上传
        {  m_btnTBWJJ.selected = YES ; m_TBWJJ = YES; }
        else
        {  m_btnTBWJJ.selected = NO ; m_TBWJJ = NO;}
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

-(IBAction)OnBack:(id)sender
{
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnFinish:(id)sender
{
    if([m_txfFolderTitle.text isEqualToString:@""])
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"请输入文件夹标题！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
        [alert release];
        return ;
    }
    
    TCateInfo *cateInfo = nil ;
    
    cateInfo = [BizLogic getCate:m_FolderID];
    
    cateInfo.strCatalogName = m_txfFolderTitle.text;
    cateInfo.nCatalogColor = m_ColorIndex ;
    cateInfo.nCatalogIcon = m_IconIndex ;
    if(m_Lock)
        cateInfo.nEncryptFlag = 1 ;
    else
        cateInfo.nEncryptFlag = 0 ;
    if(m_TBWJJ)
        cateInfo.tHead.nNeedUpload = 0 ;
    else
        cateInfo.tHead.nNeedUpload = 1 ;
    
    [BizLogic setCateWithCateInfo:cateInfo];
    
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

-(IBAction)OnFolderIcon:(id)sender
{
    if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    else if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    
    [PubFunction SendMessageToViewCenter:NMChoseFolderIcon :0 :1 :[MsgParam param:self :@selector(setFolderIcon:) :nil :0]];
}

-(IBAction)OnFolderColor:(id)sender
{
    if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    else if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    [PubFunction SendMessageToViewCenter:NMChoseFolderColor :0 :1 :[MsgParam param:self :@selector(setFolderColor:) :nil :0]];
}

//密码锁
-(IBAction)OnLock:(id)sender
{
    if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    else if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    m_btnLock.selected = !m_btnLock.selected ;
    m_Lock = m_btnLock.selected;
}

//同步此文件夹
-(IBAction)OnTBWJJ:(id)sender
{
    if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    else if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    m_btnTBWJJ.selected = !m_btnTBWJJ.selected ;
    m_TBWJJ = m_btnTBWJJ.selected;
}

//共享管理
-(IBAction)OnShareManage:(id)sender
{
      [PubFunction SendMessageToViewCenter:NMFolderPaiXu :0 :1 :nil];
}

-(void)setFolderID:(NSString *)FolderID
{
    if(m_FolderID != nil) [m_FolderID release];
    m_FolderID = [[NSString alloc] initWithString:FolderID];
}

-(void)setFolderIcon:(NSString *)strIndex 
{
    NSString *iconName = nil;
    int index = strIndex.intValue ;
    switch ( index ) {
        case ICON_DEFAULT:
            iconName = @"btn_folder1.png";
            break;
        case ICON_WORK:
            iconName = @"btn_folder2.png";
            break;
        case ICON_TODOLIST:
            iconName = @"btn_folder3.png";
            break;
        case ICON_AFFLATUS:
            iconName = @"btn_folder4.png";
            break;
        case ICON_PERSONAL:
            iconName = @"btn_folder5.png";
            break;
        default:
            iconName = @"btn_folder5.png";
            break;
    }
    m_viFolderIcon.image = [UIImage imageNamed:iconName];
    m_IconIndex = index ;
    
}

-(void)setFolderColor:(NSString *)strIndex 
{
    NSString *imageName = nil;
    int index = strIndex.intValue ;
    switch ( index ) {
        case COLOR_1:
            imageName = @"ChoseColor_Yellow.png";
            break;
        case COLOR_2:
            imageName = @"ChoseColor_Purple.png";
            break;
        case COLOR_3:
            imageName = @"ChoseColor-Blue.png";
            break;
        case COLOR_4:
            imageName = @"ChoseColor_TBule.png";
            break;
        case COLOR_5:
            imageName = @"ChoseColor_DBule.png";
            break;
        default:
            imageName = @"ChoseColor_Yellow.png";
            break;
    }
    m_viFolderColor.image = [UIImage imageNamed:imageName];
    m_ColorIndex = index ;
}

-(IBAction)OnBtnFullScreen:(id)sender
{
    if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    else if ([m_txfFolderTitle isFirstResponder]) {
        [m_txfFolderTitle resignFirstResponder];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	
	return YES;
}

@end
