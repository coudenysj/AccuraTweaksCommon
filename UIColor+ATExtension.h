#import <UIKit/UIKit.h>


@interface UIColor (ATExtension)
- (CGFloat) ATRedComponent;
- (CGFloat) ATGreenComponent;
- (CGFloat) ATBlueComponent;
- (CGFloat) ATAlphaComponent;
- (void)ATGetRGBAComponents:(CGFloat[4])rgba;
- (CGFloat)ATBrightness;

+ (instancetype)ATColorWithString:(NSString *)string;
+ (instancetype)ATColorWithRGBValue:(uint32_t)rgb;
+ (instancetype)ATColorWithRGBAValue:(uint32_t)rgba;
@end