//
//  foldTableViewCell.m
//  testDemo
//
//  Created by Imac 21 on 16/1/8.
//  Copyright © 2016年 Imac 21. All rights reserved.
//

#import "foldTableViewCell.h"


//动画时间

//static const NSTimeInterval KDurtion=2.99;
@implementation foldTableViewCell
{
    NSMutableArray *animationItemViews;
    UIColor *backViewColor;
    foldTapBlock tempBlock;
}
@synthesize containerView;
@synthesize foregroundView;
@synthesize coverImageView;

- (void)awakeFromNib {
    
    NSLog(@"awakeFromNib");
    // Initialization code
    foregroundView.layer.cornerRadius=10;
    foregroundView.layer.masksToBounds=YES;

    backViewColor=[UIColor colorWithRed:0.9686 green:0.9333 blue:0.9686 alpha:1.0];
    [self configureDefaultState];
    animationItemViews =[self createAnimationItemView];
//    
//    for (UIView  *w in animationItemViews) {
//        NSLog(@"===================%@",[w description]);
//    }
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewToFriendDetailView:)];
    coverImageView.userInteractionEnabled=YES;
    [coverImageView addGestureRecognizer:tap];
}

-(void)tapImageViewToFriendDetailView:(UITapGestureRecognizer *)sender
{
    if (tempBlock) {
        tempBlock();
    }
}

-(void)fold_imageTap:(foldTapBlock)block
{
    tempBlock=block;
}

-(NSMutableArray *)durationSequence
{
    NSMutableArray *durationArray=[NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.35],[NSNumber numberWithFloat:0.23],[NSNumber numberWithFloat:0.23], nil];
    NSMutableArray *durtions=[NSMutableArray array];
    for (int index=0; index<containerView.subviews.count-1; index++) {
        
        NSNumber *tempDuration=durationArray[index];
        float temp=[tempDuration floatValue]/2;
        NSNumber *duration=[NSNumber numberWithFloat:temp];
        
        [durtions addObject:duration];
        [durtions addObject:duration];
    }
    return durtions;
}

-(CGFloat)returnSumTime
{
    NSMutableArray *tempArray=[self durationSequence];
    CGFloat sumTime=0.0;
    for (NSNumber *number in tempArray) {
        CGFloat time=[number floatValue];
        sumTime+=time;
    }
    return sumTime;
}

