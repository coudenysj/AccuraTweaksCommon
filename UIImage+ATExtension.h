

#import <UIKit/UIKit.h>

@interface UIImage (ATExtension)
- (unsigned char *)rawPixelDataWithPixelCount:(unsigned int*)pixelCountPtr;
- (NSArray *)ATExtractColors;
- (UIColor *)ATMainColor;
- (UIColor *)ATAverageColor;
@end