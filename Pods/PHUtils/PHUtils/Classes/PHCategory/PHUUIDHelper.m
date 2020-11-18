//
//  PHUUIDHelper.m
//  FBSnapshotTestCase
//
//  Created by 耿葱 on 2020/1/9.
//
#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"

#import "PHUUIDHelper.h"
#import "NSString+PH.h"

@implementation PHUUIDHelper

+ (NSString *)ph_getBizDeviceId {
    NSString *uuidString = [PHUUIDHelper ph_getDeviceId];
    uuidString = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    return [NSString stringWithFormat:@"502%@", uuidString.lowercaseString];
}

+(NSString *)ph_getDeviceId {
    NSString * strUUID = (NSString *)[PHKeyChainStore load:@"com.company.app.usernamepassword"];
    //首次执行该方法时，uuid为空
    if ([NSString ph_isNilOrEmpty:strUUID]){
        //生成一个uuid的方法
        strUUID = [self ph_getUUID];
        //将该uuid保存到keychain
        [PHKeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
    }
    return strUUID;
}

+ (NSString *)ph_getUUID {
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    return (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
}

@end


@implementation PHKeyChainStore

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    keychainQuery[(id)kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:data];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting
    //only a single attribute to be returned (the password) we
    //can set the attribute kSecReturnData to kCFBooleanTrue
    keychainQuery[(id)kSecReturnData] = (id)kCFBooleanTrue;
    keychainQuery[(id)kSecMatchLimit] = (id)kSecMatchLimitOne;
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
            NSLog(@"%@ finally", service);
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
