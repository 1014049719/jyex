//
//  WeatherIntf.h
//  Weather
//
//  Created by nd on 11-5-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

/*
#pragma mark -
#pragma mark 即时天气信息
@interface TIMWeather : NSObject
{
	//{"weatherinfo":{"city":"西安","cityid":"101110101","temp":"25","WD":"东南风","WS":"2 级","SD":"56%","WSE":"2","time":"14:30","isRadar":"1","Radar":"JC_RADAR_AZ9290_JB"}}	
	NSString *city, *cityid, *temp, *WD, *WS, *SD, *WSE, *time, *isRadar, *Radar;
}
@property (nonatomic, copy) NSString *city, *cityid, *temp, *WD, *WS, *SD, *WSE, *time, *isRadar, *Radar;


@end

#pragma mark -
@interface TIMWeather_Ext : NSObject
{
	TIMWeather *imWeather;	//即时天气
	NSString* sDataTime;	//时间
}
@property(nonatomic, retain) TIMWeather *imWeather;
@property(nonatomic, copy) NSString* sDataTime;	
	

@end



#pragma mark -
#pragma mark 一周天气信息
@interface TWeekdayWeather : NSObject
{
	//{"weatherinfo":
	//  {"city":"福州","city_en":"fuzhou","date_y":"2011年5月30 日","date":"辛卯年","week":"星期一","fchh":"11","cityid":"101230101",
	//"temp1":"30℃~19℃","temp2":"32℃~21℃","temp3":"28℃~22℃","temp4":"30℃~22℃","temp5":"30℃~21℃","temp6":"31℃~22℃",
	//"tempF1":"86℉~66.2℉","tempF2":"89.6℉~69.8℉","tempF3":"82.4℉~71.6℉","tempF4":"86℉~71.6℉","tempF5":"86℉~69.8℉","tempF6":"87.8℉~71.6℉",
	//"weather1":" 晴转多云","weather2":"多云转阴","weather3":"阵雨","weather4":"阵雨","weather5":" 阴","weather6":"多云",
	//"img1":"0","img2":"1","img3":"1","img4":"2","img5":"3","img6":"99",
	//"img7":"3","img8":"99","img9":"2","img10":"99","img11":"1","img12":"99",
	//"img_single":"0","img_title1":" 晴","img_title2":"多云","img_title3":"多云","img_title4":"阴","img_title5":"阵雨","img_title6":"阵雨",
	//"img_title7":"阵雨","img_title8":"阵雨","img_title9":" 阴","img_title10":"阴","img_title11":"多云","img_title12":"多云",
	//"img_title_single":"晴","wind1":"微风","wind2":"微风","wind3":"微风","wind4":"微风","wind5":"微风","wind6":"微风",
	//"fx1":"微风","fx2":"微风","fl1":"小于3级","fl2":"小于3级","fl3":"小于3级","fl4":"小于3级","fl5":"小于3级","fl6":"小于3 级",
	//"index":"热","index_d":"天气较热，建议着短裙、短裤、短套装、T恤等夏季服装。年老体弱者宜着长袖衬衫和单裤。",
	//"index48":"炎热","index48_d":"天气炎热，建议着短衫、短裙、短裤、薄型T恤衫、敞领短袖棉衫等清凉夏季服装。",
	//"index_uv":"强","index48_uv":"弱","index_xc":"较适宜","index_tr":"适宜","index_co":"较不舒适",
	//"st1":"30","st2":"19","st3":"32","st4":"20","st5":"25","st6":"20","index_cl":" 适宜","index_ls":"极适宜"}}
	NSString *city, *city_en, *date_y, *date, *week, *fchh, *cityid, 
	*temp1, *temp2, *temp3, *temp4, *temp5, *temp6,	
	*tempF1, *tempF2, *tempF3, *tempF4, *tempF5, *tempF6,
	*weather1, *weather2, *weather3, *weather4, *weather5, *weather6,
	*img1, *img2, *img3, *img4, *img5, *img6,		
	*img7, *img8, *img9, *img10, *img11, *img12,		
	*img_single, *img_title1, *img_title2, *img_title3, *img_title4, *img_title5, *img_title6,		
	*img_title7, *img_title8, *img_title9, *img_title10, *img_title11, *img_title12, *img_title_single,
	*wind1, *wind2, *wind3, *wind4, *wind5, *wind6,
	*fx1, *fx2, *fl1, *fl2, *fl3, *fl4, *fl5, *fl6,
	*index, *index_d, *index48, *index48_d, *index_uv, *index48_uv, *index_xc, *index_tr, *index_co,
	*st1, *st2, *st3, *st4, *st5, *st6, *index_cl, *index_ls,
	*imgToday
	;
}
@property (nonatomic, copy) NSString *city, *city_en, *date_y, *date, *week, *fchh, *cityid, 
	*temp1, *temp2, *temp3, *temp4, *temp5, *temp6,	
	*tempF1, *tempF2, *tempF3, *tempF4, *tempF5, *tempF6,
	*weather1, *weather2, *weather3, *weather4, *weather5, *weather6,
	*img1, *img2, *img3, *img4, *img5, *img6,		
	*img7, *img8, *img9, *img10, *img11, *img12,		
	*img_single, *img_title1, *img_title2, *img_title3, *img_title4, *img_title5, *img_title6,		
	*img_title7, *img_title8, *img_title9, *img_title10, *img_title11, *img_title12, *img_title_single,
	*wind1, *wind2, *wind3, *wind4, *wind5, *wind6,
	*fx1, *fx2, *fl1, *fl2, *fl3, *fl4, *fl5, *fl6,
	*index, *index_d, *index48, *index48_d, *index_uv, *index48_uv, *index_xc, *index_tr, *index_co,
	*st1, *st2, *st3, *st4, *st5, *st6, *index_cl, *index_ls,
	*imgToday
;

@end

#pragma mark -
@interface TWeekdayWeather_Ext : NSObject
{
	TWeekdayWeather* wkWeather;		//一周天气
	NSString* sDataTime;				//时间
}

@property(nonatomic, retain)TWeekdayWeather* wkWeather;
@property(nonatomic, retain)NSString* sDataTime;		

@end
*/

#pragma mark -
#pragma mark 有关天气的一些函数
@interface WeatherFunc : NSObject
{
	
}

//根据id取得天气图标
+ (NSString*) getWeatherPicNameByIndex:(NSString*)strIndex1 :(NSString*)strIndex2;

//天气图标
+(NSString*) getWeatIconFile:(NSString*)strWeaDesc;
+(NSString*) getFinalWeathRes:(NSString*)strDesc;

@end

