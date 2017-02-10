//
//  UIFolderItrmView.m
//  NoteBook
//
//  Created by cyl on 12-10-30.
//  Copyright (c) 2012年 洋基科技. All rights reserved.
//
#import "PubFunction.h"
#import "Global.h"
#import "UIImage+Scale.h"
#import "UIFolderItemView.h"
//#import "FlurryAnalytics.h"

@implementation UIFolderItemView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self->m_btn2 = nil;
        self->m_btn1 = nil;
        self->m_labelTitle = nil;
        self->m_labelNumOfFile = nil;
        self->m_labelNumOfNewFile = nil;
        self->m_ivIcon = nil;
        self->m_ivBackground = nil;
        self->m_ivBackgroundSelect = nil;
        [self setCenter:NO];
        self->m_fTop = 10.0 / 144.0;
        self->m_NumOfFile = self->m_NumOfNewFile = 0;
        self->m_iOrder = 0;
    }
    return self;
}

-(void)dealloc
{
    [m_FolderName release];
    [m_strFolderId release];
    
    SAFEFREE_OBJECT(self->m_btn2);
    SAFEFREE_OBJECT(self->m_btn1);
    SAFEFREE_OBJECT(self->m_labelTitle);
    SAFEFREE_OBJECT(self->m_labelNumOfFile);
    SAFEFREE_OBJECT(self->m_labelNumOfNewFile);
    SAFEFREE_OBJECT(self->m_ivIcon);
    SAFEFREE_OBJECT(self->m_ivBackground);
    SAFEFREE_OBJECT(self->m_ivBackgroundSelect);
    [super dealloc];
}

-(void)setCenter:(BOOL)center
{
    m_fy = (center ? 1.0 : 104.0 / 144.0);
}
-(void)drawFolderItem
{
    float x = 10.0;
    [self drawBackground];
    x += [self drawIconWitOringin:x];
    x += 10.0;
    [self drawBtn2];
    [self drawFileWithEndX:self->m_btn2.frame.origin.x WithType:0];
    [self drawFileWithEndX:self->m_labelNumOfFile.frame.origin.x WithType:1];
    x += [self drawFolderNameWithOriginX:x];
    [self drawBtn1];
}

