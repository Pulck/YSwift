//
//  UIColor+PH.h
//  FBSnapshotTestCase
//
//  Created by Hu, Yuping on 2019/11/1.
//  十六进制字符串获取UIColor、云学堂主视觉色/强调色/提示色/辅助色/文字、分割线颜色

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (PH)

/**
 十六进制转UIColor，默认alpha值为1.0f
 @param color 十六进制色值字符串
 @return UIColor对象
 */
+ (UIColor *)ph_colorWithHexString:(NSString *)color;

/**
 判断HexString是否是有效色值
 @param color 十六进制
 @return yes：是有效色值；No：不是有效色值
 */
+ (BOOL)ph_colorStatusWithHexString:(NSString *)color;

/**
 十六进制转UIColor
 @param color 十六进制色值字符串
 @param alpha 不透明度设置
 @return UIColor对象
 */
+ (UIColor *)ph_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 十六进制 根据调色板 转UIColor

 @param hexString 十六进制色值
 @param index 色板编号（1~10，color-1对应index为1）
 @return 色值
 */
+ (UIColor *)ph_colorPaletteWitHexString:(NSString *)hexString index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
