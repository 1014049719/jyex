//
//  UIAppList.h
//  NoteBook
//
//  Created by cyl on 13-4-15.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYEXUserAppInfo;

@interface UIAppList : UIView
{
    NSArray *appList;
    NSString *sHaveNoAppString;
    float m_width;
    
    UIView *vwEmptyView;
    NSObject* appDelegate;
    SEL onApp;
}

@property (nonatomic, retain) NSArray * appList;
@property (nonatomic, retain) UIView *vwEmptyView;
@property (nonatomic, retain) NSString *sHaveNoAppString;
@property (retain) NSObject* appDelegate;
@property (nonatomic, assign) SEL onApp;

-(void)drawAppListView;
-(UIView*)drawEmptyView;
-(BOOL)setButton:(UIButton*)btn Frame:(CGRect)rect AppInfo:(JYEXUserAppInfo*)appinfo Taget:(int)taget;
-(void)setTips:(int)tag msgnum:(int)msgnum;
-(void)onSelectAppButton:(id)send;
-(void)proDrawAppList;
-(void)setAppDelegate:(NSObject *)appObject Select:(SEL)appFun;


@end
