//
//  PHBlankPageView.h
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/10.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PHBlankPageType) {
    PHBlankPageTypeData,//暂无数据
    PHBlankPageTypeNoAccess,//暂无权限
};

typedef void(^PHBlankItemBlock)(id _Nullable result);

NS_ASSUME_NONNULL_BEGIN

@interface PHBlankPageView : UIView
/**
 图片
 */
@property (strong,nonatomic) UIImageView *icon;

/**
 标题
 */
@property (strong, nonatomic) UILabel *titleLabel;

/**
 附文本标题
 */
@property (strong, nonatomic) UILabel *desLabel;

/**
 去设置
 */
@property (strong, nonatomic) UIButton *settingBtn;

/**
 显示类型
 */
@property (assign, nonatomic) PHBlankPageType blankPageType;

/**
 点击按钮事件的回调
*/
@property (nonatomic, copy) PHBlankItemBlock itemAction;

/**
 显示类型
 
 @param blankPageType 类型
 */
- (void)showBlankPageType:(PHBlankPageType)blankPageType;

/**
 更换标题
 
 @param title 标题
 */
- (void)setContentTitle:(NSString * _Nullable)title;

/**
 更换图片
 
 @param imageView 图片名
 */
- (void)setImageWithImageView:(UIImage * _Nullable)imageView;

/**
 全屏，显示空白页面

 @param baseView 显示视图
 @param blankPageType 显示类型 ,暂无数据，暂无权限
 @return 空白页面视图
 */
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView blankPageType:(PHBlankPageType)blankPageType;

/// 空白页面
/// @param baseView 显示视图
/// @param blankPageType 空白页面类型
/// @param isHalfScreen 是否半屏。YES 半屏， NO ，全屏
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView blankPageType:(PHBlankPageType)blankPageType isHalfScreen:(BOOL)isHalfScreen;

/// 空白页面支持更换标题
/// @param baseView 显示视图
/// @param contentTitle 标题
/// @param isHalfScreen 是否半屏。YES 半屏， NO ，全屏
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView contentTitle:(NSString * _Nullable)contentTitle isHalfScreen:(BOOL)isHalfScreen;

/// 全屏支持更换标题和图片
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle;

/// 自定义位置支持更换标题和图片
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
+ (PHBlankPageView *)showCustomerBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle;

/// 半屏支持更换标题和图片
/// @param baseView 添加在某个view上
/// @param contentImage 图片
/// @param contentTitle 标题
+ (PHBlankPageView *)showHalfScreenBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle;

/// 全屏显示带按钮的空白页面
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
/// @param buttonTitle 按钮标题
+ (PHBlankPageView *)showGuideBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle buttonTitle:(NSString * _Nullable)buttonTitle;

/// 全屏显示描述+按钮的空白页面
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
/// @param descriptor 副标题
/// @param buttonTitle 按钮标题
+ (PHBlankPageView *)showDesGuideBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle descriptor:(NSString * _Nullable)descriptor buttonTitle:(NSString * _Nullable)buttonTitle;

/// 显示带副标题，不带按钮的空白页面
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
/// @param descriptor 副标题
/// @param isHalfScreen 是否全屏，半屏
+ (PHBlankPageView *)showDescriptorBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle descriptor:(NSString * _Nullable)descriptor isHalfScreen:(BOOL)isHalfScreen;

/**
 移除
 */
+ (void)removeBlankPageOnView:(UIView * _Nullable)baseView;

@end

NS_ASSUME_NONNULL_END
