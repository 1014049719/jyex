//
//  BussMng.m
//  Astro
//
//  Created by liuyfmac on 11-12-22.
//  Copyright 2011 洋基科技. All rights reserved.
//

#import "BussMng.h" 

#import "NSObject+SBJson.h"

#import "CommonAll.h"
#import "PubFunction.h"
#import "DBMngAll.h"
#import "GlobalVar.h"
//#import "UIUserLogin.h"
#import "Calendar.h"



@implementation BussMng
@synthesize imp;
@synthesize param;

+ (BussMng*) bussWithType :(int)type
{
	BussMng* mng = [[BussMng new] autorelease];
	mng->type = type;
	LOG_DEBUG(@"BussMng对象创建:%@", mng);
	return mng;
}

+ (id) loadWithType:(int)type
{
	id data = nil;
	switch (type)
	{
            /*
		case BMZTQ:
		{
			TWeekdayWeather_Ext* ww = [[TWeekdayWeather_Ext new]autorelease];
			
//			NSArray* aryCity = [AstroDBMng getAllCityByOrder];
//			TCityWeather* city = (aryCity && [aryCity count]>0) ? [aryCity objectAtIndex:0] : nil;
//			NSString* cityCode = city ? city.sCityCode : @"101010100";
//			if ([PubFunction stringIsNullOrEmpty:cityCode])
//			{
//				cityCode = @"101010100";
//			}
			
			
			NSString* cityCode = [AstroDBMng getDefaultCityCode];
			if ([PubFunction stringIsNullOrEmpty:cityCode])
				break;
			
			if (![AstroDBMng getWkWeather:cityCode OutData:ww])
				break;
			
			if( ![PubFunction stringIsNullOrEmpty:ww.sDataTime] && ww.wkWeather != nil ) 
			{
				data = ww;
			}
		}
			break;
            */
			
	
		case BMMZFX:
		{
			TNT_PLATE_INFO* plate = [[TNT_PLATE_INFO new] autorelease];
			if (![AstroDBMng getNameParsePlate:TheCurPeople.sGuid OutData:plate])
				break;
			
			TNT_EXPLAIN_INFO* explain = [[TNT_EXPLAIN_INFO new] autorelease];
			if (![AstroDBMng getNameParseExplain:TheCurPeople.sGuid OutData:explain])
				break;
			
			TMZFX_FREE* mzfx = [[TMZFX_FREE new] autorelease];
			mzfx.plate = plate;
			mzfx.explain = explain;
			data = mzfx;
		}
			break;
			
		
		case BMMZCS:
		{
			TNameYxTestInfo* info = [[TNameYxTestInfo new] autorelease];
			TNameYxParam* param = [[TNameYxParam new] autorelease];
			
			param.pepName = [TPEP_NAME  pepnameFromString:TheCurPeople.sPersonName];
			param.sSex = TheCurPeople.sSex;
			param.sConsumeItem = @"all";
			
			if (![AstroDBMng getNameTest:TheCurPeople.sGuid Name:param OutData:info])
				break;
			
			data = info;
		}
			break;
			
		case BMRG:
		{
			TNatureResult* info = [[TNatureResult new] autorelease];
			if (![AstroDBMng getPeopleCharacter:TheCurPeople.sGuid OutData:info])
				break;
			
			data = info;
		}
			break;
			
			
		case BMAQTH:
		{
			TLoveTaoHuaResult* info =[[TLoveTaoHuaResult new] autorelease];
			if (![AstroDBMng getLoveFlower:TheCurPeople.sGuid OutData:info])
				break;
			
			data = info;
		}
			break;
			
		default:
			break;
	}
	
	return data;
}

