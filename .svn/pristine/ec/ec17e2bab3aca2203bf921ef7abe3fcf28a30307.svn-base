#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PPShinyLabel : UIView {
  NSString* _text;
  UIFont* _font;
  UIColor* textColor;
  UIColor* _spotlightColor;
  NSTextAlignment _textAlignment;
  NSTimer* _timer;
  CGFloat _spotlightPoint;
  CGContextRef _maskContext;
  void* _maskData;
}

@property(nonatomic,copy) NSString* text;
@property(nonatomic,retain) UIFont* font;
@property(nonatomic,retain) UIColor* textColor;
@property(nonatomic,retain) UIColor* spotlightColor;
@property(nonatomic) NSTextAlignment textAlignment;

- (void)startAnimating;
- (void)stopAnimating;

@end
