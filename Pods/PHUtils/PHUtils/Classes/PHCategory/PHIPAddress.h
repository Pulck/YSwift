//
//  PHIPAddress.h
//  FBSnapshotTestCase
//
//  Created by 耿葱 on 2020/3/13.
// 获取ip地址，可以获取wifi 4g两种网络情况下的ip地址

#import <Foundation/Foundation.h>

#define BUFFERSIZE  4000
#define MAXADDRS    32
#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))
NS_ASSUME_NONNULL_BEGIN
@interface PHAddressConfig : NSObject
// extern
extern char * _Nonnull if_names[MAXADDRS];
extern char * _Nonnull ip_names[MAXADDRS];
extern char * _Nonnull hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

void InitAddresses(void);
void FreeAddresses(void);
void GetIPAddresses(void);
void GetHWAddresses(void);
@end

@interface PHIPAddress : NSObject

/// 获取设备IP地址
/// @param preferIPv4 是否ipV4
+ (NSString *)ph_getIPAddress:(BOOL)preferIPv4;
@end

NS_ASSUME_NONNULL_END
