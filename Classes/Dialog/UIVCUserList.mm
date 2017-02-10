//
//  UIVCUserList.m
//  Astro
//
//  Created by nd on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/CAAnimation.h>
//#import <QuartzCore/CATransaction.h>
#import "UIVCUserList.h"
#import "UIMakePeople.h"
#import "UIAstroAlert.h"

#import "PubFunction.h"
#import "GlobalVar.h"
#import "DBMng.h"
//#import "Calendar.h"



@implementation UIVCUserList

@synthesize vcParent;
@synthesize closeCallback;
@synthesize peopleList;
@synthesize bussMngUiLogin;
//@synthesize vcMakePeople;

//@synthesize listView;

+ (UIViewController*) addToWnd :(UIViewController*)vcParent :(SEL)closeCallback;
{ 
	UIVCUserList *vc = [[UIVCUserList alloc] initWithNibName:@"UIVCUserList" bundle:nil];
	[vc autorelease];
	
	vc.vcParent = vcParent;
	vc.closeCallback = closeCallback;
	vc.view.frame = CGRectMake(0, 0, 320, 480);
	//[[[UIApplication sharedApplication] keyWindow] addSubview:vc.view];
	[vcParent.view addSubview:vc.view];
	return vc;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    sclView.delegate = self;
    sclView.pagingEnabled = YES;
    
    if (TheCurUser==nil || TheCurUser==NULL
        || [PubFunction stringIsNullOrEmpty:TheCurUser.sUserName]
        || [PubFunction stringIsNullOrEmpty:TheCurUser.sPassword]
        || [TheCurUser.sUserName isEqualToString:CS_DEFAULTACCOUNT_USERNAME])
        [btnLogin setTitle:LOC_STR("ul_dr") forState:UIControlStateNormal];
    else
    {
        [btnLogin setTitle:TheCurUser.sUserName forState:UIControlStateNormal];
        [self onTouchDown:btnLogin];
    }
    
    btnRect = btnDemon.frame;
    //init list;
    NSString* curGuid = TheCurPeople.sGuid;
	self.peopleList = [AstroDBMng getBeShownPeopleInfoList];
    [peopleList sortUsingSelector:@selector(compareByName:)];
    if (peopleList.count > 12*9-1)
        [peopleList removeObjectsInRange:NSMakeRange(12*9-1, peopleList.count-(12*9-1))];
    
    //find host;
    TPeopleInfo* host=nil;
	int hostIdx = -1;
    for (TPeopleInfo* p in peopleList)
    {
        hostIdx++;
        if (p.bIsHost)
        {
            host = p;
            break;
        }
    }
    
    //find demon;
    TPeopleInfo* demon=nil;
	int demonIdx = -1;
    for (TPeopleInfo* p in peopleList)
    {
        demonIdx++;
        if ([p isDemo])
        {
            demon = p;
            break;
        }
    }


    
    //cacul page num;
    int n = peopleList.count;
    
    if (n%2)
        n += 1;
    else
        n += 2;
    
    int pages = n/12;
    if (n%12) pages++;
    
    CGSize size = sclView.frame.size;
    float wd = size.width;
    size.width *= pages;
    sclView.contentSize = size;
    CGRect f = lbHor.frame;
    f.size.width = size.width;
    lbHor.frame = f;
    float yOffset = f.origin.y;
    for (int i=0; i<5; i++)
    {
        yOffset += 45;
        [self addHorLine:yOffset];
    }
    
    float xOffset = 0;
    for (int i=1; i<pages; i++)
    {
        xOffset += wd;
        [self addVerLine:xOffset];
        [self addVerLine:xOffset+154];
        [self addVerLine:xOffset+308];
    }
    
    
    //add host
    int i = 0;
    if (host!=nil)
    {
        NSString* name = [PubFunction replaceStr:host.sPersonName :@"-" :@""];
        name = [name stringByAppendingString:@" (主人)"];
        BOOL curSelected = [host.sGuid isEqualToString:curGuid];
        [self addItem:name :curSelected :hostIdx+100 :i++];
        if (curSelected)
            curTag = hostIdx+100;
    }
    
    //add others
	int idx = -1;
	for (TPeopleInfo* p in peopleList)
	{
		idx++;
		if (p==host || p==demon) continue;
        
        NSString* name = [PubFunction replaceStr:p.sPersonName :@"-" :@""];
        BOOL curSelected = [p.sGuid isEqualToString:curGuid];
		[self addItem:name :curSelected :idx+100 :i++];
        if (curSelected)
			curTag = idx+100;
	}
	
    //add demon
	if (demon!=nil)
	{
        NSString* name = [PubFunction replaceStr:demon.sPersonName :@"-" :@""];
        name = [name stringByAppendingString:@" (演示)"];
        [btnDemon setTitle:name forState:UIControlStateNormal];
        btnDemon.tag = demonIdx + 100;
		if ([demon.sGuid isEqualToString:curGuid])
        {
            btnDemon.selected = YES;
            curTag =  btnDemon.tag;
        }
        if (i%2!=0) i++;
        
        btnDemon.frame = [self caculBtnRect:i];
        [sclView bringSubviewToFront:btnDemon];
	}
    
    //add people mng
    if (i%2!=1) i++;
    btnMng.frame = [self caculBtnRect:i];
    [sclView bringSubviewToFront:btnMng];
    

    //页面指示器
    [self initPageDot:pages];
    
    
    
    //动画
    f = anmView.frame;
    anmView.autoresizesSubviews = YES;
    float h = f.size.height;//-14;
    //f.origin.y += 14;
	f.size.height = 1;
    anmView.frame = f;
    f.size.height = h;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(startAnmFinished:)];
	anmView.frame = f;
	[UIView commitAnimations];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float xOffset = scrollView.contentOffset.x;
    float w = scrollView.frame.size.width;
    if (w<0) return;
    
    int page = xOffset/w;
    if (page<9)
        [self setPageDot:page];
    
}
 
