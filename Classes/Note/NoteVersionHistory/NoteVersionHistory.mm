//
//  NoteVersionHistory.m
//  NoteBook
//
//  Created by mwt on 12-11-8.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//

#import "NoteVersionHistory.h"
#import "PubFunction.h"
#import "CommonAll.h"

@implementation NoteVersionHistory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        
    [self DrawView] ;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)OnFinish:(id)sender
{
    //完成按钮
   	[PubFunction SendMessageToViewCenter:NMBack :0 :1 :nil];
	[PubFunction SendMessageToViewCenter:NMNavFuncShow :0 :0 :nil];
}

-(void)ShowVersionHistory:(NSString*) VersionInfo
{    
    CGFloat y = m_lbTitleSample.frame.origin.y;

    NSString *strFile = [[NSBundle mainBundle] pathForResource:@"version" ofType:@"txt"];
    NSString *strVersion = [NSString stringWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:nil];
    if (!strVersion) return;
    while (1) {
        NSRange rangeStart = [strVersion rangeOfString:@"<"];
        NSRange rangeEnd = [strVersion rangeOfString:@">"];
        if ( rangeStart.length <= 0 || rangeEnd.length <= 0) break;
        
        if ( rangeEnd.location > rangeStart.location + 5)
        {
            NSRange range;
            range.location = rangeStart.location+1;
            range.length = rangeEnd.location - rangeStart.location - 1;
            NSString *strText = [strVersion substringWithRange:range];
            
            while ( [strText length] > 2) { //除去开头的回车换行
                NSString *strTmp = [strText substringToIndex:1];
                if ([strTmp isEqualToString:@"\r"] || [strTmp isEqualToString:@"\n"] ) strText = [strText substringFromIndex:1];
                else break;
            }
            
            range = [strText rangeOfString:@"\r"];
            if ( range.length <= 0 ) range = [strText rangeOfString:@"\n"];
            if ( range.length > 0)
            {
                NSString *strTitle = [strText substringToIndex:range.location];
                NSString *strContent = [strText substringFromIndex:(range.location+range.length)];
                while ( [strContent length] > 2) { //除去开头的回车换行
                    NSString *strTmp = [strContent substringToIndex:1];
                    if ([strTmp isEqualToString:@"\r"] || [strTmp isEqualToString:@"\n"] ) strContent = [strContent substringFromIndex:1];
                    else break;
                }
                
                y = [self addKeyValue:strTitle :strContent :y];
            }
        }
        
        strVersion = [strVersion substringFromIndex:(rangeEnd.location+rangeEnd.length)];
    }
    
    
    CGSize contentSize = self->m_viVersionHistory.frame.size;
    if ( y > contentSize.height ) 
        contentSize.height = y + 10 ;
    [self->m_viVersionHistory setContentSize:contentSize] ;
    
}


-(float) addKeyValue:(NSString*)key :(NSString*)val :(float)y
{
	CGRect f = m_lbTitleSample.frame;
	f.origin.y = y;
	UILabel* lb = [[UILabel alloc] initWithFrame:f];
	lb.font = m_lbTitleSample.font;
	lb.textColor = m_lbTitleSample.textColor;
	lb.backgroundColor = m_lbTitleSample.backgroundColor;
	lb.text = key;
	[m_viVersionHistory addSubview:lb];
	[lb release];
	y += f.size.height;
	
	f = m_lbContentSample.frame;
	f.origin.y = y;
	CGSize size = f.size;
	size.height = 999;
	f.size = [val sizeWithFont:m_lbContentSample.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    f.size.width = m_lbContentSample.frame.size.width;
	
	lb = [[UILabel alloc] initWithFrame:f];
	lb.lineBreakMode = NSLineBreakByWordWrapping;
	lb.numberOfLines = 0;
	lb.font = m_lbContentSample.font;
	lb.textColor = m_lbContentSample.textColor;
	lb.backgroundColor = m_lbContentSample.backgroundColor;
	lb.text = val;
    
	[m_viVersionHistory addSubview:lb];
	[lb release];
	
	y += f.size.height;
	return y;
}


-(void) DrawView
{
    [self->m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [self->m_btnFinish setBackgroundImage:[[UIImage imageNamed:@"btn_TouLanA-2.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    
    m_lbVersion.text = [CommonFunc getAppVersion];
    
    [self ShowVersionHistory:nil ];    
}

-(void)dealloc
{
    SAFEREMOVEANDFREE_OBJECT(m_btnFinish) ;
    SAFEREMOVEANDFREE_OBJECT(m_lbVersion) ;
    SAFEREMOVEANDFREE_OBJECT(m_viVersionHistory) ;
    SAFEREMOVEANDFREE_OBJECT(m_lbTitleSample) ;
    SAFEREMOVEANDFREE_OBJECT(m_lbContentSample) ;
    
    [super dealloc];
}

@end
