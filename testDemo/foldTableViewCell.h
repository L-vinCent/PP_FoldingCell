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

typedef void(^foldTapBlock)(void);
@interface foldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RotatedView *foregroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foregroundTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *foldTestImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
-(void)selectedAnimation:(BOOL )isSelected animated:(BOOL)animated completion:(CompletionHandler)completion;
-(BOOL)isAnimating;
-(CGFloat)returnSumTime;
-(void)fold_imageTap:(foldTapBlock)block;
@end
