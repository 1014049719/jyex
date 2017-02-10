//
//  SelectFolderIcon.h
//  NoteBook
//
//  Created by mwt on 12-11-20.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PubFunction.h"

@interface SelectFolderIcon : UIViewController{
    IBOutlet UIButton *m_btnBack ;
    IBOutlet UIButton *m_btnFinish ;
    
    MsgParam* msgParam;
}

@property (nonatomic, retain) MsgParam* msgParam;

-(void)dealloc ;

-(IBAction)OnBack:(id)sender;
-(IBAction)OnFinish:(id)sender;

-(IBAction)OnFolderIcon:(id)sender ;
@end
