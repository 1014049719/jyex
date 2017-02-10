//
//  MBUpLoadItemMsg.h
//  pass91
//
//  Created by Zhaolin He on 09-9-4.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSocket.h"
#import "MBBaseStruct.h"

@interface MBUpLoadItemMsg : PSocket {
    
}
+ (PSocket*)shareMsg;
-(void)uploadWithUserInfo:(NSData *)data content:(CMBItemNew *)item;
@end
