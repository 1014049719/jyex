//
//  UIFolderManage.h
//  NoteBook
//
//  Created by zd on 13-2-20.
//  Copyright (c) 2013年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderList2.h"
#import "UIFilesList.h"

@interface UIFolderManage : UIViewController
{
    IBOutlet UIButton *m_btnBack ;
    IBOutlet UIScrollView *m_viFolderScrollView;
    
    UIFolderList2 *m_FolderList;
    
@public
    NSString *m_ParentFolderID ;
}

-(void)dealloc ;

-(IBAction)OnBack:(id)sender ;
-(IBAction)OnNewFolder:(id)sender ;
-(IBAction)OnPXFolder:(id)sender ;

-(void)drawFolderList;

-(void)setParentFolderID:(NSString*)FolderID ;

- (void) reRoadFolderList;

@end
