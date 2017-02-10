//
//  UIFilesItem.h
//  NoteBook
//
//  Created by cyl on 12-11-6.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BizLogicAll.h"
#import  "DBMngAll.h"

@interface UIFilesItem : UIView<UIScrollViewDelegate>
{
    @public
    UIScrollView *m_scrollFileContent;
    UIView *m_viewContent;
    UIView *m_BackGroundLeft;
    UIView *m_BackGroundRight;
    UIView *m_viewFile;
    
    UILabel *m_labelDay;
    UILabel *m_labelWeek;
    UIView *m_viewDay;
    
    UILabel *m_labelTitle;
    UILabel *m_labelSynopsis;
    
    UIImageView *m_picture ;
    
    float m_LeftMargin;
    CGSize m_sizeScreen;
    int m_iChehuaType;  //0:无侧滑,1:右滑,2:左滑
    float m_fOffSet;
    
    
@public
    NSString *m_Title;
    NSString *m_Synopsis;
    int m_Day;
    int m_Week;
    int m_Year;
    int m_Month;
    NSString *m_strFilesGUID;
    TNoteInfo *m_noteInfor;
}

+(NSString*)getWeekWithInt:(NSUInteger)week;
- (id)initWithFrame:(CGRect)frame FilesInfo:(TNoteInfo*)noteInfor;
-(void)drawFileItem;
-(void)freeItem;
-(void)onSelectBKButton:(id)sender;
@end
