#import "Constant.h"
#import "PPTabBar.h"
#import "PPAppearance.h"
///////////////////////////////////////////////////////////////////////////////////////////////////

static float kTabMargin = 8;
static float kPadding = 11;

static float kTabMargin2 = 10;
//static float kPadding2 = 10;
static float kPadding2 = 0;
static float kIconSize = 16;
static float kIconSpacing = 3;

static float kBadgeHPadding = 8;

static float kGradient1[] = {RGBA(233, 238, 246, 1), RGBA(229, 235, 243, 1), 1};

static float kReflectionBottom[] = {RGBA(228, 230, 235, 1)};
static float kReflectionBottom2[] = {RGBA(214, 220, 230, 1)};

static float kBottomLightShadow[] = {RGBA(207, 213, 225, 1)};
static float kBottomHighlight[] = {RGBA(250, 250, 252, 1)};

//static float kTopHighlight[] = {RGBA(247, 249, 252, 1)};
//static float kTopShadow[] = {RGBA(62, 70, 102, 1)};
static float kBottomShadow[] = {RGBA(202, 205, 210, 1)};



///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPTabBar

@synthesize delegate = _delegate, selectedTabIndex = _selectedTabIndex, tabItems = _tabItems,textOffSet = _textOffSet,
  tabViews = _tabViews, textColor = _textColor, tintColor = _tintColor, tabImage = _backImage;

- (PPTabBar*)initWithFrame:(CGRect)frame style:(PPTabBarStyle)style {
  if (self = [super initWithFrame:frame]) {
    _style = style;
    _selectedTabIndex = NSIntegerMax;
    _tabItems = nil;
    _tabViews = [[NSMutableArray alloc] init];
    self.textColor = [PPAppearance appearance].linkTextColor;
    _tintColor = nil;
    
    self.contentMode = UIViewContentModeLeft;
    
      if (_style == PPTabBarCustomStyle) {
	  UIImage * img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blueButton" ofType:@"png" inDirectory:@""]];
	  float topCap = 0;
		  
	  if(frame.size.height>img.size.height)	topCap = img.size.height/2;
	 self.tabImage = [img	stretchableImageWithLeftCapWidth:13 topCapHeight:topCap];
            
      _contentItemView = [[UIScrollView alloc] initWithFrame:CGRectZero];
      _contentItemView.scrollEnabled = YES;
      _contentItemView.scrollsToTop = NO;
      _contentItemView.showsVerticalScrollIndicator = NO;
      _contentItemView.showsHorizontalScrollIndicator = NO;
      [self addSubview:_contentItemView];
	  img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BoundLeft" 
																						ofType:@"png" 
																				   inDirectory:@""]];
		
	  _arrowLeft = [[UIImageView alloc] initWithImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2]];
		
	  img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BoundRight"
																			   ofType:@"png"
																		  inDirectory:@""]];	
      _arrowRight.hidden = YES;
      [self addSubview:_arrowLeft];
	  _arrowRight = [[UIImageView alloc] initWithImage: [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2]];
					
      _arrowRight.hidden = YES;
      [self addSubview:_arrowRight];
    } else {
      if (_style == PPTabBarGrayStyle) {
		  self.tabImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"profileTab"
													 ofType:@"png"
												inDirectory:@""]]
          stretchableImageWithLeftCapWidth:5 topCapHeight:0];

        self.backgroundColor = RGBCOLOR(237, 239, 244);
      } else if (_style == PPTabBarBlueStyle) {
		  self.tabImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"feedTab"
																						   ofType:@"png"
																					  inDirectory:@""]]
						   stretchableImageWithLeftCapWidth:5 topCapHeight:0];

        self.backgroundColor = RGBCOLOR(58, 88, 151);
      }
      _contentItemView = nil;
      _arrowLeft = nil;
      _arrowRight = nil;
    }
  }
  return self;
}

