//
//  NSObject+PH.m
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/29.
//

#import "NSObject+PHDevice.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <sys/utsname.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NSObject (PH)

+ (BOOL)ph_iphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSStringEncoding encoding = NSASCIIStringEncoding;
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:encoding];
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"] || [platform isEqualToString:@"iPhone11,2"] || [platform isEqualToString:@"iPhone11,8"] || [platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"] || [platform isEqualToString:@"iPhone12,1"] || [platform isEqualToString:@"iPhone12,3"] || [platform isEqualToString:@"iPhone12,5"]) {
        return YES;
    } else if ([platform isEqualToString:@"i386"]||[platform isEqualToString:@"x86_64"]) {
        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
        CGFloat screen_height = [UIScreen mainScreen].bounds.size.height;
        if ((screen_width == 375)&&(screen_height == 812)) { // 模拟器iPhoneX,XS
            return YES;
        } else if ((screen_width == 414)&&(screen_height == 896)) { // 模拟器iPhoneXR,XSMAX
            return YES;
        }
    }
    return NO;
}

+ (NSString *)ph_deviceOSVersion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString * mode = [self iphoneType];
    return [NSString stringWithFormat:@"%@_%@",mode,phoneVersion];
    
}

+ (NSString *)ph_OSInfo{
    NSString* phoneName = [[UIDevice currentDevice] systemName];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@ %@",phoneName,phoneVersion];
}

+ (NSString *)ph_iphoneTypeInfo{
    NSString * type = [self iphoneType];
    return type;
}

+ (NSString *)iphoneType {
    //需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSStringEncoding encoding = NSASCIIStringEncoding;
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:encoding];
    if (![platform containsString:@"iPhone"]) return [self otherAppleDeviceTypeWithPlatform:platform];
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    return platform;
}

+ (NSString *)otherAppleDeviceTypeWithPlatform:(NSString *)platform {
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV5,3"])   return @"Apple TV 4";
    if ([platform isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    return platform;
}

@end
