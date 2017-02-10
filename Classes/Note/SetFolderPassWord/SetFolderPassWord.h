//
//  SetFolderPassWord.h
//  NoteBook
//
//  Created by mwt on 12-11-20.
//  Copyright (c) 2012年 网龙网络有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetFolderPassWord : UIViewController{
    IBOutlet UIButton *m_btnFinish ;
    IBOutlet UITextField *m_txfPassWord1 ;
    IBOutlet UITextField *m_txfPassWord2 ;
}

-(IBAction)OnFinish:(id)sender ;

-(void) DrawView;
@end
