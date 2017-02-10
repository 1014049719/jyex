//
//  WeatherIntf.m
//  Weather
//
//  Created by nd on 11-5-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BussIntfWeather.h"
#import "PubFunction.h"

#pragma mark -
#pragma mark 有关天气的一些函数
@implementation WeatherFunc

//从黄历天气移植过来的
+ (NSString*) getWeatherPicNameByIndex :(NSString*)strIndex1 : (NSString*)strIndex2
{
	NSString *imgIndex = strIndex1;
	
	NSString* iconFile = nil;
	switch ([imgIndex intValue]) 
	{
		case 0: //晴
			iconFile = @"sunny.png";
			break;
		case 1: //多云
			iconFile = @"cloudy.png";
			break;
		case 2: //阴
			iconFile = @"overcast.png";
			break;			
		case 3: //阵雨
			iconFile = @"showers.png";
			break;
		case 4: //雷阵雨
			iconFile = @"thunderstorm.png";
			break;
		case 5: //雷阵雨伴有冰雹
			iconFile = @"w6.png";
			break;
		case 6: //雨夹雪
			iconFile = @"sleet.png";
			break;
		case 7: //小雨
			iconFile = @"cn_lightrain.png";
			break;
		case 8: //中雨
			iconFile = @"rain.png";
			break;
		case 9: //大雨
			iconFile = @"cn_heavyrain.png";
			break;
		case 10: //暴雨
			iconFile = @"storm.png";
			break;
		case 11: //大暴雨
			iconFile = @"storm.png";
			break;
		case 12://特大暴雨
			iconFile = @"storm.png";
			break;
		case 13: //阵雪
			iconFile = @"chance_of_snow.png";
			break;
		case 14://小雪
			iconFile = @"snow.png";
			break;
		case 15://中雪
			iconFile = @"w14.png";
			break;
		case 16://大雪
			iconFile = @"w16.png";
			break;
		case 17://暴雪
			iconFile = @"w17.png";
			break;
		case 18://雾
			iconFile = @"fog.png";
			break;
		case 19://冻雨
			iconFile = @"icy.png";
			break;
		case 20://沙尘暴
			iconFile = @"w21.png";
			break;
		case 21://小雨_中雨
			iconFile = @"cn_lightrain.png";
			break;
		case 22: // 中到大雨
			iconFile = @"rain.png";
			break;
		case 23: // 大雨_暴雨
			iconFile = @"cn_heavyrain.png";
			break;
		case 24: // 暴雨_大暴雨
			iconFile = @"storm.png";
			break;
		case 25: // 大暴雨_特大暴雨
			iconFile = @"storm.png";
			break;
		case 26: // 小雪_中雪
			iconFile = @"w14.png";
			break;
		case 27: // 中雪_大雪
			iconFile = @"w16.png";
			break;
		case 28: // 大雪_暴雪
			iconFile = @"w17.png";
			break;
		case 29: // 浮尘
			iconFile = @"dust.png";
			break;
		case 30: // 扬沙
			iconFile = @"w29.png";
			break;
		case 31: // 强沙尘暴
			iconFile = @"w21.png";
			break;
		default:
			iconFile = @"unknown.png";
			break;
	}

	return iconFile;
}

//从android算命移植过来
+(NSString*) getWeatIconFile:(NSString*)strWeaDesc
{
    //由于简繁体混合存在，所以需要同时判断。
    
	//图标列表
    //if (IS_FT)
    {
        NSMutableDictionary* dctFlName = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"unknown.png",			@"暫無數據",
                                          @"sunny.png",				@"晴",		
                                          @"cloudy.png",			@"多雲",		
                                          @"overcast.png",			@"陰",		
                                          @"showers.png",			@"陣雨",		
                                          @"storm.png",				@"暴雨",		
                                          @"thunderstorm.png",		@"雷陣雨",
                                          @"cn_heavyrain.png",		@"大雨",	
                                          @"cn_lightrain.png",		@"小雨",		
                                          @"w14.png",				@"小雪",		
                                          @"snow.png",				@"大雪",		
                                          @"w6.png",				@"雨夾雪",
                                          @"unknown.png",			@"風",		
                                          @"w29.png",				@"塵",		
                                          @"fog.png",				@"霧",		
                                          nil
                                          ];
        
        NSString* strFileName = [dctFlName objectForKey:strWeaDesc];
        [dctFlName release];
        if ( [strFileName isKindOfClass:[NSString class] ] )
            return strFileName; 
    }
    
    //else
    {
	NSMutableDictionary* dctFlName = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									  @"unknown.png",			@"暂无数据",
									  @"sunny.png",				@"晴",		
									  @"cloudy.png",			@"多云",		
									  @"overcast.png",			@"阴",		
									  @"showers.png",			@"阵雨",		
									  @"storm.png",				@"暴雨",		
									  @"thunderstorm.png",		@"雷阵雨",
									  @"cn_heavyrain.png",		@"大雨",	
									  @"cn_lightrain.png",		@"小雨",		
									  @"w14.png",				@"小雪",		
									  @"snow.png",				@"大雪",		
									  @"w6.png",				@"雨夹雪",
									  @"unknown.png",			@"风",		
									  @"w29.png",				@"尘",		
									  @"fog.png",				@"雾",		
									  nil
									  ];
	
	NSString* strFileName = [dctFlName objectForKey:strWeaDesc];
	[dctFlName release];
	return strFileName;
    }
}

