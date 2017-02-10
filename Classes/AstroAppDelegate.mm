//
//  AstroAppDelegate.m
//  Weather
//
//  Created by nd on 11-5-24.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AstroAppDelegate.h"
//#import "WeatherViewController.h"
//#import "Business.h"
#import "PubFunction.h"
#import "DbConstDefine.h"
#import "UIAstroAlert.h"
#import "MessageConst.h"
#import "DataSync.h"
#import "CommonAll.h"

//---------------------add for  note-----
#import "CommonDirectory.h"
#import "PFunctions.h"
#import "Global.h"
#import "BizLogicAll.h"
//----------------------------------


//#import "FlurryAnalytics.h"
#import "GlobalVar.h"
#import "Global.h"
//#import "UIContentReview.h"

//91 NOTE
#import "NoteMainPage.h"

#import "FolderSetting.h"
#import "NoteLogin.h"
//#import "NoteRegister.h"
#import "NoteConfig.h"
#import "NoteInformation.h"
#import "NoteVersionHistory.h"
#import "UIFolder.h"
#import "UINoteEdit.h"
//#import "UINoteRead.h"
#import "UINoteSearch.h"
#import "UILastNote.h"
#import "SoftPassWord.h"
#import "UISelectFont.h"
#import "UINotePhotoQuality.h"
#import "About.h"
#import "UINoteMoreSoft.h"
#import "UIWeb.h"

//#import "iOSUtils.h"

#import "POAPinyin.h"
#import "Help.h"

#import "UINoteLabel.h"
#import "UIFolderManage.h"
#import "UINewFolder.h"
#import "SelectFolderIcon.h"
#import "SelectFolderColor.h"
#import "UIFolderSetting.h"
#import "UIFolderPaiXu.h"
#import "UIFilePaiXuSelect.h"


//===========================
//家园E线
#import "UIJYEXLogin.h"
#import "UIJYEXMainPage.h"
#import "UIJYEXMainPage2.h"

#import "UIJYEXGeneralApp.h"
#import "UIJYEXCZGS.h"
#import "JUEX_UISetting.h"
#import "UIPictureSender.h"
#import "jyexum_even_define.h"
#import "UIJYEXUpdatePassword.h"
#import "UIRegisterVC.h"
#import "UIJYEXSubPage.h"
#import "UIXCSelect.h"



#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@implementation AstroAppDelegate
@synthesize window;
@synthesize nav; 
@synthesize bussCheckVer;
@synthesize bussMng;
@synthesize bussUpdataSoft;
//@synthesize adController;


- (void)dealloc 
{
    //广告controller 2012.7.12
    //[adController.view removeFromSuperview];
    //self.adController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [reach stopNotifier];
    [reach release];
    
    if ( autoUpdataNoteTimer ) {
        [autoUpdataNoteTimer invalidate];
        autoUpdataNoteTimer = nil;
    }
	[GlobalParamCall Free];
	[GlobalVar ReleaseInstance];
    
	[bussCheckVer destroyBussReqObj];
	self.bussCheckVer = nil;
	self.nav = nil;
	self.window = nil;
    
    [super dealloc];
}