-(void)configureAnimationItems:(AnimationType)animationType
{
    if (animationType==Open) {
        
        for (UIView *view in containerView.subviews) {
            
            if ([view isKindOfClass:[RotatedView class]]) {
                view.alpha=0;
            }
        }
        
    }else
    {   //close
        
        for (UIView *view in containerView.subviews) {
            if (![view isKindOfClass:[RotatedView class]]) return;
            
            RotatedView *tempRotaView=(RotatedView *)view;
            if (animationType==Open) {
                tempRotaView.alpha=0;
            }else
            {
                tempRotaView.alpha=1;
                tempRotaView.backView.alpha=0;
            }
            
            
        }
        
    }

}
-(void)closeAnimation:(CompletionHandler)completion
{
    NSArray *durations=[self durationSequence];
    durations = [[durations reverseObjectEnumerator]allObjects];
    NSTimeInterval delay=0;
    NSString *timing=kCAMediaTimingFunctionEaseIn;
    CGFloat from=0.0;
    CGFloat to=M_PI/2;
    BOOL hidden=YES;
    [self configureAnimationItems:Close];
    for (int index=0; index<animationItemViews.count; index++) {
           float duration=[durations[index] floatValue];
        NSArray *tempArray=[[animationItemViews reverseObjectEnumerator]allObjects];
        RotatedView *animatedView=tempArray[index];
        [animatedView foldingAnimation:timing from:from to:to delay:delay duration:duration hidden:hidden];
        
        from=from==0.0?-M_PI/2:0.0;
        to=to==0.0?M_PI/2:0.0;
        timing=timing==kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
        hidden=!hidden;
        delay+=duration;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
       self.containerView.alpha=0;
        completion();
        
    });
    
    RotatedView *firstItemView;
    for (UIView *tempView in containerView.subviews) {
        
        if (tempView.tag==0) {
            
            firstItemView=(RotatedView *)tempView;
           // firstItemView.layer.masksToBounds=NO;
        }
        
        float value=(delay-[[durations lastObject] floatValue] *1.5);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(value* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            firstItemView.layer.masksToBounds =YES;

        });
        
    }
    
}
-(void)openAnimation:(CompletionHandler)completion
{
    NSArray *durtions=[self durationSequence];
    NSTimeInterval delay=0;
    NSString *timing=kCAMediaTimingFunctionEaseIn;
    CGFloat from=0.0;
    CGFloat to=-M_PI/2;
    BOOL hidden=YES;
    [self  configureAnimationItems:Open];

    for (int  index=0; index<animationItemViews.count; index++) {
        float duration=[durtions[index] floatValue];
        RotatedView *animatedView=animationItemViews[index];
        [animatedView foldingAnimation:timing from:from to:to delay:delay duration:duration hidden:hidden];
        from=from==0?M_PI/2:0.0;
        to=to==0.0?-M_PI/2:0.0;
        timing=timing==kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
        hidden=!hidden;
        delay+=duration;

    }
       for (UIView *view in containerView.subviews) {
        if (view.tag==0) {
            RotatedView *firstItemView=(RotatedView*)view;
            firstItemView.layer.masksToBounds=YES;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:firstItemView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            firstItemView.layer.mask = maskLayer;
        }
        else if(view.tag==3)
        {
             RotatedView *lastItemView=(RotatedView*)view;
            lastItemView.layer.masksToBounds=YES;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lastItemView.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            lastItemView.layer.mask = maskLayer;

        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([durtions[0] floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //firstItemView.layer.masksToBounds=NO;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        completion();
        
    });
    
}

//设置初始状态
-(void)configureDefaultState
{
    
    self.containerViewTopConstraint.constant=_foregroundTopConstraint.constant;
    
    containerView.alpha=0;
    
    //将第一个图设置成圆角
    UIView *firstItemView;
    for (UIView  *v in containerView.subviews ) {
        if (v.tag==0) {
            firstItemView=v;
            
        }
    }
    
//    firstItemView.layer.cornerRadius=foregroundView.layer.cornerRadius;
//    firstItemView.layer.masksToBounds=YES;
    
    //设置外层图片属性
    foregroundView.layer.anchorPoint=CGPointMake(0.5,1);

    self.foregroundTopConstraint.constant+=foregroundView.bounds.size.height/2;
//    [self setAnchorPoint:CGPointMake(0.5, 1) forView:foregroundView];
    foregroundView.layer.transform=[self transform3d];
    [self.contentView bringSubviewToFront:foregroundView];
    
    for (NSLayoutConstraint *constraint in containerView.constraints) {
        
        if ([constraint.identifier isEqualToString:@"yPosition"]) {
            
//            NSLog(@"----%@",constraint.description);
           
            constraint.constant -= [constraint.firstItem layer].bounds.size.height/ 2;
            [constraint.firstItem layer].anchorPoint=CGPointMake(0.5, 0);
            [constraint.firstItem layer].transform=[self transform3d];

        }
    }
    
    //添加背景View
    RotatedView *previusView;
    for (UIView *s in containerView.subviews) {
        {
            
            if(s.tag>0&&[s isKindOfClass:[RotatedView class]]){
                RotatedView *tempView=(RotatedView *)s;
                [previusView addBackViewHeight:tempView.bounds.size.height color:backViewColor];
                previusView=tempView;
//
                
            }
          
            
        }
    }
    
}

//3d偏移属性设置
-(CATransform3D )transform3d
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}

-(NSMutableArray *)createAnimationItemView
{
    NSMutableArray *items=[NSMutableArray array];
    NSMutableArray *rotatedViews=[NSMutableArray array];
    
    [items addObject:foregroundView];
    
    for (UIView *itemView in containerView.subviews) {
        
        if([itemView isKindOfClass:[RotatedView class]])
        {
            RotatedView *tempView=(RotatedView *)itemView;
            [rotatedViews addObject:tempView];
            
            if (tempView.backView!=nil) [rotatedViews addObject:tempView.backView];
        }
        
        
    }
    [items addObjectsFromArray:rotatedViews];
    return items;
    
}

-(void)selectedAnimation:(BOOL)isSelected animated:(BOOL)animated completion:(CompletionHandler)completion
{
    if (isSelected) {
        containerView.alpha=1;
        for (UIView *subView in containerView.subviews) {
            subView.alpha=1;
        }
        
        if (animated)
        {
            [self openAnimation:^{
                completion();
            }];
        }
        else
        {
            
            foregroundView.alpha=0;
            for (UIView *subView in containerView.subviews) {
                
                if ([subView isKindOfClass:[RotatedView class]]) {
                    
                    RotatedView *rotateView=(RotatedView *)subView;
                    rotateView.backView.alpha=0;
                }
            }
        }
    
    }else
    {
        //关闭状态
        if (animated) {
           [self closeAnimation:^{
               completion();
           }];
        }else
        {
            foregroundView.alpha=1;
            containerView.alpha=0;
        }
    }
    
    
}

-(BOOL)isAnimating
{
    for (UIView *item in animationItemViews) {
        
        if(item.layer.animationKeys.count>0) return YES;
        
}
        return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
