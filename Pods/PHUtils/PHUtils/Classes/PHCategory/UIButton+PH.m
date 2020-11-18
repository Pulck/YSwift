//
//  UIButton+PH.m
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/29.
//

#import "UIButton+PH.h"
#import <objc/runtime.h>

@implementation UIButton (PH)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)ph_BigEdgeTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    NSNumber *numTop = [NSNumber numberWithFloat:top];
    objc_setAssociatedObject(self, &topNameKey, numTop, OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSNumber *numRight = [NSNumber numberWithFloat:right];
    objc_setAssociatedObject(self, &rightNameKey, numRight, OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSNumber *numBottom = [NSNumber numberWithFloat:bottom];
    objc_setAssociatedObject(self, &bottomNameKey, numBottom, OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSNumber *numLeft = [NSNumber numberWithFloat:left];
    objc_setAssociatedObject(self, &leftNameKey, numLeft, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        CGFloat resultX = self.bounds.origin.x - leftEdge.floatValue;
        CGFloat resultY = self.bounds.origin.y - topEdge.floatValue;
        CGFloat resultW = self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue;
        CGFloat resultH = self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue;
        
        return CGRectMake( resultX, resultY, resultW, resultH);
    }
    return self.bounds;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