+(NSString*) getFinalWeathRes:(NSString*)strDesc
{
	//先查图标列表
	NSString* icoFile = [WeatherFunc getWeatIconFile:strDesc];
	if (icoFile)
		return icoFile;
	
	//未找到时，修正描述后再查
	NSString* strOut = nil;
    NSRange rg;

    //不分简繁体判断了
    //if (IS_FT)
    {
        if ([PubFunction strHasStr:strDesc :@"中雪"] ||
            [PubFunction strHasStr:strDesc :@"大雪"] ||
            [PubFunction strHasStr:strDesc :@"暴雪"])
            strOut = @"大雪";
        else if ([PubFunction strHasStr:strDesc :@"暴雨"])
            strOut = @"暴雨";
        else if ([PubFunction strHasStr:strDesc :@"小雪"])
            strOut = @"小雪";
        else if ([PubFunction strHasStr:strDesc :@"雷陣雨"])
            strOut =  @"雷陣雨";
        else if ([PubFunction strHasStr:strDesc :@"大雨"] || 
                 [PubFunction strHasStr:strDesc :@"中雨"])
            strOut =  @"大雨";
        else if ([PubFunction strHasStr:strDesc :@"陣雨"])
            strOut =  @"陣雨";
        else if ([PubFunction strHasStr:strDesc :@"小雨"])
            strOut =  @"小雨";
        else if ([PubFunction strHasStr:strDesc :@"塵"])
            strOut =  @"塵";
        else if ([PubFunction strHasStr:strDesc :@"霧"])
            strOut =  @"霧";
        else if ([PubFunction strHasStr:strDesc :@"雲"] ||
                 [PubFunction strHasStr:strDesc :@"陰"])
            strOut =  @"多雲";
        else if ([PubFunction strHasStr:strDesc :@"風"])
            strOut =  @"風";
        
        if (strOut!=nil)
        {
            icoFile = [WeatherFunc getWeatIconFile:strOut];
            if (icoFile)
                return icoFile;
        }
        
        //rg = [strDesc rangeOfString:@"轉"];     
    //}
    //else
    //{
        if ([PubFunction strHasStr:strDesc :@"中雪"] ||
            [PubFunction strHasStr:strDesc :@"大雪"] ||
            [PubFunction strHasStr:strDesc :@"暴雪"])
            strOut = @"大雪";
        else if ([PubFunction strHasStr:strDesc :@"暴雨"])
            strOut = @"暴雨";
        else if ([PubFunction strHasStr:strDesc :@"小雪"])
            strOut = @"小雪";
        else if ([PubFunction strHasStr:strDesc :@"雷阵雨"])
            strOut =  @"雷阵雨";
        else if ([PubFunction strHasStr:strDesc :@"大雨"] || 
                 [PubFunction strHasStr:strDesc :@"中雨"])
            strOut =  @"大雨";
        else if ([PubFunction strHasStr:strDesc :@"阵雨"])
            strOut =  @"阵雨";
        else if ([PubFunction strHasStr:strDesc :@"小雨"])
            strOut =  @"小雨";
        else if ([PubFunction strHasStr:strDesc :@"尘"])
            strOut =  @"尘";
        else if ([PubFunction strHasStr:strDesc :@"雾"])
            strOut =  @"雾";
        else if ([PubFunction strHasStr:strDesc :@"云"] ||
                 [PubFunction strHasStr:strDesc :@"阴"])
            strOut =  @"多云";
        else if ([PubFunction strHasStr:strDesc :@"风"])
            strOut =  @"风";
        
        if (strOut!=nil)
        {
            icoFile = [WeatherFunc getWeatIconFile:strOut];
            if (icoFile)
                return icoFile;
        }
        
        rg = [strDesc rangeOfString:@"转"];
    }
    
    if (rg.location!=NSNotFound)
    {
        strOut = [strDesc substringToIndex:rg.location];
        icoFile = [WeatherFunc getWeatIconFile:strOut];
        if (icoFile)
            return icoFile;
        
        strOut = [strDesc substringFromIndex:rg.location+1];
        icoFile = [WeatherFunc getWeatIconFile:strOut];
        if (icoFile)
            return icoFile;
    }
    
    return @"unknown.png";
    
  
}
 

@end