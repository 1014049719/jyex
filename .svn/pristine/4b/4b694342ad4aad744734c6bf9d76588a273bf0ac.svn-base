//
//  UIRegisterVC.h
//  JYEX
//
//  Created by zd on 14-4-25.
//  Copyright (c) 2014年 广州洋基. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussMng.h"


@interface UIRegisterVC : UIViewController
{
    IBOutlet UITextField *txfPhoneNumber ;
    IBOutlet UITextField *txfName ;
    IBOutlet UITextField *txfNC ;
    IBOutlet UITextField *txfPassWord1 ;
    IBOutlet UITextField *txfPassWord2 ;
    IBOutlet UITextField *txfMail ;
    IBOutlet UIScrollView *svMain ;
    
    
    id callBackObject ;
    SEL callBackSEL ;
    
    BussMng* bussRequest;
}
@property(nonatomic,assign)id callBackObject ;
@property(nonatomic,assign)SEL callBackSEL ;

@property (nonatomic,retain) BussMng *bussRequest;


- (IBAction)onGoBack:(id)sender ;

- (IBAction)onRegister:(id)sender ;

@end