-(void)drawBackground
{   
    NSString *imageName = nil;
    switch ( self->m_BackgroundIndex ) {
        case COLOR_1:
            imageName = @"folder_list_bk1.png";
            break;
        case COLOR_2:
            imageName = @"folder_list_bk2.png";
            break;
        case COLOR_3:
            imageName = @"folder_list_bk3.png";
            break;
        case COLOR_4:
            imageName = @"folder_list_bk4.png";
            break;
        case COLOR_5:
            imageName = @"folder_list_bk5.png";
            break;
        default:
            imageName = @"folder_list_bk1.png";
            break;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    assert( image );
    if ( self->m_ivBackground) {
        self->m_ivBackground.image = image;
        //self->m_ivBackgroundSelect.image = [image UpdateImageAlpha:0.6];
        return;
    }
    self->m_ivBackground = [[UIImageView alloc] initWithImage:image];
    assert( self->m_ivBackground );
    self->m_ivBackground.userInteractionEnabled = YES;
    CGRect r = CGRectMake(0, 0, image.size.width, image.size.height);
    self->m_ivBackground.frame = r;
    
    //UIImage *imageSelect = [UIImage imageNamed:@"btn_FolderSelect@2x.png"]; 
    //self->m_ivBackgroundSelect
    //= [[UIImageView alloc] initWithImage:imageSelect];
    //assert( self->m_ivBackgroundSelect );
    //self->m_ivBackgroundSelect.frame = r;
    //self->m_ivBackgroundSelect.hidden = YES;
    
    r.origin.x = self.frame.origin.x;
    r.origin.y = self.frame.origin.y;
    r.size.width = ( (r.size.width < self.frame.size.width) ? self.frame.size.width : r.size.width);
    r.size.height = ( (r.size.height < self.frame.size.height) ? self.frame.size.height : r.size.height);
    self.frame = r;
    [self addSubview:self->m_ivBackground];
    //[self addSubview:self->m_ivBackgroundSelect];
}

-(float)drawIconWitOringin:(float)x
{
    NSString *iconName = nil;
    switch ( self->m_IconIndex ) {
        case ICON_DEFAULT:
            iconName = @"btn_folder1.png";
            break;
        case ICON_WORK:
            iconName = @"btn_folder2.png";
            break;
        case ICON_TODOLIST:
            iconName = @"btn_folder3.png";
            break;
        case ICON_AFFLATUS:
            iconName = @"btn_folder4.png";
            break;
        case ICON_PERSONAL:
            iconName = @"btn_folder5.png";
            break;
        default:
            iconName = @"btn_folder5.png";
            break;
    }
    UIImage *image = [UIImage imageNamed:iconName];
    assert( image );
    if ( self->m_ivIcon ) {
        self->m_ivIcon.image = image;
        return self->m_ivIcon.frame.size.width;
    }
    self->m_ivIcon = [[UIImageView alloc] initWithImage:image];
    assert( self->m_ivIcon );
    self->m_ivIcon.userInteractionEnabled = YES;
    CGRect r = self.frame;
    CGSize s = image.size;
    self->m_ivIcon.frame 
    = CGRectMake( x
        , ( self->m_fy *  r.size.height - s.height )/2.0 + self->m_fTop * r.size.height
        , s.width, s.height);
    [self addSubview:self->m_ivIcon];
    return self->m_ivIcon.frame.size.width;
}

-(float)drawFolderNameWithOriginX:(float) x
{
    if ( self->m_labelTitle ) {
        [self->m_labelTitle removeFromSuperview];
        [self->m_labelTitle release];
    }
    self->m_labelTitle
    = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    UIFont *textFont = FONT_34PX_BOLD;
    //[UIFont boldSystemFontOfSize:20];
    [PubFunction getLableWithString:self->m_FolderName \
    lable:self->m_labelTitle contentfont:textFont \
    maxsize:CGSizeMake(10000, self.frame.size.height * 0.5) origin:CGPointMake(x, 0)];
    self->m_labelTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    CGRect r = self->m_labelTitle.frame;
    float maxWidth = 0.0;
    if ( self->m_labelNumOfNewFile ) {
        maxWidth = self->m_labelNumOfNewFile.frame.origin.x - x - 5;
    }
    else if( self->m_labelNumOfFile )
    {
        maxWidth = self->m_labelNumOfFile.frame.origin.x - x - 5;
    }
    else if( self->m_btn2 )
    {
        maxWidth = self->m_btn2.frame.origin.x - x - 5;
    }
    else
    {
        maxWidth = self.frame.size.width - x - 5;
    }
    if ( r.size.width > maxWidth) {
        r.size.width = maxWidth;
    }
    
    r.origin.y
    = (self->m_fy * self.frame.size.height - r.size.height)/2.0
        + self->m_fTop * self.frame.size.height;
    self->m_labelTitle.frame = r;
    [self->m_labelTitle setTextColor:[UIColor whiteColor]];
    self->m_labelTitle.userInteractionEnabled = YES;
    [self addSubview:self->m_labelTitle];
    return r.size.width;
}

-(float)drawFileWithEndX:(float)x WithType:(int)type
{
    CGPoint origin;
    origin.x = x;
    UILabel *label = 0;
    NSString *s = 0;
    if ( type == 0 ) {
        if ( self->m_labelNumOfFile ) {
            [self->m_labelNumOfFile removeFromSuperview];
            [self->m_labelNumOfFile release];
            self->m_labelNumOfFile = nil;
        }
        self->m_labelNumOfFile
        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        s = [NSString stringWithFormat:@"%d", self->m_NumOfFile];
        label = self->m_labelNumOfFile;
    }
    else
    {
        if ( self->m_labelNumOfNewFile ) {
            [self->m_labelNumOfNewFile removeFromSuperview];
            [self->m_labelNumOfNewFile release];
            self->m_labelNumOfNewFile = nil;
        }
        
        if ( 0 == self->m_NumOfNewFile ) {
            return 0;
        }
        
        self->m_labelNumOfNewFile
        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        s = [NSString stringWithFormat:@"今日%d  ", self->m_NumOfNewFile];
        label = self->m_labelNumOfNewFile;
    }
        
    UIFont *textFont = FONT_31PX;
    //[UIFont systemFontOfSize:16];
    [PubFunction getLableWithString:s \
                              lable:label contentfont:textFont \
                            maxsize:CGSizeMake(self.frame.size.width - origin.x, self.frame.size.height) origin:CGPointMake(0, 0)];
    CGRect r = label.frame;
    r.origin.y = (self->m_fy * self.frame.size.height - r.size.height)/2.0
        + self->m_fTop * self.frame.size.height;
    r.origin.x = x - r.size.width;
    label.frame = r;
    [label setTextColor:[UIColor whiteColor]];
    label.userInteractionEnabled = YES;
    [self addSubview:label];
    return r.size.width;
}

-(void) onDown:(id)sender
{
    self->m_ivBackgroundSelect.hidden = NO;
    //self->m_ivBackground.hidden = YES;
}

- (void) onSelect:(id)sender {
    
    //[PubFunction SendMessageToViewCenter:NMNavFuncHide :0 :0 :nil];
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    //self->m_ivBackgroundSelect.hidden = YES;
    //self->m_ivBackground.hidden = NO;
    if ( NMNoteEdit == tag || NMNoteFolder == tag ) {
        [_GLOBAL setEditorAddNoteInfo:NEWNOTE_TEXT catalog:self->m_strFolderId noteinfo:nil];
    }
	[PubFunction SendMessageToViewCenter:tag :0 :1 :nil];
}

-(void)drawBtn2
{
    if ( self->m_btn2 ) {
        [self->m_btn2 removeFromSuperview];
        [self->m_btn2 release];
        self->m_btn2 = nil;
    }
    UIImage *icon = [UIImage imageNamed:@"btn_NewFloder_nor.png"];
    assert( icon );
    //CGRect r = CGRectMake(0, 0, icon.size.width, icon.size.height);
    CGRect r = CGRectMake(0, 0, 44, 44);
    r.origin.x = self.frame.size.width - 16 - r.size.width;
    r.origin.y = (self->m_fy * self.frame.size.height - r.size.height)/2.0
        + self->m_fTop * self.frame.size.height;
    self->m_btn2 = [[UIButton alloc] initWithFrame:r];
    [self->m_btn2 setImage:icon forState:UIControlStateNormal];
    self->m_btn2.imageEdgeInsets
    = UIEdgeInsetsMake((44-icon.size.height)/2.0, (44-icon.size.width)/2.0, (44-icon.size.height)/2.0, (44-icon.size.width)/2.0);
    self->m_btn2.tag = NMNoteEdit;
    [self->m_btn2 addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventTouchUpInside];
    //[self->m_btn2 addTarget:self action:@selector(onDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self->m_btn2];
}

-(void)drawBtn1
{
    if ( self->m_btn1 ) {
        [self->m_btn1 removeFromSuperview];
        [self->m_btn1 release];
        self->m_btn1 = nil;
    }
    CGRect r = self.frame;
    r.origin.x = r.origin.y = 0.0;
//    if ( self->m_btn2 ) {
//        r.size.width = self->m_btn2.frame.origin.x - 10;
//    }
    self->m_btn1 = [[UIButton alloc] initWithFrame:r];
    UIImage *imageSelect = [UIImage imageNamed:@"btn_FolderSelect.png"]; 
    r.size = imageSelect.size;
    //self->m_ivBackgroundSelect
    [self->m_btn1 setImage:[UIImage imageNamed:@"btn_FolderSelect.png"] forState:UIControlStateHighlighted];
    self->m_btn1.tag = NMNoteFolder;
    [self->m_btn1 addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventTouchUpInside];
    //[self->m_btn1 addTarget:self action:@selector(onDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self->m_btn1]; 
    [self bringSubviewToFront:self->m_btn2];
}

-(void)setInforWithCateInfor:(TCateInfo *)cateinfor
{
    self->m_FolderName = [cateinfor.strCatalogName copy];
    self->m_IconIndex = cateinfor.nCatalogIcon;
    self->m_BackgroundIndex = cateinfor.nCatalogColor;
    self->m_NumOfFile = cateinfor.nNoteCount;
    self->m_NumOfNewFile = cateinfor.nCurdayNoteCount;
    self->m_strFolderId = [cateinfor.strCatalogIdGuid copy];
    self->m_iOrder = cateinfor.nOrder;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
