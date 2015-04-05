#import "ATPSAccuraTweaksTableCell.h"

@implementation AccuraLogoView
-(AccuraLogoView*)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		_logoImageView = [[UIImageView alloc]init];
		[self addSubview:_logoImageView];
	}
	return self;
}
-(void)setLogoImage:(UIImage*)image{
	_logoImage = image;
	self.logoImageView.image = self.logoImage;
}
-(void)layoutSubviews{
	[super layoutSubviews];
	if(self.logoImage){
		CGFloat width = self.bounds.size.width;
		CGFloat height = self.bounds.size.height;

		CGFloat logoRatio = self.logoImageView.image.size.width / self.logoImageView.image.size.height;
		CGFloat logoWidth = width * 0.6;
		CGFloat logoHeight = logoWidth/logoRatio;


		CGFloat logoHorizontalMargin = width * 0.20;
		CGFloat logoVerticalMargin = (height - logoHeight)/2;

		CGRect logoFrame = CGRectMake(logoHorizontalMargin , logoVerticalMargin, logoWidth, logoHeight);

		self.logoImageView.frame = logoFrame;
	}

}
@end


@interface AccuraTeamView : UIView{
	BOOL _simonIsFirst;
}
@property(nonatomic)UIImage* head1Image;
@property(nonatomic)UIImage* head2Image;
@property(nonatomic)UIImageView* head1;
@property(nonatomic)UIImageView* head2;
@property(nonatomic)UILabel* head1RoleLabel;
@property(nonatomic)UILabel* head2RoleLabel;
@property(nonatomic)UILabel* head1NameLabel;
@property(nonatomic)UILabel* head2NameLabel;

@end

@implementation AccuraTeamView
-(AccuraTeamView*)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		_simonIsFirst = (BOOL)(arc4random() % 2);

		_head1 = [[UIImageView alloc]init];
		_head2 = [[UIImageView alloc]init];
		_head1RoleLabel = [[UILabel alloc]init];
		_head2RoleLabel = [[UILabel alloc]init];

		_head1RoleLabel.text = @"DEVELOPER";
		_head1RoleLabel.textAlignment = NSTextAlignmentCenter;
		_head1RoleLabel.textColor = [UIColor colorWithRed:0.427 green:0.427 blue:0.447 alpha:0.8];
		_head1RoleLabel.font = [UIFont systemFontOfSize:10];

		_head2RoleLabel.text = @"DESIGNER";
		_head2RoleLabel.textAlignment = NSTextAlignmentCenter;
		_head2RoleLabel.textColor = [UIColor colorWithRed:0.427 green:0.427 blue:0.447 alpha:0.8];
		_head2RoleLabel.font = [UIFont systemFontOfSize:10];

		_head1NameLabel = [[UILabel alloc]init];
		_head2NameLabel = [[UILabel alloc]init];

		_head1NameLabel.text = @"Simon Selg";
		_head1NameLabel.textAlignment = NSTextAlignmentCenter;
		_head1NameLabel.textColor = [UIColor blackColor];
		_head1NameLabel.font = [UIFont systemFontOfSize:14];

		_head2NameLabel.text = @"Ibrahim Al-Dalaimi";
		_head2NameLabel.textAlignment = NSTextAlignmentCenter;
		_head2NameLabel.textColor = [UIColor blackColor];
		_head2NameLabel.font = [UIFont systemFontOfSize:14];

		[self addSubview:_head1];
		[self addSubview:_head2];

		[self addSubview:_head1RoleLabel];
		[self addSubview:_head2RoleLabel];

		[self addSubview:_head1NameLabel];
		[self addSubview:_head2NameLabel];
	}
	return self;
}
-(void)setHead1Image:(UIImage*)image{
	_head1Image = image;
	self.head1.image = self.head1Image;
}
-(void)setHead2Image:(UIImage*)image{
	_head2Image = image;
	self.head2.image = self.head2Image;
}
-(void)layoutSubviews{
	[super layoutSubviews];
	//8 | 38 |8 | 38 | 8
	if(self.head1Image && self.head2Image){
		CGFloat width = self.bounds.size.width;
		CGFloat height = self.bounds.size.height;

		CGFloat headRatio = self.head1.image.size.width / self.head1.image.size.height;
		CGFloat headWidth = width * 0.38;
		CGFloat headHeight = headWidth/headRatio;

		CGFloat headVerticalMargin = (height - headHeight)/2;
		CGFloat horizontalMargin = width * 0.08;

		CGRect head1Frame = CGRectMake(horizontalMargin, headVerticalMargin, headWidth, headHeight);
		CGRect head2Frame = CGRectMake(horizontalMargin*2 + headWidth, headVerticalMargin, headWidth, headHeight);

		CGRect head1RoleLabelFrame = CGRectMake(horizontalMargin, headVerticalMargin - 4 - 14, headWidth, 14);
		CGRect head2RoleLabelFrame = CGRectMake(horizontalMargin*2 + headWidth, headVerticalMargin - 4 - 14, headWidth, 14);

		CGRect head1NameLabelFrame = CGRectMake(horizontalMargin, headVerticalMargin + headHeight + 6, headWidth, 16);
		CGRect head2NameLabelFrame = CGRectMake(horizontalMargin*2 + headWidth, headVerticalMargin + headHeight + 6, headWidth, 16);


		if(_simonIsFirst){
			self.head1.frame = head1Frame;
			self.head2.frame = head2Frame;

			self.head1RoleLabel.frame = head1RoleLabelFrame;
			self.head2RoleLabel.frame = head2RoleLabelFrame;

			self.head1NameLabel.frame = head1NameLabelFrame;
			self.head2NameLabel.frame = head2NameLabelFrame;
		}else{
			self.head1.frame = head2Frame;
			self.head2.frame = head1Frame;

			self.head1RoleLabel.frame = head2RoleLabelFrame;
			self.head2RoleLabel.frame = head1RoleLabelFrame;

			self.head1NameLabel.frame = head2NameLabelFrame;
			self.head2NameLabel.frame = head1NameLabelFrame;
		}
	}
}
@end

