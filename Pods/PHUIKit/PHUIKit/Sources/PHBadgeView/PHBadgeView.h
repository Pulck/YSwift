//
//  PHBadgeView.h
//  Masonry
//
//  Created by Hu, Yuping on 2019/11/6.
//  角标View，可以设置数字；数字为0时，显示圆点

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHBadgeView : UIView

/** 显示角标的数字 */
@property (nonatomic, strong) UILabel *badge;
/** 角标的字体 */
@property (nonatomic, strong) UIFont *badgeFont;
/** 角标的背景颜色 */
@property (nonatomic, strong) UIColor *badgeBgColor;
/** 角标的文字颜色 */
@property (nonatomic, strong) UIColor *badgeTextColor;


/**
 获取一个角标实例
 
 @return 返回一个角标实例
 */
+ (PHBadgeView *)bageView;

/**
 获取一个圆形的红点，默认宽度和高度都是8（不带数字）
 
 @return 返回角标对象
 */
+ (instancetype)showRedDotBadge;

/**
 获取一个带数字的红点，宽度和高度时根据当前的数字大小来计算出来
 
 @param value 红点的数字
 @return 返回角标对象
 */
+ (instancetype)showNumberBadgewithValue:(NSInteger)value;

/**
 清除角标上的数字
 */
- (void)clearBadge;

/**
 重新设置当前小红点的背景颜色（解决UITableViewCell选中时，当前视图失去颜色的问题）
 */
- (void)resetColor;

/**
 获取当前角标的Size大小
 */
- (CGSize)fetchBadgeSize;

@end

NS_ASSUME_NONNULL_END
