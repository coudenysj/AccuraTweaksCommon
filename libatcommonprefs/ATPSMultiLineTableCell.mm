#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "ATPSTableCell.h"
#import "../ATColorExtensions.h"

@interface ATPSMultiLineTableCell : PSTableCell <ATPSTableCell>{
	NSString* _labelText;
	UILabel* _multiLineLabel;
	CGFloat _fontSize;
	UIColor* _textColor;
}
@end

@implementation ATPSMultiLineTableCell

//adds support for bold, italic and some weird text with a background Color
-(void)parseFormatString:(NSString*)markdownString intoAttributedString:(NSMutableAttributedString*)attributedString{
	NSRange range;

	#define boldTagBounds @"*"
	#define boldTagRegExp @"\\*[^\\*]+?\\*"
	#define boldFont [UIFont boldSystemFontOfSize:_fontSize]

	#define italicTagBounds @"**"
	#define italicTagRegExp @"\\*\\*[^\\*]+?\\*\\*"
	#define italicFont [UIFont italicSystemFontOfSize:_fontSize]

	#define codeTagBounds @"***"
	#define codeTagRegExp @"\\*\\*\\*[^\\*]+?\\*\\*\\*"

	#define codeFont  [UIFont fontWithName:@"AmericanTypewriter" size:_fontSize]
	#define codeFGColor [UIColor colorWithWhite:0.3 alpha:1.000]
	#define codeBGColor [UIColor colorWithWhite:0 alpha:0.05]

	if(_textColor){
		NSRange rangeAfterReplacing = {0,[[self cleanedMarkdownString:markdownString]length]};
		[attributedString addAttribute:NSForegroundColorAttributeName value:_textColor range:rangeAfterReplacing];
	}

	while ((range = [markdownString rangeOfString:codeTagRegExp options:NSRegularExpressionSearch]).location != NSNotFound) {
		NSString* newRangeContent = [[markdownString substringWithRange:range] stringByReplacingOccurrencesOfString:codeTagBounds withString:@""];
		markdownString = [markdownString stringByReplacingCharactersInRange:range withString:newRangeContent];

		NSUInteger numberOfCtrMarks = [[[markdownString substringToIndex:range.location] componentsSeparatedByString:boldTagBounds] count] - 1;
		//numberOfCtrMarks += [[[markdownString substringToIndex:range.location] componentsSeparatedByString:codeTagBounds] count] - 1;

		NSRange rangeAfterReplacing = {range.location - numberOfCtrMarks, range.length - 2*[codeTagBounds length]};

   		[attributedString addAttribute:NSFontAttributeName value:codeFont range:rangeAfterReplacing];
   		[attributedString addAttribute:NSForegroundColorAttributeName value:codeFGColor range:rangeAfterReplacing];
        [attributedString addAttribute:NSBackgroundColorAttributeName value:codeBGColor range:rangeAfterReplacing];
   	}

	while ((range = [markdownString rangeOfString:italicTagRegExp options:NSRegularExpressionSearch]).location != NSNotFound) {
		NSString* newRangeContent = [[markdownString substringWithRange:range] stringByReplacingOccurrencesOfString:italicTagBounds withString:@""];
		markdownString = [markdownString stringByReplacingCharactersInRange:range withString:newRangeContent];

		NSUInteger numberOfCtrMarks = [[[markdownString substringToIndex:range.location] componentsSeparatedByString:boldTagBounds] count] - 1;

		NSRange rangeAfterReplacing = {range.location - numberOfCtrMarks, range.length - 2*[italicTagBounds length]};

   		[attributedString addAttribute:NSFontAttributeName value:italicFont range:rangeAfterReplacing];

   	}

	while ((range = [markdownString rangeOfString:boldTagRegExp options:NSRegularExpressionSearch]).location != NSNotFound) {
		NSString* newRangeContent = [[markdownString substringWithRange:range] stringByReplacingOccurrencesOfString:boldTagBounds withString:@""];
		markdownString = [markdownString stringByReplacingCharactersInRange:range withString:newRangeContent];

		NSUInteger numberOfCtrMarks = [[[markdownString substringToIndex:range.location] componentsSeparatedByString:boldTagBounds] count] - 1;
		numberOfCtrMarks += [[[markdownString substringToIndex:range.location] componentsSeparatedByString:italicTagBounds] count] - 1;

		NSRange rangeAfterReplacing = {range.location - numberOfCtrMarks, range.length - 2*[boldTagBounds length]};

   		[attributedString addAttribute:NSFontAttributeName value:boldFont range:rangeAfterReplacing];
   	}
}

-(NSString*)cleanedMarkdownString:(NSString*)markdownString{
	#define tagBounds @"*"
	return  [markdownString stringByReplacingOccurrencesOfString:tagBounds withString:@""];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		_labelText = specifier.properties[@"multiLineLabel"];
		_multiLineLabel = [[UILabel alloc]init];

		//get font size
		UIFont *sizedFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
		_fontSize = sizedFont.pointSize;
		_multiLineLabel.font = [UIFont systemFontOfSize:_fontSize];
		_multiLineLabel.numberOfLines = 0;

		id backgroundColor = [specifier.properties objectForKey:@"backgroundColor"];
		if([backgroundColor isKindOfClass:[UIColor class]]){
			self.backgroundColor = backgroundColor;
		}else if([backgroundColor isKindOfClass:[NSString class]]){
			self.backgroundColor = [UIColor ATColorWithString:backgroundColor];
		}

		id textColor = [specifier.properties objectForKey:@"textColor"];
		if([textColor isKindOfClass:[UIColor class]]){
			_textColor = textColor;
		}else if([textColor isKindOfClass:[NSString class]]){
			_textColor = [UIColor ATColorWithString:textColor];
		}else{
			_textColor = [UIColor blackColor];
		}


		NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
		paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
		paragraphStyles.firstLineHeadIndent = 2.0f;                //must have a value to make it work

		NSString* cleanedText = [self cleanedMarkdownString:_labelText];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cleanedText];
		[self parseFormatString:_labelText intoAttributedString:attributedString];

		if(!specifier.properties[@"noJustify"]){
			[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyles range:NSMakeRange(0, [cleanedText length])];
		}

		_multiLineLabel.attributedText = attributedString;


		[self.contentView addSubview:_multiLineLabel];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	float leftMargin = 0;
	UIImageView* iconImageView = [self iconImageView];
	if(iconImageView){
		leftMargin = iconImageView.frame.origin.x + iconImageView.frame.size.width;
	}

	//I don't like this. Should update this.
    _multiLineLabel.frame = CGRectMake(leftMargin + 20,5,self.contentView.bounds.size.width - 40 - leftMargin, self.contentView.bounds.size.height - 15);
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	//still a bit hacky.

	UIImageView* iconImageView = [self iconImageView];
	if(iconImageView){
		width -= (/*iconImageView.frame.origin.x*/20 + iconImageView.image.size.width);
	}
	if(self.specifier->cellType == PSLinkCell || self.specifier->cellType == PSLinkListCell){
		width -= 35;
	}
	CGRect labelRect = [_multiLineLabel.text boundingRectWithSize:CGSizeMake(width - 60, 0) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:_fontSize]} context:nil];

	return labelRect.size.height + 20;
}


@end