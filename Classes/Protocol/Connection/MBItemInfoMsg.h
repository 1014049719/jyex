//
//  MBItemInfoMsg.h
//  pass91
//
//  Created by Zhaolin He on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBBaseStruct.h"
#import "PSocket.h"

@interface MBItemInfoMsg : PSocket {
	
}
+ (PSocket*)shareMsg;
-(void)sendPacketWithData:(NSData *)data ItemID:(GUID)guidItem version:(unsigned int)dwCurVer a2binfo:(A2BInfo &)info;
@end
