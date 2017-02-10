//
//  UIZMZMBssLisst.m
//  Astro
//
//  Created by cyl on 12-7-13.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "PubFunction.h"
#import "GlobalVar.h"

#import "UIZMZMBssLisst.h"

@interface UIZMZMBssLisst()
- (void) animationFinished : (id) sender;
- (void) beginEndAnimation;
@end

@implementation UIZMZMBssLisst

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
    self = [super initWithNibName:@"UIZMZMBssLisst" bundle:nil];
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
    
    if (IS_FT) {
        [btn_Ballot setTitle:@"抽簽算命" forState:nil];
        [btn_Number setTitle:LOC_STR("nb_hmcs") forState:nil];
        [btn_Heart setTitle:LOC_STR("ht_aqsp") forState:nil];
        [btn_Dream setTitle:LOC_STR("dm_zgjm") forState:nil];
        [btn_TodayAlmanac setTitle:@"黃       歷" forState:nil];
        [btn_Lottery setTitle:LOC_STR("tbcp") forState:nil];
        [btn_ChengGu setTitle:LOC_STR("cg_cgsm") forState:nil];
    }
    switch ( self->businessType ) {
        case NMBallot:
            btn_Current = self->btn_Ballot;
            break;
        case NMNumber:
            btn_Current = self->btn_Number;
            break;
        case NMHeart:
            btn_Current = self->btn_Heart;
            break;
        case NMDream:
            btn_Current = self->btn_Dream;
            break;
        case NMAlmanac:
            btn_Current = self->btn_TodayAlmanac;
            break;
        case NMLottery:
            btn_Current = self->btn_Lottery;
            break;
        case NMChengGu:
            btn_Current = self->btn_ChengGu;
            break;
        default:
            btn_Current = self->btn_Ballot;
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
    = CGRectMake(20, (r.size.height - 10) / 2.0
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
    if ( sender == btn_Ballot ) {  //第一个
        ivTopBG.hidden = NO;
    }
    else if( sender == btn_ChengGu )  //最后一个
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
