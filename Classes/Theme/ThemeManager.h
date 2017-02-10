//
//  ThemeManager.h
//  Weather
//
//  Created by sundb on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

@interface NSString (HexValue)
-(NSUInteger)hexValue;
@end

enum  THEME_TYPE{
	DARK_BLUE, LIGHT_YELLOW
};

@interface ThemeManager : NSObject{
    
    // 主题列表
    NSDictionary        *themeDictionary;
    
    // 当前主题图片列表
    NSDictionary        *themeImages;
    
    // 当前主题颜色列表
    NSDictionary        *themeColors;
    
    // 当前主题名
    NSString            *currentTheme;
    
    // 图片缓存
    NSMutableDictionary *imageCache;
    
    // 颜色缓存
    NSMutableDictionary *colorCache;
	
	// 主题的类型
	enum THEME_TYPE themeType;
}

@property(nonatomic,retain) NSDictionary *themeDictionary;
@property(nonatomic,retain) NSDictionary *themeImages;
@property(nonatomic,retain) NSDictionary *themeColors;
@property(nonatomic,retain) NSDictionary *imageCache;
@property(nonatomic,retain) NSDictionary *colorCache;
@property(nonatomic,copy) NSString       *currentTheme;
@property(nonatomic) enum THEME_TYPE themeType;

+ (ThemeManager *)sharedThemeManager;
- (void)notifyThemeChaneged;
- (UIImage *)imageWithStyle:(NSString *)styleName;
- (UIColor *)colorWithStyle:(NSString *)styleName;
- (void)setThemeName:(NSString *)theme;

@end