+ (id) loadWithType:(int)type :(id)p
{    
	id data = nil;
	switch (type)
	{
		case BMZWYS_DAY:
		{
			TZWYS_FLOWYEAR_EXT* zwys = [[TZWYS_FLOWYEAR_EXT new] autorelease];
			if ([TheCurPeople isDemo])
			{
				if (![AstroDBMng getDemoZwYsDay:TheCurPeople.sGuid YS:zwys])
					break;
			}
			else
			{
				if (![AstroDBMng getZwYs_Day:TheCurPeople.sGuid Date:(TDateInfo*)p YS:zwys])
					break;
			}
			
			
			data = zwys;
		}
			break;
			
		case BMZWYS_MONTH:
		{
			
			TZWYS_FLOWYEAR_EXT* zwys = [[TZWYS_FLOWYEAR_EXT new] autorelease];
			if ([TheCurPeople isDemo])
			{
				if (![AstroDBMng getDemoZwYsMonth:TheCurPeople.sGuid YS:zwys])
					break;
			}
			else
			{
				if (![AstroDBMng getZwYs_Month:TheCurPeople.sGuid Date:(TDateInfo*)p YS:zwys])
					break;
			}
			
			data = zwys;
		}
			break;
			
			
		case BMZWYS_YEAR:
		{
			TZWYS_FLOWYEAR_EXT* zwys = [[TZWYS_FLOWYEAR_EXT new] autorelease];
			if ([TheCurPeople isDemo])
			{
				if (![AstroDBMng getDemoZwYsYear:TheCurPeople.sGuid YS:zwys])
					break;
			}
			else
			{
				if (![AstroDBMng getZwYs_Year:TheCurPeople.sGuid Date:(TDateInfo*)p YS:zwys])
					break;
			}
			
			data = zwys;
		}
			break;
		
        case BMMONEYFORTUNE:
        {
			TLYSM_MONEYFORTUNE_EXT* zwys = [[TLYSM_MONEYFORTUNE_EXT new] autorelease];
			if ([TheCurPeople isDemo])
			{
				if (![AstroDBMng getDemoLYSMMoney:TheCurPeople.sGuid YS:zwys])
					break;
			}
			else
			{
				if (![AstroDBMng getLYSMMoney:TheCurPeople.sGuid Date:(TDateInfo*)p YS:zwys])
					break;
			}
			
			data = zwys;
		}
            break;
            
		case BMPP:
		{
			TNAME_PD_RESULT* ppResult = [[TNAME_PD_RESULT new] autorelease];
			TParamNameMatch* pm = (TParamNameMatch*)p;
			if (![AstroDBMng getNameMatch:TheCurPeople.sGuid Name:(TNAME_PD_PARAM*)pm.pd OutData:ppResult])
				break;
			
			data = ppResult;
		}
			break;
			
		case BMLRYS:
		{
			TFlowYS* lrys = [[TFlowYS new] autorelease];
			if ([TheCurPeople isDemo])
			{
				if (![AstroDBMng getDemoFlowYSDay:TheCurPeople.sGuid YS:lrys])
					break;
			}
			else
			{
				TDateInfo* dt = (TDateInfo*)p;
				if (![AstroDBMng getFlowYS:TheCurPeople.sGuid YsType:EYunshiTypeLiuri Date:dt YS:lrys])
					break;
			}
			
			data = lrys;
		}
			break;
			
		case BMLYYS:
		{
			TFlowYS* lrys = [[TFlowYS new] autorelease];
			if ([TheCurPeople isDemo])
			{
				if (![AstroDBMng getDemoFlowYSMonth:TheCurPeople.sGuid YS:lrys])
					break;
			}
			else
			{
				TDateInfo* dt = (TDateInfo*)p;
				if (![AstroDBMng getFlowYS:TheCurPeople.sGuid YsType:EYunshiTypeLiuyue Date:dt YS:lrys])
					break;
			}
			
			data = lrys;
		}
			break;
			
        //add 2012.8.16 事业成长
        case BMSYYS:
		{
			TSYYS_EXT* syys = [[TSYYS_EXT new] autorelease];
			if ([TheCurPeople isDemo])
			{
				if (![AstroDBMng getDemoYsCareer:TheCurPeople.sGuid YS:syys])
					break;
			}
			else
			{
				if (![AstroDBMng getYs_Career:TheCurPeople.sGuid Date:(TDateInfo*)p YS:syys])
					break;
			}
			
			data = syys;
		}
			break;    
			
		default:
			break;
	}
			
	return data;
}

-(void)dealloc
{
    LOG_DEBUG(@"BussMng对象dealloc:%@", self);
    
	[self cancelBussRequest];
	
	[super dealloc];
}

-(void)cancelBussRequest
{
	//LOG_DEBUG(@"BussMng对象释放: %@", self);
	//LOG_DEBUG(@"BussMng对象释放--imp: %@", imp);
	
	if (imp)
	{
		BussInterImplBase* buss = (BussInterImplBase*)imp;
		if ([buss respondsToSelector:@selector(destroyBussReqObj)])
		{
			[buss destroyBussReqObj];
		}
		else
		{
		//	LOG_DEBUG(@"BussInterImplBase对象: %@", buss);
		}

		self.imp = nil;
	}
	
	callbackObj = nil;
	callbackSel = nil;
	self.param = nil;
}

+(void)cancelBussRequest:(BussMng*)buss, ...
{
	[buss cancelBussRequest];
	
	//parameter list
    va_list argList; 
	va_start(argList, buss); 
	while (id arg = va_arg(argList, id)) 
	{ 
		BussMng* bs = (BussMng*)arg;
		[bs cancelBussRequest];
	} 
	va_end(argList); 
}

- (void)request:(id)obj :(SEL)sel :(id)p
{
    NSLog(@"request:obj=%p,sel=%p,p=%p",obj,sel,p);
    
	callbackObj = obj;
	callbackSel = sel;
	self.param = p;
	
	switch (type)
	{
		//case BMZTQ:
		case BMLogin:
        case BMJYEXAutoLogin:
        case BMJYEXUpdataSoft:
		case BMRegister:
		case BMUiLogin:
		case BMValidLogin:
			step = STEP_BUSS1;
			[self bussRequest];
			break;
			
		case BMLRYS:
		case BMLYYS:
		case BMMZFX:
		case BMMZCS:
		case BMZWYS_DAY:
		case BMZWYS_MONTH:
		case BMZWYS_YEAR:
        case BMMONEYFORTUNE:
		case BMRG:
		case BMAQTH:
		case BMPP:
		case BMConsumeCheck:
		case BMConsumeRequest:
		case BMConsumePay:
		case BMGetQa:
		case BMSndQa:
        case BMQianDao:
        case BMSYYS:   //事业成长，add 2012.8.16
        case BMServerDateTime: //add 2012.8.20
        default:
		{
			//check login
			if (![TheCurUser isLogined])
				step = STEP_LOGIN;
			else 
				step = STEP_BUSS1;
				
			[self bussRequest];
		}
		break;
			
	}
}

