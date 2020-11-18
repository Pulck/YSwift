//
//  PHMaxLinesTextView.h
//  PHUIKit
//
//  Created by dingw on 2019/12/23.
//  Copyright © 2019 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHTextView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 PHTextView，限制最大行数，并返回计算后的高度便于调用方布局
 */
@interface PHMaxLinesTextView : PHTextView

/**
 文字改变时，计算总高，包括文字高度，场景：当输入文字时textView需要同时增加高度，可使用此回调设置textView高度
 */
@property (nonatomic, copy) void(^heightChangedBlock)(CGFloat height, PHMaxLinesTextView *textView);

/**
 设置最小高度，当设置此值后，heightChangedBlock回调的最小高度为minHeight
 */
@property (nonatomic, assign) CGFloat minHeight;

/**
 最大行数
 */
@property (nonatomic, assign) NSUInteger maxLines;

/**
 文字改变处理
 */
- (void)textDidChange;

@end

NS_ASSUME_NONNULL_END
