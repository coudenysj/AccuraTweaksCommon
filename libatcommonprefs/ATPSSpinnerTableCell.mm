#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface ATPSSpinnerTableCell : PSTableCell
@end


@implementation ATPSSpinnerTableCell {
	UIActivityIndicatorView *_activityView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self->_activityView = [[UIActivityIndicatorView alloc]
        	initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

	    [self->_activityView startAnimating];
	    [self.contentView addSubview:self->_activityView];
	}

	return self;
}

-(void)layoutSubviews{
	[super layoutSubviews];

	self->_activityView.frame = self.contentView.bounds;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}
@end