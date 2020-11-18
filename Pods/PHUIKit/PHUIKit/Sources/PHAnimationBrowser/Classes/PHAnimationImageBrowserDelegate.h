//
//  PHAnimationImageBrowserDelegate.h
//  图片浏览Demo
//
//  Created by Hu, Yuping on 2019/12/27.
//  Copyright © 2019 江苏云学堂信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBIBDataProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAnimationImageBrowser;

@protocol PHAnimationImageBrowserDelegate <NSObject>

@optional

/**
 页码变化
 
 @param imageBrowser 图片浏览器
 @param page 当前页码
 @param data 数据
 */
- (void)yb_imageBrowser:(PHAnimationImageBrowser *)imageBrowser pageChanged:(NSInteger)page data:(id<YBIBDataProtocol>)data;

/**
 响应长按手势（若实现该方法将阻止其它地方捕获到长按事件）
 
 @param imageBrowser 图片浏览器
 @param data 数据
 */
- (void)yb_imageBrowser:(PHAnimationImageBrowser *)imageBrowser respondsToLongPressWithData:(id<YBIBDataProtocol>)data;

/**
 开始转场
 
 @param imageBrowser 图片浏览器
 @param isShow YES 表示入场，NO 表示出场
 */
- (void)yb_imageBrowser:(PHAnimationImageBrowser *)imageBrowser beginTransitioningWithIsShow:(BOOL)isShow;

/**
 结束转场
 
 @param imageBrowser 图片浏览器
 @param isShow YES 表示入场，NO 表示出场
 */
- (void)yb_imageBrowser:(PHAnimationImageBrowser *)imageBrowser endTransitioningWithIsShow:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
