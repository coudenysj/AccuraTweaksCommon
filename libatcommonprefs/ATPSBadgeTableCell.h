#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "../UIColor+ATExtension.h"
#import "ATPSTableCell.h"

@interface ATBadgeView : UIView

@property (nonatomic, retain)    NSString *badgeString;
@property (nonatomic, retain)    UIColor *badgeColor;
@property (nonatomic, retain)    UIColor *badgeTextColor;
@property (nonatomic, retain)    UIColor *badgeBorderColor;
@property (nonatomic, assign)    CGFloat badgeBorderWidth;
@property (nonatomic, assign)    CGFloat horizPadding;
@property (nonatomic, assign)    CGFloat fontSize;
@property (nonatomic, assign)    CGFloat radius;

@end


@interface ATPSBadgeTableCell : PSTableCell <ATPSTableCell>{
	CGFloat _defaultBadgeHorizPadding;
	CGFloat _defaultBadgeVertPadding;
}
@property (nonatomic, retain)  NSString *badgeString;
@property (nonatomic, retain)  ATBadgeView *badge;
@property (nonatomic, retain)  UIColor *badgeColor;
@property (nonatomic, retain)  UIColor *badgeTextColor;
@property (nonatomic, retain)  UIColor *badgeBorderColor;
@property (nonatomic, assign)    CGFloat badgeBorderWidth;
@property (nonatomic, assign)  CGFloat badgeHorizPadding;
@property (nonatomic, assign)  CGFloat badgeVertPadding;
@property (nonatomic, assign)  CGFloat badgeLeftMargin;
@property (nonatomic, assign)  CGFloat badgeRightMargin;
@property (nonatomic, assign)  BOOL badgeMakeRound;
@property (nonatomic, assign)  CGFloat badgeRadius;
@property (nonatomic, assign)  NSString* badgeAlignment;
@end