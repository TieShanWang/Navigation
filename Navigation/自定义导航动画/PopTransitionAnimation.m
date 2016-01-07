//
//  PopTransitionAnimation.m
//  DZXNavigationController
//
//  Created by Kenway on 15/12/21.
//  Copyright © 2015年 Zahi. All rights reserved.
//

#import "PopTransitionAnimation.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEE_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation PopTransitionAnimation

//转场动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}

//转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //获取转场容器
    UIView *containerView = [transitionContext containerView];
    
    //获取转场前界面视图
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //获取转场后界面图层
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //初始化阴影图层
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEE_HEIGHT)];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    [toViewController.view addSubview:self.shadowView];
    
    [containerView insertSubview:toViewController.view
                    belowSubview:fromViewController.view];
    
    //缩小视图，随着动画慢慢恢复正常
//    toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    //添加阴影
    fromViewController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    fromViewController.view.layer.shadowOpacity = 0.6;
    fromViewController.view.layer.shadowRadius = 8;
    
    
    CGFloat duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration
                     animations:^{
                         self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         fromViewController.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEE_HEIGHT);
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         [self.shadowView removeFromSuperview];
                     }];
//    _transitionContext = transitionContext;
    //----------------pop动画一-------------------------//
    
    //    [UIView beginAnimations:@"View Flip" context:nil];
    //    [UIView setAnimationDuration:duration];
    //    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
    //    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    //    [UIView commitAnimations];//提交UIView动画
    //    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    //----------------pop动画二-------------------------//
    
    //    CATransition *tr = [CATransition animation];
    //    tr.type = @"cube";
    //    tr.subtype = @"fromLeft";
    //    tr.duration = duration;
    //    tr.removedOnCompletion = NO;
    //    tr.fillMode = kCAFillModeForwards;
    //    tr.delegate = self;
    //    [containerView.layer addAnimation:tr forKey:nil];
    //    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
}

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];

}

@end
