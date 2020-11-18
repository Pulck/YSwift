//
//  PHFrameworkUtil.m
//  PHUtils
//
//  Created by dingw on 2020/9/2.
//

#import "PHFrameworkUtil.h"
#import "NSString+PH.h"
#import "PHMacro.h"

@implementation PHFrameworkUtil


/// 获取Framework里bundle中的资源路径
/// @param class Framework中的class，用来获取Framework路径
/// @param resourceBundleName 资源bundle名，如：PHResource.bundle，需要带后缀
/// @param resourceName 资源名，如：image.svg，需要带后缀
+ (NSString *)ph_resourcePathWithFrameworkClass:(Class)class resourceBundleName:(NSString *)resourceBundleName resourceName:(NSString *)resourceName {
    if (!class || [NSString ph_isNilOrEmpty:resourceBundleName] || [NSString ph_isNilOrEmpty:resourceName]) {
        return nil;
    }
    NSBundle *frameworkBundle = PH_BUNDLE_FOR_CLASS(class);
    NSString *resourceBundlePath = [frameworkBundle pathForResource:resourceBundleName ofType:nil];
    return [resourceBundlePath stringByAppendingPathComponent:resourceName];
}

/// 获取Framework里bundle中的图片
/// @param class Framework中的class，用来获取Framework路径
/// @param resourceBundleName 资源bundle名，如：PHResource.bundle，需要带后缀
/// @param resourceName 资源名，如：image.jpg，需要带后缀（图片生成方法[UIImage imageNamed:inBundle:compatibleWithTraitCollection:]）
+ (UIImage *)ph_imageWithFrameworkClass:(Class)class resourceBundleName:(NSString *)resourceBundleName resourceName:(NSString *)resourceName {
    if (!class || [NSString ph_isNilOrEmpty:resourceBundleName] || [NSString ph_isNilOrEmpty:resourceName]) {
        return nil;
    }
    NSBundle *frameworkBundle = PH_BUNDLE_FOR_CLASS(class);
    NSString *resourceBundlePath = [frameworkBundle pathForResource:resourceBundleName ofType:nil];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    return PH_IMAGE_NAMED_BUNDLE(resourceName, resourceBundle);
}

@end