- (void)dealloc {
  [_tabItems release];
  [_tabViews release];
  [_arrowLeft release];
  [_arrowRight release];
  [_contentItemView release];
  [_textColor release];
  [_tintColor release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateOverflow {
  if (_contentItemView.contentOffset.x < (_contentItemView.contentSize.width-self.frame.size.width)) {
    _arrowRight.frame = CGRectMake(self.frame.size.width-_arrowRight.frame.size.width, 2,
      _arrowRight.frame.size.width, _arrowRight.frame.size.height);
    _arrowRight.hidden = NO;
  } else {
    _arrowRight.hidden = YES;
  }
  if (_contentItemView.contentOffset.x > 0) {
    _arrowLeft.frame = CGRectMake(0, 2, _arrowLeft.frame.size.width, _arrowLeft.frame.size.height);
    _arrowLeft.hidden = NO;
  } else {
    _arrowLeft.hidden = YES;
  }
}

- (void)layoutTabs {
  CGFloat margin = _style == PPTabBarCustomStyle ? kTabMargin2 : kTabMargin;
  CGFloat padding = _style == PPTabBarCustomStyle ? kPadding2 : kPadding;
  CGFloat x = margin;

  if (self.contentMode == UIViewContentModeScaleToFill) {
    CGFloat maxTextWidth = self.frame.size.width - (margin*2 + padding*2*_tabViews.count);
    CGFloat totalTextWidth = 0;
    CGFloat totalTabWidth = margin*2;
    CGFloat maxTabWidth = 0;
    for (int i = 0; i < _tabViews.count; ++i) {
      PPTabView* tab = [_tabViews objectAtIndex:i];
      [tab sizeToFit];
      totalTextWidth += tab.frame.size.width - padding*2;
      totalTabWidth += tab.frame.size.width;
      if (tab.frame.size.width > maxTabWidth) {
        maxTabWidth = tab.frame.size.width;
      }
    }

    if (totalTextWidth > maxTextWidth) {
      CGFloat shrinkFactor = maxTextWidth/totalTextWidth;
      for (int i = 0; i < _tabViews.count; ++i) {
        PPTabView* tab = [_tabViews objectAtIndex:i];
        CGFloat textWidth = tab.frame.size.width - padding*2;
        tab.frame = CGRectMake(x, 0, ceil(textWidth * shrinkFactor) + padding*2 , self.frame.size.height);
        x += tab.frame.size.width;
      }
    } else {
      CGFloat averageTabWidth = ceil((self.frame.size.width - margin*2)/_tabViews.count);
      if (maxTabWidth > averageTabWidth && self.frame.size.width - totalTabWidth < margin) {
        for (int i = 0; i < _tabViews.count; ++i) {
          PPTabView* tab = [_tabViews objectAtIndex:i];
          tab.frame = CGRectMake(x, 0, tab.frame.size.width, self.frame.size.height);
          x += tab.frame.size.width;
        }
      } else {
        for (int i = 0; i < _tabViews.count; ++i) {
          PPTabView* tab = [_tabViews objectAtIndex:i];
          tab.frame = CGRectMake(x, 0, averageTabWidth, self.frame.size.height);
          x += tab.frame.size.width;
        }
      }
    }
  } else {
    for (int i = 0; i < _tabViews.count; ++i) {
      PPTabView* tab = [_tabViews objectAtIndex:i];
      [tab sizeToFit];
      tab.frame = CGRectMake(x, 0, tab.frame.size.width, self.frame.size.height);
      x += tab.frame.size.width;
    }
  }
    
  if (_style == PPTabBarCustomStyle) {
    CGPoint textOffSet = _contentItemView.contentOffset;
    _contentItemView.frame = self.bounds;
    _contentItemView.contentSize = CGSizeMake(x + kTabMargin2, self.frame.size.height);
    _contentItemView.contentOffset = textOffSet;
  }
}

- (void)tabTouchedUp:(PPTabView*)tab {
  self.selectedTabView = tab;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)drawRect:(CGRect)rect {
  if (_style == PPTabBarGrayStyle) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

    CGContextSetFillColor(context, kReflectionBottom);
    CGContextFillRect(context, CGRectMake(rect.origin.x, floor(rect.size.height/2)+3,
        rect.size.width, floor(rect.size.height/2)-3));
    
    CGPoint bottomLine2[] = {rect.origin.x, rect.origin.y+rect.size.height-0.5,
      rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-0.5};
    CGPoint bottomLine[] = {rect.origin.x, rect.origin.y+rect.size.height-1.5,
      rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-1.5};

    CGContextSaveGState(context);
    CGContextSetStrokeColorSpace(context, space);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColor(context, kBottomLightShadow);
    CGContextStrokeLineSegments(context, bottomLine, 2);
    CGContextSetStrokeColor(context, kBottomHighlight);
    CGContextStrokeLineSegments(context, bottomLine2, 2);
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(space);
  } else if (_style == PPTabBarCustomStyle) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

    CGFloat locations[] = {0, 1};
    
    CGFloat halfHeight = rect.size.height > 10
      ? floor(rect.size.height/2)+1
      : rect.size.height;
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, kGradient1, locations, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0),
      CGPointMake(0, halfHeight), 0);
    CGGradientRelease(gradient);

    if (rect.size.height > 10) {
      CGContextSetFillColor(context, kReflectionBottom2);
      CGContextFillRect(context, CGRectMake(rect.origin.x, floor(rect.size.height/2)+1,
          rect.size.width, floor(rect.size.height/2)-1));
    }
    
