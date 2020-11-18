//
//  NSURL+PH.h
//  FBSnapshotTestCase
//
//  Created by Hu, Yuping on 2019/11/1.
//  url字符串进行Encode/Decode

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (PH)

/**
 url字符串进行Encode
 
 @param str url字符串
 @return 返回Encode后字符串
 */
+(NSString*)ph_urlValueEncode:(NSString*)str;

/**
 对编码后的进行解码

 @param str 编码字符串过的
 @return 解码后的字符串
 */
+(NSString *)ph_urlValueDecode:(NSString*)str;

/**
 获取视频第一帧

 @param url 视频URL
 @return image
 */
+ (UIImage*)ph_getVideoPreViewImageWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
