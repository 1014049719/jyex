//
//  UIPictureZLVC.h
//  JYEX
//
//  Created by zd on 14-4-14.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPictureZLVC : UIViewController
{
    IBOutlet UIImageView *viL ;
    IBOutlet UIImageView *viM ;
    IBOutlet UIImageView *viH ;
    
    int curPictureZL ;
    
    id callbackObject ;
    SEL callbackSEL ;
}
@property(assign,nonatomic)int curPictureZL ;
@property(assign,nonatomic)id callbackObject ;
@property(assign,nonatomic)SEL callbackSEL ;

- (IBAction)onGoBack:(id)sender ;
- (IBAction)onPictureZLL:(id)sender ;
- (IBAction)onPictureZLM:(id)sender ;
- (IBAction)onPictureZLH:(id)sender ;

@end
