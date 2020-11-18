//
//  PHNavigationBar.h
//  lottie-ios
//
//  Created by 秦平平 on 2019/11/19.
//
// 导航栏视图，支持返回按钮，以及右边最多支持两个item
// 支持显示文字或图片


#import <UIKit/UIKit.h>
#import "PHButtonPro.h"

/// 导航栏返回通知
extern NSString * _Nonnull const kPHNavigationBarGoBackNotification;

typedef void (^PHNavBarGoBackBlock)(UIButton* _Nullable item);

typedef void (^PHNavBarItemActionBlock)(UIButton* _Nullable item, NSInteger index);

@protocol PHNavigationBarDelegate <NSObject>
@optional
/// 返回按钮事件
- (void)goBack;

/// item按钮事件
- (void)itemAction:(NSInteger)index;

@end
NS_ASSUME_NONNULL_BEGIN

@interface PHNavigationBar : UIView

/// 事件代理
@property (nonatomic, weak) id<PHNavigationBarDelegate> delegate;

/// 显示分割线
@property (nonatomic, assign) BOOL showLine;

/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// 返回按钮
@property (nonatomic, strong, readonly) UIButton *goBackButton;

/// 右边item
@property (nonatomic, strong, readonly) PHButtonPro *rightButton1;

/// 右边item2
@property (nonatomic, strong, readonly) PHButtonPro *rightButton2;

/// 是否显示白色背景
@property (nonatomic, assign, readonly) BOOL mainColorBackground;

/// 按钮1传入的是否为图片
@property (nonatomic, assign, readonly) BOOL item1Image;

/// 按钮2传入的是否为图片
@property (nonatomic, assign, readonly) BOOL item2Image;

/// 左边返回按钮点击事件回调
@property (nonatomic, copy) PHNavBarGoBackBlock goBackBlock;

/// 右边按钮点击事件回调
@property (nonatomic, copy) PHNavBarItemActionBlock itemIndexBlock;

/// 标题文本
@property (nonatomic, copy) NSString *title;

/** 隐藏返回按钮 */
@property (nonatomic, assign) BOOL hideBackItem;


/// 初始化方法
/// @param title 标题
/// @param items 右边按钮标题或者图片
- (instancetype)initWithTitle:(NSString *)title items:(NSArray<id>*)items;

/**
 初始化方法

 @param title 标题
 @param items 右边按钮标题或者图片
 @param mainColorBackground 是否显示白色背景
 @return 导航view
 */
- (instancetype)initWithTitle:(NSString *)title items:(NSArray<id>*)items mainColorBackground:(BOOL)mainColorBackground;

/**
 设置右边item

 @param items 数组
 */
- (void)showRightItems:(NSArray<id>*)items;


/**
 更换按钮颜色

 @param color 颜色
 */
- (void)imageWihtTintColor:(UIColor *)color;



@end

NS_ASSUME_NONNULL_END
