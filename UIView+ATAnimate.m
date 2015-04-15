#import "UIView+ATAnimate.h"

@implementation UIView (ATAnimate)

- (void)ATAuthenticAnimateFrameTo:(CGRect)toRect withDuration:(NSTimeInterval)duration completion:(void (^)(void))completion{
    //from here: Google Material Desing: http://www.google.com/design/spec/animation/authentic-motion.html#authentic-motion-mass-weight

    CAMediaTimingFunction * swiftOutTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.40 :0 :0.2 :1];
    [self ATAnimateFrameTo:toRect withDuration:duration timingFunction:swiftOutTimingFunction completion:completion];
}


- (void)ATAnimateFrameTo:(CGRect)toRect withDuration:(NSTimeInterval)duration timingFunction:(CAMediaTimingFunction*)timingFunction completion:(void (^)(void))completion
{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:completion];

            CGPoint fromPosition = ((CALayer*)self.layer.presentationLayer).position; //make sure we start at the current position - in case there's another animation going on!
            CGPoint toPosition = CGPointMake(CGRectGetMidX(toRect), CGRectGetMidY(toRect));

            self.layer.position = toPosition;
            CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            positionAnimation.timingFunction = timingFunction;
            positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
            positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
            positionAnimation.duration = duration;


            CGRect boundsFrom = ((CALayer*)self.layer.presentationLayer).bounds; //make sure we start with the current bounds - in case there's another animation going on!
            CGRect boundsTo = CGRectMake(0,0,toRect.size.width,toRect.size.height);

            self.layer.bounds = boundsTo;
            CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
            boundsAnimation.timingFunction = timingFunction;
            boundsAnimation.fromValue = [NSValue valueWithCGRect:boundsFrom];
            boundsAnimation.toValue = [NSValue valueWithCGRect:boundsTo];
            boundsAnimation.duration = duration;


            [self.layer addAnimation:positionAnimation forKey:@"position"];
            [self.layer addAnimation:boundsAnimation forKey:@"bounds"];


    } [CATransaction commit];
}

//don't use this for frame animations - use it for colors or opacity.
+ (void)ATAnimateWithDuration:(NSTimeInterval)duration timingFunction:(CAMediaTimingFunction*)timingFunction animation:(void (^)(void))animation completion:(void (^)(void))completion
{
    [UIView beginAnimations:nil context:NULL];
    [CATransaction begin];{
        [CATransaction setAnimationDuration:duration];
        [CATransaction setAnimationTimingFunction:timingFunction];
        [CATransaction setCompletionBlock:completion];

        animation();

        [CATransaction commit];
    }
    [UIView commitAnimations];
}


@end