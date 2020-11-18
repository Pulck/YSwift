//
//  PHTabBarController.m
//  PHUIKit
//
//  Created by 耿葱 on 2020/1/11.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHTabBarController.h"
#import <PHUtils/PHUtils.h>

@interface PHTabBarController ()

@end

@implementation PHTabBarController

- (instancetype)initWithControllers:(NSArray *)controllers
                             titles:(NSArray *)titles
                       normalImages:(NSArray *)normalImages
                     selectedImages:(NSArray *)selectedImages
                    unselectedColor:(NSString *)unselectedColor
                      selectedColor:(NSString *)selectedColor {
    if ([self init] && controllers.count == titles.count) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:controllers.count];
        for (NSInteger i = 0; i < controllers.count; i++) {
            if (i<5) {
                id normalImage = @"";
                if (i < normalImages.count) {
                    normalImage = normalImages[i];
                }
                id selectedImage = @"";
                if (i < selectedImages.count) {
                    selectedImage = selectedImages[i];
                }
                [array addObject:[self setupChildViewController:controllers[i] title:titles[i] normalImage:normalImage selectedImage:selectedImage unselectedColor:unselectedColor selectedColor:selectedColor]];
            }
        }
        self.tabBar.translucent = NO;
        self.viewControllers = [NSArray arrayWithArray:array];
    }
    return self;
}

- (UIViewController *)setupChildViewController:(UIViewController *)childVc
                                         title:(NSString *)title
                                   normalImage:(id)normalImage
                                 selectedImage:(id)selectedImage
                               unselectedColor:(NSString *)unselectedColor
                                 selectedColor:(NSString *)selectedColor{
    if ([childVc isKindOfClass:[UIViewController class]]) {
        if ([NSString ph_notNilAndNotEmpty:title]) {
            childVc.title = title;
        }
        if ([normalImage isKindOfClass:[UIImage class]]) {
            childVc.tabBarItem.image = [[UIImage ph_originImage:normalImage scaleToSize:CGSizeMake(25.0, 25.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            ;
        }else if ([NSString ph_notNilAndNotEmpty:normalImage] && [(NSString *)normalImage containsString:@"http"]) {
            childVc.tabBarItem.image = [[UIImage ph_originImage:[self imageWithLocalUrl:normalImage] scaleToSize:CGSizeMake(25.0, 25.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else if ([NSString ph_notNilAndNotEmpty:normalImage]) {
            childVc.tabBarItem.image = [[UIImage ph_originImage:[UIImage imageNamed:normalImage] scaleToSize:CGSizeMake(25.0, 25.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if ([selectedImage isKindOfClass:[UIImage class]]) {
            childVc.tabBarItem.selectedImage = [[UIImage ph_originImage:selectedImage scaleToSize:CGSizeMake(25.0, 25.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else if ([NSString ph_notNilAndNotEmpty:selectedImage] && [(NSString *)selectedImage containsString:@"http"]) {
            childVc.tabBarItem.selectedImage = [[UIImage ph_originImage:[self imageWithLocalUrl:selectedImage] scaleToSize:CGSizeMake(25.0, 25.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else if ([NSString ph_notNilAndNotEmpty:selectedImage]) {
            childVc.tabBarItem.selectedImage = [[UIImage ph_originImage:[UIImage imageNamed:selectedImage] scaleToSize:CGSizeMake(25.0, 25.0)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if ([NSString ph_isNilOrEmpty:unselectedColor]) {
            unselectedColor = @"#757575";
        }
        if ([NSString ph_isNilOrEmpty:selectedColor]) {
            selectedColor = @"#1D2F4F";
        }
        [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor ph_colorWithHexString:unselectedColor], NSForegroundColorAttributeName, nil]  forState:UIControlStateNormal];
        if (@available(iOS 10.0, *)) {
            self.tabBar.unselectedItemTintColor = [UIColor ph_colorWithHexString:unselectedColor];
        }
        [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor ph_colorWithHexString:selectedColor], NSForegroundColorAttributeName, nil]  forState:UIControlStateHighlighted];
        self.tabBar.tintColor = [UIColor ph_colorWithHexString:selectedColor];
    }
    return childVc;
}

- (UIImage *)imageWithLocalUrl:(NSString *)url{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:url]];
    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    return image;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.viewDidAppearBlock) {
        self.viewDidAppearBlock();
    }
}

@end
