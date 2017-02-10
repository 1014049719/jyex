//
//  UIPictureSender.h
//  JYEX
//
//  Created by zd on 13-12-24.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAsset+AGIPC.h"
#import "CPictureSelected.h"
#import "CLImageEditor.h"
#import "PubFunction.h"

#import "BussMng.h"

@interface UIPictureSender : UIViewController<UIActionSheetDelegate,CLImageEditorDelegate,UIAlertViewDelegate>
{
    IBOutlet UIButton *btnBack  ;
    IBOutlet UIButton *btnNavFinish ;
    IBOutlet UIScrollView *svPictureList ;
    IBOutlet UIButton *btnXCName ;
    IBOutlet UILabel *lbtitle ;
    IBOutlet UILabel *lbTPZL ;//图片质量
    IBOutlet UILabel *lbXCName ;//相册名称
    IBOutlet UILabel *lbAddXPInfo;//还可加多少张相片的信息
    IBOutlet UITextField *txfPicTYMS;//照片的统一描述
    IBOutlet UILabel *m_lbXCType; //相册类别
    
    NSMutableArray *pictureList ;
    NSMutableArray *imageViewList ;
    NSMutableArray *pinLunLabelList ;
    NSString *currentXCName ;//当前相册
    NSString *currentXCID ;//当前相册ID
    NSString *currentXCUid; //当强相册uid
    NSString *currentXCUsername; //当前相册用户名
    
    int curEditSelectPicture ;//当前选择编辑相片索引
    
    IBOutlet UIImageView *ivFlag ;
    BOOL EditSelect ;
    CLImageEditor *editor ;
    UIImage *imageTemp ;
    
    //UIView *vWait ;
    BOOL Wait ;
    BOOL bFirst;
    //UIWindow *waitWindow ;
    int PictureZL ; //图片质量 0:普通(L)  1:高清(M)  2:原图(H)
    
    
    BOOL bCameraFirst;
    
    NSDictionary *callDic ;//提供网页调用传递参数用
    
    //参数
    MsgParam* msgParam;
    
    BussMng* bussRequest;

}

@property(nonatomic,retain)NSMutableArray *pictureList ;
@property(nonatomic,retain)NSMutableArray *imageViewList ;
@property(nonatomic,retain)NSMutableArray *pinLunLabelList ;
@property(nonatomic,copy)NSString *currentXCName ;
@property(nonatomic,copy)NSString *currentXCID ;
@property(nonatomic,copy)NSString *currentXCUid ;
@property(nonatomic,copy)NSString *currentXCUsername ;
@property(nonatomic,assign)int curEditSelectPicture ;
@property(nonatomic,assign,setter=SetSelect:)BOOL EditSelect ;
@property(nonatomic,readonly,getter = GetPictureFileList)NSArray *PictureFileList ;
@property(nonatomic,setter = setWait:)BOOL Wait ;
@property(nonatomic,assign)int PictureZL ;
@property(nonatomic,retain)NSDictionary *callDic ;
@property (nonatomic,retain) MsgParam* msgParam;
@property(nonatomic,retain) BussMng *bussRequest;


- (IBAction)onCancel:(id)sender ;
- (IBAction)onOK:(id)sender ;
- (IBAction)onSelectXC:(id)sender ;
- (IBAction)onAddPicture:(id)sender ;
- (IBAction)onPictureZL:(id)sender ;

//add by zd 2015-01-12
- (IBAction)onAddPictureFromCamera:(id)sender;
- (IBAction)onAddPictureFromAlbum:(id)sender;


- (void)clickPicture:(id)sender ;
- (CGRect)getImageFrame:(int)index ;
- (CGRect)getPinLunLabelFrame:(int)index ;
- (void)pictureSelect:(NSMutableArray*)pictureArray ;
- (void)removeAllImageView ;
//- (void)setXCName:(NSString*)name ;
- (void)setXCName:(NSDictionary*)dic ;
- (void)SetSelect:(BOOL)flag ;

//选择取消
- (void)pictureIsCancel;

- (void)GetSelectedPictureList:(NSMutableDictionary*)dic ;


//- (void)saveSelectPicture ;//保存选择上传的图片

- (void)saveSelectPicture:(CPictureSelected*)pic ;

- (void)updateImageToImageView:(CPictureSelected*)pic ;

- (BOOL)pictureIsSelected:(ALAsset*)pic ;

- (CPictureSelected*)findPictureSelected:(int) ID ;

- (UIImageView*)findEditImageView:(int)ID ;

- (void)deleteSelectPicture ;

- (void)deleteAllPicture ;

- (NSArray*)GetPictureFileList ;

- (void)setWait:(BOOL)wait ;

- (void)updatePictureZL:(NSNumber*) pzl ;

//改变图片质量时重新生成图片
- (void)reSavePicture ;

//add by zd 2015-01-12
//更新还可增加多少张相片
- (void)updateAddPicInfo:(NSString*)info ;

- (void)loadCamera;

- (IBAction)textFiledReturnEditing:(id)sender ;

- (UILabel*)createPinLunLabel:(CGRect)frame;

@end
