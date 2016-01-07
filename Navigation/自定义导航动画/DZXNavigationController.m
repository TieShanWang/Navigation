//
//  DZXNavigationController.m
//  DZXNavigationController
//
//  Created by Kenway on 15/12/21.
//  Copyright © 2015年 Zahi. All rights reserved.
//

#import "DZXNavigationController.h"

@interface DZXNavigationController ()

@end

@implementation DZXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self interactivePopGestureRecognizerType];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}


//#pragma mark - 转场动画
- (id <UIViewControllerAnimatedTransitioning>)
    navigationController:(UINavigationController *)navigationController
    animationControllerForOperation:(UINavigationControllerOperation)operation
    fromViewController:(UIViewController *)fromVC
    toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        PushTransitionAnimation *pushTransitionAnimation = [PushTransitionAnimation new];
        return pushTransitionAnimation;
    }
    else if (operation == UINavigationControllerOperationPop) {
        PopTransitionAnimation *popTransitionAnimation = [PopTransitionAnimation new];
        return popTransitionAnimation;
    }
    return nil;
}


#pragma mark - 判断页面数，页面数>1时执行动画
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count > 1) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark- 添加百分比手势
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    if ([animationController isKindOfClass:[PopTransitionAnimation class]]) {
        return self.percentDrivenInteractiveTransition;
    }

    return nil;
    
}

#pragma mark - 手势具体方法
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture{
    
    CGPoint point = [gesture translationInView:gesture.view];
    CGFloat progress = point.x / gesture.view.bounds.size.width;
    
    //限制progress始终大于0
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenInteractiveTransition updateInteractiveTransition:progress];
    }
    else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        //判断手势滑动距离是否超过屏幕的一半，如果超过一半则完成pop动画
        if (progress > 0.5) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }
        else{
            [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        self.percentDrivenInteractiveTransition = nil;
    }
}

#pragma mark - 判断滑动返回手势方式
- (void)setInteractivePopGestureRecognizerType:(InteractivePopGestureRecognizerType)interactivePopGestureRecognizerType{
    switch (interactivePopGestureRecognizerType) {
        case 0:
            break;
        case 1:
        {
            //添加边缘返回手势
            UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
            edgePanGestureRecognizer.edges = UIRectEdgeLeft;
            [self.view addGestureRecognizer:edgePanGestureRecognizer];
        }
            break;
        case 2:
        {
            //添加全屏返回手势
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:panGestureRecognizer];
        }
            break;
        default:
            break;
    }
}



@end
