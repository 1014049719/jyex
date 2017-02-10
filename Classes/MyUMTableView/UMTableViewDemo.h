//
//  UMTableViewDemo.h
//  Astro
//
//  Created by susn on 12-8-28.
//  Copyright (c) 2012年 网龙网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMUFPTableView.h"


@interface UMTableViewDemo : UIViewController <UITableViewDelegate, UITableViewDataSource, UMUFPTableViewDataLoadDelegate> {
    
    NSMutableArray *_mPromoterDatas;
    UMUFPTableView *_mTableView;
    
    UIView *maskView;
    UILabel *statusLabel;
    UIImageView *noNetworkImageView;
    UIActivityIndicatorView *activityIndicator;
    
}


@end
