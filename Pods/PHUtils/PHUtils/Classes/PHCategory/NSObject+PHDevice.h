//
//  NSObject+PHDevice.h
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/29.
//换算文件大小、获取文件大小的单位、随机6位数、将原始文件进行Base64加密/解密、获取磁盘总大小、获取磁盘剩余空间、根据路径获取文件大小

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PHDevice)

/**
 判断刘海屏
 
 @return YES：刘海屏
 */
+ (BOOL)ph_iphoneX;

/*
 设备机型和系统版本号
 */
+ (NSString *)ph_deviceOSVersion;

/*
 系统版本号
 */
+ (NSString *)ph_OSInfo;

/*
 设备机型
 */
+ (NSString *)ph_iphoneTypeInfo;
@end

NS_ASSUME_NONNULL_END
