//
//  RotatedView.h
//  SocketTest
//
//  Created by Imac 21 on 16/1/5.
//  Copyright © 2016年 Imac 21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotatedView : UIView
@property(nonatomic,strong) RotatedView *backView;
@property(nonatomic,assign) BOOL hiddenAfterAnimation;


//-(void)animationDidStop;
//-(void)animationDidStart;
-(void)foldingAnimation:(NSString *)timing from:(CGFloat)from to:(CGFloat)to delay:(NSTimeInterval)delay  duration:(NSTimeInterval)durtion hidden:(BOOL)hidden;
-(void)addBackViewHeight:(CGFloat)height color:(UIColor *)color;

@end
