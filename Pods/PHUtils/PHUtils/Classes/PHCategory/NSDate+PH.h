//
//  NSDate+PH.h
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (PH)

/**
 字符串转时间
 
 @param timeStr 需要转的字符串
 @param formatterStr 格式化字符串;
 @param timeZone 字符串所属的时区，不传则使用系统时区，建议不传！
 @return 转换后的时间
 */
+ (NSDate *)ph_formatTimeString:(NSString *)timeStr
                   formatterStr:(NSString *)formatterStr
                       timeZone:(NSTimeZone * __nullable)timeZone;

/**
 时间转字符串
 
 @param date 需要转的时间
 @param formatterStr 格式化字符串
 @param timeZone 时间所属的时区，不传则使用系统时区，建议不传！
 @return 转换后的字符串
 */
+ (NSString *)ph_formatDate:(NSDate *)date
               formatterStr:(NSString *)formatterStr
                   timeZone:(NSTimeZone * __nullable)timeZone;

/**
 判断当前对象是否是今天
 
 @return YES：当前对象是今天，当前对象不是今天；
 */
- (BOOL)ph_isToday;

/**
 判断当前对象是否为昨天
 
 @return YES：当前对象是昨天，当前对象不是昨天；
 */
- (BOOL)ph_isYesterday;

/**
 日期转换为时间戳字符串
 
 @param date 日期
 @return 时间戳字符串
 */
+ (NSString *)ph_dateToTimestamp:(NSDate *)date;

/**
 时间戳字符串转日期
 
 @param string 时间戳字符串
 @return 日期
 */
+ (NSDate *)ph_timestampToDate:(NSString *)string;

/**
 日期格式转字符串

 @param date 日期
 @param format 日期格式
 @return 格式化的日期字符串
 */
+ (NSString *)ph_dateToString:(NSDate *)date withDateFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
