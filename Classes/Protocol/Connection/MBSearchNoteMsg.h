//
//  MBSearchNoteMsg.h
//  NoteBook
//
//  Created by wangsc on 10-10-19.
//  Copyright 2010 ND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSocket.h"
#import "MBBaseStruct.h"


@interface MBSearchNoteMsg :  PSocket
{
    
}
+ (PSocket*)shareMsg;
-(void)sendPacketWithData:(NSData *)data searchWord:(unistring)searchWord count:(int)count;
@end
