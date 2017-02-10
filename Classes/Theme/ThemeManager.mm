//
//  ThemeManager.m
//  Weather
//
//  Created by sundb on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ThemeManager.h"
#import "SBJSON.h"
#import "UIColor+Hex.h"
#import "DBMng.h"

NSString *const kThemeJsonPath = @"theme.json";

@implementation NSString(HexValue)
-(NSUInteger)hexValue
{
	const char *hexString = [self UTF8String];
	
	int num;
	
	sscanf(hexString, "%x", &num);

	return num;
	
}
@end


@implementation ThemeManager
@synthesize themeDictionary;
@synthesize themeImages;
@synthesize themeColors;
@synthesize currentTheme;
@synthesize imageCache;
@synthesize colorCache;
@synthesize themeType;

- (void)setThemeName:(NSString *)theme {
    if ([themeDictionary objectForKey:theme] == nil) {
        return;
    }
    self.currentTheme                 = theme;
    NSString     *themePath      = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[themeDictionary objectForKey:theme]];
    NSString     *themeJsonPath  = [themePath stringByAppendingPathComponent:kThemeJsonPath];
    NSString     *themeJson      = [[[NSString alloc] initWithContentsOfFile:themeJsonPath encoding:NSUTF8StringEncoding error:nil] autorelease];
	NSDictionary *themeDic       = [[themeJson JSONValue] objectForKey:@"theme"];
	if (themeDic) {
		self.themeImages             = [themeDic objectForKey:@"images"];
		self.themeColors			 = [themeDic objectForKey:@"colors"];
		self.imageCache              = nil;
		self.colorCache = nil;
		if ([theme isEqual:@"darkblue"]) {
			self.themeType = DARK_BLUE;
		} else if ([theme isEqual:@"lightyellow"]) {
			self.themeType = LIGHT_YELLOW;
		}
	}
}

-(id)init
{
    self = [super init];
    if(self)
    {
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"themes" ofType:@"plist"];
        themeDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        if ([AstroDBMng getShowOldbak]) {
			[self setThemeName:@"darkblue"];
		} else {
			[self setThemeName:@"lightyellow"];
		}
    }
    return self;
}

- (id)initWithTheme:(NSString *)theme {
    self = [super init];
    if(self)
    {
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"themes" ofType:@"plist"];
        themeDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        [self setThemeName:theme];
    }
    return self;
}

- (void)dealloc {   
    [themeDictionary release];
    [themeImages release];
    [themeColors release];
    [currentTheme release];
    [imageCache release];
    [colorCache release];
    [super dealloc];
}

+ (ThemeManager *)sharedThemeManager {
    static ThemeManager *instance = nil;
//	if (instance == nil) {
//		instance = [[ThemeManager alloc] init];
//	}
	
	@synchronized(self) {
        if (instance == nil) {
            instance = [[ThemeManager alloc] init];
        }
    }

	return instance;
}

// 获取图片路径
- (NSString *)cacheImagePathWithStyle:(NSString *)styleName {
    NSString          *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[themeDictionary objectForKey:currentTheme]];
    return [themePath  stringByAppendingPathComponent:[themeImages objectForKey:styleName]];
}

// 获取图片路径
- (NSString *)cacheColorPathWithStyle:(NSString *)styleName {
    NSString          *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:currentTheme];
    return [themePath  stringByAppendingPathComponent:[themeImages objectForKey:styleName]];
}

- (UIImage *)imageWithStyle:(NSString *)styleName {
    NSLog(@"获得主题图片 %@", styleName);
    
    if (imageCache == nil) {
        imageCache       = [[NSMutableDictionary alloc] init];
    }
    UIImage *returnImage = [imageCache objectForKey:styleName];
    if (returnImage != nil) {
        NSLog(@"返回缓存图片");
        return returnImage;
    }
    
    NSString *path = [self cacheImagePathWithStyle:styleName];
    NSLog(@"%@", path);
    returnImage    = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
    if (returnImage == nil) {
        NSLog(@"图片获取失败");
        return nil;
    }
    
    [imageCache setObject:returnImage forKey:styleName];
    return returnImage;
}


- (UIColor *)colorWithStyle:(NSString *)styleName {
    NSLog(@"获得颜色 %@", styleName);
    
    if (colorCache == nil) {
        colorCache = [[NSMutableDictionary alloc] init];
    }
    UIColor *returnColor = [colorCache objectForKey:styleName];
    if (returnColor != nil) {
        NSLog(@"返回缓存颜色");
        return returnColor;
    }
    
    NSArray *arrColor = [themeColors objectForKey:styleName];
	if (!arrColor) {
		NSLog(@"颜色不存在%@", styleName);
		return [UIColor clearColor];
	}

    CGFloat  red      = [[arrColor objectAtIndex:0] hexValue]/255.0;
    CGFloat  green    = [[arrColor objectAtIndex:1] hexValue]/255.0;
    CGFloat  blue     = [[arrColor objectAtIndex:2] hexValue]/255.0;
    CGFloat  alpha    = [[arrColor objectAtIndex:3] floatValue];
	if (alpha == 0.0) {
		return [UIColor clearColor];
	}
    returnColor       = [UIColor colorWithRed:red  green:green blue:blue alpha:alpha];
    [colorCache setObject:returnColor forKey:styleName];
    return returnColor;
}

- (void)notifyThemeChaneged {
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification
                                                        object:nil
                                                      userInfo:nil];
}

@end
