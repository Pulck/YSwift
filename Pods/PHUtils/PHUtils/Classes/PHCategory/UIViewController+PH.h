//
//  UIViewController+PH.h
//  FBSnapshotTestCase
//
//  Created by 秦平平 on 2020/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PH)

/// 获取当前最上面的控制器（对象方法）
- (UIViewController *)ph_getCurrentViewController;
/// 获取当前最上面的控制器（类方法）
+ (UIViewController *)ph_getCurrentViewController;
@end

NS_ASSUME_NONNULL_END
