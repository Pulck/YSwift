//
//  PHFrameworkUtil.h
//  PHUtils
//
//  Created by dingw on 2020/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取Framework里bundle中的资源路径
#define PH_RESOURCE_PATH_FRAMEWORK_BUNDLE(kClass,kResourceBundleName,kResourceName) [PHFrameworkUtil ph_resourcePathWithFrameworkClass:kClass resourceBundleName:kResourceBundleName resourceName:kResourceName];
/// 获取Framework里bundle中的图片
#define PH_IMAGE_FRAMEWORK_BUNDLE(kClass,kResourceBundleName,kResourceName) [PHFrameworkUtil ph_imageWithFrameworkClass:kClass resourceBundleName:kResourceBundleName resourceName:kResourceName];

@interface PHFrameworkUtil : NSObject

/// 获取Framework里bundle中的资源路径
/// @param class Framework中的class，用来获取Framework路径
/// @param resourceBundleName 资源bundle名，如：PHResource.bundle，需要带后缀
/// @param resourceName 资源名，如：image.svg，需要带后缀
+ (NSString *)ph_resourcePathWithFrameworkClass:(Class)class resourceBundleName:(NSString *)resourceBundleName resourceName:(NSString *)resourceName;

/// 获取Framework里bundle中的图片
/// @param class Framework中的class，用来获取Framework路径
/// @param resourceBundleName 资源bundle名，如：PHResource.bundle，需要带后缀
/// @param resourceName 资源名，如：image.jpg，需要带后缀（图片生成方法[UIImage imageNamed:inBundle:compatibleWithTraitCollection:]）
+ (UIImage *)ph_imageWithFrameworkClass:(Class)class resourceBundleName:(NSString *)resourceBundleName resourceName:(NSString *)resourceName;

@end

NS_ASSUME_NONNULL_END
