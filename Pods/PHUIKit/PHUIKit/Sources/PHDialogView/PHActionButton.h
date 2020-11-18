//
//  PHActionButton.h
//  AFNetworking
//
//  Created by zhuli on 2018/5/13.
//  按钮封装
//  测试重点：纯代码、xib、mas布局

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YXYButtonType) {
    ///纯蓝色背景
    YXYButtonTypeDefault,
    ///纯蓝色背景+圆角
    YXYButtonTypeCorner,
    ///带边框 圆角+边框
    YXYButtonTypeBorder,
} ;

@interface PHActionButton : UIButton

/**
 YXYButtonType xib样式
 */
@property (assign, nonatomic) IBInspectable NSInteger xibType;

/**
 YXYButtonType 样式
 */
@property (assign, nonatomic) YXYButtonType type;

/**
 主色值（供外部在原有样式下改色值）
 */
@property (copy, nonatomic) NSString * _Nonnull mainColorStr;

/**
 高亮主色值（供外部在原有样式下改色值）
 */
@property (copy, nonatomic) NSString * _Nonnull mainHighlightColorStr;


///**
// 是否禁用 （YES：禁用；NO：不禁用，默认NO）
// */
//@property (assign, nonatomic) BOOL shouldShowDisabled;

/**
 初始化PHActionButton

 @param frame size
 @param type YXYButtonType
 @return button
 */
- (instancetype __nullable)initWithFrame:(CGRect)frame type:(YXYButtonType)type;

@end


#pragma matk - PHAction

typedef NS_ENUM(NSInteger,PHActionStyle) {
    ///纯白色背景+蓝色字
    PHActionStyleDefault = 0,
    ///纯蓝色背景+白色字
    PHActionStyleBlue,
};

@interface PHAction : NSObject

typedef void(^PHActionBlock)(PHAction * __nullable action);

typedef void(^PHActionBtnBlock)(PHActionButton * __nullable button);

/**
 按钮标题
 */
@property (nonatomic, copy) NSString * __nullable title;

/**
 按钮样式
 */
@property (nonatomic, assign) NSInteger style;

@property (nonatomic, copy) PHActionBlock __nullable block;
@property (nonatomic, copy) PHActionBtnBlock __nullable btnblock;

+ (instancetype __nullable)actionWithTitle:(nullable NSString *)title style:(PHActionStyle)style handler:(void (^ __nullable)(PHAction * __nullable action))handler;

+ (instancetype __nullable)actionWithTitle:(nullable NSString *)title style:(PHActionStyle)style handler:(void (^ __nullable)(PHAction * __nullable action))handler button:(void (^ __nullable)( PHActionButton * __nullable button))button;

@end

#pragma matk - PHActionView

@interface PHActionView : UIView

- (void)addAction:(PHAction * __nullable)action;

@end
