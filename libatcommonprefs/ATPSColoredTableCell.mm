#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "../ATColorExtensions.h"

@interface ATPSColoredTableCell : PSTableCell
@end


@implementation ATPSColoredTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];
	return self;
}

-(void)layoutSubviews{
	[super layoutSubviews];

	id backgroundColor = [self.specifier.properties objectForKey:@"backgroundColor"];

	if([backgroundColor isKindOfClass:[UIColor class]]){
		self.backgroundColor = backgroundColor;
	}else if([backgroundColor isKindOfClass:[NSString class]]){
		self.backgroundColor = [UIColor ATColorWithString:backgroundColor];
	}else{
		self.backgroundColor = nil;
	}

	id textColor = [self.specifier.properties objectForKey:@"textColor"];

	if([textColor isKindOfClass:[UIColor class]]){
		self.textLabel.textColor = textColor;
	}else if([textColor isKindOfClass:[NSString class]]){
		self.textLabel.textColor = [UIColor ATColorWithString:textColor];
	}else{
		self.textLabel.textColor = [UIColor blackColor];
	}
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}
@end