//lparam:用于表示是否动画. 0-NO； 1-YES
- (void)doFunc:(NSInteger)numMessageID :(NSInteger)wParam :(NSInteger)lParam :(id)obj
{
	BOOL bAnimateEnabled = (lParam == 1) ? YES : NO;
    switch (numMessageID) 
	{
        case NMNone:
			[nav  setViewControllers:nil animated:bAnimateEnabled]; 
            break;
        
        case NMBack:
			if (nav.viewControllers.count>1) 
			{
                [TheGlobal popNavTitle];
				if (wParam >= 2)
				{
					int idx = (nav.viewControllers.count > 2) ? (int)(nav.viewControllers.count-wParam-1) : 0;
					[nav popToViewController:[[nav viewControllers] objectAtIndex:idx] animated:bAnimateEnabled];
				}
				else
				{
					[nav popViewControllerAnimated:bAnimateEnabled];
				}
			}
            break;
			
		//case NMNavFuncHide:
			//navFunc.hidden = YES;
		//	break;
			
		//case NMNavFuncShow:
			//navFunc.hidden = NO;
			//break;
			
			
			//main window
		case NMHome:
		{
            
#ifdef VER_YEZZB
            int flag = 0;
            NSArray *arr = nav.viewControllers;
            for (UIViewController *vcc in arr ) {
                if ( [vcc isKindOfClass:[UIJYEXCZGS class]]) {
                    flag = 1;
                    break;
                }
            }
            if ( 1 == flag )  //已经存在
                break;
            
            //[FlurryAnalytics logEvent:@"成长故事"] ;
            [TheGlobal setNavTitle:@"成长故事"];
            UIJYEXCZGS *vc = [[UIJYEXCZGS alloc] initWithNibName:@"UIJYEXCZGS" bundle:nil];
            JYEXUserAppInfo *jyexAppInfo = (JYEXUserAppInfo*)obj;
            NSString *s = [jyexAppInfo.sAppCode uppercaseString];
            int i = 0;
            if( [s isEqualToString:@"YEZX"] )
                i = 1;
            [vc setAppType:i];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
            
#else
            int flag = 0;
            NSArray *arr = nav.viewControllers;
            for (UIViewController *vcc in arr ) {
                if ( [vcc isKindOfClass:[UIJYEXMainPage class]] ||
                     [vcc isKindOfClass:[UIJYEXMainPage2 class]]) {
                    flag = 1;
                    break;
                }
            }
            if ( 1 == flag )  //已经存在
                break;
            
            
            [TheGlobal setNavTitle:@"首页"];
			//[FlurryAnalytics logEvent:@"首页"];
            //UIJYEXMainPage  *vc = [[UIJYEXMainPage alloc] initWithNibName:@"UIJYEXMainPage" bundle:nil];
            UIJYEXMainPage2  *vc = [[UIJYEXMainPage2 alloc] initWithNibName:@"UIJYEXMainPage2" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
#endif
            

		}
            break;
//------------------------------家园E线----------------------------------
        case NMJYEXLogin:
        {
            //[FlurryAnalytics logEvent:@"登录"] ;
            [TheGlobal setNavTitle:@"登录"];
            BOOL b = NO;
            if ( obj ) {
                int i = [((NSNumber*)obj ) intValue];
                b = (i ? YES : NO);
            }
            UIJYEXLogin *vc = [[UIJYEXLogin alloc] initWithNibName:@"UIJYEXLogin" bundle:nil back:b];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
            
        case NMJYEXGeneralApp:
        {
            //[FlurryAnalytics logEvent:@"应用"] ;
            [TheGlobal setNavTitle:@"应用"];
            //BOOL back = (lParam == 1 ? YES : NO);
            UIJYEXGeneralApp *vc = [[UIJYEXGeneralApp alloc] initWithNibName:@"UIJYEXGeneralApp" bundle:nil];
            JYEXUserAppInfo *jyexAppInfo = (JYEXUserAppInfo*)obj;
            vc.appInfo = jyexAppInfo;
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];

        }
            break;
            
        case NMJYEXCZGS:
        {
            //[FlurryAnalytics logEvent:@"成长故事"] ;
            [TheGlobal setNavTitle:@"成长故事"];
            UIJYEXCZGS *vc = [[UIJYEXCZGS alloc] initWithNibName:@"UIJYEXCZGS" bundle:nil];
            JYEXUserAppInfo *jyexAppInfo = (JYEXUserAppInfo*)obj;
            NSString *s = [jyexAppInfo.sAppCode uppercaseString];
            int i = 0;
            if( [s isEqualToString:@"YEZX"] )
                i = 1;
            [vc setAppType:i];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];

        }
            break;
            
        case NMJYEXSubPage:
        {
            [TheGlobal setNavTitle:@"加载子页"];
            UIJYEXSubPage *vc = [[UIJYEXSubPage alloc] initWithNibName:@"UIJYEXSubPage" bundle:nil];
            vc.msgParam = obj;
            [nav pushViewController:vc animated:bAnimateEnabled] ;
            [vc release] ;
        }
            break;
            
        case NMJYEXSetting:
        {
#ifdef YOUMENG
            //[FlurryAnalytics logEvent:@"设置"] ;
            //记录友盟统计事件
            [MobClick beginEvent: UMEVENTID_PERSONSETTING] ;

#endif
            

            [TheGlobal setNavTitle:@"设置"];
            //BOOL back = (lParam == 1 ? YES : NO);
            JUEX_UISetting *vc = [[JUEX_UISetting alloc] initWithNibName:@"JUEX_UISetting" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
            [MobClick endEvent:UMEVENTID_PERSONSETTING] ;

        }
            break;
        case NMJYEXRegister:
        {
            [TheGlobal setNavTitle:@"注册帐号"];
            UIRegisterVC *vc = [[UIRegisterVC alloc] initWithNibName:@"UIRegisterVC" bundle:nil] ;
            MsgParam *Param = (MsgParam*)obj ;
            vc.callBackObject = Param.obsv ;
            vc.callBackSEL = Param.callback ;
            [nav pushViewController:vc animated:bAnimateEnabled] ;
            [vc release] ;
        }
            break ;
//------------------------------笔记的页面放在这里----------------------
        case NMNoteEdit:
        {
#ifdef YOUMENG
			//[FlurryAnalytics logEvent:@"笔记编辑"];
            //记录友盟统计事件
            [MobClick beginEvent: UMEVENTID_WRITELOG] ;

#endif
            
            [TheGlobal setNavTitle:@"笔记编辑"];
			UINoteEdit *vc = [[UINoteEdit alloc] initWithNibName:@"UINoteEdit" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
           	[vc release];
            [MobClick endEvent:UMEVENTID_WRITELOG] ;
        }
            break;
        
        /*
        case NMNoteRead:
        {
			//[FlurryAnalytics logEvent:@"笔记查看"];
            [TheGlobal setNavTitle:@"笔记查看"];
			UINoteRead *vc = [[UINoteRead alloc] initWithNibName:@"UINoteRead" bundle:nil];
            
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
            
        }
            break;
        */
            
        case NMJYEXUploadPic: //传照片
        {
#ifdef YOUMENG
            //记录友盟统计事件
            [MobClick event: UMEVENTID_SENDPICTURE] ;
#endif
            

            [TheGlobal setNavTitle:@"传照片"];
			UIPictureSender *vc = [[UIPictureSender alloc] initWithNibName:@"UIPictureSender" bundle:nil];
            vc.msgParam = obj;
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
            [MobClick endEvent:UMEVENTID_SENDPICTURE] ;
        }
            break;
            
        case NMJYEXSelectAlbum: //选择相册，新建相册
        {
            UIXCSelect *vc = [[UIXCSelect alloc] initWithNibName:@"UIXCSelect" bundle:nil];
            vc.msgParam = obj ;
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
            
            
 //------------------------------笔记的页面房子这里----------------------
	
        //add by zd begin
        /*
        case NMNoteRegister://注册91Note
        {
            [FlurryAnalytics logEvent:@"注册"] ;
            [TheGlobal setNavTitle:@"注册"];
            NoteRegister *vc = [[NoteRegister alloc] initWithNibName:@"NoteRegister" bundle:nil];
            vc.msgParam = obj;
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];			
        }
            break;
        */
        case NMNoteLogin:
        {
            //[FlurryAnalytics logEvent:@"登录"] ;
            [TheGlobal setNavTitle:@"登录"];
            NoteLogin *vc = [[NoteLogin alloc] initWithNibName:@"NoteLogin" bundle:nil ] ;
            vc.msgParam = obj;
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        
        /*
        case NMNoteVersionHistory://版本履历
        {
            //[FlurryAnalytics logEvent:@""] ;
            [TheGlobal setNavTitle:@"版本履历"];
            NoteVersionHistory *vc = [[NoteVersionHistory alloc] initWithNibName:@"NoteVersionHistory" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case NMAppHelp://帮助
        {
            //[FlurryAnalytics logEvent:@"帮助"] ;
            Help *vc = [[Help alloc] initWithNibName:@"Help" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        
        
        case NMNoteInfor://笔记信息
        {
            //[FlurryAnalytics logEvent:@"笔记信息"];
            [TheGlobal setNavTitle:@"笔记信息"];
            TNoteInfo *info = (TNoteInfo*)obj;
            //NoteInformation *vc = [[NoteInformation alloc] initWithNibName:@"NoteInformation" bundle:nil];
            NoteInformation *vc = [[NoteInformation alloc] initWithNibName:@"NoteInformation" bundle:nil NoteGuid:info];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case NMNoteLabel:
        {
            //[FlurryAnalytics logEvent:@"笔记标签"];
            [TheGlobal setNavTitle:@"笔记标签"];
            UINoteLabel *vc = [[UINoteLabel alloc] initWithNibName:@"UINoteLabel" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case NMFolderManage:
        {
            //[FlurryAnalytics logEvent:@"文件夹管理"];
            [TheGlobal setNavTitle:@"文件夹管理"];
            UIFolderManage *vc = [[UIFolderManage alloc] initWithNibName:@"UIFolderManage" bundle:nil];
            [vc setParentFolderID:[_GLOBAL getParentFolderID]];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case NMNewFolder:
        {
            //[FlurryAnalytics logEvent:@"新建文件夹"];
            [TheGlobal setNavTitle:@"新建文件夹"];
            UINewFolder *vc = [[UINewFolder alloc] initWithNibName:@"UINewFolder" bundle:nil];
            [vc setParentFolderID:[_GLOBAL getParentFolderID]];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case NMChoseFolderIcon:
        {
            //[FlurryAnalytics logEvent:@"文件夹图标选择"];
            [TheGlobal setNavTitle:@"文件夹图标选择"];
            SelectFolderIcon *vc = [[SelectFolderIcon alloc] initWithNibName:@"SelectFolderIcon" bundle:nil];
            vc.msgParam = obj ;
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case NMChoseFolderColor:
        {
            //[FlurryAnalytics logEvent:@"文件夹颜色选择"];
            [TheGlobal setNavTitle:@"文件夹颜色选择"];
            SelectFolderColor *vc = [[SelectFolderColor alloc] initWithNibName:@"SelectFolderColor" bundle:nil];
            vc.msgParam = obj;
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case NMFolderConfig:
        {
            //[FlurryAnalytics logEvent:@"文件夹设置"];
            [TheGlobal setNavTitle:@"文件夹设置"];
            UIFolderSetting *vc = [[UIFolderSetting alloc] initWithNibName:@"UIFolderSetting" bundle:nil];
            [vc setFolderID:[_GLOBAL getCurrentConfigFolderID]];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break;
        case  NMFolderPaiXu:
        {
            //[FlurryAnalytics logEvent:@"文件夹排序"];
            [TheGlobal setNavTitle:@"文件夹排序"];
            UIFolderPaiXu *vc = [[UIFolderPaiXu alloc] initWithNibName:@"UIFolderPaiXu" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break ;
        case NMFilePaiXuSelect:
        {
            //[FlurryAnalytics logEvent:@"文件排序选择"];
            [TheGlobal setNavTitle:@"文件排序选择"];
            UIFilePaiXuSelect *vc = [[UIFilePaiXuSelect alloc] initWithNibName:@"UIFilePaiXuSelect" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
            [vc release];
        }
            break ;
        //add by zd end
        */
            
        case NMNoteFolder:
        {
#ifdef YOUMENG
            //[FlurryAnalytics logEvent:@"文件夹"];
            //记录友盟统计事件
            [MobClick event: UMEVENTID_LOOKSENDBOX] ;

#endif
            
            [TheGlobal brushNavTitle];
			UIFolder *vc = [[UIFolder alloc] initWithNibName:@"UIFolder" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
            [MobClick endEvent:UMEVENTID_LOOKSENDBOX] ;
        }
            break;
            
        case NMJYEXUpdatePassword:
        {
#ifdef YOUMENG
            //[FlurryAnalytics logEvent:@"修改密码"];
            //记录友盟统计事件
            //[MobClick event: UMEVENTID_LOOKSENDBOX] ;
#endif
            
            [TheGlobal setNavTitle:@"修改密码"];
			UIJYEXUpdatePassword *vc = [[UIJYEXUpdatePassword alloc] initWithNibName:@"UIJYEXUpdatePassword" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
        }
            break;
            
        /*
        case NMNoteSearch:
        {
            //[FlurryAnalytics logEvent:@"搜索"];
            [TheGlobal setNavTitle:@"搜索"];
			UINoteSearch *vc = [[UINoteSearch alloc] initWithNibName:@"UINoteSearch" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];	 
        }
            break;
        case NMNoteLast:
        {
            //[FlurryAnalytics logEvent:@"最新笔记"];
            [TheGlobal setNavTitle:@"最新笔记"];
			UILastNote *vc = [[UILastNote alloc] initWithNibName:@"UILastNote" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];	
        }
            break;
        case NMNoteConfig:
        {
            //[FlurryAnalytics logEvent:@"设置"];
            [TheGlobal setNavTitle:@"设置"];
			NoteConfig *vc = [[NoteConfig alloc] initWithNibName:@"NoteConfig" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];	
        }
            break;
		case NMNoteSoftPwd:
        {
            //[FlurryAnalytics logEvent:@"密码保护"];
            [TheGlobal setNavTitle:@"密码保护"];
			SoftPassWord *vc
            = [[SoftPassWord alloc] initWithNibName:@"SoftPassWord" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];	
        }
            break;
            
        case NMNoteFont:
        {
            //[FlurryAnalytics logEvent:@"设置字体"];
            [TheGlobal setNavTitle:@"设置字体"];
			UISelectFont *vc
            = [[UISelectFont alloc] initWithNibName:@"UISelectFont" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
        }
            break;
        
        case NMNotePhotoQuality:
        {
            //[FlurryAnalytics logEvent:@"图片质量设置"];
            [TheGlobal setNavTitle:@"图片质量设置"];
			UINotePhotoQuality *vc
            = [[UINotePhotoQuality alloc] initWithNibName:@"UINotePhotoQuality" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
        }
            break;
            
        case NMNoteAbout:
        {
            //[FlurryAnalytics logEvent:@"关于"];
            [TheGlobal setNavTitle:@"关于"];
			About *vc
            = [[About alloc] initWithNibName:@"About" bundle:nil];
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
        }
            break;
        */
            
        case NMWebView:
        {
            //[FlurryAnalytics logEvent:@"页面查看"];
            [TheGlobal setNavTitle:@"页面查看"];
			UIWeb *vc = [[UIWeb alloc] initWithNibName:@"UIWeb" bundle:nil];
            vc.msgParam = obj;
            [nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
        }
            break;
        /*
        case NMSettingAbout:
			{
				[FlurryAnalytics logEvent:@"配置-关于"];
				UIVCSettingAbout *vc = [[UIVCSettingAbout alloc] initWithNibName:@"UIVCSettingAbout" bundle:nil];
				vc.msgParam = obj;
				[nav pushViewController:vc animated:bAnimateEnabled];
				[vc release];	 	
			}
            break;
         
        case NMSettingAdvice:
			{
				[FlurryAnalytics logEvent:@"配置-建议"];
				UIVCSettingAdvice *vc = [[UIVCSettingAdvice alloc] initWithNibName:@"UIVCSettingAdvice" bundle:nil];
				[nav pushViewController:vc animated:bAnimateEnabled];
				[vc release];	 	
			}
            break;
        */
        /*
        case NMAppInfo:
		{
            UINoteMoreSoft *vc = [[UINoteMoreSoft alloc] initWithNibName:@"UINoteMoreSoft" bundle:nil];
			[nav pushViewController:vc animated:bAnimateEnabled];
			[vc release];
            
		}
        */
			//通知启动版本检查线程
		case NMCheckVersion:
		{
			NSString* sVal = [AstroDBMng getSystemCfg:@"willcheckSoftVerAtStarting" Cond:@"" Default:@""];
			if ([sVal isEqualToString:@"YES"])
			{
				[NSThread detachNewThreadSelector:@selector(checkNewVerThread) toTarget:self withObject:nil]; 
				[self checkUpgradeTip];
			}

			[AstroDBMng setSystemCfg:@"willcheckSoftVerAtStarting" Cond:@"" Value:@"NO"];
		}
			break;
            
            
            

		default:
            break;
    }
	
}

// 处理系统在执行过程中以及用户操作过程中需要中心控制的信息
- (void) receiveSysMessage: (NSNotification *)note{
	
    NSInteger numMessageID;
    NSInteger wParam, lParam;
    id obj;
    
    numMessageID    = [[[note userInfo] objectForKey:CS_MSG_ID_4_WHICH_PAGE_WILL_BE_NAVIGATED] integerValue];
    wParam          = [[[note userInfo] objectForKey:CS_WPARAM_4_NAVIGATE_VIA_CENTER] integerValue];
    lParam          = [[[note userInfo] objectForKey:CS_LPARAM_4_NAVIGATE_VIA_CENTER] integerValue];
    obj             = [[note userInfo] objectForKey:CS_OPARAM_4_NAVIGATE_VIA_CENTER];
    
//	LOG_INFO(@"");
    //NSLog(@"numMessageID=%d wParam=%d lParam=%d", numMessageID, wParam, lParam);
	//[self showNavigationInfo];
    	//[self showNavigationInfo];
	[self doFunc:numMessageID :wParam :lParam :obj];	//lparam:用于表示是否动画. 0-NO； 1-YES
}  


- (void) _willEnterForeground {
	LOG_INFO(@"返回前台");
    
    //取一次新消息数
    if ( [TheCurUser isLogined] ) {
        [[DataSync instance] syncRequest:BIZ_SYNC_QUERYUPDATENUMBER :nil :nil :nil];
         //启动上传
        [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_JYEX_NOTE :nil :nil :nil];
    }
    
    //删除旧的笔记
    [NSThread detachNewThreadSelector:@selector(_DeleteOldNote) toTarget:nil withObject:nil];
    [BizLogic deleteOldNote];

    
	//[FlurryAnalytics logEvent:@"返回前台"];
	
    NSString *strDate = [CommonFunc getCurrentDate];
    NSString *strLastDate = [TheGlobal getUpdateDate];
    if (!strLastDate || ![strDate isEqualToString:strLastDate] ) {
        [NSThread detachNewThreadSelector:@selector(checkNewVerThread) toTarget:self withObject:nil];
    }
}

- (void) _DeleteOldNote
{
    [BizLogic deleteOldNote];
}


- (void) _willTerminate {
	LOG_INFO(@"退出...");
    
#ifdef YOUMENG
    [MobClick event: UMEVENTID_APPUSETIME] ;
#endif
    
	//[FlurryAnalytics logEvent:@"退出"];
	[self release];
	//[CityIntf free];
	[GlobalParamCall Free];
	[PubFunction freeLocStr];
    [POAPinyin clearCache];
	
//	LOG_INFO(@"退出OK");
//	LOG_INFO(@"==========Application Terminate=========="); 
	//if (listRefreshCity)
	//{
	//	[listRefreshCity release];
	//	listRefreshCity = nil;
	//}
}

- (void)checkNewVerThread
{ 
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	
	
    [bussUpdataSoft cancelBussRequest];
	self.bussUpdataSoft = [BussMng bussWithType:BMJYEXUpdataSoft];
	[bussUpdataSoft request:self :@selector(jyexSoftUpdata:) :nil];
	[pool release]; 
}

/*
-(void)onCheckVersionCallBack:(id)arg
{
	
	[bussCheckVer destroyBussReqObj];
	self.bussCheckVer = nil;

	if ([arg isKindOfClass:[NSError class]])
	{
		return;
	}
	
	TCheckVersionResult* verInfo = nil;
	if ( ![AstroDBMng getVerCheckResult:&verInfo] || !verInfo)
	{
		LOG_ERROR(@"检查新版本失败");
		return;
	}
	
	//LOG_DEBUG(@"版本检测：ver=%@ url=%@", verInfo.sVerCode, verInfo.sDownURL); 
	
	if ( [PubFunction stringIsNullOrEmpty:verInfo.sVerCode] || [PubFunction stringIsNullOrEmpty:verInfo.sDownURL])
	{
		return;
	}
	
	// 显示版本比较结果
	NSComparisonResult compareResult = [BussCheckVersion compareVersion:verInfo.sVerCode :CS_SOFTWARE_VERSION];
	if (compareResult == NSOrderedDescending)
	{
		NSString* sToday = [PubFunction getTodayStr];
		NSString* sLast = [AstroDBMng getSystemCfg:@"VerPromptDate" Cond:@"" Default:@""];
		
		NSDate* dateLastPrompt = [PubFunction convertString2NSDate:sLast :@"yyyy-MM-dd"];
		
		NSInteger today, tY, tM, tD;
		[PubFunction getToday:&tY :&tM :&tD];
		today = tY * 100 * 100 + tM * 100 + tD;
		
		NSInteger lastDate, lastY, lastM, lastD;
		[PubFunction decodeNSDate:dateLastPrompt :&lastY :&lastM :&lastD];
		lastDate = lastY * 100 * 100 + lastM * 100 + lastD;

		NSInteger diff = [PubFunction BetweenDays:lastDate :today];
		if (diff >= 7)
		{
			[self performSelectorOnMainThread:@selector(showNewVerPrompt:) withObject:verInfo waitUntilDone:YES];
			[AstroDBMng setSystemCfg:@"VerPromptDate" Cond:@"" Value:sToday];
		}
	}
	else 
	{
		//[self performSelectorOnMainThread:@selector(ShowStr:) withObject:@"当前版本已是最新版本！" waitUntilDone:NO];
	}
	
} 


- (void)showNewVerPrompt:(id)param
{
	TCheckVersionResult* verInfo = (TCheckVersionResult*)param;
	
	NSString* strPrompt = [NSString stringWithFormat:LOC_STR("fxxbb_fmt"), verInfo.sVerCode];
	int ShowStrAnswer = [UIAstroAlert askWait:strPrompt :[NSArray arrayWithObjects:LOC_STR("abt_az"),  @"取消", nil]];    
	if (ShowStrAnswer==0)
	{
        NSString *url = [PubFunction replaceStr:verInfo.sDownURL :@"itms://" :@"http://"];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	}
}
*/




-(void) checkUpgradeTip
{
// 暂时取消版本履历显示    
//	NSLog(@"%@", @"checkUpgradeTip");
//	//if (nav.topViewController)
//	{ 
//		if ([[Bussiness getInstance]checkUpgradeFlag])
//		{
//			UIVCUpgradeTip *vc = [UIVCUpgradeTip getInstance]; 
//			//[nav.topViewController.view addSubview: vc.view]; 
//			[window addSubview:vc.view];
//		} 		
//	}
}


//---------------------------------
#pragma -
#pragma push notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *tokenstring = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenstring = [tokenstring stringByReplacingOccurrencesOfString:@" " withString:@""];
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备。
    NSLog(@"My token is:%@", tokenstring);
    //MESSAGEBOX(tokenstring);
    [_GLOBAL setTokenString:tokenstring];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
    
    //MESSAGEBOX(error_str);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //在此处理接收到的消息。
    NSLog(@"Receive remote notification : %@  app state=%d",userInfo,[UIApplication sharedApplication].applicationState );
    
    
    NSString *str = [NSString stringWithFormat:@"收到通知消息:%@",userInfo];
    //MESSAGEBOX(str);
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *alert = @"收到新消息";
    if (aps ) alert = [aps objectForKey:@"alert"];
    //alert = [@"收到消息: " stringByAppendingString:alert];
    //[UIAstroAlert info:alert :5.0 :NO :LOC_MID :NO];
    
    
    NSString *url = [userInfo objectForKey:@"url"];
    if ( url ) {
        url = [CS_URL_BASE stringByAppendingString:url];
        [PubFunction SendMessageToViewCenter:NMJYEXSubPage :0 :1 :[MsgParam param:nil :nil :url :0]];
    }
    
    //NSNumber *value1 = [userInfo objectForKey:@"value1"];

    
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge>0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        badge = 0;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        //[UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
    
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //正处于前台，显示收到推送消息
        [UIAstroAlert info:alert :5.0 :NO :LOC_MID :NO];
    }
    
    
    /*
     NSString *strTemp = @"1";
     [AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"ConnectOnShare" value:strTemp];
     if ( [strTemp isEqualToString:@"0"] ) {
     }
     else {
     //发同步消息
     [[DataSync instance] syncRequest:BIZ_SYNC_AllCATALOG_NOTE :nil :nil :nil];
     }*/
}

//ios 8.0
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:NOTIFICATION_LOGIN_SUCCESS]) {
        
    }
    else if ([identifier isEqualToString:NOTIFICATION_NETSTATUS_CHANGE]) {
        
    }
    
    if ( completionHandler ) {
        completionHandler();
    }
}


//---------------------------------



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化友盟统计分析SDK
    //[MobClick setDelegate:self] ;
    /*
    [MobClick appLaunched] ; 
    该函数使应用程序每次只会在启动时会向服务器发送一次消息，在应用程序过程中产生的所有消息
    (包括自定义事件和本次使用时长)都会在下次启动的时候发送。如果应用程序启动时处在不联网状
    态，那么消息会缓存本地，下次再尝试发送。
    如果需要实时发送则使用:[MobClick setDelegate:self reportPolicy:REALTIME] ;
    reportPolicy参数可以选REALTIME或BATCH, 如需要实时发送每次事件统计，则填写REALTIME
    (使用建议：建议使用BATCH形式，减少App与网络的交互，为用户节省流量)
    */
    
#ifdef YOUMENG
    
    //appKey=53562f5956240b2f84007ae5为临时测试appkey.
    //正式AppKey[5359c5a256240b7fab0984b2]
    [MobClick appLaunched] ;
    
#ifdef YEZZB
    [MobClick startWithAppkey:@"535f559e56240b538e00efcf" reportPolicy:REALTIME channelId:@""] ;
#else
    [MobClick startWithAppkey:@"5359c5a256240b7fab0984b2" reportPolicy:REALTIME channelId:@""] ;
#endif
    
    //[MobClick appLaunched] ;
    //[MobClick setDelegate:self reportPolicy:REALTIME] ;
    //[MobClick setDelegate:self reportPolicy:BATCH] ;
    [MobClick setCrashReportEnabled:YES] ;
    //[MobClick setAppVersion:@"2.0.0"] ;
    [MobClick setLogEnabled:YES] ;
    [MobClick event: UMEVENTID_APPUSETIME ] ;
    [MobClick beginEvent: UMEVENTID_APPUSETIME] ;
    

    /*
     //获取设备ID,用于umeng登记测试机
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    */
    
#endif
    
    
    
    /*
    if ( IS_IPHONE_5 ) 
    {
        NSString *strResourcePath  = [[NSBundle mainBundle] resourcePath];
        NSString * strFile = [NSString stringWithFormat:@"%@/Default-568h.png", strResourcePath];
        UIImage *image = [UIImage imageWithContentsOfFile:strFile];
        imgView.image = image;
    }
    */
    
    
	LOG_INFO(@"==========Application Start=========="); 
	//[FlurryAnalytics startSession:@"ILBBBFLDP9FIKMYIBEM1"];  //要替换成note的，已替换
	//[FlurryAnalytics logEvent:@"启动"];
    
    //--------增加note iphone的初始化-------2012.11.9-----
    //检查缺省用户目录(guest)
    [CommonFunc checkUserDirectory:CS_DEFAULTACCOUNT_USERNAME];
    //检查配置文件NoteBookConfig.plist
    [PFunctions createConfigFile];
	//---------------------------------------------
    
    
	//本地化字符串加载
	[PubFunction initLocStr];
    //Calendar::InitCalendarLoc((int)IS_FT);
	
	//黄历查询用到的全局参数
	[GlobalParamCall Init]; 

	//全局变量初始化
	[[GlobalVar getInstance] initGlobalVar];
    
    //[AstroDBMng moveDbFile_1_1];
    //[CommonFunc moveDbFile_1_1];
    
	//打开公用数据库
	//[AstroDBMng loadDbCustom1];
	//[AstroDBMng loadDbCustom2];
	//[AstroDBMng loadDbCustom3];
	[AstroDBMng loadDbAstroCommon];
	
	//初始化当前帐号
	[[GlobalVar getInstance] initCurAccount];
    
    //当前账号处理: 数据目录（没有则创建），确认数据库文件（没有则创建）、打开数据库、创建表、创建缺省记录等。
    [BizLogic procCurAccount];
        
    
    //------------------------------------------------
    
     
    
	//监听事件
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSysMessage:) name:CS_MSG_NAVIGATE object:nil];
    
	//注册系统消息响应入口
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willTerminate) name:UIApplicationWillTerminateNotification object:nil];
	
	// On iOS 4.0+ only, listen for foreground notification	
	if(&UIApplicationWillEnterForegroundNotification != nil)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
	}	
	
    // 注意：您必须在这里替换您的app id 和 密匙,id 和 密匙可以从网站上获取。	
    //[AdPublisherConnect requestAdPublisherConnect:DTN_ASTRO_APPID SecretKey:DTN_ASTRO_KEY UserID:TheCurUser.sUserID];
	
    
    
    //消息推送注册----------
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeBadge|UIUserNotificationTypeAlert) categories:nil]];
        //[[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationType)(UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge)];
    }
    //// add for push notification end
    //--------------------
    
    
    
    //判断是否由远程消息通知触发应用程序启动
    //if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
    //获取应用程序消息通知标记数（即小红圈中的数字）
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge>0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        badge = 0;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        
        //NSString *strTemp = @"1";
        //[AstroDBMng getCfg_cfgMgr:@"CommonCfg" name:@"ConnectOnShare" value:strTemp];
        //if ( [strTemp isEqualToString:@"0"] ) {
        //}
        //else {
        //    if ( [DataSync isCanAutoLogin] ) {
        //        [self performSelector:@selector(sendLoginMsg) withObject:nil afterDelay:2.0];
        //    }
        //}
    }
    
    
	//初始化导航栏
	curPage = NMHome;
    //rootViewController *rootvc = [[rootViewController alloc] initWithNibName:@"rootViewController" bundle:nil];
    UINavigationController *nv  = [[UINavigationController alloc] initWithRootViewController:nil];
	self.nav = nv;
    self.window.rootViewController = nv;
	[nv release];
	nav.navigationBar.hidden = YES;
	[window addSubview:nav.view];	
    [window makeKeyAndVisible];
    
    
    if ( launchOptions ) {
        MESSAGEBOX(@"launchOptions has msg");
    }
	

	//升级数据库
	[NSThread detachNewThreadSelector:@selector(upgradeDatabase:) toTarget:self withObject:self]; 
    
    if ( autoUpdataNoteTimer ) {
        [autoUpdataNoteTimer invalidate];
        autoUpdataNoteTimer = nil;
    }
    autoUpdataNoteTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(AutoUpdataNote) userInfo:nil repeats:YES];
    
    
    //网络监测
    reach = [[Reachability reachabilityForInternetConnection] retain];
    NetworkStatus status = [reach currentReachabilityStatus];
    [[Global instance] setNetworkStatus:status];
    if ( status == kNotReachable)
        [UIAstroAlert info:@"网络不可用" :3.0 :NO :LOC_MID :NO];
    
    // start the notifier which will cause the reachability object to retain itself!
    [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(reachabilityChanged:)
                                        name:kReachabilityChangedNotification
                                        object:nil];
    [reach startNotifier];

	return YES;
}



