//
//  MBSubDirListMsg.h
//  pass91
//
//  Created by Zhaolin He on 09-9-2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSocket.h"
#import "MBBaseStruct.h"

@interface MBSubDirListMsg : PSocket {
    
}
+ (PSocket*)shareMsg;
-(void)sendPacketWithData:(NSData *)data parentGUID:(GUID)guidDir version:(unsigned int)dwVerFrom;
@end
