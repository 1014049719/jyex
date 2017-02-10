//
//  NetConstDefine.h
//  SparkEnglish
//  定义网络相关常量
//  Created by huanghb on 11-1-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark 设置参数


////////////全局常量///////////


//#define CS_URL_BASE				@"http://app.jy1x.com:9527/"
//#define CS_OUTER_URL_BASE		@"http://app.jy1x.com:9527/"

//#define CS_URL_BASE				@"http://192.168.6.127:881/"
//#define CS_OUTER_URL_BASE		@"http://192.168.6.127:881/"
//#define CS_URL_BASE				@"http://180.139.136.202:883/"
//#define CS_OUTER_URL_BASE		@"http://180.139.136.202:883/"
#define CS_URL_BASE				@"http://117.141.115.68:883/"
#define CS_OUTER_URL_BASE		@"http://117.141.115.68:883/"

//#define CS_URL_BASE				@"http://192.168.168.88/"
//#define CS_OUTER_URL_BASE		@"http://192.168.168.88/"


//#define CS_URL_BASE				@"http://www.jyex.cn/"
//#define CS_OUTER_URL_BASE		@"http://www.jyex.cn/"

//#define CS_URL_BASE				@"http://www.jyex.cn:881/"
//#define CS_OUTER_URL_BASE		@"http://www.jyex.cn:881/"


//#define CS_URL_BASE				@"http://180.139.136.202:880/"
//#define CS_OUTER_URL_BASE		@"http://180.139.136.202:880/"

//#define CS_URL_BASE				@"http://61.144.88.98:6805/"
//#define CS_OUTER_URL_BASE		@"http://61.144.88.98:6805/"

//#define CS_URL_BASE				@"http://kk.jy1x.com:6805/"
//#define CS_OUTER_URL_BASE		@"http://kk.jy1x.com:6805/"

//#define CS_URL_BASE				@"http://192.168.6.106:81/"
//#define CS_OUTER_URL_BASE		@"http://192.168.6.106:81/"

//#define CS_URL_BASE				@"http://180.139.136.202:881/"
//#define CS_OUTER_URL_BASE		@"http://180.139.136.202:881/"


//Apple ID(苹果商店id)
#ifdef VER_YEZZB
#define APPLE_ID     @"871044881"
#define JYEX_APPID @"2000"

#else
#define APPLE_ID     @"672633361"
#define JYEX_APPID @"1000"

#endif

#define JYEX_APPSROUCE @"App Store"


#ifndef PRODUCT
#define PRODUCT   @"家园e线"
#endif


#ifndef TARGETOS
#define TARGETOS   @"iPhone"
#endif

// 软件标识
#define CS_SOFT_ID      @"81"

#ifndef XUANSHANG_ID
#define XUANSHANG_ID   @"4002"
#endif

#ifndef VERSION
#define VERSION     1
#endif

//应用程序ID(充值用)
//#define     APP_ID		105222
//#define		APP_KEY		@"d7e963d89bf51e201a6ef9d6852a1a3bbc314a9f5e4aa6b0"

//果合广告ID
//#define  GHAD_ID  @"f773b3c43174dbdce4dddce8631cb32f"
//#define  GHAD_ID  @"c6ab500fdc528ae881512af99a04c7ed"
#define  GHAD_ID  @"dd0f0d0e06265a393ff83536ba14e8b4"

#define  DTN_ASTRO_APPID @"ea6c839e-78b4-4786-aeaa-e093f6fec8a8"
#define  DTN_ASTRO_KEY   @"yshhrfrlnrun"

//#define  GHAD_ID @"f773b3c43174dbdce4dddce8631cb32f"


//------------------
//服务端
//班级空间
#define PATH_HOMEPAGE_CLASS @"mobile.php?mod=space&ac=intoclass&version=new&offline=1"
#define URL_HOMEPAGE_CLASS [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_CLASS]

//成长每一天
#define PATH_HOMEPAGE_GROWING_TEACHER \
@"mh.php?mod=workbench_jiaoshi&ac=czmyt_index&nav_arr=czmyt_index&in_mobile=1&offline=1"
#define PATH_HOMEPAGE_GROWING_PARENT @"mh.php?mod=workbench_jiazhang&ac=czmyt_menu&in_mobile=1&offline=1"
#define PATH_HOMEPAGE_GROWING_MASTER @"mh.php?mod=workbench_school&ac=czmyt_menu&nav_arr=jkda&in_mobile=1&offline=1"
#define URL_HOMEPAGE_GROWING_TEACHER [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_GROWING_TEACHER]
#define URL_HOMEPAGE_GROWING_PARENT [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_GROWING_PARENT]
#define URL_HOMEPAGE_GROWING_MASTER [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_GROWING_MASTER]

