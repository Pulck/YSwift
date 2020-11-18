//
//  AESCipher.h
//  AESCipher
//
//  Created by Welkin Xie on 8/13/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//
//  https://github.com/WelkinXie/AESCipher-iOS
//

#import <Foundation/Foundation.h>

NSString * aesEncryptString(NSString *content, NSString *key, NSString *initVector);
NSString * aesDecryptString(NSString *content, NSString *key, NSString *initVector);

NSData * aesEncryptData(NSData *contentData, NSData *keyData, NSString *initVector);
NSData * aesDecryptData(NSData *contentData, NSData *keyData, NSString *initVector);
