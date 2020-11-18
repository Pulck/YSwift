//
//  PHBaseDataUtil.m
//  FBSnapshotTestCase
//
//  Created by Hu, Yuping on 2019/10/31.
//

#import "PHBaseDataUtil.h"

#define NUMBER(__OBJ) [NSNumber numberWithInt:__OBJ]
#define NUMBER_LONG(__OBJ) [NSNumber numberWithLong:__OBJ]
#define NUMBER_DOUBLE(__OBJ) [NSNumber numberWithDouble:__OBJ]

@implementation PHBaseDataUtil

+ (BOOL)isPHKindOfClass:(id)value class:(Class)class
{
    if (value && ![value isEqual:[NSNull null]] && [value isKindOfClass:class]) {
        return  TRUE;
    }
    
    return FALSE;
}

+ (BOOL)isPHKindOfDictionary:(id)value
{
    return [self isPHKindOfClass:value class:[NSDictionary class]];
}

+ (BOOL)isPHKindOfNSNumber:(id)value
{
    
    return [self isPHKindOfClass:value class:[NSNumber class]];
}

+ (BOOL)isPHKindOfArray:(id)value
{
    
    return [self isPHKindOfClass:value class:[NSArray class]];
}

+ (BOOL)isPHKindOfString:(id)value
{
    return [self isPHKindOfClass:value class:[NSString class]];
}

+ (NSString * _Nonnull)paramStringIsNull:(id)param {
    if ([self isPHKindOfClass:param class:[NSString class]]) { // 是NSString类型,并且非空
        return param;
    }
    return @"";// 非NSString类型
}

+ (NSString *)paramStringIsNull:(NSString *)param format:(NSString *)format {
    NSString *result = param; // 默认为传进来的字符串参数
    if ([param isEqual:[NSNull null]] || param == nil || [param isEqualToString:@""]) {
        result = format; // 若参数无效，则返回格式字符串
    }
    return result;
}

+ (NSArray * _Nonnull)paramArrayIsNull:(id)param {
    // 是NSArray类型,并且非空
    if ([self isPHKindOfClass:param class:[NSArray class]]) {
        return param;
    }
    return @[];// 非NSArray类型
}

+ ( NSDictionary * _Nonnull )paramDictIsNull:(id)param {
    // 是NSDictionary类型,并且非空
    if ([self isPHKindOfClass:param class:[NSDictionary class]]) {
        return param;
    }
    return @{};// 非NSDictionary类型
}

+ (NSData * _Nonnull)paramDataIsNull:(id)param {
    if ([self isPHKindOfClass:param class:[NSData class]]) { // 是NSData类型,并且非空
        return param;
    }
    return [NSData data];// 非NSData类型
}

+ (NSNumber *)paramNumberIsNull:(id)param
{
    if ([param isKindOfClass:[NSNumber class]]) {
        NSNumber *num = param;
        if ([param isEqual:[NSNull null]] || param == nil || [param isEqual: @""]) {
            num = NUMBER(0);
        }
        return num;
    }else if ([param isKindOfClass:[NSString class]]) {
        NSString *num = (NSString *)param;
        NSNumber *result = [NSNumber numberWithDouble:[num doubleValue]];
        if ([[self paramStringIsNull:num] isEqualToString:@""]) {
            result = NUMBER(0);
        }
        return result;
    }
    
    return NUMBER(0);
}

+ (NSNumber *)paramNumberDoubleIsNull:(NSNumber *)param
{
    if ([param isKindOfClass:[NSNumber class]]) {
        NSNumber *result = param;
        if ([param isEqual:[NSNull null]] || param == nil || [param isEqual: @""]) {
            result = NUMBER(0);
        }
        return result;
    }else if ([param isKindOfClass:[NSString class]]) {
        NSString *num = (NSString *)param;
        NSNumber *result = [NSNumber numberWithDouble:[num doubleValue]];
        if ([[self paramStringIsNull:num] isEqualToString:@""]) {
            result = NUMBER(0);
        }
        return result;
    }
    return NUMBER(0);
}

@end
