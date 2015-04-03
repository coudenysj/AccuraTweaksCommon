#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSHeaderFooterView.h>
#import <Preferences/PSTextFieldSpecifier.h>
#import <Preferences/PSHeaderFooterView.h>
#import <Preferences/PSTableCell.h>



@interface ATPSImageTableCell : PSTableCell <PSHeaderFooterView>
@end


@implementation ATPSImageTableCell {
	UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self.backgroundColor = [UIColor clearColor];

		_imageView = [[UIImageView alloc] initWithImage:specifier.properties[@"iconImage"]];
		[self.contentView addSubview:_imageView];

		self.imageView.hidden = YES;
		self.textLabel.hidden = YES;
		self.detailTextLabel.hidden = YES;
	}

	return self;
}

-(void)layoutSubviews{
	[super layoutSubviews];

	CGFloat imageRatio = _imageView.image.size.width / _imageView.image.size.height;

	CGFloat imageWidth = self.contentView.bounds.size.width;
	CGFloat imageHeight = imageWidth / imageRatio;

	_imageView.frame = CGRectMake(0,0, imageWidth, imageHeight);
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	CGFloat imageRatio = _imageView.image.size.width / _imageView.image.size.height;
	return width / imageRatio;
}
@end