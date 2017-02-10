//
//  MBA2BListMsg.h
//  pass91
//
//  Created by Zhaolin He on 09-9-7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBBaseStruct.h"
#import "PSocket.h"

@interface MBA2BListMsg : PSocket 
{
    
}
+ (PSocket*)shareMsg;
-(void)sendPacketWithData:(NSData *)data NoteID:(GUID)guidA version:(unsigned int)dwVerFrom;
@end
