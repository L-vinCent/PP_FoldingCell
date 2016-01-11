//
//  RotatedView.m
//  SocketTest
//
//  Created by Imac 21 on 16/1/5.
//  Copyright © 2016年 Imac 21. All rights reserved.
//

#import "RotatedView.h"




@implementation RotatedView

@synthesize backView;
@synthesize hiddenAfterAnimation;

-(void)awakeFromNib
{
    hiddenAfterAnimation=NO;
}
-(void)addBackViewHeight:(CGFloat)height color:(UIColor *)color
{

    RotatedView *view=[[RotatedView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = color;
    backView.backgroundColor=[UIColor greenColor];
    view.layer.anchorPoint = CGPointMake(0.5,1);
    view.layer.transform=[self transform3d];
    view.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:view];
     backView=view;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                        constant:height]];
    
    NSLayoutConstraint *t1=[NSLayoutConstraint constraintWithItem:view
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1.0
                                                        constant:self.bounds.size.height - height + height/2];
    NSLayoutConstraint *t2=[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:0];
    NSLayoutConstraint *t3=[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:0];
    
    [self addConstraints:@[t1,t2,t3]];
    
}
-(void)rotatedX:(CGFloat)angle {
    
    CATransform3D allTransofrom = CATransform3DIdentity;
    CATransform3D rotateTransform = CATransform3DMakeRotation(angle, 1, 0, 0);
    allTransofrom = CATransform3DConcat(allTransofrom, rotateTransform);
    allTransofrom = CATransform3DConcat(allTransofrom, [self transform3d]);
    self.layer.transform = allTransofrom;
}

-(CATransform3D)transform3d
{
    CATransform3D transform=CATransform3DIdentity;
    transform.m34=2.5/-2000;
    return transform;
}

-(void)foldingAnimation:(NSString *)timing from:(CGFloat)from to:(CGFloat)to delay:(NSTimeInterval)delay  duration:(NSTimeInterval)durtion hidden:(BOOL)hidden
{
    CABasicAnimation *rotateAnimation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    
    rotateAnimation.timingFunction =[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:from];
    rotateAnimation.toValue = [NSNumber numberWithFloat:to];
    rotateAnimation.duration =durtion;
    rotateAnimation.delegate = self;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = false;
    rotateAnimation.beginTime = CACurrentMediaTime()+delay;
    
    hiddenAfterAnimation = hidden;
    
    [self.layer addAnimation:rotateAnimation forKey:@"rotation.x"];
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (hiddenAfterAnimation) {
        self.alpha = 0;
    }
//    if(UIKeyboardDidHideNotification) self.alpha=0.8;
    [self.layer removeAllAnimations];
    self.layer.shouldRasterize=NO;
//    [self rotatedX:0];
}


-(void)animationDidStart:(CAAnimation *)anim
{
    self.layer.shouldRasterize = YES;
    self.alpha = 1;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
