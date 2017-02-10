//
//  FileViewController.h
//  cwViewer
//
//  Created by chen wu on 09-7-6.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController<UITextViewDelegate,UISearchBarDelegate> {
	UISearchBar * sBar;
	UITextView  * tv;
	UITextField * tf;
	NSRange range;
	NSString * filePath;
}
- (BOOL)isFileExist:(NSString *) path;
- (id)initWithFilePath:(NSString *)path;
- (void)updateData;
@property(nonatomic,retain)NSString * filePath;
@end
