//
//  DragLeftInteractiveTransition.m
//  AwemeDemo
//
//  Created by 朱力 on 2019/12/4.
//

#import "DragLeftInteractiveTransition.h"

@interface DragLeftInteractiveTransition ()

@property (nonatomic, strong) UIViewController *presentingVC;
@property (nonatomic, assign) CGPoint viewControllerCenter;
@property (nonatomic, strong) CALayer *transitionMaskLayer;

@end

@implementation DragLeftInteractiveTransition

#pragma mark -
#pragma mark - override methods 复写方法
-(CGFloat)completionSpeed{
    return 1 - self.percentComplete;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    NSLog(@"%.2f",percentComplete);
    
}

- (void)cancelInteractiveTransition {
    NSLog(@"转场取消");
}

- (void)finishInteractiveTransition {
    NSLog(@"转场完成");
}


- (CALayer *)transitionMaskLayer {
    if (_transitionMaskLayer == nil) {
        _transitionMaskLayer = [CALayer layer];
    }
    return _transitionMaskLayer;
}

#pragma mark - private methods 私有方法
- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

#pragma mark - event response 所有触发的事件响应 按钮、通知、分段控件等
- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *vcView = gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:vcView.superview];
    if(!self.isInteracting && (translation.x < 0 || translation.y < 0 || translation.x < translation.y)) {
        return;
    }
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            //修复当从右侧向左滑动的时候的bug 避免开始的时候从又向左滑动 当未开始的时候
            CGPoint vel = [gestureRecognizer velocityInView:gestureRecognizer.view];
            if (!self.isInteracting && vel.x < 0) {
                self.isInteracting = NO;
                return;
            }
            [self setStateBeginTransition:vcView];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:[self getStateChangedProgress:translation]];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            [self stateEndedProgress:translation];
            //移除 遮罩
            [self.transitionMaskLayer removeFromSuperlayer];
            self.transitionMaskLayer = nil;
        }
            break;
        default:
            break;
    }
}

- (CGFloat)getStateChangedProgress:(CGPoint)translation {
    CGFloat progress = translation.x / [UIScreen mainScreen].bounds.size.width;
    progress = fminf(fmaxf(progress, 0.0), 1.0);
    CGFloat ratio = 1.0f - progress*0.5f;
    [_presentingVC.view setCenter:CGPointMake(_viewControllerCenter.x + translation.x * ratio, _viewControllerCenter.y + translation.y * ratio)];
    _presentingVC.view.transform = CGAffineTransformMakeScale(ratio, ratio);
    return progress;
}

- (void)setStateBeginTransition:(UIView *)vcView {
    self.transitionMaskLayer.frame = vcView.frame;
    self.transitionMaskLayer.opaque = NO;
    self.transitionMaskLayer.opacity = 1;
    self.transitionMaskLayer.backgroundColor = [UIColor whiteColor].CGColor; //必须有颜色不能透明
    [self.transitionMaskLayer setNeedsDisplay];
    [self.transitionMaskLayer displayIfNeeded];
    self.transitionMaskLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.transitionMaskLayer.position = CGPointMake(vcView.frame.size.width/2.0f, vcView.frame.size.height/2.0f);
    vcView.layer.mask = self.transitionMaskLayer;
    vcView.layer.masksToBounds = YES;
    self.isInteracting = YES;
}

- (void)stateEndedProgress:(CGPoint)translation {
    CGFloat progress = translation.x / [UIScreen mainScreen].bounds.size.width;
    progress = fminf(fmaxf(progress, 0.0), 1.0);
    if (progress < 0.2){
        [self setStateEndAnimation:progress];
    }else {
        self.isInteracting = NO;
        [self finishInteractiveTransition];
        [_presentingVC dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setStateEndAnimation:(NSTimeInterval)progress {
    [UIView animateWithDuration:progress
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGFloat wValue = [UIScreen mainScreen].bounds.size.width;
                         CGFloat hValue = [UIScreen mainScreen].bounds.size.height;
                         [self.presentingVC.view setCenter:CGPointMake(wValue/2, hValue/2)];
                         self.presentingVC.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                     } completion:^(BOOL finished) {
                         self.isInteracting = NO;
                         [self cancelInteractiveTransition];
                     }];
}

#pragma mark - public methods 公有方法
-(void)wireToViewController:(UIViewController *)viewController {
    self.presentingVC = viewController;
    self.viewControllerCenter = viewController.view.center;
    [self prepareGestureRecognizerInView:viewController.view];
}

@end