//家园直通车
#define PATH_HOMEPAGE_JIAYUAN_TEACHER \
@"mh.php?mod=workbench_jiaoshi&ac=jyztc_index&nav_arr=jyztc_index&in_mobile=1&offline=1"
#define PATH_HOMEPAGE_JIAYUAN_PARENT @"mh.php?mod=workbench_jiazhang&ac=jzztc_menu&offline=1"
#define PATH_HOMEPAGE_JIAYUAN_MASTER @"mh.php?mod=workbench_school&ac=ywztc_menu&offline=1"
#define URL_HOMEPAGE_JIAYUAN_TEACHER [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_JIAYUAN_TEACHER]
#define URL_HOMEPAGE_JIAYUAN_PARENT [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_JIAYUAN_PARENT]
#define URL_HOMEPAGE_JIAYUAN_MASTER [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_JIAYUAN_MASTER]

//育儿掌中宝
#define PATH_HOMEPAGE_YUER @"mobile.php?mod=czgs&ac=list&jyex_mobile=1"
#define URL_HOMEPAGE_YUER [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_YUER]

//个人空间
#define PATH_HOMEPAGE_PERSON @"mobile.php?mod=space&ac=person_class&offline=1"
#define URL_HOMEPAGE_PERSON [CS_URL_BASE stringByAppendingString:PATH_HOMEPAGE_PERSON]
//---


//成长每一天：
//设置学生卡状态
#define PATH_SZXSKZT @"mobile.php?mod=space&ac=gotoszxskzt"
#define URL_SZXSKZT [CS_URL_BASE stringByAppendingString:PATH_SZXSKZT]

//写留言寄语
#define PATH_XLYJY @"mh.php?mod=workbench_jiaoshi&ac=lyjy&nav_arr=lyjy&show_method=lyjy_index_adds&in_mobile=1"
#define URL_XLYJY [CS_URL_BASE stringByAppendingString:PATH_XLYJY]

//家园直通车：
//老师发意见征询
#define PATH_FYJZX_TEACHER @"mobile.php?mod=space&ac=gotofyjzx"
#define URL_FYJZX_TEACHER [CS_URL_BASE stringByAppendingString:PATH_FYJZX_TEACHER]

//园长：
//园长发意见征询
#define PATH_FYJZX_MASTER @"mh.php?mod=workbench_school&ac=yjzx&nav_arr=ywztc&op=add&in_mobile=1&fid=46&special=1"
#define URL_FYJZX_MASTER [CS_URL_BASE stringByAppendingString:PATH_FYJZX_MASTER]

//园长发每周食谱
#define PATH_FMZSP @"mh.php?mod=workbench_school&ac=mzsp&ac2=mod&nav_arr=ywztc&in_mobile=1"
#define URL_FMZSP [CS_URL_BASE stringByAppendingString:PATH_FMZSP]

//家长
//发请假
#define PATH_FQJ @"mh.php?mod=workbench_jiazhang&ac=qj&ac2=mod&nav_arr=jzztc&in_mobile=1"
#define URL_FQJ [CS_URL_BASE stringByAppendingString:PATH_FQJ]

//发事件提醒
#define PATH_FSJTX @"mh.php?mod=workbench_jiazhang&ac=sjtx&ac2=mod&nav_arr=jzztc&in_mobile=1"
#define URL_FSJTX [CS_URL_BASE stringByAppendingString:PATH_FSJTX]

//发园长信箱
#define PATH_FYZXX @"mh.php?mod=workbench_jiazhang&ac=yzxx&ac2=mod&nav_arr=jzztc&in_mobile=1"
#define URL_FYZXX [CS_URL_BASE stringByAppendingString:PATH_FYZXX]

//帮助
#define PATH_HELP @"mobile.php?mod=space&ac=help"
#define URL_HELP [CS_URL_BASE stringByAppendingString:PATH_HELP]


//本地主页(班级空间、成长每一天、家园直通车、育儿掌中宝、个人空间)
#define FILENAME_HOMEPAGE_CLASS @"homepage1.html"
#define FILENAME_HOMEPAGE_GROWING @"homepage2.html"
#define FILENAME_HOMEPAGE_JIAYUAN @"homepage3.html"
#define FILENAME_HOMEPAGE_YUER @"homepage4.html"
#define FILENAME_HOMEPAGE_PERSON @"homepage5.html"

