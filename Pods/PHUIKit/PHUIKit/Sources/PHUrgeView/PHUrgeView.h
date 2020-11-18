//
//  PHUrgeView.h
//  PHUIKit
//
//  Created by 朱力 on 2020/8/19.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^urgeBlock)(id urgeInfo);

@interface PHUrgeView : UIView

/// 初始化督促
/// @param nameStr 名字
/// @param descStr 描述
/// @param urgeInfo 督促id或依据信息
/// @param sideslipAction 开启右侧滑动配置
- (instancetype)initWithInfo:(NSString *)nameStr
                     descStr:(NSString *)descStr
                      urgeInfo:(id)urgeInfo
              sideslipAction:(BOOL)sideslipAction;

/// 更新督促数据
/// @param nameStr 名字
/// @param descStr 描述
/// @param urgeInfo 督促id或依据信息
- (void)resetData:(NSString *)nameStr
          descStr:(NSString *)descStr
           urgeInfo:(id)urgeInfo;

/// 因外部无法直接把UIimage出来头像交给外部设置
@property (nonatomic, strong) UIImageView * headerImage;

/// 导航头中的元素点击行为回调
@property (nonatomic, copy) urgeBlock urgeBlock;

/// 是否需要动画
@property (nonatomic, assign) BOOL animations;

/// 动画速度
@property (nonatomic, assign) CGFloat animationSpeeds;

/// 弹出督促
/// @param completion 动画执行完成回调
- (void)showUrge:(void (^ __nullable)(BOOL finished))completion;

/// 收起督促
/// @param completion 动画执行完成回调
- (void)hideUrge:(void (^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
