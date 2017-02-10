//
//  UIPresentImage.h
//  NoteBook
//
//  Created by susn on 13-1-17.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RTEGestureRecognizer.h"


@interface UIPresentImage : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    IBOutlet UIScrollView *m_scrollView;
    IBOutlet UIImageView *m_imageView; 
    IBOutlet UINavigationBar	*navigationBar;
    IBOutlet UIToolbar *m_Toolbar;
    IBOutlet UIBarButtonItem *m_btnLastImage;
    IBOutlet UIBarButtonItem *m_btnNextImage;
    IBOutlet UIBarButtonItem *m_btnJump;
    
    NSArray *m_arrItem;
    int m_pos;
    
    CGPoint hintpoint;
    RTEGestureRecognizer *_singleRecognizer;
    CGFloat xoffset;
    
    NSString *strUrl;
    
}

@property (nonatomic,retain) NSArray *m_arrItem;
@property (nonatomic,assign) int m_pos;
@property (nonatomic,assign) NSString *strUrl;

- (IBAction) onToolCancel:(id)sender;
- (IBAction) onToolLast:(id)sender;
- (IBAction) onToolNext:(id)sender;
- (IBAction) onToolOprNote:(id)sender;
- (IBAction)onJumpURL:(id)sender;

-(void)showTitle;
-(void)showJumpURLBtn:(BOOL)show;
-(void)dispImage;
-(void)savePhotoToAlbumWithIndex:(NSInteger)index;
-(void)saveAllPhoto;
-(void)setUrl:(NSString *)url;
-(void)execSyncAfterThreeSeconds;


@end