- (void) initPageDot:(int)pages
{
    if (pages<=1)
        return;
    
	UIImage* img0 = [UIImage imageNamed:@"turnpage_0.png"];
	UIImage* img1 = [UIImage imageNamed:@"turnpage_1.png"];
    
    float xOffset = (312 - pages*20 - (pages-1)*10)/2;
	CGRect f = CGRectMake(xOffset, 339, 20, 20);
	for (int i=0; i<pages; i++)
	{
		UIImageView* dot = [[UIImageView alloc] initWithFrame:f];
		dot.tag = 1000+i;
		dot.image = img0;
		dot.highlightedImage = img1;
        dot.autoresizingMask = lbPage.autoresizingMask;
		[anmView addSubview:dot];
		[dot release];
		f.origin.x += 30;
	}
    
	[anmView bringSubviewToFront:lbPage];
    curPage = -1;
	[self setPageDot:0];
}

- (void) setPageDot:(int)idx
{
    if (curPage==idx) return;
    curPage = idx;
    lbPage.hidden = YES;
    lbPage.text = [NSString stringWithFormat:@"%d",idx+1];
	curDot.highlighted = NO;
	curDot = (UIImageView*)[self.view viewWithTag:idx+1000];
	curDot.highlighted = YES;
    lbPage.center = curDot.center;
    lbPage.hidden = NO;
}

- (CGRect) caculBtnRect:(int)idx
{
    CGRect f = btnRect;
    float pageWidth = sclView.frame.size.width;
    float x = (idx/12) * pageWidth;
	x += f.origin.x;
    if (idx%2)
        x += f.size.width+2;
    
    float y = f.origin.y + ((idx%12)/2)*(f.size.height+2);
    
    f.origin.x = x;
    f.origin.y = y;
    
    return f;
    
}

