//
//  PHTabBarController.h
//  PHUIKit
//
//  Created by 耿葱 on 2020/1/11.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHTabBarController : UITabBarController

@property (nonatomic, copy) void (^viewDidAppearBlock) (void);
/**
 根据控制器，标题，选中图片，未选中图片创建TabBar控制器

 @param controllers 控制器数组
 @param titles 标题数组
 @param normalImages 未选中数组
 @param selectedImages 选中数组
 @param unselectedColor 图片和title的未选中颜色
 @param selectedColor 图片和title的选中颜色
 @return TabBar控制器
 */

- (instancetype)initWithControllers:(NSArray *)controllers
                             titles:(NSArray *)titles
                       normalImages:(NSArray *)normalImages
                     selectedImages:(NSArray *)selectedImages
                    unselectedColor:(NSString *)unselectedColor
                      selectedColor:(NSString *)selectedColor;
@end

NS_ASSUME_NONNULL_END
