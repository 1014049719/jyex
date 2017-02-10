//
//  UIFolderItrmView.h
//  NoteBook
//
//  Created by cyl on 12-10-30.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "DBMngAll.h"

#define FOLDER_BACKGROUND_1 1
#define FOLDER_BACKGROUND_2 2
#define FOLDER_BACKGROUND_3 3
#define FOLDER_BACKGROUND_4 4
#define FOLDER_BACKGROUND_5 5

#define FOLDER_ICON_1 1
#define FOLDER_ICON_2 2
#define FOLDER_ICON_3 3
#define FOLDER_ICON_4 4
#define FOLDER_ICON_5 5

@interface UIFolderItemView : UIView
{
    UIImageView *m_ivBackground;
    UIImageView *m_ivBackgroundSelect;
    UIImageView *m_ivIcon;
    UILabel *m_labelTitle;
    UILabel *m_labelNumOfFile;
    UILabel *m_labelNumOfNewFile;
    UIButton *m_btn1;
    UIButton *m_btn2;
    float m_fy;
    float m_fTop;
    
@public
    int m_IconIndex;
    int m_BackgroundIndex;
    NSString *m_FolderName;
    int m_NumOfFile;
    int m_NumOfNewFile;
    NSString* m_strFolderId;
    int m_iOrder;
}


-(void)drawFolderItem;
-(void)drawBackground;
-(float)drawIconWitOringin:(float)x;
-(float)drawFolderNameWithOriginX:(float) x;
-(float)drawFileWithEndX:(float)x WithType:(int)type;
-(void)drawBtn2;
-(void)drawBtn1;
-(void)setCenter:(BOOL)center;
-(void)setInforWithCateInfor:(TCateInfo *)cateinfor;
- (void) onSelect:(id)sender;
-(void) onDown:(id)sender;
@end
