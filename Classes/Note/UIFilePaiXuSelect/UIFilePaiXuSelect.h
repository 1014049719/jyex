//
//  UIFilePaiXuSelect.h
//  NoteBook
//
//  Created by zd on 13-3-4.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolder.h"

@interface UIFilePaiXuSelect : UIViewController
{
    IBOutlet UIImageView  *m_imgaview11 ;
    IBOutlet UIImageView  *m_imgaview12 ;
    IBOutlet UIImageView  *m_imgaview21 ;
    IBOutlet UIImageView  *m_imgaview22 ;
    IBOutlet UIImageView  *m_imgaview31 ;
    IBOutlet UIImageView  *m_imgaview32 ;
    IBOutlet UIImageView  *m_imgaview41 ;
    IBOutlet UIImageView  *m_imgaview42 ;
    IBOutlet UIImageView  *m_imgaview51 ;
    IBOutlet UIImageView  *m_imgaview52 ;
    
    UIViewController* vcParent;
	SEL	closeCallback;
    
    int PaiXuYiJu; //排序依据：1~5
    int PaiXuFangShi ; //排序方式：降序(1) or 升序(2)
}

@property (nonatomic, assign) UIViewController* vcParent;
@property (nonatomic, assign) SEL closeCallback;
@property int PaiXuYiJu ;//排序依据：1~5
@property int PaiXuFangShi; //排序方式：降序(1) or 升序(2)

- (void)dealloc;

+ (UIViewController*) addToWnd :(UIViewController*)vcParent :(SEL)closeCallback;

- (IBAction)OnBack:(id)sender ;

- (IBAction)OnPaiXuSelect:(id)sender ;//排序依据选择

- (IBAction)OnPaiXuFangShi:(id)sender ;// 降序 or 升序

@end
