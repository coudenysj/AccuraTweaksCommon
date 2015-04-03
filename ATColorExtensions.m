#import "ATColorExtensions.h"

@implementation UIColor (ATColorExtensions)

+ (NSDictionary *)ATStandardColors
{
    static NSDictionary *colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //todo: add more colors. Like babyBlue. APpple uses that for facetime buttons
        colors = @{@"black": [self blackColor],
                  @"darkgray": [self darkGrayColor],
                  @"lightgray": [self lightGrayColor],
                  @"white": [self whiteColor],
                  @"gray": [self grayColor],
                  @"red": [self redColor],
                  @"green": [self greenColor],
                  @"blue": [self blueColor],
                  @"cyan": [self cyanColor],
                  @"yellow": [self yellowColor],
                  @"magenta": [self magentaColor],
                  @"orange": [self orangeColor],
                  @"purple": [self purpleColor],
                  @"brown": [self brownColor],
                  @"clear": [self clearColor],
                  @"systemBlue": [self colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]};
    });

    return colors;
}

+ (instancetype)ATColorWithString:(NSString *)string
{
    string = [string lowercaseString];

    //try standard colors first
    UIColor *color = nil;
    color = [self ATStandardColors][string];

    if (color)
        return color;

    return [[self alloc] ATInitWithString:string];
}

+ (instancetype)ATColorWithRGBValue:(uint32_t)rgb
{
    return [[self alloc] initWithRGBValue:rgb];
}

+ (instancetype)ATColorWithRGBAValue:(uint32_t)rgba
{
    return [[self alloc] initWithRGBAValue:rgba];
}

- (instancetype)ATInitWithString:(NSString *)string
{
    //convert to lowercase
    string = [string lowercaseString];

    //try hex. Todo: differntiate between hex and decimal
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"0x" withString:@""];

    //convert to RGBA.
    switch ([string length])
    {
        case 0:
        {
            string = @"00000000";
            break;
        }
        case 3:
        {
            NSString *red = [string substringWithRange:NSMakeRange(0, 1)];
            NSString *green = [string substringWithRange:NSMakeRange(1, 1)];
            NSString *blue = [string substringWithRange:NSMakeRange(2, 1)];
            string = [NSString stringWithFormat:@"%1$@%1$@%2$@%2$@%3$@%3$@ff", red, green, blue];
            break;
        }
        case 6:
        {
            //RGB format. Convert to RGBA with alpha 1
            string = [string stringByAppendingString:@"ff"];
            break;
        }
        case 8:
        {
            //no need to convert. allready in RGBA format
            break;
        }
        default:
        {
            //well - shit.
            return nil;
        }
    }

    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanHexInt:&rgba];
    return [self initWithRGBAValue:rgba];
}

- (instancetype)initWithRGBValue:(uint32_t)rgb
{
    //oh apple. why don't you accept RGB based on 255?!?
    CGFloat red = ((rgb & 0xFF0000) >> 16) / 255.0f;
	CGFloat green = ((rgb & 0x00FF00) >> 8) / 255.0f;
	CGFloat blue = (rgb & 0x0000FF) / 255.0f;
	return [self initWithRed:red green:green blue:blue alpha:1.0f];
}

- (instancetype)initWithRGBAValue:(uint32_t)rgba
{
    CGFloat red = ((rgba & 0xFF000000) >> 24) / 255.0f;
    CGFloat green = ((rgba & 0x00FF0000) >> 16) / 255.0f;
	CGFloat blue = ((rgba & 0x0000FF00) >> 8) / 255.0f;
	CGFloat alpha = (rgba & 0x000000FF) / 255.0f;
	return [self initWithRed:red green:green blue:blue alpha:alpha];
}

/*- (CGFloat)redValue
{
    CGFloat rgba[4];
    [self getRGBAComponents:rgba];
	return rgba[0];
}

- (CGFloat)greenValue
{
    CGFloat rgba[4];
    [self getRGBAComponents:rgba];
	return rgba[1];
}

- (CGFloat)blueValue
{
    CGFloat rgba[4];
    [self getRGBAComponents:rgba];
	return rgba[2];
}

- (CGFloat)alphaValue
{
    return CGColorGetAlpha(self.CGColor);
}*/

@end
