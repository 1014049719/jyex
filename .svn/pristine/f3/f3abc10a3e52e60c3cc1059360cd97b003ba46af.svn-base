
#import "PPImageView.h"

@class PPTabItem, PPTabView, PPImageView;

typedef enum {
  PPTabBarBlueStyle = 0,
  PPTabBarGrayStyle = 1,
  PPTabBarCustomStyle = 2
} PPTabBarStyle;

@protocol PPTabBarDelegate;

@interface PPTabBar : UIView {
  id<PPTabBarDelegate> _delegate;
  PPTabBarStyle _style;
  NSInteger _selectedTabIndex;
  UIImageView* _arrowLeft;
  UIImageView* _arrowRight;
  UIScrollView* _contentItemView;
  NSArray* _tabItems;
  NSMutableArray* _tabViews;
  UIColor* _textColor;
  UIColor* _tintColor;
  UIImage* _backImage;
  CGPoint _textOffSet;
}

@property(nonatomic,assign) id<PPTabBarDelegate> delegate;
@property(nonatomic,retain) NSArray* tabItems;
@property(nonatomic,readonly) NSArray* tabViews;
@property(nonatomic,assign) PPTabItem* selectedTabItem;
@property(nonatomic,assign) PPTabView* selectedTabView;
@property(nonatomic) NSInteger selectedTabIndex;
@property(nonatomic) CGPoint textOffSet;
@property(nonatomic,retain) UIColor* textColor;
@property(nonatomic,retain) UIColor* tintColor;
@property(nonatomic,retain) UIImage* tabImage;

-(void)setDelegated:(id<PPTabBarDelegate>)de;
- (PPTabBar *)initWithFrame:(CGRect)frame style:(PPTabBarStyle)style;
- (void)hideTabWithIndex:(NSInteger)tabIndex;
- (void)showTabWithIndex:(NSInteger)tabIndex;


@end

@interface PPTabView : UIControl {
  UILabel* _titleLabel;
  UIImageView* _badgeImage;
  UIImageView* _backImage;
  UILabel* _badgeLabel;
  PPTabBarStyle _style;
  PPTabItem* _tabItem;
  PPImageView* _iconImage;
  
}

@property(nonatomic,retain) PPTabItem* tabItem;

- (id)initWithItem:(PPTabItem*)item tabBar:(PPTabBar*)tabBar style:(PPTabBarStyle)style;

@end

@interface PPTabItem : NSObject {
  
	NSString* _title;
	UIImage * _barImage;//unused
	NSString* _icon;
	id _object;
	int _badgeCount;
	PPTabBar* _tabBar;
}

@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* icon;
@property(nonatomic,retain) id object;
@property(nonatomic) int badgeNumber;

- (id)initWithTitle:(NSString*)title;
- (id)initWithImage:(UIImage *)image;
- (id)initWithCustomView;
@end

@protocol PPTabBarDelegate <NSObject>
- (void)PPTabBar:(PPTabBar*)tabBar didSelectedTabAtIndex:(NSInteger)index;
@end