-(void) upgradeDatabase:(id)appDelegate
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	
	//数据库升级
	[AstroDBMng updateDatabase];
	
	//升级后,继续界面线程
	[self performSelectorOnMainThread:@selector(autoLogin) withObject:appDelegate waitUntilDone:NO];
	
	[pool release];
}

-(void)autoLogin
{
    
    [bussMng cancelBussRequest];
    self.bussMng = [BussMng bussWithType:BMJYEXAutoLogin];
    [bussMng request:self :@selector(openMainWindow:) :nil];
}

-(void)openMainWindow:(TBussStatus*)sts
{
    [bussMng cancelBussRequest];
	self.bussMng = nil;
	
    [UIAstroAlert infoCancel];
    
    EnumOfNavigateMessage mainPage = NMJYEXLogin;
    if ( sts && sts.sInfo) {
        if ( [sts.sInfo isEqualToString:@"login_false"] ) {
            //[UIAstroAlert info:@"密码错误,请检查您的密码!" :2.0 :NO :LOC_MID :NO];
        }
        else if( [sts.sInfo isEqualToString:@"no_user"] )
        {
            //[UIAstroAlert info:@"用户名不存在,请检查您的用户名!" :2.0 :NO :LOC_MID :NO];
        }
        else if( [sts.sInfo isEqualToString:@"login_success"] )
        {
            mainPage = NMHome;
        }
    }
    else if(sts==nil || sts.iCode == 200)
    {
        mainPage = NMHome;
    }
    
    JYEXUserAppInfo *ylzzb = nil;
    
    /*
#ifdef VER_YEZZB
    if ( mainPage == NMHome ) {
        NSArray *arr = [BizLogic getAppListByUserName:TheCurUser.sUserName AppType:USER_APP_TYPE_BOUGHT];
        for (JYEXUserAppInfo *app in arr ) {
            if( [app.sAppCode isEqualToString:LM_YEZZB] ) {
                ylzzb = app;
                break;
            }
        }
        if ( !ylzzb )
            mainPage = NMJYEXLogin;
    }
#endif
    */

	//打开主界面
    [self doFunc:mainPage :0 :0 :ylzzb];


	//设置启动检查新版本标识
	[AstroDBMng setSystemCfg:@"willcheckSoftVerAtStarting" Cond:@"" Value:@"YES"];
	[NSThread detachNewThreadSelector:@selector(checkNewVerThread) toTarget:self withObject:nil]; 
    //[self checkUpgradeTip];
}




