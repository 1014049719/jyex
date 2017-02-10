//
//  MBNoteThumbMsg.h
//  NoteBook
//
//  Created by wangsc on 10-10-25.
//  Copyright 2010 ND. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBBaseStruct.h"
#import "PSocket.h"


@interface MBNoteThumbMsg : PSocket {

}
+ (PSocket*)shareMsg;
-(void)sendPacketWithData:(NSData *)data noteID:(GUID)guidNote version:(uint32_t)version imgWidth:(uint32_t)nWidth imgHeight:(uint32_t)nHeight;

@end
