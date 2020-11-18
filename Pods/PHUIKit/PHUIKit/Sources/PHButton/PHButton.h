//
//  PHButton.h
//  downloadTest
//
//  Created by Tiany on 2020/2/6.
//  Copyright © 2020 yunxuetang. All rights reserved.
//  普通按钮(大 | 中 | 小)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 按钮类型

 - PHButtonTypeBig: 大按钮
 - PHButtonTypeMiddle: 中按钮
 - PHButtonTypeSmall: 小按钮
 */
typedef NS_ENUM(NSInteger,PHButtonType) {
    PHButtonTypeBig     = 0,
    PHButtonTypeMiddle  = 1 << 0,
    PHButtonTypeSmall   = 1 << 1
};

/**
 按钮样式

 - PHButtonStyleNormal: 常规样式(带主题色)
 - PHButtonStyleValue1: 样式1(带边框)
 - PHButtonStyleValue2: 样式2(次要)
 - PHButtonStyleValue3: 样式3
 */
typedef NS_OPTIONS(NSUInteger, PHButtonStyle) {
    PHButtonStyleNormal = 0,
    PHButtonStyleValue1 = 1 << 0,
    PHButtonStyleValue2 = 1 << 1,
    PHButtonStyleValue3 = 1 << 2
};

/**
 按钮的状态

 - PHButtonStateNormal: 常规
 - PHButtonStateHighlighted: 高亮
 - PHButtonStateDisabled: 不可用
 - PHButtonStateLoading: 加载中
 */
typedef NS_OPTIONS(NSUInteger, PHButtonState) {
    PHButtonStateNormal       = 0,
    PHButtonStateHighlighted  = 1 << 0,
    PHButtonStateDisabled     = 1 << 1,
    PHButtonStateLoading      = 1 << 2
};

@interface PHButton : UIControl

/**
 按钮样式: 默认Normal
 */
@property (nonatomic, assign) PHButtonStyle buttonStyle;

/**
 创建按钮

 @param buttonType 按钮类型
 @return 返回按钮对象
 */
+ (instancetype)buttonWithType:(PHButtonType)buttonType;

/**
 设置按钮标题

 @param title 标题
 @param state 状态
 */
- (void)setTitle:(nullable NSString *)title forState:(PHButtonState)state;

/**
 设置按钮标题颜色

 @param color 色值
 @param state 状态
 */
- (void)setTitleColor:(nullable UIColor *)color forState:(PHButtonState)state;

/**
 设置按钮背景颜色
 
 @param color 色值
 @param state 状态
 */
- (void)setBackgroundColor:(nullable UIColor *)color forState:(PHButtonState)state;

@end

NS_ASSUME_NONNULL_END
