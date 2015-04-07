#import "ATPSBadgeTableCell.h"

@implementation ATBadgeView

- (id) initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.backgroundColor = [UIColor clearColor];
		self.fontSize = 11.f;
	}

	return self;
}

- (void) drawRect:(CGRect)rect
{
    // Set up variable for drawing
    CGFloat scale = [[UIScreen mainScreen] scale];
	CGFloat fontsize = self.fontSize;
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    CGSize numberSize = [self.badgeString sizeWithAttributes:@{ NSFontAttributeName:font }];
    if(!self.radius)
    	self.radius = 8.5;

    //prevent overflow. Todo: cleanup here!
    if(numberSize.width > (self.frame.size.width - 2*self.horizPadding)){
    	numberSize.width = (self.frame.size.width - 2*self.horizPadding);
    }


    UIColor *color;
    if(self.badgeColor)
        color = self.badgeColor;
    else
    	color = [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1.0];

	CALayer *badgeLayer = [CALayer layer];
	[badgeLayer setFrame:rect];
	[badgeLayer setBackgroundColor:[color CGColor]];
	[badgeLayer setCornerRadius:self.radius];

    if(self.badgeBorderColor){
        [badgeLayer setBorderWidth:self.badgeBorderWidth];
        [badgeLayer setBorderColor:self.badgeBorderColor.CGColor];
    }else{
        [badgeLayer setBorderWidth:0];
    }

    UIGraphicsBeginImageContextWithOptions(badgeLayer.frame.size, NO, scale);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSaveGState(context);
	[badgeLayer renderInContext:context];
	CGContextRestoreGState(context);

    //Frame for the badge text
	CGRect bounds = CGRectMake((rect.size.width / 2) - (numberSize.width / 2) ,
                               ((rect.size.height / 2) - (numberSize.height / 2)),
                               numberSize.width , numberSize.height);

    //draw the text. if clear color, clip it
    UIColor *stringColor = nil;
    if(self.badgeTextColor){
        stringColor = self.badgeTextColor;
    	CGContextSetBlendMode(context, kCGBlendModeNormal);
    }
    else{
        stringColor = [UIColor clearColor];
        CGContextSetBlendMode(context, kCGBlendModeClear);
    }


    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.badgeString drawInRect:bounds withAttributes:@{ NSFontAttributeName:font,
                                                       NSParagraphStyleAttributeName:paragraph,
                                                       NSForegroundColorAttributeName:stringColor}];


	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[outputImage drawInRect:rect];

    //make corners roudn if needed
    [[self layer] setCornerRadius:self.radius];

}
@end

