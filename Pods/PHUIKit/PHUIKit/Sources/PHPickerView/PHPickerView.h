//
//  PHPickerView.h
//  PHUIKit
//
//  Created by 秦平平 on 2019/11/4.
//
//  PickerView弹框
//  适用于多种选项的展示，可以自定义标题及左右两边的点击按钮

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHPickerView : UIView
/**
 确定后回调（回调选中的下标，显示的字符）
 */
@property (nonatomic,copy) void (^completionBlock)(NSInteger index,NSString *result);

/**
 PHPickerView页面隐藏回调
 */
@property (nonatomic,copy) void (^cancelBlock)(void);

/**
 PHPickerView标题
*/
@property (nonatomic, strong, readonly) UILabel * titleLabel;

/**
 PHPickerView取消按钮
*/
@property (nonatomic, strong, readonly) UIButton * cancleBtn;

/**
 PHPickerView确定按钮
*/
@property (nonatomic, strong, readonly) UIButton * doneBtn;


/**
 设置标题和数据（需要和初始化一起设置）
 
 @param title 标题
 @param data 数据
 */
- (void)showPickerWithTitle:(NSString *)title data:(NSArray *)data;

/**
 设置默认值
 
 @param row 第一列（从0开始）
 @param animated animated
 */
- (void)selectRow:(NSInteger)row animated:(BOOL)animated;

/**
 显示已经初始化的PHPickerView
 */
- (void)show;

/**
 隐藏view
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
