//
//  PHPopupMenuPath.m
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/13.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHPopupMenuPath.h"
#import "PHPopupRectConst.h"

@implementation PHPopupMenuPath

+ (CAShapeLayer *)ph_maskLayerWithRect:(CGRect)rect
                            rectCorner:(UIRectCorner)rectCorner
                          cornerRadius:(CGFloat)cornerRadius
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
                        arrowDirection:(PHPopupMenuArrowDirection)arrowDirection
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self ph_bezierPathWithRect:rect rectCorner:rectCorner cornerRadius:cornerRadius borderWidth:0 borderColor:nil backgroundColor:nil arrowWidth:arrowWidth arrowHeight:arrowHeight arrowPosition:arrowPosition arrowDirection:arrowDirection].CGPath;
    return shapeLayer;
}


+ (UIBezierPath *)ph_bezierPathWithRect:(CGRect)rect
                             rectCorner:(UIRectCorner)rectCorner
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor * _Nullable)borderColor
                        backgroundColor:(UIColor * _Nullable)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
                         arrowDirection:(PHPopupMenuArrowDirection)arrowDirection
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (borderColor) {
        [borderColor setStroke];
    }
    if (backgroundColor) {
        [backgroundColor setFill];
    }
    bezierPath.lineWidth = borderWidth;
    rect = CGRectMake(borderWidth / 2, borderWidth / 2, PHRectWidth(rect) - borderWidth, PHRectHeight(rect) - borderWidth);
    CGFloat topRightRadius = 0,topLeftRadius = 0,bottomRightRadius = 0,bottomLeftRadius = 0;
    CGPoint topRightArcCenter,topLeftArcCenter,bottomRightArcCenter,bottomLeftArcCenter;
    
    if (rectCorner & UIRectCornerTopLeft) {
        topLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerTopRight) {
        topRightRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomLeft) {
        bottomLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomRight) {
        bottomRightRadius = cornerRadius;
    }
    
    if (arrowDirection == PHPopupMenuArrowDirectionTop) {
        topLeftArcCenter = CGPointMake(topLeftRadius + PHRectX(rect), arrowHeight + topLeftRadius + PHRectX(rect));
        topRightArcCenter = CGPointMake(PHRectWidth(rect) - topRightRadius + PHRectX(rect), arrowHeight + topRightRadius + PHRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) - bottomLeftRadius + PHRectX(rect));
        bottomRightArcCenter = CGPointMake(PHRectWidth(rect) - bottomRightRadius + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius + PHRectX(rect));
        if (arrowPosition < topLeftRadius + arrowWidth / 2) {
            arrowPosition = topLeftRadius + arrowWidth / 2;
        }else if (arrowPosition > PHRectWidth(rect) - topRightRadius - arrowWidth / 2) {
            arrowPosition = PHRectWidth(rect) - topRightRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(arrowPosition - arrowWidth / 2, arrowHeight + PHRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition, PHRectTop(rect) + PHRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition + arrowWidth / 2, arrowHeight + PHRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) - topRightRadius, arrowHeight + PHRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius - PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) + PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectX(rect), arrowHeight + topLeftRadius + PHRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        
    }else if (arrowDirection == PHPopupMenuArrowDirectionBottom) {
        topLeftArcCenter = CGPointMake(topLeftRadius + PHRectX(rect),topLeftRadius + PHRectX(rect));
        topRightArcCenter = CGPointMake(PHRectWidth(rect) - topRightRadius + PHRectX(rect), topRightRadius + PHRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) - bottomLeftRadius + PHRectX(rect) - arrowHeight);
        bottomRightArcCenter = CGPointMake(PHRectWidth(rect) - bottomRightRadius + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius + PHRectX(rect) - arrowHeight);
        if (arrowPosition < bottomLeftRadius + arrowWidth / 2) {
            arrowPosition = bottomLeftRadius + arrowWidth / 2;
        }else if (arrowPosition > PHRectWidth(rect) - bottomRightRadius - arrowWidth / 2) {
            arrowPosition = PHRectWidth(rect) - bottomRightRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(arrowPosition + arrowWidth / 2, PHRectHeight(rect) - arrowHeight + PHRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition, PHRectHeight(rect) + PHRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition - arrowWidth / 2, PHRectHeight(rect) - arrowHeight + PHRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) - arrowHeight + PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectX(rect), topLeftRadius + PHRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) - topRightRadius + PHRectX(rect), PHRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius - PHRectX(rect) - arrowHeight)];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
    }else if (arrowDirection == PHPopupMenuArrowDirectionLeft) {
        topLeftArcCenter = CGPointMake(topLeftRadius + PHRectX(rect) + arrowHeight,topLeftRadius + PHRectX(rect));
        topRightArcCenter = CGPointMake(PHRectWidth(rect) - topRightRadius + PHRectX(rect), topRightRadius + PHRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + PHRectX(rect) + arrowHeight, PHRectHeight(rect) - bottomLeftRadius + PHRectX(rect));
        bottomRightArcCenter = CGPointMake(PHRectWidth(rect) - bottomRightRadius + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius + PHRectX(rect));
        if (arrowPosition < topLeftRadius + arrowWidth / 2) {
            arrowPosition = topLeftRadius + arrowWidth / 2;
        }else if (arrowPosition > PHRectHeight(rect) - bottomLeftRadius - arrowWidth / 2) {
            arrowPosition = PHRectHeight(rect) - bottomLeftRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(arrowHeight + PHRectX(rect), arrowPosition + arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(PHRectX(rect), arrowPosition)];
        [bezierPath addLineToPoint:CGPointMake(arrowHeight + PHRectX(rect), arrowPosition - arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(arrowHeight + PHRectX(rect), topLeftRadius + PHRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) - topRightRadius, PHRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius - PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(arrowHeight + bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) + PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
    }else if (arrowDirection == PHPopupMenuArrowDirectionRight) {
        topLeftArcCenter = CGPointMake(topLeftRadius + PHRectX(rect),topLeftRadius + PHRectX(rect));
        topRightArcCenter = CGPointMake(PHRectWidth(rect) - topRightRadius + PHRectX(rect) - arrowHeight, topRightRadius + PHRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) - bottomLeftRadius + PHRectX(rect));
        bottomRightArcCenter = CGPointMake(PHRectWidth(rect) - bottomRightRadius + PHRectX(rect) - arrowHeight, PHRectHeight(rect) - bottomRightRadius + PHRectX(rect));
        if (arrowPosition < topRightRadius + arrowWidth / 2) {
            arrowPosition = topRightRadius + arrowWidth / 2;
        }else if (arrowPosition > PHRectHeight(rect) - bottomRightRadius - arrowWidth / 2) {
            arrowPosition = PHRectHeight(rect) - bottomRightRadius - arrowWidth / 2;
        }
        [bezierPath moveToPoint:CGPointMake(PHRectWidth(rect) - arrowHeight + PHRectX(rect), arrowPosition - arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) + PHRectX(rect), arrowPosition)];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) - arrowHeight + PHRectX(rect), arrowPosition + arrowWidth / 2)];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) - arrowHeight + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius - PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) + PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectX(rect), arrowHeight + topLeftRadius + PHRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) - topRightRadius + PHRectX(rect) - arrowHeight, PHRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        
    }else if (arrowDirection == PHPopupMenuArrowDirectionNone) {
        topLeftArcCenter = CGPointMake(topLeftRadius + PHRectX(rect),  topLeftRadius + PHRectX(rect));
        topRightArcCenter = CGPointMake(PHRectWidth(rect) - topRightRadius + PHRectX(rect),  topRightRadius + PHRectX(rect));
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) - bottomLeftRadius + PHRectX(rect));
        bottomRightArcCenter = CGPointMake(PHRectWidth(rect) - bottomRightRadius + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius + PHRectX(rect));
        [bezierPath moveToPoint:CGPointMake(topLeftRadius + PHRectX(rect), PHRectX(rect))];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) - topRightRadius, PHRectX(rect))];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectWidth(rect) + PHRectX(rect), PHRectHeight(rect) - bottomRightRadius - PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + PHRectX(rect), PHRectHeight(rect) + PHRectX(rect))];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(PHRectX(rect), arrowHeight + topLeftRadius + PHRectX(rect))];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    }
    
    [bezierPath closePath];
    return bezierPath;
}

@end