//定时期每隔30秒就调度一次
-(void) AutoUpdataNote
{
    static int s_i  = -1;
    if ([[Global instance] getNetworkStatus] == NotReachable
        || ([TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME]
            || !TheCurUser.isLogined ))
    {
        s_i = 0;
    }
    else if( [[Global instance] getNetworkStatus] != NotReachable ){
        if ( s_i == -1 || s_i == 0 ) {
            s_i = 1;
            [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_JYEX_NOTE :nil :nil :nil];
        }
    }
}




-(void) jyexSoftUpdata:(TBussStatus*)sts
{
    [bussUpdataSoft cancelBussRequest];
	self.bussUpdataSoft = nil;
    [self performSelectorOnMainThread:@selector(showSoftUpdata) withObject:nil waitUntilDone:YES];
}

-(void) showSoftUpdata
{
    if ( [TheGlobal getUpdataSoftFlag] ) {
        UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:nil message:@"现已检测到有新的版本,需要立即升级吗?" delegate:self cancelButtonTitle:@"下次" otherButtonTitles:@"升级",nil];
        [alertview show];
        [alertview release]; 
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [TheGlobal resetUpdataSoftFlag];
    if ( buttonIndex == 0 ) { //取消
    }
    else { //放弃, 返回
        NSLog(@"%@", TheGlobal.sUpdataSoftUrl);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TheGlobal.sUpdataSoftUrl]]; 
    }
}



//网络变化通知
- (void) reachabilityChanged: (NSNotification*)note {
    Reachability * r = [note object];
    
    NSString *text;
    NetworkStatus status;
    
    if(![r isReachable]) {
        status = NotReachable;
        text = @"网络不可用";
    }
    else {
        text = @"网络可用";
    
        if (reach.isReachableViaWiFi) {
            status = ReachableViaWiFi;
        }
        else {
            status = ReachableViaWWAN;
        }
    }
    
    [[Global instance] setNetworkStatus:status];
    [UIAstroAlert info:text :2.0 :NO :0 :NO];
    
    if ( status != NotReachable ) { //启动上传
        [[DataSync instance] syncRequest:BIZ_SYNC_UPLOAD_JYEX_NOTE :nil :nil :nil];
    }
}

//*****************************************************************************************
//友盟SDK MobClickDelegate
//appKey:53562f5956240b2f84007ae5为开发测试用的，正式发布的时候需要申请一个正式的帐号并再该帐号下创建
//一个应用，使用该应用的appKey。
- (NSString*)appKey
{
    //5359c5a256240b7fab0984b2[正式AppKey]
    return @"5359c5a256240b7fab0984b2" ;
}

//*****************************************************************************************
@end
