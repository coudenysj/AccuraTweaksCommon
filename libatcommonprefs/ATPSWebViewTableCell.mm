#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>

@interface ATPSWebViewTableCell : PSTableCell
@end


@implementation ATPSWebViewTableCell {
	UIWebView* _webView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {

		self->_webView = [[UIWebView alloc]initWithFrame:CGRectZero];
		self->_webView.backgroundColor = [UIColor clearColor];
		self->_webView.opaque = NO;
		self->_webView.scrollView.bounces = NO;
		self->_webView.scrollView.scrollEnabled = NO;

		NSString *url = specifier.properties[@"url"];
		NSURL *urlURL = [NSURL URLWithString:url];
		NSURLRequest* urlRequest = [NSURLRequest requestWithURL:urlURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
		[self->_webView loadRequest:urlRequest];

		[self.contentView addSubview:self->_webView];
	}

	return self;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	self.userInteractionEnabled = YES;

	self->_webView.frame = self.contentView.bounds;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}
@end