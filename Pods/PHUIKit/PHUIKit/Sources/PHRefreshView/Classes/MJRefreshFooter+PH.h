//
//  MJRefreshFooter+PH.h
//  Masonry
//
//  Created by Hu, Yuping on 2019/11/11.
//  备注：MJRefreshFooter+PH 主要是给MJRefreshFooter 添加方法;继承无法给父类添加方法。
//  用PHRefreshSDKDXFooter 继承的原因：MJ方法都不需要改变，如果用类别需要重命名所有方法，否则原会被覆盖。

#import "MJRefresh/MJRefreshFooter.h"


NS_ASSUME_NONNULL_BEGIN

@interface MJRefreshFooter (PH)

/**
 刷新失败（显示：加载失败，点我重试吧）
 */
- (void)ph_refreshFailture;

@end

NS_ASSUME_NONNULL_END
