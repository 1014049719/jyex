//
//  UIVCSettingBlogSet.m
//  Weather
//
//  Created by nd on 11-11-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIVCSettingBlogSet.h"
#import "UIAstroAlert.h"
#import "BlogIntf.h"
#import "UIVCSettingBlogBind.h"
#import <unistd.h>

@implementation UIVCSettingBlogSet

@synthesize dbData;
@synthesize btnSwitchUnbind;
@synthesize tableViewBind;
@synthesize msgParam;


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (IS_FT)
    {
        lbCap.text = LOC_STR("bg_wbfxsz");
        lbSZJJ.text = LOC_STR("bg_szjj");
        [btnSwitchUnbind setTitle:LOC_STR("bg_qxgl") forState:UIControlStateNormal];
    }
    
    
    [self.tableViewBind setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
	self.dbData = [[BlogIntf instance] GetBlogList];
    
    if (dbData.count==0) 
    {
        //[UIAstroAlert info:LOC_STR("bg_zzcx") :0.0 :YES :LOC_MID :NO];
        [UIAstroAlert info:LOC_STR("bg_zzcx") :YES :YES];  //改为阻塞方式，update 2012.10.15
        [self performSelectorInBackground:@selector(queryBindListInBackground) withObject:nil];
    }
    else
        [tableViewBind reloadData];
}


#pragma mark -
#pragma mark IBActions
- (IBAction)returnBtnPress:(id)sender
{ 
    [UIAstroAlert infoCancel];
 
    if (msgParam!=nil)
    {
        /*
        NSString *result = nil;
        for (SNSInfo* info in dbData)
        {
            if (info.isBind)
            {
                result = @"bind";
                break;
            }
        }
        */
		[msgParam.obsv performSelector:msgParam.callback withObject:nil];
    }
    
    isBack = YES;
    [PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
}

- (IBAction)btnSwitchUnbindClick:(id)sender 
{
    unbind_state = !unbind_state;
	
 //   UIImage *image = nil;

	if (unbind_state) {
		[self.btnSwitchUnbind setTitle: @"完成" forState:UIControlStateNormal];
//		image = [[UIImage imageNamed:@"02.btn_分享_01.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];		
	} else {
		[self.btnSwitchUnbind setTitle: LOC_STR("bg_qxgl") forState:UIControlStateNormal];
//		image = [[UIImage imageNamed:@"btn_comm_01_normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];		
	}
	
    [tableViewBind reloadData];
}

#pragma mark -
#pragma mark 监视blog list发生修改操作
- (void) refreshTableViewOnMainThread {
    
    if (isBack)
    {
        [self retain];
        [self performSelector:@selector(release) withObject:nil afterDelay:0.1];
        return;
    }
    
    self.dbData = [[BlogIntf instance] GetBlogList];
    [tableViewBind reloadData];
} 

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context  {
    // 监视到blog list发生修改操作，重新刷新界面
	if ([keyPath isEqualToString:@"list"]) {
        [self performSelectorOnMainThread:@selector(refreshTableViewOnMainThread) withObject:nil waitUntilDone:NO];     
    }
}

#pragma mark -
#pragma mark 查询绑定列表/绑定/查询/取消绑定

- (void) refreshBindListOnMainThread:(NSNumber*)success 
{
    //add 2012.8.20 ,取消正在查询的对话框
    [UIAstroAlert infoCancel];
    
    if (isBack)
    {
        [self retain];
        [self performSelector:@selector(release) withObject:nil afterDelay:0.1];
        return;
    }
    
    if ([success boolValue]) 
    {
        self.dbData = [[BlogIntf instance] GetBlogList];
        [tableViewBind reloadData];
    } 
    else
        [UIAstroAlert info:LOC_STR("bg_qjc") :3.0 :NO :LOC_MID :NO];
}

/*
    {
        [PubFunction showTipMessage:LOC_STR("bg_qjc") withImageNamed: @"icon_checkmark_02.png" inSeconds:2];
        
        // 释放窗口		
		if ([[BlogIntf instance] IsBinded])
		{
			[PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
		}
		else
		{
			[PubFunction SendMessageToViewCenter:NMBack :2 :1 :nil];
		}
    }
*/

- (void) queryBindListInBackground
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:6.0];
    BOOL success = [[BlogIntf instance] ReqBlogList]; 
    NSNumber *num = [NSNumber numberWithBool:success];
    [self performSelectorOnMainThread:@selector(refreshBindListOnMainThread:) withObject:num waitUntilDone:NO]; 
    
    [pool release];
}