- (void) addItem :(NSString*)name :(BOOL)isSelected :(int)tag :(int)idx
{
	UIButton* btn = [UIButton  buttonWithType:UIButtonTypeCustom];
	btn.titleEdgeInsets = btnDemon.titleEdgeInsets;
	btn.titleLabel.font = btnDemon.titleLabel.font;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[btn setTitleColor:[btnDemon titleColorForState: UIControlStateNormal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[btnDemon backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
	[btn setBackgroundImage:[btnDemon backgroundImageForState:UIControlStateSelected] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(onChangePeople:) forControlEvents:UIControlEventTouchUpInside];
    
    //[btn setTitleColor:[btnAddNew titleColorForState: UIControlStateSelected] forState:UIControlStateSelected];
	//[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	//[btn setTitleColor:[btnAddNew titleColorForState: UIControlStateHighlighted] forState:UIControlStateHighlighted];
/*	
    CGRect f = btnDemon.frame;
    float pageWidth = sclView.frame.size.width;
    float xOffset = (idx/12) * pageWidth;
	xOffset += f.origin.x;
    if (idx%2)
        xOffset += f.size.width+2;
    
    float yOffset = f.origin.y + ((idx%12)/2)*(f.size.height+2);

    
    f.origin.x = xOffset;
	f.origin.y = yOffset;
    */
    
	btn.frame = [self caculBtnRect:idx];
	btn.tag = tag;
    btn.selected =  isSelected;
    [btn setTitle:name forState:UIControlStateNormal];
	[sclView addSubview:btn];
}


- (void) addHorLine:(float)y
{
    CGRect f = lbHor.frame;
    f.origin.y = y;
    UILabel* lb = [[UILabel alloc] initWithFrame:f];
	lb.backgroundColor = lbHor.backgroundColor;
	[sclView addSubview:lb];
	[lb release];
}

- (void) addVerLine:(float)x
{
    CGRect f = lbVer.frame;
    f.origin.x = x;
    UILabel* lb = [[UILabel alloc] initWithFrame:f];
	lb.backgroundColor = lbVer.backgroundColor;
	[sclView addSubview:lb];
	[lb release];
}
	
	
- (void) startAnmFinished : (id) sender
{
    CGRect f = anmView.frame;
    f.origin.y -= 14;
	f.size.height += 14;
    anmView.frame = f;
}

- (void) animationFinished : (id) sender
{
	[vcParent performSelector:closeCallback withObject:self withObject:callbackInfo];
}


-(void) touchesBegan :(NSSet *)touches withEvent:(UIEvent *)event
{
	[self beginEndAnimation];
}

- (void) beginEndAnimation
{
	CGRect f = anmView.frame;
	f.size.height = 1;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
	anmView.frame = f;
	[UIView commitAnimations];
}

- (IBAction) onTouchDown:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    
    if (tag==2001)
        ivSel1.hidden = NO;
    else if (tag==2002)
        ivSel2.hidden = NO;
}
- (IBAction) onTouchCancel:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    
    if (tag==2001)
        ivSel1.hidden = YES;
    else if (tag==2002)
        ivSel2.hidden = YES;
}

- (IBAction) onPeopleMng:(id)sender
{
    
    [PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    MsgParam *param = [MsgParam param:self :@selector(peopleMngClose:) :nil :10];
    [PubFunction SendMessageToViewCenter:NMSettingPepople :0 :1 :param];
}

- (void)peopleMngClose:(id)result
{
   [vcParent performSelector:closeCallback withObject:self withObject:result];
}

/*
-(void)onSetPeopleClose:(id)result
{
	[self updateCellDesc:ERowIndexPeople];
}
*/
/*
- (IBAction) onDelPeople :(id)sender
{
	
	int idx = ((UIButton*)sender).tag-100;
	TPeopleInfo* info = [peopleList objectAtIndex:idx];
	NSString* str = [NSString stringWithFormat:LOC_STR("ul_qr_fmt"),
					 [PubFunction replaceStr:info.sPersonName :@"-" :@""]];
	
	if (0!=[UIAstroAlert askWait:str :[NSArray arrayWithObjects:@"确定",@"取消",nil]])
		return;
	
	[AstroDBMng removePopleInfoBysGUID:info.sGuid];
	if ([info.sGuid isEqualToString:TheCurPeople.sGuid])
	{
		TheCurPeople = [AstroDBMng getDemoPeople];
		callbackInfo = @"changePeople";
		[self beginEndAnimation];
		//[vcParent performSelector :closeCallback withObject:self withObject:@"changePeople"];
	}
	else
	{
		callbackInfo = nil;
		[self beginEndAnimation];
		//[vcParent performSelector :closeCallback withObject:self withObject:nil];
	}
}
*/
 

- (IBAction) onUserLogin :(id)sender
{
	[PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];

	[bussMngUiLogin cancelBussRequest];
	self.bussMngUiLogin = [BussMng bussWithType:BMUiLogin];
	[bussMngUiLogin request:self :@selector(loginCallback:) :nil];
}


- (IBAction) onChangePeople :(id)sender
{
	UIButton* btn = (UIButton*)sender;
	btn.selected = YES;
	((UIButton*)[anmView viewWithTag:curTag]).selected = NO;
	curTag = btn.tag;
	int idx = curTag-100;
	TPeopleInfo* info = [peopleList objectAtIndex:idx];
	
	if ([info.sGuid isEqualToString:TheCurPeople.sGuid])
	{
		callbackInfo = nil;
		[self beginEndAnimation];
		//[vcParent performSelector :closeCallback withObject:self withObject:nil];
	}
	else 
	{
		TheCurPeople = info;
		callbackInfo = @"changePeople";
		[self beginEndAnimation];
		//[vcParent performSelector :closeCallback withObject:self withObject:@"changePeople"];
	}
}

- (IBAction) onMakePeople :(id)sender
{
	[PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
	[PubFunction SendMessageToViewCenter:NMMakePeople :0 :1 :[MsgParam param:self :@selector(makePeopleClose:) :nil :MP_NEW]];
}

- (void) makePeopleClose:(id)result
{
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
	//callbackInfo = (NSString*) result;
	//[self beginEndAnimation];
	[vcParent performSelector :closeCallback withObject:self withObject:result];
}


/*
- (IBAction) onDemon :(id)sender
{
	TheCurPeople = [AstroDBMng getDemoPeople];
	[vcParent performSelector :closeCallback withObject:self withObject:@"changePeople"];
}
*/


- (void) loginCallback:(TBussStatus*)sts
{
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
	[bussMngUiLogin cancelBussRequest];
	self.bussMngUiLogin = nil;
	if (sts==nil)
	{
		[TheGlobal initCurPeople];
		[vcParent performSelector :closeCallback withObject:self withObject:@"changePeople"];
	}
	else 
	{
		[vcParent performSelector :closeCallback withObject:self withObject:nil];
	}
}



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
   
}


- (void)dealloc 
{
	[bussMngUiLogin cancelBussRequest];
	self.bussMngUiLogin = nil;
	// Release any retained subviews of the main view.
	self.peopleList = nil;
	//self.vcMakePeople = nil;
	
	[super dealloc];
}


@end
