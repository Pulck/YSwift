//
//  PHMarqueeView.m
//  PHUIKit
//
//  Created by 秦平平 on 2020/2/3.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHMarqueeView.h"
#import <PHUtils/PHUtils.h>

@interface PHMarqueeView ()<CAAnimationDelegate> {
    CGFloat _width;
    CGFloat _height;
    CGFloat _animationViewWidth;
    CGFloat _animationViewHeight;
    CGFloat _labelWidth;
    BOOL    _stoped;
    UIView *_contentView;
}

@property (nonatomic, strong) UIView *animationView;

@end

@implementation PHMarqueeView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _width  = frame.size.width;
        _height = frame.size.height;
        self.speed               = 1.f;
        self.layer.masksToBounds = YES;
        self.animationView       = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height)];
        [self addSubview:self.animationView];
    }
    
    return self;
}

- (void)addContentView {
    [_contentView removeFromSuperview];
    NSString *string = [NSString stringWithFormat:@"%@", self.marqueeText];
    UILabel  *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    label.userInteractionEnabled = NO;
    if (self.fontSize <= 0) {
        self.fontSize = 18;
    }
    label.font       = [UIFont boldSystemFontOfSize:self.fontSize];
    label.text       = string;
    if (!self.textColor) {
        self.textColor = [UIColor ph_colorWithHexString:@"#BFBFBF" alpha:.4];
    }
    label.textColor  = self.textColor;
    if (self.showShadow) {  // 是否显示阴影
        label.shadowColor = [UIColor colorWithWhite:0 alpha:0.75];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    }
    CGFloat width = [string ph_widthWithStringAttribute:@{NSFontAttributeName:label.font,NSForegroundColorAttributeName:label.textColor}];
    CGRect labelFrame = label.frame;
    labelFrame.size.width = width;
    label.frame = labelFrame;
    label.frame = label.bounds;
    _contentView             = label;
    self.animationView.frame = label.bounds;
    [self.animationView addSubview:_contentView];
    
    _animationViewWidth  = self.animationView.frame.size.width;
    _animationViewHeight = self.animationView.frame.size.height;
}

- (void)startAnimation {
    [self addContentView];
    _stoped = NO;
    CGPoint pointRightCenter = CGPointMake(_width + _animationViewWidth / 2.f, _animationViewHeight / 2.f);
    CGPoint pointLeftCenter  = CGPointMake(-_animationViewWidth / 2, _animationViewHeight / 2.f);
    CGPoint fromPoint        = pointRightCenter;
    CGPoint toPoint          = pointLeftCenter;
    self.animationView.center = fromPoint;
    UIBezierPath *movePath    = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    [movePath addLineToPoint:toPoint];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path                 = movePath.CGPath;
    //    速度控制函数(CAMediaTimingFunction)
    moveAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    moveAnimation.removedOnCompletion  = YES;
    moveAnimation.duration             = _animationViewWidth / 30.f * (1 / self.speed);
    moveAnimation.delegate             = self;
    [self.animationView.layer addAnimation:moveAnimation forKey:@"animationViewPosition"];
    
}

- (void)stopAnimation {
    _stoped = YES;
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawMarqueeView:animationDidStopFinished:)]) {
        [self.delegate drawMarqueeView:self animationDidStopFinished:flag];
    }
    if (flag && !_stoped) {
        [self startAnimation];
    }
}

- (void)pauseAnimation {
    [self pauseLayer:self.animationView.layer];
}

- (void)resumeAnimation {
    [self resumeLayer:self.animationView.layer];
}

- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed               = 0.0;
    layer.timeOffset          = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime     = layer.timeOffset;
    layer.speed                   = 1.0;
    layer.timeOffset              = 0.0;
    layer.beginTime               = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime               = timeSincePause;
}

@end
