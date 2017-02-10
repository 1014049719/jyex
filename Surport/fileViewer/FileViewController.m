//
//  FileViewController.m
//  cwViewer
//
//  Created by chen wu on 09-7-6.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FileViewController.h"
#import "Constant.h"

//#define USE_UTF8

@implementation FileViewController
@synthesize filePath;
- (BOOL)isFileExist:(NSString *) path    
{
	NSFileManager *manager = [[NSFileManager alloc] init];
	BOOL ret = [manager fileExistsAtPath:path];
	[manager release];
	return ret;
}

- (id)initWithFilePath:(NSString *)path
{
	if(path == nil)
	{
		NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
		path = [userDefault objectForKey:@"Log_File_Path"];
	}
	self = [super init];
	self.filePath = path;
	return self;
}

- (void)loadView{
	//[super loadView];
	UIView * contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view = contentView;
	[contentView release];
	self.title = @"LOG FILE Viewer";
	self.navigationItem.titleView = nil;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"search"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(searchAction)]autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"path"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(openAction)] autorelease];
	tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
	tv.textColor = [UIColor brownColor];
	tv.text = @"log 查看器,点击path输入log文件的路径,下次进入时可以自动打开log文件,点击search可以查找特定文字";
	tv.font = [UIFont systemFontOfSize:20];
	[self.view addSubview:tv];
	tv.editable = NO;
	
	if([self isFileExist:filePath])
	{
		NSFileHandle * fh = [NSFileHandle fileHandleForReadingAtPath:filePath];
		NSData *fData= [fh readDataToEndOfFile];
        
#ifdef USE_UTF8
        NSStringEncoding htmlEncoding = NSUTF8StringEncoding;
#else 
        NSStringEncoding htmlEncoding = NSUnicodeStringEncoding;
#endif
        
        NSString * content = [[NSString alloc] initWithData:fData encoding:htmlEncoding];
        
		tv.text = content;
		[content release];
		[fh closeFile];
		[tv scrollRangeToVisible:NSMakeRange([tv.text length], 0)];
	}
}
- (NSString *)getPath
{
	return filePath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)searchAction
{
	sBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
	self.navigationItem.titleView = sBar;
	sBar.delegate = self;
	sBar.barStyle = self.navigationController.navigationBar.barStyle;
	//UINavigationController
	sBar.placeholder = @"搜索的文本";
	[sBar release];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)openAction
{
	tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 300, 44-16)];
	tf.placeholder = @"要显示文本的路径";
	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	tf.borderStyle = UITextBorderStyleRoundedRect;
	self.navigationItem.titleView = tf;
    
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithTitle:@"back"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(loadView)];

	self.navigationItem.leftBarButtonItem = itemleft;
    [itemleft release];
    
    UIBarButtonItem *itemright = [[UIBarButtonItem alloc] initWithTitle:@"open"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(openFile)];
	self.navigationItem.rightBarButtonItem = itemright;
    [itemright release];
    
}
- (void)openFile
{
    
	NSString * path = [tf text];
	if([self isFileExist:path])
	{
		self.filePath = path;
		NSFileHandle * file  = [NSFileHandle fileHandleForReadingAtPath:path];
		NSData *fData = [file readDataToEndOfFile];
        
#ifdef USE_UTF8
        NSStringEncoding htmlEncoding = NSUTF8StringEncoding;
#else 
        NSStringEncoding htmlEncoding = NSUnicodeStringEncoding;
#endif
        
		NSString * content = [[NSString alloc] initWithData:fData encoding:htmlEncoding];
        
        tv.text  = content;
		[content  release];
		[tv scrollRangeToVisible:NSMakeRange([tv.text length], 0)];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"search"
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(searchAction)]autorelease];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"home"
																				   style:UIBarButtonItemStyleBordered
																				  target:self
																				  action:@selector(openAction)] autorelease];
		self.title = @"LOG FILE Viewer";
		self.navigationItem.titleView = nil;
		[file closeFile];
	}
}

- (void)updateData
{
	NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:filePath forKey:@"Log_File_Path"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar's cancel button while in edit mode
	sBar.showsCancelButton = YES;
	range = NSMakeRange(0, 0);
	// flush and save the current list content in case the user cancels the search later
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	sBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //	NSString * listContent = [tv text];
    //	NSString * listForSearch = [sBar text];
    //	if([listContent length]>0&&listForSearch>0)
    //	{
    //		range = [listContent rangeOfString:listForSearch];
    //		if(range.length > 0) 
    //			[tv scrollRangeToVisible:range];
    //	}
	
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[sBar resignFirstResponder];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"search"
																			  style:UIBarButtonItemStylePlain
																			 target:self
																			 action:@selector(searchAction)]autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"path"
																			   style:UIBarButtonItemStyleBordered
																			  target:self
																			  action:@selector(openAction)] autorelease];
	self.navigationItem.titleView = nil;
	//self.title = @"Log 查看器";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSString * listContent = [tv text];
	NSString * listForSearch = [sBar text];
	if([listContent length]>0&&listForSearch>0)
	{
		range = [listContent rangeOfString:listForSearch
								   options:NSLiteralSearch
									 range:NSMakeRange(range.location,[tv.text length] - range.location)];
		if(range.length > 0) 
			[tv scrollRangeToVisible:range];
	}
	
	[sBar resignFirstResponder];
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self  updateData];
}

/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}



/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
	
	[tf release];
	[tv release];
	[super dealloc];
	
}


@end

