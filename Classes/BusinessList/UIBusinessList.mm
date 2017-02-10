//
//  UIBusinessList.m
//  Astro
//
//  Created by cyl on 12-7-10.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//
#import "PubFunction.h"
#import "GlobalVar.h"

#import "UIBusinessList.h"

@interface UIBusinessList()
- (void) animationFinished : (id) sender;
- (void) beginEndAnimation;
@end

@implementation UIBusinessList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBusinessType:(NSUInteger)type ParentView:(UIViewController*)parentView CloseCallBack:(SEL)closeCallBack
{
    self = [super initWithNibName:@"UIBusinessList" bundle:nil];
    if ( self ) {
        self->businessType = type;
        self->vcParent = parentView;
        self->closeListCallback = closeCallBack;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self->newBusinessType = nil;
    UIButton *btn_Current = nil;
    
    if(IS_FT)
    {
        [btn_RGTZ setTitle:LOC_STR("ps_rgtz") forState:nil];
        [btn_YunShi setTitle:@"運       勢" forState:nil];
        [btn_TestName setTitle:@"姓名測試" forState:nil];
        [btn_MathName setTitle:@"姓名匹配" forState:nil];
        [btn_LoveTaoHua setTitle:LOC_STR("lv_aqth") forState:nil];
        [btn_Money setTitle:@"財富趨勢" forState:nil];
        [btn_Career setTitle:@"事業成長" forState:nil];
    }
    
    switch ( self->businessType ) {
        case NMPerson:
            btn_Current = self->btn_RGTZ;
            break;
        case NMFortune:
            btn_Current = self->btn_YunShi;
            break;
        case NMName:
            btn_Current = self->btn_TestName;
            break;
        case NMMatch:
            btn_Current = self->btn_MathName;
            break;
        case NMLove:
            btn_Current = self->btn_LoveTaoHua;
            break;
        case NMMoneyFortune:
            btn_Current = self->btn_Money;
            break;
        case NMCareer:
            btn_Current = self->btn_Career;
            break;
        default:
            btn_Current = self->btn_RGTZ;
            break;
    }
    [btn_Current setSelected:YES];
    UIImage *arrow = [UIImage imageNamed:@"arrow.png"];
    assert( arrow );
    UIImageView *iv = [[UIImageView alloc] initWithImage:arrow];
    CGRect r = btn_Current.frame;
//    iv.frame
//    = CGRectMake(10, (r.size.height - arrow.size.height) / 2.0
//                         , arrow.size.width, arrow.size.height);
    iv.frame
        = CGRectMake(15, (r.size.height - 10) / 2.0
                             , 10, 10);
    [btn_Current addSubview:iv];
    [iv release];
    
    //动画
    CGRect f = anmView.frame;
    anmView.autoresizesSubviews = YES;
    float h = f.size.height;//-14;
    //f.origin.y += 14;
	f.size.height = 1;
    anmView.frame = f;
    f.size.height = h;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(startAnmFinished:)];
	anmView.frame = f;
	[UIView commitAnimations];
}

- (void)viewDidUnload
{
    if( self->newBusinessType )
    {
        [self->newBusinessType release];
        self->newBusinessType = nil;
    }
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onSelectBtn:(id)sender
{
    if ( self->businessType != ((UIButton*)sender).tag ) {
        self->newBusinessType
        = [[NSNumber numberWithInt:((UIButton*)sender).tag] retain];
    }

    [self beginEndAnimation];
}

- (IBAction)onPress:(id)sender
{
    if ( sender == btn_RGTZ ) {
        ivTopBG.hidden = NO;
    }
    else if( sender == btn_Career )
    {
        ivBtmBG.hidden = NO;
    }
}

- (void) animationFinished : (id) sender
{
	[vcParent performSelector:closeListCallback withObject:self withObject:self->newBusinessType];
}

- (void) beginEndAnimation
{
	CGRect f = anmView.frame;
	f.size.height = 1;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
	anmView.frame = f;
	[UIView commitAnimations];
}

-(void) touchesBegan :(NSSet *)touches withEvent:(UIEvent *)event
{
	[self beginEndAnimation];
}
@end
