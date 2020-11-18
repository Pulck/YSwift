//
//  UIButton+PH.h
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/29.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (PH)
/**
 *  扩大 UIButton 的點擊範圍
 *  控制上下左右的延長範圍
 *
 *  @param top    top
 *  @param right  right
 *  @param bottom bottom
 *  @param left   left
 */
- (void)ph_BigEdgeTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end

NS_ASSUME_NONNULL_END
