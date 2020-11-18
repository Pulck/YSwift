//
//  PHUUIDHelper.h
//  FBSnapshotTestCase
//
//  Created by 耿葱 on 2020/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHUUIDHelper : NSObject

/**
 获取基于凤凰业务的当前设备的唯一ID（设备ID与业务需求拼接）

 @return 基于凤凰业务的当前设备的唯一ID
 */
+ (NSString *)ph_getBizDeviceId;

/**
 获取当前设备的唯一ID，重装APP后不会发生变化，手机恢复出厂设置或重置钥匙串会后会发生变化

 @return 设备唯一ID
 */
+(NSString *)ph_getDeviceId;

/**
 获取系统返回的uuid，重装APP后会发生变化

 @return 系统返回的uuid
 */
+ (NSString *)ph_getUUID;

@end

@interface PHKeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
