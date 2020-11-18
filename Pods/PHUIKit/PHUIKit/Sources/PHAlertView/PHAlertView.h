//
//  PHAlertView.h
//  Masonry
//
//  Created by 秦平平 on 2019/11/11.
//
//  Alert弹框；
//  支持纯文本、文本输入以及图片进行弹框展示
//  支持单个按钮，以及最多支持三个按钮的弹框展示

#import <UIKit/UIKit.h>
#import "PHButtonPro.h"

typedef void(^PHAlertViewHandler)(NSInteger index, NSString * _Nullable title, NSString * _Nullable text);
typedef void(^PHAlertCancelBlock)(NSString * _Nullable title);
typedef void(^PHAlertTextNumberBlock)(NSString * _Nullable text);
typedef void(^PHAlertRadioStateBlock)(BOOL state);

typedef NS_ENUM(NSUInteger, PHAlertTextType) {
    PHAlertTypeTextShow = 0, /// 仅文本展示 默认
    PHAlertTypeInput, ///  文本输入
    PHAlertTypeTextRadio, ///  支持选择框，保存设置
    PHAlertTypeLongInput, /// 长文本输入
    PHAlertImageTypeTop /// 图片显示在顶部 默认
};

NS_ASSUME_NONNULL_BEGIN

@interface PHAlertView : UIView

/// 取消按钮
@property (nonatomic, strong, readonly) PHButtonPro *cancelBtn;

/// 确定按钮
@property (nonatomic, strong, readonly) PHButtonPro *doneBtn;

/// 其它按钮
@property (nonatomic, strong, readonly) PHButtonPro *otherBtn;

/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// 文本输入框视图
@property (nonatomic, strong, readonly) UITextField *textFieldView;

/// 长文本输入框
@property (nonatomic, strong) UITextView *messageTextView;

/// 文本输入框提示语
@property (nonatomic, copy) NSString *placeholder;

/// 输入框默认文本
@property (nonatomic, copy) NSString *defaultText;

/// 文本输入框限制字数 默认 100
@property (nonatomic, assign) NSInteger textNumber;
/// 键盘弹出样式
@property (nonatomic, assign) UIKeyboardType textKeyboardType;

/// 键盘是否显示文字联想提示，默认显示联想提示
@property (nonatomic, assign) UITextAutocorrectionType autocorrectionType;

/// 取消按钮回调
@property (nonatomic, copy) PHAlertCancelBlock cancelAction;

/// 字数超出限制
@property (nonatomic, copy) PHAlertTextNumberBlock textNumberAction;

/// 选择框的状态
@property (nonatomic, copy) PHAlertRadioStateBlock radioAction;

/// 点击Item回调
@property (nonatomic, copy) PHAlertViewHandler itemAction;

/// 初始化
/// @param type 类型    支持仅展示/文本输入
/// @param title 标题 （可以为空）
/// @param message 信息说明
/// @param cancelTitle 取消按钮标题 （不可以为空）
/// @param otherTitles   按钮标题
- (instancetype)initWithAlertType:(PHAlertTextType)type
                            title:(NSString * _Nullable)title
                          message:(NSString * __nullable)message
                      cancelTitle:(NSString * _Nullable)cancelTitle
                      otherTitles:(NSArray<NSString *> * _Nullable)otherTitles;

/// 初始化
/// @param type 图片显示类型     图片在顶部
/// @param image 图片 （不为空)
/// @param title 标题
/// @param message 说明信息
/// @param cancelTitle 取消按钮标题 （不可以为空）
/// @param otherTitles 按钮标题
- (instancetype)initWithAlertType:(PHAlertTextType)type
                            image:(UIImage * _Nullable)image
                            title:(NSString * _Nullable)title
                          message:(NSString * __nullable)message
                      cancelTitle:(NSString * _Nullable)cancelTitle
                      otherTitles:(NSArray<NSString *> * _Nullable)otherTitles;

/// 显示视图
- (void)show;

/// 隐藏视图
- (void)hide;

@end

NS_ASSUME_NONNULL_END
