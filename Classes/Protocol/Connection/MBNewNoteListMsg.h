//
//  MBNewNoteListMsg.h
//  NoteBook
//
//  Created by wangsc on 10-10-11.
//  Copyright 2010 ND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSocket.h"
#import "MBBaseStruct.h"

@interface MBNewNoteListMsg : PSocket 
{
    
}
+ (PSocket*)shareMsg;
-(void)sendPacketWithData:(NSData *)data fromVersion:(int)version count:(int)count;
@end
