//
//  PHButtonSegmentView.h
//  PHUIKit
//
//  Segement Button
//  选择切换按钮，用于模式切换等
//
//  Created by liangc on 2019/11/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PHButtonSegmentViewDelegate <NSObject>

/// 已选择左侧按钮
- (void)didSelectLeftSegmentButton;

/// 已选择右侧按钮
- (void)didSelectRightSegmentButton;

@end

@interface PHButtonSegmentView : UIView

/// 代理对象
@property (nonatomic, weak) id<PHButtonSegmentViewDelegate> delegate;

/// 左侧按钮标题获取与设置
@property (nonatomic, copy) NSString *leftTitle;
/// 右侧按钮标题获取与设置
@property (nonatomic, copy) NSString *rightTitle;
/// 可点击状态获取与设置
@property (nonatomic) BOOL enable;

// 左侧按钮背景颜色
/// 左侧按钮点击背景颜色
@property (nonatomic) UIColor *leftTouchColor;
/// 左侧按钮默认背景颜色
@property (nonatomic) UIColor *leftBackGroundColor;

// 右侧按钮背景颜色
/// 右侧按钮点击背景颜色
@property (nonatomic) UIColor *rightTouchColor;
/// 右侧按钮默认背景颜色
@property (nonatomic) UIColor *rightBackgroundColor;

// 左侧按钮标题文字颜色
/// 左侧按钮可用状态标题文字颜色
@property (nonatomic) UIColor *leftTitleColor;
/// 左侧按钮不可用状态标题文字颜色
@property (nonatomic) UIColor *leftDisableTitleColor;

// 右侧按钮标题文字颜色
/// 右侧按钮可用状态标题文字颜色
@property (nonatomic) UIColor *rightTitleColor;
/// 右侧按钮不可用状态标题文字颜色
@property (nonatomic) UIColor *rightDisableTitleColor;

@end

NS_ASSUME_NONNULL_END
