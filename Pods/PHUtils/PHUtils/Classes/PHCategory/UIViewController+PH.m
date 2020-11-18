//
//  UIViewController+PH.m
//  FBSnapshotTestCase
//
//  Created by 秦平平 on 2020/3/10.
//

#import "UIViewController+PH.h"

@implementation UIViewController (PH)

- (UIViewController *)ph_getCurrentViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }
    else{
        nextResponder = appRootVC;
    }
    
    //1、tabBarController
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UIViewController *vc = tabbar.viewControllers[tabbar.selectedIndex];
        if ([vc isKindOfClass:[UINavigationController class]]) { // 如果是Navigation则取navigation中的最后一个vc
            UINavigationController * nav = (UINavigationController *)vc;
            result = nav.childViewControllers.lastObject;
        } else { // 如果不是Navigaytion，则直接取当前的VC
            result = vc;
        }
        
        if (!result) { // 添加此判断，当Navgation中的数组为空的时候，返回当前的Navigation
            result = nextResponder;
        }
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        //2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
        
        if (!result) { // 添加此判断，当Navgation中的数组为空的时候，返回当前的Navigation
            result = nextResponder;
        }
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}

+ (UIViewController *)ph_getCurrentViewController {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }
    else{
        nextResponder = appRootVC;
    }
    
    //1、tabBarController
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UIViewController *vc = tabbar.viewControllers[tabbar.selectedIndex];
        if ([vc isKindOfClass:[UINavigationController class]]) { // 如果是Navigation则取navigation中的最后一个vc
            UINavigationController * nav = (UINavigationController *)vc;
            result = nav.childViewControllers.lastObject;
        } else { // 如果不是Navigaytion，则直接取当前的VC
            result = vc;
        }
        
        if (!result) { // 添加此判断，当Navgation中的数组为空的时候，返回当前的Navigation
            result = nextResponder;
        }
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        //2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
        
        if (!result) { // 添加此判断，当Navgation中的数组为空的时候，返回当前的Navigation
            result = nextResponder;
        }
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}

@end
