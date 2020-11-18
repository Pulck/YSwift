//
//  NSDate+PH.m
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/23.
//

#import "NSDate+PH.h"

@implementation NSDate (PH)

// 字符串转时间
+ (NSDate *)ph_formatTimeString:(NSString *)timeStr
                   formatterStr:(NSString *)formatterStr
                       timeZone:(NSTimeZone * __nullable)timeZone {
    if (!timeStr || !formatterStr) {
        return [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    formatter.timeZone = timeZone;
    if (!timeZone) {
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    }
    NSDate *date = [formatter dateFromString:timeStr];
    return date;
}

// 时间转字符串
+ (NSString *)ph_formatDate:(NSDate *)date
               formatterStr:(NSString *)formatterStr
                   timeZone:(NSTimeZone * __nullable)timeZone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterStr;
    formatter.timeZone = timeZone;
    if (!timeZone) {
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    }
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

// 是否是今天
- (BOOL)ph_isToday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}

// 是否是昨天
- (BOOL)ph_isYesterday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *nowDate = [fmt dateFromString:nowString];
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

// 将日期转换为时间戳字符串
+ (NSString *)ph_dateToTimestamp:(NSDate *)date {
    NSTimeInterval stamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", stamp];
}

//时间戳字符串转日期
+ (NSDate *)ph_timestampToDate:(NSString *)string {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[string doubleValue]];
    return date;
}

//日期格式转字符串
+ (NSString *)ph_dateToString:(NSDate *)date withDateFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

@end
