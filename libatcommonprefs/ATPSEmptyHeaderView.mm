#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSHeaderFooterView.h>
#import <Preferences/PSTableCell.h>

@interface ATPSEmptyHeaderView : PSTableCell <PSHeaderFooterView>
@end


//an allmost empty header view. great to force an group specifier to start at the top of the prefs page

@implementation ATPSEmptyHeaderView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	//when we make it 0, PSListController won't use it
	return 0.1;
}
@end
