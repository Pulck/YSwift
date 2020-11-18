//
//  UIView+PH.m
//  PHUtils
//
//  Created by Hu, Yuping on 2019/11/1.
//

#import "UIView+PH.h"
#import <objc/runtime.h>
#import "PHMacro.h"

@implementation UIView (PH)

- (CGFloat)ph_left {
    return self.frame.origin.x;
}

- (void)setPh_left:(CGFloat)ph_left {
    CGRect frame = self.frame;
    frame.origin.x = ph_left;
    self.frame = frame;
}

- (CGFloat)ph_top {
    return self.frame.origin.y;
}

- (void)setPh_top:(CGFloat)ph_top {
    CGRect frame = self.frame;
    frame.origin.y = ph_top;
    self.frame = frame;
}

- (CGFloat)ph_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setPh_right:(CGFloat)ph_right {
    CGRect frame = self.frame;
    frame.origin.x = ph_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ph_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setPh_bottom:(CGFloat)ph_bottom {
    CGRect frame = self.frame;
    frame.origin.y = ph_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ph_width {
    return self.frame.size.width;
}

- (void)setPh_width:(CGFloat)ph_width {
    CGRect frame = self.frame;
    frame.size.width = ph_width;
    self.frame = frame;
}

- (CGFloat)ph_height {
    return self.frame.size.height;
}

- (void)setPh_height:(CGFloat)ph_height {
    CGRect frame = self.frame;
    frame.size.height = ph_height;
    self.frame = frame;
}

- (CGPoint)ph_origin {
    return self.frame.origin;
}

- (void)setPh_origin:(CGPoint)ph_origin {
    CGRect frame = self.frame;
    frame.origin = ph_origin;
    self.frame = frame;
}

- (CGSize)ph_size {
    return self.frame.size;
}

- (void)setPh_size:(CGSize)ph_size {
    CGRect frame = self.frame;
    frame.size = ph_size;
    self.frame = frame;
}

- (void)setPh_centerX:(CGFloat)ph_centerX {
    CGPoint center = self.center;
    center.x = ph_centerX;
    self.center = center;
}

- (CGFloat)ph_centerX {
    return self.center.x;
}

- (void)setPh_centerY:(CGFloat)ph_centerY {
    CGPoint center = self.center;
    center.y = ph_centerY;
    self.center = center;
}

- (CGFloat)ph_centerY {
    return self.center.y;
}

- (void)setPh_x:(CGFloat)ph_x {
    CGRect frame = self.frame;
    frame.origin.x = ph_x;
    self.frame = frame;
}

- (void)setPh_y:(CGFloat)ph_y {
    CGRect frame = self.frame;
    frame.origin.y = ph_y;
    self.frame = frame;
}

- (CGFloat)ph_x {
    return self.frame.origin.x;
}

- (CGFloat)ph_y {
    return self.frame.origin.y;
}

- (void)ph_printFrame {
    NSString *formateStr =@"%@'s frame : origin = (%.1f %.1f) size = (%.1f %.1f)";
    PHLog(formateStr, [self class], self.ph_left, self.ph_top, self.ph_width, self.ph_height);
}

- (UIViewController *)ph_responderViewController {
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        //判断下一个响应者是否为控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

///淡入
- (void)ph_fadeInWithTime:(NSTimeInterval)time{
    self.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time animations:^{
        weakSelf.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

///淡出
- (void)ph_fadeOutWithTime:(NSTimeInterval)time{
    self.alpha = 1;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

///缩放
- (void)ph_scalingWithTime:(NSTimeInterval)time andscal:(CGFloat)scal{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time animations:^{
        weakSelf.transform = CGAffineTransformMakeScale(scal,scal);
    }];
}

///旋转
- (void)ph_revolvingWithTime:(NSTimeInterval)time andDelta:(CGFloat)delta{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:time animations:^{
        weakSelf.transform = CGAffineTransformMakeRotation(delta);
    }];
}
///圆角的颜色
- (UIColor *)ph_roundCornerColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPh_roundCornerColor:(UIColor *)ph_roundCornerColor {
    UIColor *col = ph_roundCornerColor;
    objc_setAssociatedObject(self, @selector(ph_roundCornerColor), col, OBJC_ASSOCIATION_RETAIN);
}
///圆角的半径
- (CGFloat)ph_roundCornerRadius
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setPh_roundCornerRadius:(CGFloat)ph_roundCornerRadius {
    NSNumber *num = @(ph_roundCornerRadius);
    objc_setAssociatedObject(self, @selector(ph_roundCornerRadius), num, OBJC_ASSOCIATION_RETAIN);
}

/**
 lineView:       需要绘制成虚线的view
 lineLength:     虚线的宽度
 lineSpacing:    虚线的间距
 lineColor:      虚线的颜色
 */
+ (void)ph_drawDashLine:(UIView *)lineV width:(int)lineW spacing:(int)lineS color:(UIColor *)lineC
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineV.bounds];
    CGFloat pointX = CGRectGetWidth(lineV.frame) / 2;
    CGFloat pointY = CGRectGetHeight(lineV.frame);
    CGPoint point = CGPointMake( pointX, pointY);
    [shapeLayer setPosition:point];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineC.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineV.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    NSNumber *firstNum = [NSNumber numberWithInt:lineW];
    NSNumber *secondNum = [NSNumber numberWithInt:lineS];
    NSArray *patternArr = @[firstNum,secondNum];
    [shapeLayer setLineDashPattern:patternArr];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineV.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineV.layer addSublayer:shapeLayer];
}

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft |
 *   UIRectCornerTopRight | UIRectCornerBottomLeft |
 *   UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)ph_addRoundedCorners:(UIRectCorner)corners
                    withRadii:(CGSize)radii {
    
    UIBezierPath* rnd = nil;
    CGRect bnd = self.bounds;
    rnd = [UIBezierPath bezierPathWithRoundedRect:bnd byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rnd.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft |
 *   UIRectCornerTopRight | UIRectCornerBottomLeft |
 *   UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)ph_addRoundedCorners:(UIRectCorner)corners
                    withRadii:(CGSize)radii
                     viewRect:(CGRect)rect {
    
    UIBezierPath * rnd = nil;
    rnd=[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rnd.CGPath];
    
    self.layer.mask = shape;
}

@end
