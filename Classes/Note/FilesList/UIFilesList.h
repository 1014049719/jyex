//
//  UIFilesList.h
//  NoteBook
//
//  Created by cyl on 12-11-9.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFilesList : UIView
{
    NSMutableArray *m_FilesList;
}

-(void)drawFilesList;
@end
