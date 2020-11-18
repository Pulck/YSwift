//
//  PHRefreshSDKDXFooter.h
//  Masonry
//
//  Created by Hu, Yuping on 2019/11/11.
//  上拉加载，继承于MJRefresh，支持样式『加载失败』『没有更多数据』

#import "MJRefresh/MJRefreshBackFooter.h"
#import "PHUIKit/MJRefreshFooter+PH.h"

NS_ASSUME_NONNULL_BEGIN

@interface PHRefreshSDKDXFooter : MJRefreshBackFooter

/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

@end

NS_ASSUME_NONNULL_END
