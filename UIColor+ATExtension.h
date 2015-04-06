#import <UIKit/UIKit.h>


@interface UIColor (ATExtension)
/*@property (nonatomic, readonly) CGFloat redValue;
@property (nonatomic, readonly) CGFloat greenValue;
@property (nonatomic, readonly) CGFloat blueValue;
@property (nonatomic, readonly) CGFloat alphaValue;*/

+ (instancetype)ATColorWithString:(NSString *)string;
+ (instancetype)ATColorWithRGBValue:(uint32_t)rgb;
+ (instancetype)ATColorWithRGBAValue:(uint32_t)rgba;
@end