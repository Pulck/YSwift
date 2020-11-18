//
//  UIView+PH.h
//  PHUtils
//
//  Created by Hu, Yuping on 2019/11/1.
//  left/width/centerX等获取、圆角的颜色/半径、打印frame、获取当前view所在控制器、淡入/淡出/缩放/旋转动画

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PH)

@property (nonatomic) CGFloat ph_left;
@property (nonatomic) CGFloat ph_top;
@property (nonatomic) CGFloat ph_right;
@property (nonatomic) CGFloat ph_bottom;
@property (nonatomic) CGFloat ph_width;
@property (nonatomic) CGFloat ph_height;

@property (nonatomic) CGPoint ph_origin;
@property (nonatomic) CGSize ph_size;

@property (nonatomic, assign) CGFloat ph_x;
@property (nonatomic, assign) CGFloat ph_y;
@property (nonatomic, assign) CGFloat ph_centerX;
@property (nonatomic, assign) CGFloat ph_centerY;

/**
 *  圆角的颜色-这个颜色需要和背景颜色设置一致
 */
@property (nonatomic, strong)  UIColor *ph_roundCornerColor;

/**
 *  圆角的半径
 */
@property (nonatomic, assign)  CGFloat ph_roundCornerRadius;

/**
 打印当前视图的Frame
 */
- (void)ph_printFrame;


/**
 获取当前视图的下一个事件响应VC对象
 @return 下一个事件h接收对象VC
 */
- (UIViewController *)ph_responderViewController;

/**
 淡入动画
 
 @param time 动画执行时长
 */
- (void)ph_fadeInWithTime:(NSTimeInterval)time;

/**
 淡出动画
 
 @param time 动画执行时长
 */
- (void)ph_fadeOutWithTime:(NSTimeInterval)time;

/**
 缩放动画
 
 @param time 动画执行时长
 */
- (void)ph_scalingWithTime:(NSTimeInterval)time andscal:(CGFloat)scal;

/**
 旋转动画
 
 @param time 动画执行时长
 */
- (void)ph_revolvingWithTime:(NSTimeInterval)time andDelta:(CGFloat)delta;

/**
 lineV:       需要绘制成虚线的view
 lineW:     虚线的宽度
 lineS:    虚线的间距
 lineC:      虚线的颜色
 */
+ (void)ph_drawDashLine:(UIView *)lineV width:(int)lineW spacing:(int)lineS color:(UIColor *)lineC;

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)ph_addRoundedCorners:(UIRectCorner)corners
                    withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)ph_addRoundedCorners:(UIRectCorner)corners
                    withRadii:(CGSize)radii
                     viewRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