- (void) bussRequest
{
	
	if (step==STEP_LOGIN)
	{
		if (didLogin)
		{
			TBussStatus* sts = [[TBussStatus new] autorelease];
			sts.iCode = 500;
			sts.sInfo = LOC_STR("bm_fwq_yc");
			[callbackObj performSelector:callbackSel withObject:sts];
		}
		else
		{
			didLogin = YES;
//			BussLogin* login = [BussLogin new];
//			self.imp = login;
//			[login release];
//			[login Login:TheCurUser.sUserName Password:TheCurUser.sPassword RemPswd:TheCurUser.iSavePasswd  AutoLogin:TheCurUser.iAutoLogin ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
            
            BussJYEXLogin* login = [BussJYEXLogin new];
			self.imp = login;
			[login release];
			[login Login:TheCurUser.sUserName Password:TheCurUser.sPassword RemPswd:TheCurUser.iSavePasswd AutoLogin:TheCurUser.iAutoLogin ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];

		}

		return;
	}
		
	switch (type)
	{
		case BMLogin:
		{
			//BussLogin* login = [BussLogin new];
            BussJYEXLogin* login = [BussJYEXLogin new];
			self.imp = login;
			[login release];
			TParamLogin* p = (TParamLogin*)param;
			[login Login:p.user Password:p.pswd RemPswd:p.remPswd AutoLogin:p.autoLogin ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
		}
			break;
            
        case BMJYEXAutoLogin:
        {
			//BussLogin* login = [BussLogin new];
            BussJYEXLogin* login = [BussJYEXLogin new];
			self.imp = login;
			[login release];
			[login AutoLogin:self ResponseSelector:@selector(bussRequestCallback:)];
		}
			break;
    
        case BMJYEXUpdataSoft:
        {
            BussJYEXSoftUpdata *obj = [BussJYEXSoftUpdata new];
            self.imp = obj;
            [obj release];
            [obj getSoftInfoFromVersion:APPLE_ID ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
		case BMRegister:
		{
			BussRegisterUser* reg = [BussRegisterUser new];
			self.imp = reg;
			[reg release];
			TParamRegister* p = (TParamRegister*)param;
			[reg registerUser:p.user Password:p.pswd Nickname:p.nick RespTarget:self RespSelector:@selector(bussRequestCallback:)];
		}
			break;
			
		case BMValidLogin:
		{
			if (TheCurUser==nil || TheCurUser==NULL
				|| [PubFunction stringIsNullOrEmpty:TheCurUser.sUserName]
				|| [PubFunction stringIsNullOrEmpty:TheCurUser.sPassword]
				|| [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME])
				[PubFunction SendMessageToViewCenter:NMLogin :0 :1 :[MsgParam param:self :@selector(uiLoginCallback:) :nil :0]];
			else
			{
				BussLogin* login = [BussLogin new];
				self.imp = login;
				[login release];
				//[login Login:TheCurUser.sUserName Password:TheCurUser.sPassword RemPswd:TheCurUser.iSavePasswd ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
			}
		}
			break;
			
		case BMUiLogin:
			[PubFunction SendMessageToViewCenter:NMLogin :0 :1 :[MsgParam param:self :@selector(uiLoginCallback:) :nil :0]];
			break;
			
			
			
		case BMConsumePay:
		{
			CSMParam* csmp =  (CSMParam*)param;
			int t = csmp.type;
			BussConsume* csm = [BussConsume new];
			self.imp = csm;
			[csm release];
			if (t==CSM_NAME_PARSE)
			{
				[csm payNameParseConsume:EConsumeItem_NameParseAll
					  ResponseTarget:self 
					ResponseSelector:@selector(bussRequestCallback:)];
			}
			else if (t==CSM_NAME_MATCH)
			{
				[csm payNameMatchConsume:csmp.str1
								   Woman:csmp.str2
						  ResponseTarget:self
						ResponseSelector:@selector(bussRequestCallback:)];
			}
			else if (t==CSM_LRYYS)
			{
				[csm payLiuriyueConsume:csmp.y Month:csmp.m ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
			}
			else if (t==CSM_LNYS)
			{
				[csm payLiunianConsume:csmp.y ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
			}
            else if (t==CSM_FORTUNE_YS)
            {
                [csm payFortuneConsume:self ResponseSelector:@selector(bussRequestCallback:)];
            }
            else if (t==CSM_CAREER_YS)
            {
                [csm payCareerConsume:self ResponseSelector:@selector(bussRequestCallback:)];
            }
		}
			break;
			
		case BMGetQa:
		{
			BussSuggest* suggest = [BussSuggest new];
			self.imp = suggest;
			[suggest release];
			[suggest reqSuggestAnswer:self :@selector(bussRequestCallback:)];
		}
			break;
			
		case BMSndQa:
		{
			BussSuggest* suggest = [BussSuggest new];
			self.imp = suggest;
			[suggest release];
			[suggest sendSuggest:(NSString*)param :self :@selector(bussRequestCallback:)];
		}
			break;

        //以下为91note网络业务
        case BMLogin91Note:
        {
            BussLogin91Note* login91note = [BussLogin91Note new];
			self.imp = login91note;
			[login91note release];
			[login91note Login91Note:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMLogout91Note:   //注销
        {
            BussLogout91Note* logout91note = [BussLogout91Note new];
            self.imp = logout91note;
            [logout91note release];
            [logout91note Logout91Note:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMGetUserInfo:    //获取用户信息
        {
            BussGetUserInfo* getuserinfo = [BussGetUserInfo new];
            self.imp = getuserinfo;
            [getuserinfo release];
            [getuserinfo GetUserInfo:self ResponseSelector:@selector(bussRequestCallback:)]; 
        }
            break;
            
        case BMDownDir:        //下载文件夹
        {
            BussDownDir* downdir = [BussDownDir new];
            self.imp = downdir;
            [downdir release];
            [downdir DownDir:nil from:[(NSNumber *)(self.param) intValue] to:0 size:0 ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];            
        }
            break;
            
        case BMUploadDir:      //上传文件夹
        {
            BussUploadDir* uploaddir = [BussUploadDir new];
            self.imp = uploaddir;
            [uploaddir release];
            
            [uploaddir UploadDir:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMGetLatestNote:   //获取最新笔记信息
        {
            BussGetLatestNote* getlatestnote = [BussGetLatestNote new];
            self.imp = getlatestnote;
            [getlatestnote release];
            [getlatestnote GetLatestNote:0 to:0 size:0 ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];  
        }
            break;
            
        case BMDownNoteList:    //下载笔记列表信息
        {
            BussDownNoteList* downnotelist = [BussDownNoteList new];
            self.imp = downnotelist;
            [downnotelist release];
            [downnotelist DownNoteList:nil from:[(NSNumber *)(self.param) intValue] to:0 size:0 ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];  
        }
            break;
            
        case BMDownNote:        //根据笔记ID下载笔记信息
        {
            BussDownNote* downnote = [BussDownNote new];
            self.imp = downnote;
            [downnote release];
            
            TNoteInfo *pNoteInfo = self.param;
            [downnote DownNote:pNoteInfo.strNoteIdGuid user_id:pNoteInfo.tHead.nUserID currentver:pNoteInfo.tHead.nCurrVerID ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMUploadNote:      //上传笔记信息
        {
            BussUploadNote* uploadnote = [BussUploadNote new];
            self.imp = uploadnote;
            [uploadnote release];
            
            [uploadnote UploadNote:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMJYEXJYEXNote:
        {
            BussUploadJYEXNote* uploadnote = [BussUploadJYEXNote new];
            self.imp = uploadnote;
            [uploadnote release];
            
            [uploadnote UploadNote:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMJYEXGetUpdateNumber:
        {
            BussJYEXGetUpdateNumber *updatenumber = [BussJYEXGetUpdateNumber new];
            self.imp = updatenumber;
            [updatenumber release];
            
            [updatenumber getUpdateNumber:[(NSNumber *)self.param intValue] ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMJYEXQueryAlbumList:
        {
            BussJYEXQueryAlbumList *queryalbumlist = [BussJYEXQueryAlbumList new];
            self.imp = queryalbumlist;
            [queryalbumlist release];
            
            [queryalbumlist QueryAlbumList:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMJYEXUploadPhoto:
        {
            BussJYEXUploadPhoto *uploadphoto = [BussJYEXUploadPhoto new];
            self.imp = uploadphoto;
            [uploadphoto release];
            
            NSString *itemguid = [self.param objectForKey:@"itemguid"];
            NSString *albumid = [self.param objectForKey:@"albumid"];
            NSString *title = [self.param objectForKey:@"title"];
            NSString *albumname = [self.param objectForKey:@"albumname"];
            NSString *uid = [self.param objectForKey:@"uid"];
            NSString *username = [self.param objectForKey:@"username"];
            
            [uploadphoto uploadPhoto:albumid title:title albumname:albumname itemguid:itemguid uid:uid username:username ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMJYEXCreateAlbum:
        {
            BussJYEXCreateAlbum *createalbum = [BussJYEXCreateAlbum new];
            self.imp = createalbum;
            [createalbum release];
            
            NSString *albumname = [self.param objectForKey:@"albumname"];
            NSNumber *spaceid = [self.param objectForKey:@"spaceid"];
            
            [createalbum CreateAlbum:albumname space:spaceid ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
            
        }
            break;
            
            
        case BMJYEXRegister:
        {
            BussJYEXRegister *registeruser = [BussJYEXRegister new];
            self.imp = registeruser;
            [registeruser release];
            
            NSString *username = [self.param objectForKey:@"username"];
            NSString *password = [self.param objectForKey:@"password"];
            NSString *nickname = [self.param objectForKey:@"nickname"];
            NSString *realname = [self.param objectForKey:@"realname"];
            NSString *email = [self.param objectForKey:@"email"];
            
            [registeruser RegisterUser:username password:password nickname:nickname readlname:realname email:email ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];

        }
            break;
            
            
        case BMJYEXUpdateUserInfo:
        {
            BussJYEXUpdateUserInfo *updateuserinfo = [BussJYEXUpdateUserInfo new];
            self.imp = updateuserinfo;
            [updateuserinfo release];
            
            NSString *uid = [self.param objectForKey:@"uid"];
            NSString *username = [self.param objectForKey:@"username"];
            NSString *oldpassword = [self.param objectForKey:@"oldpassword"];
            NSString *newpassword = [self.param objectForKey:@"newpassword"];
            NSString *nickname = [self.param objectForKey:@"nickname"];
            NSString *realname = [self.param objectForKey:@"realname"];
            NSString *email = [self.param objectForKey:@"email"];
            NSString *mobile = [self.param objectForKey:@"mobile"];
            
            [updateuserinfo UpdateUserInfo:uid username:username oldpassword:oldpassword newpassword:newpassword nickname:nickname readlname:realname email:email mobile:mobile ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
            
        }
            break;
            
        
        case BMJYEXGetAlbumPics:
        {
            BussJYEXGetAlbumPics *getalbumpics = [BussJYEXGetAlbumPics new];
            self.imp = getalbumpics;
            [getalbumpics release];
            
            NSString *strAlbumId = [self.param objectForKey:@"albumid"];
            
            [getalbumpics GetAlbumPics:strAlbumId ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMQueryAvatar: //查询头像是否存在
        {
            BussQueryAvatar* queryavatar = [BussQueryAvatar new];
            self.imp = queryavatar;
            [queryavatar release];
            
            [queryavatar QueryAvatar:TheCurUser.sUserID ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMGetAvatar:   //下载头像文件
        {
            BussGetAvatar* getavatar = [BussGetAvatar new];
            self.imp = getavatar;
            [getavatar release];
            
            //下载临时文件
            NSString *strDownFile = [CommonFunc getAvatarDownloadPath];
            NSString *strContentType = [CommonFunc getStreamTypeByExt:@"jpg"];
            [getavatar GetAvatar:TheCurUser.sUserID filename:strDownFile contenttype:strContentType ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
        
        //-----------------------------------------------
            
        case BMSearchNoteList:  //通过标题查找笔记
        {
            
        }
            break;
            
        case BMGetNoteAll:  //获取笔记的所有项
        {
            BussGetNoteAll* getnoteall = [BussGetNoteAll new];
            self.imp = getnoteall;
            [getnoteall release];
            
            TNoteInfo *pNoteInfo = self.param;
            int maxver = [AstroDBMng getNote2ItemMaxVersionByNoteGuid:pNoteInfo.strNoteIdGuid];
            [getnoteall GetNoteAll:pNoteInfo.strNoteIdGuid from:maxver neednote:0 ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;           
            
        case BMDownNoteXItems:  //获取笔记的笔记与笔记项关联列表
        {
            BussDownNoteXItems* downnotexitems = [BussDownNoteXItems new];
            self.imp = downnotexitems;
            [downnotexitems release];
            
            TNoteInfo *pNoteInfo = self.param;
            int maxver = [AstroDBMng getNote2ItemMaxVersionByNoteGuid:pNoteInfo.strNoteIdGuid];
            
            [downnotexitems DownNoteXItems:pNoteInfo.strNoteIdGuid from:maxver to:0 size:0 ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMUploadNoteXItems: //上传笔记与笔记项关联信息
        {
            BussUploadNoteXItems* uploadnotexitem = [BussUploadNoteXItems new];
            self.imp = uploadnotexitem;
            [uploadnotexitem release];
            
            [uploadnotexitem UploadNoteXItems:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
        case BMDownItem:       //获取笔记项信息
        {
            BussDownItem* downitem = [BussDownItem new];
            self.imp = downitem;
            [downitem release];
            
            TNoteXItem *pNoteXItem = self.param;
            [downitem DownItem:pNoteXItem.strItemIdGuid user_id:pNoteXItem.tHead.nUserID current_ver:0 ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];            
        }
            break;
            
        case BMUploadItem:     //上载笔记项信息
        {
            BussUploadItem* uploaditem = [BussUploadItem new];
            self.imp = uploaditem;
            [uploaditem release];
            
            [uploaditem UploadItem:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];              
        }
            break;
            
        case BMDownItemFile:   //下载笔记项文件
        {
            BussDownItemFile* downitemfile = [BussDownItemFile new];
            self.imp = downitemfile;
            [downitemfile release];
            
            //下载临时文件
            TItemInfo *pItemInfo = (TItemInfo *)self.param;
            NSString *strDownFile = [CommonFunc getTempDownDir];
            strDownFile = [strDownFile stringByAppendingFormat:@"/%@.%@",pItemInfo.strItemIdGuid,pItemInfo.strItemExt];
            NSString *strContentType = [CommonFunc getStreamTypeByExt:pItemInfo.strItemExt];
            [downitemfile DownItemFile:pItemInfo.strItemIdGuid filename:strDownFile contenttype:strContentType ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];  
        }
            break;
            
        case BMUploadItemFile: //上传笔记项数据包
        {
            BussUploadItemFile* uploaditemfile = [BussUploadItemFile new];
            self.imp = uploaditemfile;
            [uploaditemfile release];
            
            [uploaditemfile UploadItemFile:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];              
        }
            break;
            
        case BMUploadItemFileFinish: //上传笔记项完成     
        {
            BussUploadItemFileFinish* uploaditemfilefinish = [BussUploadItemFileFinish new];
            self.imp = uploaditemfilefinish;
            [uploaditemfilefinish release];
                        
            [uploaditemfilefinish UploadItemFileFinish:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
         }
            break;
		case BMJYEXUploadItemFile:
        {
            BussJYEXUploadItemFile* uploaditemfile = [BussJYEXUploadItemFile new];
            self.imp = uploaditemfile;
            [uploaditemfile release];
            
            [uploaditemfile UploadItemFile:self.param ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)]; 
        }
            break;
            
        case BMJYEXDownloadFile://下载文件
        {
            BussDownloadFile* downitemfile = [BussDownloadFile new];
            self.imp = downitemfile;
            [downitemfile release];
            
            //下载临时文件
            NSString *strUrl = [self.param objectForKey:@"url"];
            NSString *strFilename = [self.param objectForKey:@"filename"];
            NSString *strContentType = [self.param objectForKey:@"contenttype"];
       

            //TItemInfo *pItemInfo = (TItemInfo *)self.param;
            //NSString *strDownFile = [CommonFunc getTempDownDir];
            //strDownFile = [strDownFile stringByAppendingFormat:@"/%@.%@",pItemInfo.strItemIdGuid,pItemInfo.strItemExt];
            //NSString *strContentType = [CommonFunc getStreamTypeByExt:pItemInfo.strItemExt];
            [downitemfile DownloadFile:strUrl filename:strFilename contenttype:strContentType  ResponseTarget:self ResponseSelector:@selector(bussRequestCallback:)];
        }
            break;
            
            
		default:
			break;
	}
}

- (void) bussRequestCallback:(id)rcvData
{
	TBussStatus* sts = nil;
    sts = [[TBussStatus new] autorelease];
        
    sts.iCode = ((BussInterImplBase *)(self.imp)).iHttpCode;  //正常时是200

	if (rcvData!=nil && [rcvData isKindOfClass:[NSError class]] && sts.iCode != 200)
	{
        sts.iCode = [(NSError*)rcvData code];  //错误http代码
        
		if (step==STEP_LOGIN) {
			sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_dr"), [(NSError*)rcvData domain]];
        }
        else
		{
            if ( BMLogin != type && BMValidLogin != type && BMRegister != type && BMJYEXAutoLogin != type )
            {
                if (sts.iCode==401 && !didLogin)
                {
                    TheCurUser.iLoginType = ELoginType_OffLine;  //add 2012.12.18
                    step = STEP_LOGIN;
                    [self bussRequest];
                    return;
                }
            }
            
			switch (type)
			{
				case BMLogin:
                case BMJYEXAutoLogin:
				case BMValidLogin:
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_dr"), [(NSError*)rcvData domain]];
					break;
					
				case BMRegister:
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_zc"), [(NSError*)rcvData domain]];
					break;
					
				case BMMZFX:
				{
					if (step==STEP_BUSS1)
						sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_mp"), [(NSError*)rcvData domain]];
					else if (step==STEP_BUSS2)
						sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_mzxx"), [(NSError*)rcvData domain]];
				}
					break;
					
				case BMMZCS:
				{					
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_mzkz"), [(NSError*)rcvData domain]];
					
				}
					break;
					
					
				case BMZWYS_DAY:
				case BMZWYS_MONTH:
				case BMZWYS_YEAR:
                case BMMONEYFORTUNE:
                case BMSYYS:  //事业成长 add 2012.8.16
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_ys"), [(NSError*)rcvData domain]];
					break;
					
				case BMRG:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_rg"), [(NSError*)rcvData domain]];
					
				}
					break;
					
				case BMAQTH:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_aq"), [(NSError*)rcvData domain]];
					
				}
					break;
                    
                case BMQianDao:
				{
                    sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_qd"), [(NSError*)rcvData domain]];
					
				}
					break;
                    
                case BMServerDateTime:  //add 2012.8.20
				{
                    sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_serverdatetime"), [(NSError*)rcvData domain]];
					
				}
					break;
					
				case BMPP:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_xmpp"), [(NSError*)rcvData domain]];
					
				}
					break;
					
				case BMConsumeRequest:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_xfxx"), [(NSError*)rcvData domain]];
				}
					break;
					
				case BMConsumeCheck:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_sfxf"), [(NSError*)rcvData domain]];
				}
					break;
					
				case BMConsumePay:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_xfzf"), [(NSError*)rcvData domain]];
				}
					break;
					
				case BMGetQa:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_hqjy"), [(NSError*)rcvData domain]];
				}
					break;
					
				case BMSndQa:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_tjjy"), [(NSError*)rcvData domain]];
				}
					break;
					
				case BMLRYS:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_lrjp"), [(NSError*)rcvData domain]];
				}
					break;
					
					
				case BMLYYS:
				{
					sts.sInfo = [NSString stringWithFormat:LOC_STR("bm_sb_lyjp"), [(NSError*)rcvData domain]];
				}
					break;
					
					//case add...
				default:
                {
                    sts.sInfo = [NSString stringWithFormat:@"%@", [(NSError*)rcvData domain]];
                }
                    break;
			}
		}
	}
	else  //成功的处理
	{        
        if (step==STEP_LOGIN)
        {
            step = STEP_BUSS1;
            [self bussRequest];
            return;
        }
        
		switch (type)
		{
			case BMMZFX:
			{
                if (step==STEP_BUSS1)
				{
					step = STEP_BUSS2;
					[self bussRequest];
					return;
				}
			}
				break;
			
			case BMLRYS:
			case BMLYYS:
			case BMMZCS:
			case BMZWYS_DAY:
			case BMZWYS_MONTH:
			case BMZWYS_YEAR:
            case BMMONEYFORTUNE:
			case BMRG:
			case BMAQTH:
			case BMPP:
			case BMGetQa:
			case BMSndQa:
            case BMSYYS:  //事业成长, 2012.8.15
			{
			}
				break;
                
			case BMQianDao:  //要修改
            {
                NSDictionary* retJsObj = [(NSString*)rcvData JSONValue];
                sts.rtnData = retJsObj;
            }
                break;
                
            case BMServerDateTime:  //要修改
            {
                NSDictionary* retJsObj = [(NSString*)rcvData JSONValue];
                sts.rtnData = retJsObj;
            }
                break;
                
			case BMConsumeRequest:  //要修改
			{
				TProductInfo* info = [[TProductInfo new] autorelease];
				if ([PubFunction stringIsNullOrEmpty:(NSString*)rcvData])
				{
					sts.sInfo =  LOC_STR("bm_fhsjcw");
					sts.rtnData = nil;
					break;
				}
				
				if (![BussConsume unpackGetPriceResult:(NSString*)rcvData Result:info])
				{
					sts.sInfo =  LOC_STR("bm_fhsjcw");
					sts.rtnData = nil;
					break;
				}
				
				sts.rtnData = info;
			
			}
				break;
				
			case BMConsumeCheck:
			{
				TCheckPayResult* info = [[TCheckPayResult new] autorelease];
				
				if ([PubFunction stringIsNullOrEmpty:(NSString*)rcvData])
				{
					sts.sInfo =  LOC_STR("bm_fhsjcw");
					sts.rtnData = nil;
					break;
				}
				
				if (![BussConsume unpackCheckPayedResult:(NSString*)rcvData Result:info])
				{
					sts.sInfo =  LOC_STR("bm_fhsjcw");
					break;
				}
				
				sts.rtnData = info;
				
			}
				break;
				
			case BMConsumePay:
			{
				TPayResult* info = [[TPayResult new] autorelease];
				
				if ([PubFunction stringIsNullOrEmpty:(NSString*)rcvData])
				{
					sts.sInfo = LOC_STR("bm_fhsjcw");
					sts.rtnData = nil;
					break;
				}
				
				if (![BussConsume unpackPayResult:(NSString*)rcvData Result:info])
				{
					sts.sInfo = LOC_STR("bm_jxsjcw");
					break;
				}
				
				sts.rtnData = info;
				
			}
				break;
				
			//
			
			default:  //缺省处理
            {                
                if ( [self.imp respondsToSelector:@selector(unpackJsonForResult:Result:)]) {
                    [self.imp unpackJsonForResult:(NSString*)rcvData Result:sts];
                }
                else {
                    if ( [rcvData isKindOfClass:[NSString class]] ) {
                        if ( ![(NSString*)rcvData hasPrefix:@"{"] )  sts.rtnData = nil;
                        else {
                            NSDictionary* retJsObj = [(NSString*)rcvData JSONValue];
                            sts.rtnData = retJsObj;
                        }
                    }
                }
            }
                break;
		}
	}
	
    //[self.imp destroyBussReqObj];
	//self.imp = nil;
    
     NSLog(@"sts1:%p  retaincount=%d",sts,[sts retainCount]);
	[callbackObj performSelector:callbackSel withObject:sts];
    //NSLog(@"sts2:%p  retaincount=%d",sts,[sts retainCount]);
}


- (void) uiLoginCallback :(TBussStatus*)sts
{	
	if (sts.iCode==1)
		[callbackObj performSelector:callbackSel withObject:nil];
	else
	{
		sts.sInfo = nil;
		[callbackObj performSelector:callbackSel withObject:sts];
	}
}


//运势免费时间限
+(BOOL)isFreeDayYS:(TDateInfo*)dateInf
{
    DateInfo nl  = Calendar::Lunar(DateInfo(dateInf.year, dateInf.month, dateInf.day));
    int n = nl.year*10000+nl.month*100+nl.day;
    
    if (n < 20100101)
        return NO;
    
    TDateInfo* curDate = [TDateInfo getTodayDateInfo];
    DateInfo nlToday = Calendar::Lunar(DateInfo(curDate.year, curDate.month, curDate.day));
    nlToday.day = Calendar::GetMonthDays(nlToday.year, nlToday.month);
    
    if (n > nlToday.year*10000 + nlToday.month*100 + nlToday.day)
        return NO;
    
    return YES;
    
    
    
   /* 
    
	if(!dateInf)
		return NO;
	
	//参数日期
	NSDate* date = [PubFunction makeDateByNYR:dateInf.year :dateInf.month :dateInf.day];
	NSString* strDate = [PubFunction formatDateTime2NSStringWithDate:date :@"yyyy-MM-dd"];

	//最小日期
	NSString* strMinDate = @"2010-01-01";
	
	//最大日期:本农历月最后一天
	//今日阳历
	NSDate* dtTd = [NSDate date];
	int y, m, d;
	[PubFunction decodeNSDate:dtTd :&y :&m :&d];
	//今日农历
	int ny, nm, nd;
	bool leap;
	if( !Calendar::GetLunarFromDay(y, m, m, ny, nm, nd, leap) )
		return NO;
	//离农历月最后一天还差几天
	int nNLMaxDays = Calendar::GetMonthDays(ny, nm);
	int diffDays = nNLMaxDays - nd;
	//农历月最后一天的阳历
	NSTimeInterval diffSecs = diffDays * 24 * 60 * 60;
	NSDate* dtMax = [NSDate dateWithTimeInterval:diffSecs sinceDate:dtTd];
	NSString* strMaxDate = [PubFunction formatDateTime2NSStringWithDate:dtMax :@"yyyy-MM-dd"];
	
	//范围比较
	if ([strDate compare:strMinDate] != NSOrderedAscending		//不小于
		&& [strDate compare:strMaxDate] != NSOrderedDescending)		//不大于
	{
		return YES;
	}
	else
	{
		return NO;
	}
    */
}

+ (BOOL)isFreeMonthYS:(TDateInfo*)dateInf
{
    DateInfo nl  = Calendar::Lunar(DateInfo(dateInf.year, dateInf.month, dateInf.day));
    
    if (nl.year*100+nl.month < 201001)
        return NO;
    
    TDateInfo* curDate = [TDateInfo getTodayDateInfo];
    DateInfo nlToday = Calendar::Lunar(DateInfo(curDate.year, curDate.month, curDate.day));
    if (nl.year*100+nl.month > nlToday.year*100+nlToday.month)
        return NO;
   
    return YES;
    
    // get dateInf nl y;
    // get curdate nl y;
    
    /*
	if(!dateInf)
		return NO;
	
	//参数日期
	NSDate* date = [PubFunction makeDateByNYR:dateInf.year :dateInf.month :dateInf.day];
	NSString* strDate = [PubFunction formatDateTime2NSStringWithDate:date :@"yyyy-MM"];
	
	//最小日期
	NSString* strMinDate = @"2010-01";
	
	//最大日期:本月
	NSString* strMaxDate = [PubFunction formatDate2NSString_YYYY_MM];
	
	//范围比较
	if ([strDate compare:strMinDate] != NSOrderedAscending		//不小于
		&& [strDate compare:strMaxDate] != NSOrderedDescending)		//不大于
	{
		return YES;
	}
	else
	{
		return NO;
	}
     */
}

+(BOOL)isFreeYearYS:(TDateInfo*)dateInf
{
    
    TDateInfo* curDate = [TDateInfo getTodayDateInfo];
    
    DateInfo nl  = Calendar::Lunar(DateInfo(dateInf.year, dateInf.month, dateInf.day));
    DateInfo nlToday = Calendar::Lunar(DateInfo(curDate.year, curDate.month, curDate.day));
    
    
    if (nl.year < 2010)
        return NO;
    
    if (nl.year > nlToday.year+1)
        return NO;
    
    return YES;
    
    /*
	if(!dateInf)
		return NO;
	
	//参数日期： dateInf.year
	
	//最小年份
	int minDate = 2010;
	
	//最大年份：今年＋明年
	int y, m, d;
	[PubFunction getToday:&y :&m :&d];
	
	//范围比较
	if ( dateInf.year >= minDate && dateInf.year <= y+1 ) 
	{
		return YES;
	}
	else
	{
		return NO;
	}
     */
}


//add 2012.8.20 ,改为和服务器的时间比较
//运势免费时间限
+(BOOL)isFreeDayYS_Date:(TDateInfo*)dateInf curDate:(TDateInfo*)curDate
{
    DateInfo nl  = Calendar::Lunar(DateInfo(dateInf.year, dateInf.month, dateInf.day));
    int n = nl.year*10000+nl.month*100+nl.day;
    
    if (n < 20100101)
        return NO;
    
    //TDateInfo* curDate = [TDateInfo getTodayDateInfo];
    DateInfo nlToday = Calendar::Lunar(DateInfo(curDate.year, curDate.month, curDate.day));
    nlToday.day = Calendar::GetMonthDays(nlToday.year, nlToday.month);
    
    if (n > nlToday.year*10000 + nlToday.month*100 + nlToday.day)
        return NO;
    
    return YES;
    
    
    
    /* 
     
     if(!dateInf)
     return NO;
     
     //参数日期
     NSDate* date = [PubFunction makeDateByNYR:dateInf.year :dateInf.month :dateInf.day];
     NSString* strDate = [PubFunction formatDateTime2NSStringWithDate:date :@"yyyy-MM-dd"];
     
     //最小日期
     NSString* strMinDate = @"2010-01-01";
     
     //最大日期:本农历月最后一天
     //今日阳历
     NSDate* dtTd = [NSDate date];
     int y, m, d;
     [PubFunction decodeNSDate:dtTd :&y :&m :&d];
     //今日农历
     int ny, nm, nd;
     bool leap;
     if( !Calendar::GetLunarFromDay(y, m, m, ny, nm, nd, leap) )
     return NO;
     //离农历月最后一天还差几天
     int nNLMaxDays = Calendar::GetMonthDays(ny, nm);
     int diffDays = nNLMaxDays - nd;
     //农历月最后一天的阳历
     NSTimeInterval diffSecs = diffDays * 24 * 60 * 60;
     NSDate* dtMax = [NSDate dateWithTimeInterval:diffSecs sinceDate:dtTd];
     NSString* strMaxDate = [PubFunction formatDateTime2NSStringWithDate:dtMax :@"yyyy-MM-dd"];
     
     //范围比较
     if ([strDate compare:strMinDate] != NSOrderedAscending		//不小于
     && [strDate compare:strMaxDate] != NSOrderedDescending)		//不大于
     {
     return YES;
     }
     else
     {
     return NO;
     }
     */
}

+ (BOOL)isFreeMonthYS_Date:(TDateInfo*)dateInf curDate:(TDateInfo*)curDate
{
    DateInfo nl  = Calendar::Lunar(DateInfo(dateInf.year, dateInf.month, dateInf.day));
    
    if (nl.year*100+nl.month < 201001)
        return NO;
    
    //TDateInfo* curDate = [TDateInfo getTodayDateInfo];
    DateInfo nlToday = Calendar::Lunar(DateInfo(curDate.year, curDate.month, curDate.day));
    if (nl.year*100+nl.month > nlToday.year*100+nlToday.month)
        return NO;
    
    return YES;
    
    // get dateInf nl y;
    // get curdate nl y;
    
    /*
     if(!dateInf)
     return NO;
     
     //参数日期
     NSDate* date = [PubFunction makeDateByNYR:dateInf.year :dateInf.month :dateInf.day];
     NSString* strDate = [PubFunction formatDateTime2NSStringWithDate:date :@"yyyy-MM"];
     
     //最小日期
     NSString* strMinDate = @"2010-01";
     
     //最大日期:本月
     NSString* strMaxDate = [PubFunction formatDate2NSString_YYYY_MM];
     
     //范围比较
     if ([strDate compare:strMinDate] != NSOrderedAscending		//不小于
     && [strDate compare:strMaxDate] != NSOrderedDescending)		//不大于
     {
     return YES;
     }
     else
     {
     return NO;
     }
     */
}

+(BOOL)isFreeYearYS_Date:(TDateInfo*)dateInf curDate:(TDateInfo*)curDate
{
    
    //TDateInfo* curDate = [TDateInfo getTodayDateInfo];
    
    DateInfo nl  = Calendar::Lunar(DateInfo(dateInf.year, dateInf.month, dateInf.day));
    DateInfo nlToday = Calendar::Lunar(DateInfo(curDate.year, curDate.month, curDate.day));
    
    
    if (nl.year < 2010)
        return NO;
    
    if (nl.year > nlToday.year+1)
        return NO;
    
    return YES;
    
    /*
     if(!dateInf)
     return NO;
     
     //参数日期： dateInf.year
     
     //最小年份
     int minDate = 2010;
     
     //最大年份：今年＋明年
     int y, m, d;
     [PubFunction getToday:&y :&m :&d];
     
     //范围比较
     if ( dateInf.year >= minDate && dateInf.year <= y+1 ) 
     {
     return YES;
     }
     else
     {
     return NO;
     }
     */
}



@end

@implementation TParamLogin
@synthesize user;
@synthesize pswd;
@synthesize remPswd;
@synthesize autoLogin;

- (void) dealloc
{
	self.user = nil;
	self.pswd = nil;
	[super dealloc];
}

@end

@implementation TParamRegister
@synthesize user;
@synthesize pswd;
@synthesize nick;

- (void) dealloc
{
	self.user = nil;
	self.pswd = nil;
	self.nick = nil;
	[super dealloc];
}

@end



@implementation TMZFX_FREE
@synthesize plate;
@synthesize explain;

-(void)dealloc
{
	self.plate = nil;
	self.explain = nil;
	[super dealloc];
}

@end

@implementation CSMParam
@synthesize title;
@synthesize str1;
@synthesize str2;
@synthesize item;
@synthesize type;
@synthesize y;
@synthesize m;
@synthesize lr_or_ly;

- (void) dealloc
{
	self.title = nil;
	self.str1 = nil;
	self.str2 =nil;
	
	[super dealloc];
}

@end

@implementation TParamZwys
@synthesize dateInfo;
@synthesize lookFrom;

+ (TParamZwys*) param :(TDateInfo*)dateInfo
{
	TParamZwys* p = [[TParamZwys new] autorelease];
	p.dateInfo = dateInfo;
	p.lookFrom = EConsumeLookFrom_Buy;
	return p;
}

- (void) dealloc
{
	self.dateInfo = nil;
	[super dealloc];
}

@end

@implementation TParamNameMatch
@synthesize pd;
@synthesize lookFrom;

+ (TParamNameMatch*) param :(TNAME_PD_PARAM*) pd
{
	TParamNameMatch* p = [[TParamNameMatch new] autorelease];
	p.pd = pd;
	p.lookFrom = EConsumeLookFrom_Buy;
	return p;
}

- (void) dealloc
{
	self.pd = nil;
	[super dealloc];
}

@end





