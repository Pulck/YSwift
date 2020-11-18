//
//  UIImage+PH.h
//  FBSnapshotTestCase
//
//  Created by Hu, Yuping on 2019/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PH)

/**
 通过色值生成纯色图片
 
 @param color 色值
 @return 返回UIImage
 */
+ (UIImage *)ph_createImageWithColor:(UIColor *)color;

/// 根据nikeName绘制图片
/// @param name 传最后一个字
/// @param size 大小
+ (UIImage *)ph_createNikeNameImageName:(NSString *)name imageSize:(CGSize)size;

/**
 根据目标图片制作一个盖水印的图片
 
 @param originalImage 源图片
 @param title 水印文字
 @param markFont 水印文字font(如果不传默认为16)
 @param markColor 水印文字颜色(如果不传递默认为蓝色)
 @param markAlignment 水印文字对齐方式(如果不传递默认为居中)
 @param verticalSpace 水平间距
 @param horizontalSpace 垂直间距
 @param rotation 旋转角度
 @return 返回盖水印的图片
 */
+ (UIImage *)ph_addWaterImage:(UIImage *)originalImage title:(NSString *)title markFont: (CGFloat)markFont
                     markColor: (UIColor *)markColor markAlignment: (NSNumber *)markAlignment waterWidth:(CGFloat)waterWidth
                   waterHeight:(CGFloat)waterHeight verticalSpace:(CGFloat)verticalSpace
               horizontalSpace:(CGFloat)horizontalSpace transformRotation:(CGFloat)rotation;

#pragma mark -图片旋转相关
/** 纠正图片的方向 */
- (UIImage *)ph_fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)ph_rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)ph_flipVertical;

/** 水平翻转 */
- (UIImage *)ph_flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)ph_imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)ph_imageRotatedByRadians:(CGFloat)radians;

/**
 将UIView转成UIImage并返回图片路径,不支持tableview、collectionview等
 
 @param view 要转换成image的View
 @param landscapeLeft 图片截成横屏传yes
 @return 图片路径
 */
+ (NSString *)ph_getViewImagePath:(UIView *)view landscapeLeft:(BOOL)landscapeLeft;

/**
 文字转二维码（感谢田园提供代码）
 
 @param string 文字
 @param Imagesize 二维码尺寸
 @param waterImagesize 二维码水印（显示在二维码中间）
 @return 生成后的二维码
 */
+ (UIImage *)ph_qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

#pragma mark - 图片压缩
/// 压缩图片
/// @param image 需要压缩的图片
/// @param maxSize 压缩最大值，单位：kb
/// @return 压缩后返回的图片数据，可能为 nil
+ (NSData *)compressImage:(UIImage *)image maxSize:(NSInteger)maxSize;

#pragma mark - 图片裁剪
/**
 压缩图片

 @param image 原图片
 @param size 压缩后的尺寸
 @return 压缩后的图片
 */
+ (UIImage*)ph_originImage:(UIImage *)image scaleToSize:(CGSize)size;

/**
 view转image
 
 @param theView view
 @param landscapeLeft 是否哟啊横屏
 @return image
 */
+ (UIImage *)getImageFromView:(UIView *)theView landscapeLeft:(BOOL)landscapeLeft;
@end

NS_ASSUME_NONNULL_END