@implementation ATPSBadgeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self.badge = [[ATBadgeView alloc] initWithFrame:CGRectZero];

		//defaults
		_defaultBadgeHorizPadding = 6;
		_defaultBadgeVertPadding = 3;
		self.badge.fontSize = 13.0;

    	[self.contentView addSubview:self.badge];

	}

	return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];

    //badge stuff
    self.badgeLeftMargin = [self.specifier.properties objectForKey:@"badgeLeftMargin"] ? [[self.specifier.properties objectForKey:@"badgeLeftMargin"]floatValue] : 10.0;
    self.badgeRightMargin = [self.specifier.properties objectForKey:@"badgeLeftMargin"] ? [[self.specifier.properties objectForKey:@"badgeLeftMargin"]floatValue] : 10.0;

	self.badgeString = [self.specifier.properties objectForKey:@"badgeString"];
	self.badgeMakeRound = [self.specifier.properties objectForKey:@"badgeMakeRound"] ? [[self.specifier.properties objectForKey:@"badgeMakeRound"] boolValue] : YES;
	self.badgeRadius = [[self.specifier.properties objectForKey:@"badgeRadius"] floatValue];
    self.badgeAlignment = [self.specifier.properties objectForKey:@"badgeAlignment"];// ? [self.specifier.properties objectForKey:@"badgeAlignment"] : @"left";
    self.badgeBorderWidth = [self.specifier.properties objectForKey:@"badgeBorderWidth"] ? [[self.specifier.properties objectForKey:@"badgeBorderWidth"] floatValue] : 2;


    id badgeColor = [self.specifier.properties objectForKey:@"badgeColor"];
	id badgeTextColor = [self.specifier.properties objectForKey:@"badgeTextColor"];
    id badgeBorderColor = [self.specifier.properties objectForKey:@"badgeBorderColor"];

	if([badgeColor isKindOfClass:[UIColor class]]){
		self.badgeColor = badgeColor;
	}else if([badgeColor isKindOfClass:[NSString class]]){
		self.badgeColor = [UIColor ATColorWithString:badgeColor];
	}else{
		self.badgeColor = nil;
	}

	if([badgeTextColor isKindOfClass:[UIColor class]]){
		self.badgeTextColor = badgeTextColor;
	}else if([badgeTextColor isKindOfClass:[NSString class]]){
		self.badgeTextColor = [UIColor ATColorWithString:badgeTextColor];
	}else{
		self.badgeTextColor = nil;
	}

    if([badgeBorderColor isKindOfClass:[UIColor class]]){
        self.badgeBorderColor = badgeBorderColor;
    }else if([badgeBorderColor isKindOfClass:[NSString class]]){
        self.badgeBorderColor = [UIColor ATColorWithString:badgeBorderColor];
    }else{
        self.badgeBorderColor = nil;
    }

    if(!self.badgeBorderColor){
        self.badgeBorderWidth = 0;
    }
    self.badgeHorizPadding = _defaultBadgeHorizPadding + self.badgeBorderWidth;
    self.badgeVertPadding = _defaultBadgeVertPadding + self.badgeBorderWidth;


	if(self.badgeString && ![self.badgeString isEqual:@""])
	{
        self.badge.hidden = NO;

        // Calculate the size of the bage from the badge string
        UIFont *font = [UIFont systemFontOfSize:self.badge.fontSize];

        CGSize badgeSize;
        badgeSize = [self.badgeString sizeWithAttributes:@{ NSFontAttributeName:font }];

        CGSize labelSize = [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName:self.textLabel.font}];

        //todo: Add support for custom left margin
        CGRect badgeframe;
        if([self.badgeAlignment isEqualToString:@"right"]){
            CGFloat contentViewWidth = self.contentView.bounds.size.width - self.badgeRightMargin;

            //right aligned
            CGFloat badgeMinX = self.textLabel.frame.origin.x + labelSize.width + self.badgeLeftMargin;
            CGFloat badgeX = contentViewWidth - (badgeSize.width + 2*self.badgeHorizPadding);
            if(badgeX < badgeMinX){
                badgeX = badgeMinX;
            }

            badgeframe = CGRectMake(badgeX, round((self.contentView.frame.size.height - (badgeSize.height + 2*self.badgeVertPadding)) / 2),
                                      contentViewWidth - badgeX,
                                       badgeSize.height + 2*self.badgeVertPadding);

        }else{
            //left
            CGFloat badgeX = self.textLabel.frame.origin.x + self.badgeLeftMargin + labelSize.width;
            CGFloat badgeMaxX = self.contentView.bounds.size.width - self.badgeRightMargin;

            CGFloat badgeWidth = badgeSize.width + 2*self.badgeHorizPadding;
            if((badgeWidth + badgeX) > badgeMaxX){
                badgeWidth = (badgeMaxX - badgeX);
            }

            badgeframe = CGRectMake(badgeX, round((self.contentView.frame.size.height - (badgeSize.height + 2*self.badgeVertPadding)) / 2),
                                       badgeWidth,
                                       badgeSize.height + 2*self.badgeVertPadding);
        }


        if(self.badgeMakeRound){
        	self.badgeRadius = badgeframe.size.height/2;
        	if(badgeframe.size.width < badgeframe.size.height){
        		//make it round, it's possible!
        		badgeframe.size.width = badgeframe.size.height;
        	}
        }

        // Set the badge string
		[self.badge setFrame:badgeframe];
		[self.badge setBadgeString:self.badgeString];

		self.badge.horizPadding = self.badgeHorizPadding;
 		//set badge colors or force it to use defaults
		self.badge.badgeColor = self.badgeColor;
		self.badge.badgeTextColor = self.badgeTextColor;
        self.badge.badgeBorderColor = self.badgeBorderColor;
		self.badge.radius = self.badgeRadius;
        self.badge.badgeBorderWidth = self.badgeBorderWidth;
		[self.badge setNeedsDisplay];

    }
	else
	{
		 self.badge.hidden = YES;
	}

}


- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}
@end