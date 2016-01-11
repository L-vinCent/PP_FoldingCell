//
//  foldTableViewCell.h
//  testDemo
//
//  Created by Imac 21 on 16/1/8.
//  Copyright © 2016年 Imac 21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatedView.h"

typedef void(^CompletionHandler)(void);

typedef enum : NSUInteger {
    Open,
    Close,
} AnimationType;

@interface foldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RotatedView *foregroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foregroundTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;

-(void)selectedAnimation:(BOOL )isSelected animated:(BOOL)animated completion:(CompletionHandler)completion;
-(BOOL)isAnimating;
-(CGFloat)returnSumTime;
@end
