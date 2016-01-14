//
//  DSLTransitionFromFirstToSecond.m
//  TransitionExample
//
//  Created by Pete Callaway on 21/07/2013.
//  Copyright (c) 2013 Dative Studios. All rights reserved.
//

#import "DSLTransitionFromFirstToSecond.h"
#import "ViewController.h"
#import "secondViewController.h"
#import "foldTableViewCell.h"



@implementation DSLTransitionFromFirstToSecond

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    ViewController *fromViewController = (ViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    secondViewController *toViewController = (secondViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    

    // Get a snapshot of the thing cell we're transitioning from
//    foldTableViewCell *cell = (foldTableViewCell *)[fromViewController.testTableView cellForItemAtIndexPath:[[fromViewController.testTableView indexPathForSelectedRow] firstObject]];
    foldTableViewCell *cell=(foldTableViewCell *)[fromViewController.testTableView cellForRowAtIndexPath:toViewController.cellIndex];
    NSLog(@"%d",toViewController.cellIndex.row);
    


    UIView *cellImageSnapshot = [cell.foldTestImageView snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.center = [containerView convertPoint:cell.foldTestImageView.center fromView:cell.foldTestImageView.superview];
  
    // Setup the initial view states
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
//    toViewController.secondImageView.hidden = YES;

    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];

    
   

    NSLog(@"to%@",NSStringFromCGRect(toViewController.secondImageView.frame));
    NSLog(@"from%@",NSStringFromCGRect(cell.foldTestImageView.frame));
    NSLog(@"temp%@",NSStringFromCGRect(cellImageSnapshot.frame));

    [UIView animateWithDuration:duration animations:^{
        // Fade in the second view controller's view
        toViewController.view.alpha = 1.0;// Move the cell snapshot so it's over the second view controller's image view
        CGPoint point=toViewController.secondImageView.center;
        cellImageSnapshot.center=point;
        cellImageSnapshot.alpha=0.0;
        
        
    } completion:^(BOOL finished) {
        // Clean up
        toViewController.secondImageView.hidden = NO;
        cell.hidden = NO;
        [cellImageSnapshot removeFromSuperview];


        // Declare that we've finished
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
