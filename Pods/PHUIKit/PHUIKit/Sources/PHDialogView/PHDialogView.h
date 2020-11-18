//
//  PHDialogView.h
//  AFNetworking
//
//  Created by zhuli on 2018/5/24.
//

#import "PHDialogBaseView.h"
#import "PHActionButton.h"

typedef NS_ENUM(NSInteger,PHDialogStyle) {
    ///中间弹框
    PHDialogStyleDefault = 0,
    ///底部弹框
    PHDialogStyleBottom,
};

@interface PHDialogView : PHDialogBaseView

/**
 标题
 */
@property (strong, nonatomic) UILabel * __nullable titleLabel;

/**
 中间内容
 */
@property (strong, nonatomic) UITextView * __nullable contentLabel;

/**
 弹框
 */
@property (nonatomic, strong) UIView * __nullable contentView;

/**
 添加点击按钮

 @param action 点击按钮
 */
- (void)addAction:(PHAction * __nullable)action;


- (instancetype __nullable)initWithFrame:(CGRect)frame image:(UIImage * __nullable )image title:(NSString * __nullable )title message:(nullable NSString *)message;


- (instancetype __nullable)initWithFrame:(CGRect)frame image:(UIImage * __nullable )image title:(NSString * __nullable )title message:(nullable NSString *)message type:(PHDialogStyle)type;

- (instancetype __nullable)initWithFrame:(CGRect)frame image:(UIImage * _Nullable)image title:(NSString * __nullable)title message:(NSString * __nullable)message type:(PHDialogStyle)type textAlignment:(NSTextAlignment)textAlignment;

@end