@implementation ATPSAccuraTweaksTableCell{
	AccuraLogoView *_logoView;
	AccuraTeamView *_teamView;
	BOOL _showsLogo;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];
	if (self) {
		//self.backgroundColor = [UIColor clearColor];
		_showsLogo = YES;

		_logoView = [[AccuraLogoView alloc] initWithFrame:CGRectZero];
		_logoView.logoImage = [UIImage imageNamed:specifier.properties[@"logo"]];

		_teamView = [[AccuraTeamView alloc] initWithFrame:CGRectZero];
		_teamView.head1Image = [UIImage imageNamed:specifier.properties[@"head1"]];
		_teamView.head2Image = [UIImage imageNamed:specifier.properties[@"head2"]];


		self.layer.masksToBounds = YES;
		[self.contentView addSubview:_logoView];
		[self.contentView addSubview:_teamView];

		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(tabHandler)];
		singleTap.numberOfTapsRequired = 1;
		[self addGestureRecognizer:singleTap];

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[self makeTransitionToTeam];
		});
	}

	return self;
}

-(void)layoutSubviews{
	[super layoutSubviews];

	CGFloat viewWidth = self.contentView.bounds.size.width;
	CGFloat viewHeight = [self preferredHeightForWidth:viewWidth];

	if(_showsLogo){
		_logoView.frame = CGRectMake(0,0, viewWidth, viewHeight);
		_teamView.frame = CGRectMake(0,self.contentView.bounds.size.height+1, viewWidth, viewHeight);
	}else{
		_logoView.frame = CGRectMake(0,-(viewHeight), viewWidth, viewHeight);
		_teamView.frame = CGRectMake(0,0, viewWidth, viewHeight);
	}
}

-(void)tabHandler{
	if(_showsLogo){
		[self makeTransitionToTeam];
	}else{
		[self makeTransitionToLogo];
	}
}

-(void)makeTransitionToTeam{
	if(_showsLogo == false)
		return;

	_showsLogo = false;

	CGFloat viewWidth = self.contentView.bounds.size.width;
	CGFloat viewHeight = [self preferredHeightForWidth:viewWidth];

    CGRect logoViewFrame = CGRectMake(0,-(viewHeight), viewWidth, viewHeight);
	CGRect teamViewFrame = CGRectMake(0,0, viewWidth, viewHeight);

    [_logoView ATAuthenticAnimateFrameTo:logoViewFrame withDuration:0.75 completion:nil];

	[_teamView ATAuthenticAnimateFrameTo:teamViewFrame withDuration:0.75 completion:nil];
}

-(void)makeTransitionToLogo{
	if(_showsLogo == true)
		return;

	_showsLogo = true;

	CGFloat viewWidth = self.contentView.bounds.size.width;
	CGFloat viewHeight = [self preferredHeightForWidth:viewWidth];

	CGRect logoViewFrame = CGRectMake(0,0, viewWidth, viewHeight);
	CGRect teamViewFrame = CGRectMake(0,self.contentView.bounds.size.height+1, viewWidth, viewHeight);

    [_logoView ATAuthenticAnimateFrameTo:logoViewFrame withDuration:1 completion:nil];

	[_teamView ATAuthenticAnimateFrameTo:teamViewFrame withDuration:1 completion:nil];
}



- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
	return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	CGFloat imageRatio = 2.4;
	return floor(width / imageRatio);
}
@end