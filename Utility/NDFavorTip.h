//
//  NDFavorTip.h
//  SparkEnglish
//
//  Created by nd on 11-5-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NDFavorTip : NSObject {	
	UILabel *lbTip;
}


+ (NDFavorTip *) getInstance;
- (void) SetTip: (UILabel*)lb : (NSString*)tip : (float)delay;
@end
