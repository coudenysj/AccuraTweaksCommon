#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "../UIView+ATAnimate.h"

@interface ATPSAccuraTweaksTableCell : PSTableCell
-(void)makeTransitionToTeam;
-(void)makeTransitionToLogo;
@end

@interface AccuraLogoView : UIView
@property(nonatomic)UIImage* logoImage;
@property(nonatomic)UIImageView* logoImageView;
@end