//
//  UIFolderItemView2.h
//  NoteBook
//
//  Created by zd on 13-2-21.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
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

@interface UIFolderItemView2 : UIView<UIAlertViewDelegate>
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
    
    
    UIButton *m_btn3 ;//删除按钮
    BOOL m_FolderDeleteFlag ;//为YES则表示可以删除，否则不能删除，在View上不显示删除按钮
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


-(void)drawBtn3;
-(void) onDeleteFolder ;
-(void) setFolderDeleteFlag:(BOOL)flag ;

@end