//    CGPoint topLine[] = {rect.origin.x, rect.origin.y+0.5,
//      rect.origin.x+rect.size.width, rect.origin.y+0.5};
//    CGPoint topLine2[] = {rect.origin.x, rect.origin.y+1.5,
//      rect.origin.x+rect.size.width, rect.origin.y+1.5};
    CGPoint bottomLine[] = {rect.origin.x, rect.origin.y+rect.size.height-0.5,
      rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-0.5};

    CGContextSaveGState(context);
    CGContextSetStrokeColorSpace(context, space);
    CGContextSetLineWidth(context, 1.0);
//    CGContextSetStrokeColor(context, kTopShadow);
//    CGContextStrokeLineSegments(context, topLine, 2);
//    CGContextSetStrokeColor(context, kTopHighlight);
//    CGContextStrokeLineSegments(context, topLine2, 2);
    CGContextSetStrokeColor(context, kBottomShadow);
    CGContextStrokeLineSegments(context, bottomLine, 2);
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(space);
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self updateOverflow];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (CGPoint)textOffSet {
  if (_contentItemView) {
    return _contentItemView.contentOffset;
  } else {
    return CGPointMake(0, 0);
  }
}

- (void)setContentOffset:(CGPoint)offset {
  if (_contentItemView) {
    _contentItemView.contentOffset = offset;
  }
}

- (PPTabItem*)selectedTabItem {
  if (_selectedTabIndex != NSIntegerMax) {
    return [_tabItems objectAtIndex:_selectedTabIndex];
  }
  return nil;
}

- (void)setSelectedTabItem:(PPTabItem*)tabItem {
  self.selectedTabIndex = [_tabItems indexOfObject:tabItem];
}

- (PPTabView*)selectedTabView {
  if (_selectedTabIndex != NSIntegerMax && _selectedTabIndex < _tabViews.count) {
    return [_tabViews objectAtIndex:_selectedTabIndex];
  }
  return nil;
}

- (void)setSelectedTabView:(PPTabView*)tab {
  self.selectedTabIndex = [_tabViews indexOfObject:tab];
}


-(void)setDelegated:(id<PPTabBarDelegate>) de
{
	_delegate = de;
}

- (void)setSelectedTabIndex:(NSInteger)index {
  if (index != _selectedTabIndex) {
    if (_selectedTabIndex != NSIntegerMax) {
      self.selectedTabView.selected = NO;
    }

    _selectedTabIndex = index;

    if (_selectedTabIndex != NSIntegerMax) {
      self.selectedTabView.selected = YES;
    }
    
	if(_delegate == nil)
		return;

	  if (_delegate!= nil&&[_delegate respondsToSelector:@selector(PPTabBar: didSelectedTabAtIndex:)]) {
      [_delegate PPTabBar:self didSelectedTabAtIndex:_selectedTabIndex];
    }
  }
}

