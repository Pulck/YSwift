//
//  PresentScaleAnimation.h
//  AwemeDemo
//
//  Created by 朱力 on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PresentScaleAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/** cell在父视图的frame 不能为CGRectZero, 这个坐标 需要的是cell转换父视图完成之后的frame */
@property (nonatomic, assign) CGRect cellConvertFrame;

@end

NS_ASSUME_NONNULL_END
