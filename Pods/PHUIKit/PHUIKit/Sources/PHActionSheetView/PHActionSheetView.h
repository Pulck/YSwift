//
//  PHActionSheetView.h
//  FBSnapshotTestCase
//
//  Created by 秦平平 on 2019/10/31.
//
//  ActionSheet弹框，从底部弹出
//  适用于多种选项的展示

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PHButtonPro.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PHActionSheetHandler)(NSInteger index, NSString * _Nullable title);

@interface PHActionSheetView : UIView

/// 取消按钮
@property (nonatomic, strong, readonly) PHButtonPro *cancelBtn;

/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// 其它按钮颜色
@property (nonatomic, strong) UIColor *otherTitleColor;

/// 点击Item回调
@property (nonatomic, copy) PHActionSheetHandler itemAction;


/// 初始化
/// @param title 标题 （可以为空）
/// @param cancelTitle 取消按钮 （不可以为空）
/// @param otherTitles 其它标题
- (instancetype)initWithTitle:(NSString * _Nullable)title cancelTitle:(NSString * _Nullable)cancelTitle otherTitles:(NSArray<NSString * > * _Nullable)otherTitles;

/// 显示视图
- (void)show;

/// 隐藏视图
- (void)hide;

@end

NS_ASSUME_NONNULL_END