- (void)setTabItems:(NSArray*)tabItems {
  [_tabItems release];
  _tabItems =  [tabItems retain];
  
  for (int i = 0; i < _tabViews.count; ++i) {
    PPTabView* tab = [_tabViews objectAtIndex:i];
    [tab removeFromSuperview];
  }
  
  [_tabViews removeAllObjects];

  if (_selectedTabIndex >= _tabViews.count) {
    _selectedTabIndex = 0;
  }

  for (int i = 0; i < _tabItems.count; ++i) {
    PPTabItem* tabItem = [_tabItems objectAtIndex:i];
    PPTabView* tab = [[[PPTabView alloc] initWithItem:tabItem tabBar:self style:_style] autorelease];
    [tab addTarget:self action:@selector(tabTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    if (_contentItemView) {
      [_contentItemView addSubview:tab];
    } else {
      [self addSubview:tab];
    }
    [_tabViews addObject:tab];
    if (i == _selectedTabIndex) {
      tab.selected = YES;
    }
  }
  
  [self layoutTabs];
  
  if (_contentItemView) {
    [self updateOverflow];
  }
}

- (void)setTextOffSet:(CGPoint) offset
{
	_textOffSet = offset;
}
- (void)showTabWithIndex:(NSInteger)tabIndex {
  PPTabView* tab = [_tabViews objectAtIndex:tabIndex];
  tab.hidden = NO;
}

- (void)hideTabWithIndex:(NSInteger)tabIndex {
  PPTabView* tab = [_tabViews objectAtIndex:tabIndex];
  tab.hidden = YES;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPTabView

@synthesize tabItem = _tabItem;

- (id)initWithItem:(PPTabItem*)tabItem tabBar:(PPTabBar*)tabBar style:(PPTabBarStyle)style {
  if (self = [self initWithFrame:CGRectZero]) {
    _style = style;
    _badgeImage = nil;
    _badgeLabel = nil;
    
    _backImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _backImage.hidden = YES;
    [self addSubview:_backImage];

    _iconImage = [[PPImageView alloc] initWithFrame:CGRectZero];
    _iconImage.contentMode = UIViewContentModeRight;
    _iconImage.clipsToBounds = YES;
    [self addSubview:_iconImage];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.contentMode = UIViewContentModeCenter;
    _titleLabel.shadowOffset = CGSizeMake(0, -1);
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumFontSize = 8;
    _backImage.image = tabBar.tabImage;
   
    if (_style == PPTabBarBlueStyle) {

      _titleLabel.textAlignment = UITextAlignmentCenter;
      _titleLabel.font = [UIFont boldSystemFontOfSize:15];
      _titleLabel.textColor = RGBCOLOR(223, 229, 237);
      _titleLabel.highlightedTextColor = [UIColor colorWithWhite:0.1 alpha:1];
      _titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
      _titleLabel.adjustsFontSizeToFitWidth = YES;
      _titleLabel.minimumFontSize = 9;
    } else if (_style == PPTabBarGrayStyle) {
      _titleLabel.textAlignment = UITextAlignmentCenter;
      _titleLabel.font = [UIFont boldSystemFontOfSize:17];
      _titleLabel.textColor = tabBar.textColor;
      _titleLabel.highlightedTextColor = [UIColor colorWithWhite:0.1 alpha:1];
      _titleLabel.shadowColor = [UIColor whiteColor];
      _titleLabel.adjustsFontSizeToFitWidth = YES;
      _titleLabel.minimumFontSize = 9;
    } else if (_style == PPTabBarCustomStyle) {
      _titleLabel.textAlignment = UITextAlignmentCenter;
      _titleLabel.font = [UIFont boldSystemFontOfSize:13];
      _titleLabel.textColor = tabBar.textColor;
      _titleLabel.highlightedTextColor = [UIColor whiteColor];
      _titleLabel.shadowColor = [UIColor whiteColor];
    }
    [self addSubview:_titleLabel];

    self.tabItem = tabItem;
  }
  return self;
}

- (void)dealloc {
  [_tabItem release];
  [_backImage release];
  [_iconImage release];
  [_titleLabel release];
  [_badgeImage release];
  [_badgeLabel release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setBadgeNumber {
  if (!_badgeImage && _tabItem.badgeNumber) {
    _badgeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _badgeImage.image = [[UIImage imageNamed:@"badge.png"]
      stretchableImageWithLeftCapWidth:12 topCapHeight:15];
    [self addSubview:_badgeImage];
    
    _badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _badgeLabel.backgroundColor = [UIColor clearColor];
    _badgeLabel.font = [UIFont boldSystemFontOfSize:14];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.contentMode = UIViewContentModeCenter;
    _badgeLabel.textAlignment = UITextAlignmentCenter;    
    [self addSubview:_badgeLabel];
  }
  
  if (_tabItem.badgeNumber) {
    _badgeLabel.text = [NSString stringWithFormat:@"%d", _tabItem.badgeNumber];
    [_badgeLabel sizeToFit];
    
    _badgeImage.frame = CGRectMake(self.frame.size.width - (_badgeLabel.frame.size.width + kBadgeHPadding*2), 0,
      _badgeLabel.frame.size.width + 1 + kBadgeHPadding*2, 28);
    _badgeLabel.frame = CGRectMake(_badgeImage.frame.origin.x, _badgeImage.frame.origin.y, _badgeImage.frame.size.width, 22);
    _badgeImage.hidden = NO;
    _badgeLabel.hidden = NO;
  } else {
    _badgeImage.hidden = YES;
    _badgeLabel.hidden = YES;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];

  _backImage.frame = self.bounds;

  CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font];
  
  CGFloat textWidth = self.frame.size.width;
  CGFloat textLeft = 0;
  if (titleSize.width > self.frame.size.width) {
    textLeft = 4;
    textWidth -= 8;
  }
  
  if (_style == PPTabBarCustomStyle) {
    CGFloat iconWidth = _iconImage.url.length ? kIconSize + kIconSpacing : 0;
    _iconImage.frame = CGRectMake(kPadding2, floor(self.frame.size.height/2 - kIconSize/2)+2,
      kIconSize, kIconSize);
    _titleLabel.frame = CGRectOffset(self.bounds, kPadding2 + iconWidth, 0);
  } else if (_style == PPTabBarGrayStyle) {
    _iconImage.frame = CGRectZero;
    _titleLabel.frame = CGRectMake(textLeft, self.bounds.origin.y + 2,
      textWidth, self.frame.size.height);
  } else if (_style == PPTabBarBlueStyle) {
    _iconImage.frame = CGRectZero;
    _titleLabel.frame = CGRectMake(textLeft, self.bounds.origin.y + 2,
      textWidth, self.frame.size.height);
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize titleSize = [_titleLabel sizeThatFits:size];
  CGFloat padding = _style == PPTabBarCustomStyle ? kPadding2 : kPadding;
  CGFloat iconWidth = _iconImage.url.length ? kIconSize + kIconSpacing : 0;
  
  return CGSizeMake(iconWidth + titleSize.width + padding*2, size.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIControl

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  _backImage.hidden = !selected;
  _titleLabel.highlighted = selected;
  if (_style == PPTabBarCustomStyle) {
    if (selected) {
      _iconImage.contentMode = UIViewContentModeLeft;
      _titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    } else {
      _iconImage.contentMode = UIViewContentModeRight;
      _titleLabel.shadowColor = [UIColor whiteColor];
    }
  } else if (_style == PPTabBarGrayStyle) {
  } else if (_style == PPTabBarBlueStyle) {
    if (selected) {
      _titleLabel.shadowColor = [UIColor whiteColor];
    } else {
      _titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// PPTabItemDelegate

- (void)tabItem:(PPTabItem*)item badgeNumberChangedTo:(int)value {
  [self setBadgeNumber];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setTabItem:(PPTabItem*)tabItem {
  [_tabItem performSelector:@selector(setTabBar:) withObject:nil];
  [_tabItem release];
  _tabItem = [tabItem retain];
  [_tabItem performSelector:@selector(setTabBar:) withObject:self];

  _titleLabel.text = _tabItem.title;
  _iconImage.url = _tabItem.icon;
  if (_tabItem.badgeNumber) {
    [self setBadgeNumber];
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PPTabItem

@synthesize title = _title, object = _object, badgeNumber = _badgeCount, icon = _icon;

- (id)initWithTitle:(NSString*)title {
  if (self = [self init]) {
    self.title = title;
  }
  return self;
}

- (id)init {
  if (self = [super init]) {
    _title = nil;
    _icon = nil;
    _object = nil;
    _badgeCount = 0;
    _tabBar = nil;
  }
  return self;
}

- (id)initWithCustomView
{
	return  nil;
}

- (id)initWithImage:(UIImage *)image
{
	if(self = [super init])
	{
		_barImage = image;
	}
	return self;
}
- (void)dealloc {
  [_title release];
  [_icon release];
  [_object release];
  [_barImage  release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setTabBar:(PPTabBar*)tabBar {
  _tabBar = tabBar;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setBadgeNumber:(int)value {
 
	if(value<0)
		value = 0 ;
	_badgeCount = value;
	[_tabBar performSelector:@selector(tabItem:badgeNumberChangedTo:) withObject:self	  withObject:(id)value];
}

@end
