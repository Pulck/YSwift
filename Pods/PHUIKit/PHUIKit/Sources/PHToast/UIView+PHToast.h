//
//  UIView+PHToast.h
//  PHUIKit
//
//  Created by 朱力 on 2019/10/31.
//

#import <UIKit/UIKit.h>

/* =======================  =======================
 *   1、makePHToast弹出消息
 *   2、makeImagePHToast、makePHToastByType弹出带图片的消息
 *   3、makePHActiveToast弹出等待
 * =======================  =======================*/

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PHToastImageType) {
    //成功
    PHImageSuccess,
    //失败
    PHImageFailure,
};

@interface UIView (PHToast)

/**
 1、弹出居中的普通吐丝儿
 2、消失时间1.5S
 3、点击会自动消失
 4、用户无法操作当前页面的功能，但可以操作导航
 
 @param message 吐丝儿的文字内容
 @param tapToDismiss 开启点击消失
 */
- (void)makePHToast:(NSString *)message
       tapToDismiss:(BOOL)tapToDismiss;

/**
 1、弹出指定时间和位置的普通吐丝儿
 2、点击会自动消失
 3、用户无法操作当前页面的功能，但可以操作导航
 
 @param message 吐丝儿的文字内容
 @param duration 吐丝儿的显示时间
 @param tapToDismiss 开启点击消失
 */
- (void)makePHToast:(NSString *)message
           duration:(NSTimeInterval)duration
       tapToDismiss:(BOOL)tapToDismiss;

/**
 1、弹出居中的带有图片和文字的吐丝儿
 2、请传入36*36的图片
 3、图片和文本会组合居中在吐丝中
 4、文本不会自动换行
 
 @param image 传入图片内容
 @param message 传入文本内容
 @param duration 吐丝儿的显示时间
 @param tapToDismiss 开启点击消失
 */
- (void)makeImagePHToast:(UIImage *)image
                             message:(NSString *)message
                            duration:(NSTimeInterval)duration
                        tapToDismiss:(BOOL)tapToDismiss;


/**
 1、弹出居中的指定类型图片和文字的吐丝儿
 2、图片和文本会组合居中在吐丝中
 3、文本不会自动换行
 
 @param imageType 传入指定类型的图片
 @param duration 吐丝儿的显示时间
 @param tapToDismiss 开启点击消失
 */
- (void)makePHToastByType:(PHToastImageType)imageType
                  message:(NSString *)message
                 duration:(NSTimeInterval)duration
             tapToDismiss:(BOOL)tapToDismiss;

/**
 1、弹出等待吐丝儿（圆环转圈样式）
 
 @param tapToDismiss 开启点击消失
 @param msg 等待消息
 @param completion 点击消失回调
 */
- (void)makePHActiveToast:(BOOL)tapToDismiss
                      msg:(NSString * __nullable)msg
               completion:(void(^)(BOOL didTap))completion;

/**
 1、弹出带文字等待吐丝儿（圆环转圈样式）
 
 @param msg 等待消息
 */
- (void)makePHActiveToast:(NSString *)msg;

/**
 1、弹出等待吐丝儿（圆环转圈样式）
 */
- (void)makePHActiveToast;

/**
 隐藏吐丝
 */
- (void)hidePHToast;

/**
 隐藏所有吐丝
 */
- (void)hideAllPHToast;

@end

NS_ASSUME_NONNULL_END
