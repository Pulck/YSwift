//
//  PHFilterTableViewCell.h
//  lottie-ios
//
//  Created by Hu, Yuping on 2019/11/19.
//  下拉列表Cell视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHFilterTableViewCell : UITableViewCell

/** 是否禁用当前的Cell，默认值为 NO */
@property (nonatomic, assign) BOOL disabled;
/** 设置当前的标题 */
- (void) setCellText:(NSString *)title;


/** 获取Cell的文字的默认颜色 */
- (UIColor *)normalColor;
/** 设置Cell的文字显示的默认颜色 */
- (void)setNormalColor:(UIColor *)normalColor;
/** 获取Cell的文字的高亮的颜色 */
- (UIColor *)highlightColor;
/** 设置Cell的文字高亮的颜色 */
- (void)setHighlightColor:(UIColor *)highlightColor;
/** 获取Cell的文字禁用时的颜色 */
- (UIColor *)disabledColor;
/** 设置Cell的文字禁用时的颜色 */
- (void)setDisabledColor:(UIColor *)disabledColor;
/** 获取Cell分割线的颜色 */
- (UIColor *)lineColor;
/** 设置Cell分割线的颜色 */
- (void)setLineColor:(UIColor *)lineColor;
/** 设置右边的选中的图标(大小:16*16) */
- (void)setRightArrowImg:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
