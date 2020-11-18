//
//  PHMarqueeView.h
//  PHUIKit
//
//  Created by 秦平平 on 2020/2/3.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHMarqueeView;

@protocol PHMarqueeViewDelegate <NSObject>

@optional

- (void)drawMarqueeView:(PHMarqueeView *)drawMarqueeView animationDidStopFinished:(BOOL)finished;

@end

@interface PHMarqueeView : UIView

@property (nonatomic,strong) UILabel *marqueeLabel;

/** 协议 */
@property (nonatomic, weak) id <PHMarqueeViewDelegate> delegate;

/** 文本 */
@property (nonatomic, copy) NSString *marqueeText;

/** 字体 */
@property (nonatomic, assign) CGFloat fontSize;

/** 字体颜色 */
@property (nonatomic, strong) UIColor *textColor;

/**
 阴影颜色 （YES ; 显示 ；NO ；隐藏）
 */
@property (nonatomic, assign) BOOL showShadow;

/** 速度 */
@property (nonatomic) CGFloat speed;

/** 容器 */
- (void)addContentView;

/** 开始动画 */
- (void)startAnimation;

/** 停止动画 */
- (void)stopAnimation;

/** 暂停动画 */
- (void)pauseAnimation;

/** 恢复动画 */
- (void)resumeAnimation;



@end

NS_ASSUME_NONNULL_END
