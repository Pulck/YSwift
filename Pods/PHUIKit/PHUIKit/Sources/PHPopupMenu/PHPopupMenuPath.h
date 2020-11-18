//
//  PHPopupMenuPath.h
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/13.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PHPopupMenuArrowDirection) {
    PHPopupMenuArrowDirectionTop = 0,  //箭头朝上
    PHPopupMenuArrowDirectionBottom,   //箭头朝下
    PHPopupMenuArrowDirectionLeft,     //箭头朝左
    PHPopupMenuArrowDirectionRight,    //箭头朝右
    PHPopupMenuArrowDirectionNone      //没有箭头
};

NS_ASSUME_NONNULL_BEGIN

@interface PHPopupMenuPath : NSObject

+ (CAShapeLayer *)ph_maskLayerWithRect:(CGRect)rect
                            rectCorner:(UIRectCorner)rectCorner
                          cornerRadius:(CGFloat)cornerRadius
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
                        arrowDirection:(PHPopupMenuArrowDirection)arrowDirection;

+ (UIBezierPath *)ph_bezierPathWithRect:(CGRect)rect
                             rectCorner:(UIRectCorner)rectCorner
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor * _Nullable)borderColor
                        backgroundColor:(UIColor * _Nullable) backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
                         arrowDirection:(PHPopupMenuArrowDirection)arrowDirection;

@end

NS_ASSUME_NONNULL_END
