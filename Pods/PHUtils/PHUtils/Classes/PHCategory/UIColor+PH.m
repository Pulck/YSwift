//
//  UIColor+PH.m
//  FBSnapshotTestCase
//
//  Created by Hu, Yuping on 2019/11/1.
//

#import "UIColor+PH.h"

struct HSV {
    // 色调
    CGFloat h;
    // 饱和度
    CGFloat s;
    // 明度
    CGFloat v;
    // 透明度
    CGFloat al;
};
typedef struct HSV HSV;

struct RGB {
    CGFloat R;
    CGFloat G;
    CGFloat B;
    CGFloat al;
};
typedef struct RGB RGB;

const double hueStep = 2;
const double saturationStep = 16;
const double saturationStep2 = 5;
const double brightnessStep1 = 5;
const double brightnessStep2 = 15;
const double lightColorCount = 5;
const double darkColorCount = 4;

@implementation UIColor (PH)

//默认alpha值为1.0f
+ (UIColor *)ph_colorWithHexString:(NSString *)color
{
    return [self ph_colorWithHexString:color alpha:1.0f];
}

+ (BOOL)ph_colorStatusWithHexString:(NSString *)color {
    //删除字符串中的空格
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *cString = [[color stringByTrimmingCharactersInSet:characterSet] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return NO;
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return NO;
    }
    return YES;
}

+ (UIColor *)ph_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *cString = [[color stringByTrimmingCharactersInSet:characterSet] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int rValue, gValue, bVlaue;
    [[NSScanner scannerWithString:rString] scanHexInt:&rValue];
    [[NSScanner scannerWithString:gString] scanHexInt:&gValue];
    [[NSScanner scannerWithString:bString] scanHexInt:&bVlaue];
    CGFloat red = (float)rValue / 255.0f;
    CGFloat green = (float)gValue / 255.0f;
    CGFloat blue = (float)bVlaue / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//D color   : 0: #f0f6ff
//D color   : 1: #f0f6ff
//D color   : 2: #e6eeff
//D color   : 3: #bdd2ff
//D color   : 4: #94b2ff
//D color   : 5: #6b90ff
//D color   : 6: #436bff
//D color   : 7: #2e4dd9
//D color   : 8: #1d33b3
//D color   : 9: #0f1e8c
//D color   : 10: #0a1266


/**
 十六进制 根据调色板 转UIColor
 
 @param hexString 十六进制色值
 @param index 色板编号（1~10）
 @return 色值
 */
+ (UIColor *)ph_colorPaletteWitHexString:(NSString *)hexString index:(NSInteger)index {
    struct HSV hsv;
    UIColor *hsvColor = [UIColor ph_colorWithHexString:hexString];
    hsv =  [self getHSVColorWithColor:hsvColor]; // 如果设置有误，会当做黑色处理
    BOOL isLight = index <= 6;
    double iValue = index - lightColorCount - 1; // 高亮还是暗黑
    if (isLight) {
        iValue = lightColorCount + 1 - index;
    }
    double hue = [self getHueWithHue:hsv.h*360.0f i:iValue isLight:isLight]/360.0f; // 色相
    double saturation = [self getSaturationWithSaturation:hsv.s i:iValue isLight:isLight]; //明度
    saturation = saturation/100;  // 明度
    double light = [self getLightWithLight:hsv.v i:iValue isLight:isLight]/100;
    struct RGB rgb;
    rgb = [self getRGBColorToHSVWithHue:hue Sa:saturation Br:light Al:1];
    return [UIColor colorWithRed:(rgb.R) green:(rgb.G) blue:(rgb.B) alpha:1];
}


/**
 color转hsv

 @param color color
 @return hsv
 */
+ (HSV)getHSVColorWithColor:(UIColor *)color
{
    struct HSV hsv;
    [color getHue:&hsv.h saturation:&hsv.s brightness:&hsv.v alpha:&hsv.al];
    return hsv;
}

/**
 hsv转rgb

 @param hu1 色调
 @param sa1 饱和度
 @param br1 明度
 @param al1 透明度
 @return RGB
 */
+ (RGB)getRGBColorToHSVWithHue:(CGFloat)hu1 Sa:(CGFloat)sa1 Br:(CGFloat)br1 Al:(CGFloat)al1
{
    UIColor * color = [UIColor colorWithHue:hu1 saturation:sa1 brightness:br1 alpha:al1];
    struct RGB rgb;
    [color getRed:&rgb.R green:&rgb.G blue:&rgb.B alpha:&rgb.al];
    return rgb;
}

/**
 hsv的色调转换

 @param hValue 色调
 @param iValue 色卡号
 @param isLight 是否高亮
 @return hsv的h新值
 */
+ (double)getHueWithHue:(double)hValue i:(NSInteger)iValue isLight:(BOOL)isLight {
    double hue;
    if (hValue >= 60 && hValue <= 240) {
        hue = isLight ? hValue - hueStep * iValue : hValue + hueStep * iValue;
    } else {
        hue = isLight ? hValue + hueStep * iValue : hValue - hueStep * iValue;
    }
    if (hue < 0) {
        hue += 360;
    } else if (hue >= 360) {
        hue -= 360;
    }
    return hue;
}

/**
 hsv的饱和度转换

 @param sValue 饱和度
 @param iValue 色卡号
 @param isLight 是否高亮
 @return hsv的s新值
 */
+ (double)getSaturationWithSaturation:(double)sValue i:(NSInteger)iValue isLight:(BOOL)isLight {
    double saturation;
    if (isLight) {
        saturation = roundf(sValue * 100) - saturationStep * iValue;
    } else if (iValue == darkColorCount) {
        saturation = round(sValue * 100) + saturationStep;
    } else {
        saturation = round(sValue * 100) + saturationStep2 * iValue;
    }
    if (saturation > 100) {
        saturation = 100;
    }
    if (isLight && iValue == lightColorCount && saturation > 10) {
        saturation = 10;
    }
    if (saturation < 6) {
        saturation = 6;
    }
    return roundf(saturation);
}

/**
 hsv的明度转换
 
 @param lValue 明度（指hsv中的v，用value命名容易混淆）
 @param iValue 色卡号
 @param isLight 是否高亮
 @return hsv的l新值
 */
+ (double)getLightWithLight:(double)lValue i:(NSInteger)iValue isLight:(BOOL)isLight {
    double value;
    if (isLight) {
        value = round(lValue * 100) + brightnessStep1 * iValue;
    }else {
        value = round(lValue * 100) - brightnessStep2 * iValue;
    }
    if (value > 100) {
        value = 100;
    }else if (value < 0) {
        value = 0;
    }
    return value;
}
@end
