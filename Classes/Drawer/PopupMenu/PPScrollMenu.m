//
//  PPScrollmenu.m
//  test2
//
//  Created by chen wu on 09-10-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PPScrollmenu.h"


const CGFloat kScrollObjHeight	= 55;
const CGFloat kScrollObjWidth	= 280.0;
const CGFloat kPagging = 10.0;

@implementation PPScrollmenu
@synthesize items = _items;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		_backgroundView = [[UIScrollView alloc] initWithFrame:frame];
		_backgroundView.delegate = self;
		_backgroundView.autoresizesSubviews = YES;
		_backgroundView.showsVerticalScrollIndicator = NO;
		_backgroundView.showsHorizontalScrollIndicator = YES;
		_backgroundView.delaysContentTouches = NO;
		_backgroundView.scrollEnabled = YES;
		_backgroundView.pagingEnabled = NO;
		_backgroundView.clipsToBounds = YES;
		[self addSubview:_backgroundView];
		_items = nil;
		self.backgroundColor = [UIColor clearColor];
		delegate = nil;
	}
	
    return self;
}

- (void)setItems:(NSMutableArray*)tabItems {
	
	
	for (int i = 0; i < _items.count; ++i) {
		PPScrollmenuItem* item = [_items objectAtIndex:i];
		[item removeFromSuperview];
	}
	
	[_items removeAllObjects];
	
	[tabItems retain];
	[_items release];
	_items = tabItems;
	
	
	for (int i = 0; i < _items.count; ++i) {
		
		PPScrollmenuItem* menuItem = [_items objectAtIndex:i];
		
		menuItem.delegate = self;
		
		[_backgroundView addSubview:menuItem];
		
		menuItem.tag = i+1;
	}
	
	[self setNeedsLayout];
	
	
}


- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGFloat x = 0;
	
	CGFloat avgWidth = 0;
	
	if(_items.count>0)
	{
		avgWidth = 2*self.bounds.size.width/_items.count;
	}
	for (int i = 0; i<[_items count]; i++) {
		
		PPScrollmenuItem * item = (PPScrollmenuItem *)[_items objectAtIndex:i];
		
		item.frame = CGRectMake(x, self.bounds.origin.y, 2*avgWidth, self.bounds.size.height);
		
		x += item.frame.size.width + kPagging;
	}
	_backgroundView.frame = self.bounds;
	_backgroundView.contentSize = CGSizeMake(x-kPagging , self.frame.size.height);
	
}

-(void)PPScrollmenuItem:(PPScrollmenuItem *) menuItem contentColor:(UIColor *)color
{
	
	_selectedItem.selected = NO;
	[_selectedItem setNeedsDisplay];
	_selectedItem = menuItem;
	_selectedItem.selected = YES;
	[_selectedItem setNeedsDisplay];
	
	
	if([delegate respondsToSelector:@selector(PPScrollmenu:didSelectdItem:atIndex:)])
	{
		[delegate PPScrollmenu:self didSelectdItem:menuItem atIndex:menuItem.tag - 1];
	}
}

- (void)disSelected
{
	_selectedItem.selected = NO;
	[_selectedItem setNeedsDisplay];
}

- (void)dealloc {
	NSLog(@"<PPScrollmenu dealloc>");
	[_backgroundView release];
	[_items release];
    [super dealloc];
	NSLog(@"<PPScrollmenu dealloc end>");
}


@end