- (IBAction)btnBindClick: (id)sender
{  
    UIView *cell = [[sender superview] superview];
    if (cell && [cell isKindOfClass:[UITableViewCell class]]) 
    {
        NSInteger index = cell.tag;
        
        SNSInfo* info = (SNSInfo*)[dbData objectAtIndex:index];
        BlogBindParam *bp = [BlogBindParam param:info.snsName :info.snsType :BBP_BindtoSNS];
        MsgParam *param = [MsgParam param:nil :nil :bp :0];
        
        [PubFunction SendMessageToViewCenter:NMSettingBlogBind :0 :1 :param];
        
/*        if (vcBind == nil)
            vcBind = [[UIVCSettingBlogBind alloc] initWithNibName:@"UIVCSettingBlogBind" bundle:nil];
        vcBind.snsType = ((SNSInfo*)[dbData objectAtIndex:index]).snsType;
        vcBind.snsName = ((SNSInfo*)[dbData objectAtIndex:index]).snsName;
        [vcBind.view setOpaque:YES]; // force view to be loaded!
        vcBind.indicateView.hidden = NO;
        [vcBind.indicateView startAnimating];
        [self.navigationController pushViewController:vcBind animated:NO];
        [vcBind bindToSNS];
 */
    }
}


- (IBAction)btnUnbindClick: (id)sender
{
    UIView *cell = [[sender superview] superview];
    if (cell && [cell isKindOfClass:[UITableViewCell class]]) 
    {
        NSInteger index = cell.tag;
        
        SNSInfo* info = (SNSInfo*)[dbData objectAtIndex:index];
        BlogBindParam *bp = [BlogBindParam param:info.snsName :info.snsType :BBP_Unbind];
        MsgParam *param = [MsgParam param:nil :nil :bp :0];
        
        [PubFunction SendMessageToViewCenter:NMSettingBlogBind :0 :1 :param];
        
//        if (vcBind == nil)
//            vcBind = [[UIVCSettingBlogBind alloc] initWithNibName:@"UIVCSettingBlogBind" bundle:nil];
//        vcBind.snsType = ((SNSInfo*)[dbData objectAtIndex:index]).snsType;
//        vcBind.snsName = ((SNSInfo*)[dbData objectAtIndex:index]).snsName;
//        [vcBind.view setOpaque:YES]; // force view to be loaded!
//        vcBind.indicateView.hidden = NO;
//        [vcBind.indicateView startAnimating];
//        [self.navigationController pushViewController:vcBind animated:NO];
//        [vcBind unbindStatus];
    }
}

- (IBAction)btnQueryBindClick: (id)sender 
{
    UIView *cell = [[sender superview] superview];
    if (cell && [cell isKindOfClass:[UITableViewCell class]]) 
    {
        NSInteger index = cell.tag;
        
        SNSInfo* info = (SNSInfo*)[dbData objectAtIndex:index];
        BlogBindParam *bp = [BlogBindParam param:info.snsName :info.snsType :BBP_QueryStatus];
        MsgParam *param = [MsgParam param:nil :nil :bp :0];
        
        [PubFunction SendMessageToViewCenter:NMSettingBlogBind :0 :1 :param];
        	
//        if (vcBind == nil)
//            vcBind = [[UIVCSettingBlogBind alloc] initWithNibName:@"UIVCSettingBlogBind" bundle:nil];
//        vcBind.snsType = ((SNSInfo*)[dbData objectAtIndex:index]).snsType;
//        vcBind.snsName = ((SNSInfo*)[dbData objectAtIndex:index]).snsName;
//        [vcBind.view setOpaque:YES]; // force view to be loaded!
//        vcBind.indicateView.hidden = NO;
//        [vcBind.indicateView startAnimating];
//        [self.navigationController pushViewController:vcBind animated:NO];
//        [vcBind queryBindStatus];
    }
}


#pragma mark -
#pragma mark view delegate functioins.
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        [[BlogIntf instance] addObserver:self forKeyPath:@"list" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        unbind_state = NO;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


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
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableViewBind = nil;
    self.btnSwitchUnbind = nil;
}

