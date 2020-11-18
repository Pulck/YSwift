//
//  NSString+PH.h
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PH)

/**
 判断手机号是否有效
 
 @param phoneNumber 手机号
 
 @return 返回Yes:有效； No:无效
 */
+ (BOOL)ph_isValidPhoneNumber:(NSString *)phoneNumber;

/**
 判断邮箱是否有效
 
 @param email 邮箱
 
 @return 返回Yes:有效； No:无效
 */
+ (BOOL)ph_isValidEmail:(NSString *)email;

/**
 判断是否是纯数字
 
 @param number 字符串
 
 @return 返回Yes:是； No:不是
 */
+ (BOOL)ph_isValidNumber:(NSString *)number;

/**
 判断是否包含数字
 
 @param string 字符串
 
 @return 返回Yes:是； No:不是
 */
+ (BOOL)ph_isContainNumber:(NSString *)string;

/**
 判断是否包含大写
 
 @param string 字符串
 
 @return 返回Yes:是； No:不是
 */
+ (BOOL)ph_isContainUppercase:(NSString *)string;

/**
 判断是否包含小写
 
 @param string 字符串
 
 @return 返回Yes:是； No:不是
 */
+ (BOOL)ph_isContainLowercase:(NSString *)string;

/**
 判断是否包含符号
 
 @param string 字符串
 
 @return 返回Yes:是； No:不是
 */
+ (BOOL)ph_isContainSymbols:(NSString *)string;

/**
 判断是否连续字符或连续相同字符超过2个(连续指大小写字母或阿拉伯数字的ascii码相连)
 
 @param string 字符串
 
 @return 返回Yes:是； No:不是
 */
+ (BOOL)ph_isContinueString:(NSString *)string;

/**
 *  判断是否包含汉字
 *
 *  @param string 字符串
 *
 *  @return Yes 包含汉字   No 不包含汉字
 */
+ (BOOL)ph_isChineseCharacters:(NSString *)string;

/**
 忽略首尾空格后，判断字符串是否为空或nil，是空就返回YES，非空返回NO

 @param value 待判断的字符串
 @return 返回 YES 或 NO
 */
+ (BOOL)ph_isNilOrEmpty:(NSString *)value;

/**
 忽略首尾空格后，判断字符串是否为非空或非nil，非空返回YES，是空返回NO

 @param value 待判断的字符串
 @return 返回YES 或 NO
 */
+ (BOOL)ph_notNilAndNotEmpty:(NSString *)value;

/**
 计算一个字符串在特定区域的CGSize
 
 @param valueStr 原始字符串
 @param font 字符串的字体大小
 @param originSize 字符串显示的区域
 @return 字符串的宽度和高度
 */
+ (CGSize)ph_boundSizeWithString:(NSString *)valueStr font:(UIFont *)font size:(CGSize)originSize;

/**
 md5
 
 @return 返回哈希值
 */
- (NSString *)ph_md5String;

/**
 encodeURIComponent解码
 
 @return 返回解码后的字符串
 */
- (NSString *)ph_stringValueDecode;

/**
 base64 编码
 
 @return 编码后的字符串
 */
- (NSString *)ph_base64Encode;

/**
 base64 解码
 
 @return 返回解码后的字符串
 */
- (NSString *)ph_base64Decode;

/**
 encodeURIComponent编码
 
 @return 返回编码后的字符串
 */
- (NSString *)ph_stringValueEncode;

/**
 创建AttributedString的 NSMutableDictionary
 
 @param lineSpacing 行间距
 @param fontSize 字体大小
 @return NSMutableDictionary
 */
+ (NSMutableDictionary *)ph_createFontAttributedDicWtihLineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize;

- (NSString *)PH_httpReplaceHttps:(NSString *)httpStr;

/*
 字符串是否包含string
 */
- (BOOL)ph_isContainString:(NSString *)string;

- (CGFloat)ph_widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;

/**
 去除头尾空格和换行
 */
- (NSString *)ph_stringByTrimmingWhitespaceAndNewline;

/**
 时长转换成字符串

 @param second 时长
 @return 字符串
 */
+ (NSString *)ph_convertStringSecond:(long)second;

/// 将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)ph_htmlEntityDecode:(NSString *)string;

/// 将HTML字符串转化为NSAttributedString富文本字符串
+ (NSAttributedString *)ph_attributedStringWithHTMLString:(NSString *)htmlString;

/// 去掉 HTML 字符串中的标签
+ (NSString *)ph_filterHTML:(NSString *)html;

/** 获取当前路径下文件的大小 */
- (unsigned long long)fileSize;

/// 数值大于等于万转换成 W
/// @param count 数值
+ (NSString *)ph_formatNumber_w:(NSInteger)count;

/// 根据aesKey和初始化向量加密字符串
/// @param content 需要加密的字符串
/// @param key aesKey
/// @param vector 初始化向量
+ (NSString *)ph_encryptWithContent:(NSString *)content
                                key:(NSString *)key
                             vector:(NSString *)vector;
@end

NS_ASSUME_NONNULL_END
