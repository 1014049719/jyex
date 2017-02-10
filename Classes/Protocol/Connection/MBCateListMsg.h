//
//  MBCateListMsg.h
//  NoteBook
//
//  Created by wangsc on 10-9-28.
//  Copyright 2010 ND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSocket.h"
#import "MBBaseStruct.h"

@interface MBCateListMsg : PSocket {
    
}
+ (PSocket*)shareMsg;
-(void)sendPacketWithData:(NSData *)data parentGUID:(GUID)guidDir version:(unsigned int)dwVerFrom;
@end