- (void)dealloc {
    
    [[BlogIntf instance] removeObserver:self forKeyPath:@"list"];  
    
    self.tableViewBind = nil;
    self.btnSwitchUnbind = nil;
    self.msgParam = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//	NSInteger n; 
//	n = [self.dbData count]; 	
//    return n;
    return dbData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
	
	NSInteger  index = indexPath.row;
	SNSInfo *info = (SNSInfo*)[dbData objectAtIndex:index];
	
	UIImageView *img; 
	UILabel *lbName;
    UIImageView *imageView;
	UIButton *btnBind;
	UIButton *btnUnbind;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellTableIdentifier] autorelease]; 
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		img = [[UIImageView alloc]init]; 
		img.frame = CGRectMake(10, 11, 40, 40);
		img.tag = 11;
		[cell.contentView addSubview:img];
		[img release];
		
		lbName = [[UILabel alloc]init];
		lbName.frame = CGRectMake(57, 11, 120, 40);
		lbName.tag = 12;
		lbName.backgroundColor = [UIColor clearColor];
		
		[cell.contentView addSubview:lbName];
		[lbName release]; 
		
        imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"16.箭头.png"]]autorelease];
        imageView.tag = 13;
		imageView.frame = CGRectMake(298, 25, 9, 14);
        [cell.contentView addSubview:imageView];
        
		btnBind = [UIButton buttonWithType:UIButtonTypeCustom];
		btnBind.frame = CGRectMake(229, 17, 80, 28);
		btnBind.tag = 14;
		
		btnBind.titleLabel.shadowColor = [UIColor blackColor];
        
        //t_listmsg_highlight
		btnBind.titleLabel.textColor = [UIColor colorWithRed:126 green:184 blue:17 alpha:1.0];
		
        [cell.contentView addSubview:btnBind]; 
        
		btnUnbind = [UIButton buttonWithType:UIButtonTypeCustom];
		btnUnbind.frame = CGRectMake(225,18, 85, 28);
		btnUnbind.tag = 15;
		
		btnUnbind.titleLabel.shadowColor = [UIColor blackColor];
        
        //"t_alert_info_memo"
		btnUnbind.titleLabel.textColor = [UIColor colorWithRed:204 green:204 blue:204 alpha:1.0];
		[cell.contentView addSubview:btnUnbind]; 
        
		UIImageView *imageLineDot = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 320, 1)] autorelease];
		imageLineDot.image = [UIImage imageNamed:@"line_dotted.png"]; 
		[cell.contentView addSubview:imageLineDot];
	}
	cell.tag = index; 	
	img = (UIImageView*)[cell.contentView viewWithTag:11];
	NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent: info.logoCache];
	img.image = [UIImage imageWithContentsOfFile:pngPath];
	
	lbName = (UILabel*)[cell.contentView viewWithTag:12];
	lbName.text = info.snsName;
	lbName.font = [UIFont fontWithName:@"Helvetica" size:19];

    imageView = (UIImageView*)[cell.contentView viewWithTag:13];
    imageView.hidden = YES;

	btnBind = (UIButton*)[cell.contentView viewWithTag:14];
    btnBind.hidden = YES;
    btnBind.enabled = YES;
	btnBind.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [btnBind removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];

    btnUnbind = (UIButton*)[cell.contentView viewWithTag:15];
    btnUnbind.hidden = YES;
    [btnUnbind removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    
    if (unbind_state) {
        [btnUnbind setTitle:@"取消" forState:UIControlStateNormal];
		[btnUnbind.titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:15]];
        UIImage *image = [[UIImage imageNamed:@"02.btn_分享_01.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
		[btnUnbind setBackgroundImage: image forState:UIControlStateNormal];
        if (info.isBind) {
            btnUnbind.hidden = NO;
            [btnUnbind addTarget:self action:@selector(btnUnbindClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btnBind setTitle:LOC_STR("bg_wgl") forState:UIControlStateNormal];
            [btnBind setTitleColor:[UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1.0] forState:UIControlStateNormal];
            btnBind.hidden = NO;
            btnBind.enabled = NO;
        }
    } else {
        btnBind.hidden = NO;
        imageView.hidden = NO;
        if (info.isBind) {
            [btnBind setTitle:LOC_STR("bg_ygl") forState:UIControlStateNormal];
            [btnBind setTitleColor:[UIColor colorWithRed:0.27 green:0.65 blue:0.12 alpha:1.0] forState:UIControlStateNormal];
            [btnBind addTarget:self action:@selector(btnQueryBindClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btnBind setTitle:LOC_STR("bg_wgl") forState:UIControlStateNormal];
            [btnBind setTitleColor:[UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1.0] forState:UIControlStateNormal];
            [btnBind addTarget:self action:@selector(btnBindClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
	
    return cell;
}


@end
