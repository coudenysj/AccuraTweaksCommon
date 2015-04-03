#import <UIKit/UIKit.h>

//contains methods for easier animations using custom timeing functions. Like realizing an animation like the one proposed by google for google material design ("swift out / swift in"). Dubbed "authentic" here.

@interface UIView (ATAnimate)
- (void)ATAuthenticAnimateFrameTo:(CGRect)to withDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;
- (void)ATAnimateFrameTo:(CGRect)toRect withDuration:(NSTimeInterval)duration timingFunction:(CAMediaTimingFunction*)timingFunction completion:(void (^)(void))completion;
+ (void)ATAnimateWithDuration:(NSTimeInterval)duration timingFunction:(CAMediaTimingFunction*)timingFunction animation:(void (^)(void))animation completion:(void (^)(void))completion;
@end