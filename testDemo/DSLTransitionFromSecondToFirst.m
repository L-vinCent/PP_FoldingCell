//
//  DSLTransitionFromSecondToFirst.m
//  TransitionExample
//
//  Created by Pete Callaway on 21/07/2013.
//  Copyright (c) 2013 Dative Studios. All rights reserved.
//

#import "DSLTransitionFromSecondToFirst.h"

#import "ViewController.h"
#import "secondViewController.h"
#import "foldTableViewCell.h"


@implementation DSLTransitionFromSecondToFirst

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    secondViewController *fromViewController = (secondViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toViewController = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    // Get a snapshot of the image view
    UIView *imageSnapshot = [fromViewController.secondImageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:fromViewController.secondImageView.frame fromView:fromViewController.secondImageView.superview];
    fromViewController.secondImageView.hidden = YES;

    // Get the cell we'll animate to
//    DSLThingCell *cell = [toViewController collectionViewCellForThing:fromViewController.thing];
//    cell.imageView.hidden = YES;
    foldTableViewCell *cell=[toViewController tableViewCellForThing:fromViewController.cellIndex];
    
    NSLog(@"%d",fromViewController.cellIndex.row);
   
    // Setup the initial view states
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];

    [UIView animateWithDuration:duration animations:^{
        // Fade out the source view controller
        fromViewController.view.alpha = 0.0;

        // Move the image view
        imageSnapshot.frame = [containerView convertRect:cell.foldTestImageView.frame fromView:cell.foldTestImageView.superview];
        imageSnapshot.alpha=0;
    } completion:^(BOOL finished) {
        // Clean up
        [imageSnapshot removeFromSuperview];
        fromViewController.secondImageView.hidden = NO;
        cell.foldTestImageView.hidden = NO;

        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