#define FILE_LOCAL_CLASS [[CommonFunc getTempDir] stringByAppendingPathComponent:FILENAME_HOMEPAGE_CLASS]
#define FILE_LOCAL_GROWING [[CommonFunc getTempDir] stringByAppendingPathComponent:FILENAME_HOMEPAGE_GROWING]
#define FILE_LOCAL_JIAYUAN [[CommonFunc getTempDir] stringByAppendingPathComponent:FILENAME_HOMEPAGE_JIAYUAN]
#define FILE_LOCAL_YUER [[CommonFunc getTempDir] stringByAppendingPathComponent:FILENAME_HOMEPAGE_YUER]
#define FILE_LOCAL_PERSON [[CommonFunc getTempDir] stringByAppendingPathComponent:FILENAME_HOMEPAGE_PERSON]

//本地动作
#define ACT_WriteArticle @"ACT_WriteArticle"
#define ACT_SendPhoto    @"ACT_SendPhoto"
#define ACT_Setting      @"ACT_Setting"
#define ACT_NewAlbum     @"ACT_NewAlbum"
#define ACT_LOGIN        @"ACT_LOGIN"
//------------------




#define CS_INNER_URL_BASE		@"http://192.168.9.128:8080/divine/"
#define CS_URL_DOWNLOAD_BASE    @"itms-services://?action=download-manifest&url=http://api.ad.rj.91.com/uploadversion/plist/"

// 提交建议相关参数
#define CS_URL_LOGIN			@"loginByPhone"
#define CS_URL_SUGGEST			@"suggestanswer"

//默认登录帐号名、密码
#define CS_DEFAULTACCOUNT_USERNAME		@"guest"
#define CS_DEFAULTACCOUNT_PASSWORD		@"geust"

// 用户注册
#define CS_REG_URLBASE_IN			@"http://192.168.94.19/uaps/"
#define CS_REG_URLBASE_OUT			@"http://uap.91.com/"

// session 验证
#define CS_CHECKSESSION_URLBASE_IN		@"https://192.168.94.19/uaps/"
#define CS_CHECKSESSION_URLBASE_OUT		@"https://uap.91.com/"

// 取版本号
#define CS_URL_VER		@"getverinfo"

// 悬赏&建议
#define CS_ADVICE_BASE_URL     @"http://sm.91.com/apps/index.php/xs/"
#define CS_ADVICE_FUNC_SEND    @"sendsuggest"
#define CS_ADVICE_FUNC_GET     @"getanswer"

//微博
//#define CS_URL_UPDATE_APPINFO                                     @"http://api.ad.rj.91.com/uploadversoin"
#define CS_URL_UPDATE_APPINFO                                     @"http://api.ad.rj.91.com/uploadversion"
#define CS_URL_UPDATE_SKININFO                                    @"http://api.divine.rj.91.com/getPhoneBkList"
#define CS_URL_BLOG_BASE                                          @"http://share.oap.91.com/share/index.php/"
#define CS_URL_BLOG_BIND                                          @"http://share.oap.91.com/share/bind.php"

#define CS_BLOG_APPID                                             @"3"
#define CS_BLOG_APPSECRET                                         @"DCA1DE6E2781440e8E4D03BBF4E5F8A4"
#define CS_BLOG_BIND_SUCCESS_PATH                                 @"/share/oauthsuccess.php"

// 登陆
#define CS_URL_BLOG_LOGIN                                         @"login"
// 查询绑定
#define CS_URL_BLOG_QUERYBIND                                     @"querybind"
//取消绑定
#define CS_URL_BLOG_UNBIND                                        @"unbind"
// 分享文字
#define CS_URL_BLOG_SHARETEXT                                     @"sharetext"
// 分享文字 + 图片
#define CS_URL_BLOG_SHAREIMAGE                                    @"shareimage"
// 退出
#define CS_URL_BLOG_LOGOUT                                        @"logout"
// 查询分享类型
#define CS_URL_BLOG_QUERYSUPPORTS                                 @"querysupports"



#pragma mark -
#pragma mark HTTP请求方法
enum EHttpMethod
{
	HTTP_METHOD_NULL = 0,
	HTTP_METHOD_GET,	//”GET“
	HTTP_METHOD_POST,	//”POST“
	HTTP_METHOD_PUT		//”PUT“
};


// 登录成功后，发出的通知消息
//#define NOTIFICATION_LOGIN_SUCCESS @"Notification_Login_Success"

//网络状态发生变化后，发出的通知消息（目前是变成正常时发送）
#define NOTIFICATION_NETSTATUS_CHANGE @"Notification_NetStatus_Change"



