//
//  PHAnimationImageBrowserDataSource.h
//  图片浏览Demo
//
//  Created by Hu, Yuping on 2019/12/27.
//  Copyright © 2019 江苏云学堂信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBIBDataProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAnimationImageBrowser;

@protocol PHAnimationImageBrowserDataSource <NSObject>

@required

/**
 返回数据源数量
 
 @param imageBrowser 图片浏览器
 @return 数量
 */
- (NSInteger)yb_numberOfCellsInImageBrowser:(PHAnimationImageBrowser *)imageBrowser;

/**
 返回当前下标对应的数据
 
 @param imageBrowser 图片浏览器
 @param index 当前下标
 @return 数据
 */
- (id<YBIBDataProtocol>)yb_imageBrowser:(PHAnimationImageBrowser *)imageBrowser dataForCellAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
