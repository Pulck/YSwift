//
//  DismissScaleAnimation.h
//  AwemeDemo
//
//  Created by 朱力 on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DismissScaleAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect centerFrame;
/** 初始位置 不能为CGRectZero */
@property (nonatomic, assign) CGRect originCellFrame;
/** 结束位置 不能为CGRectZero */
@property (nonatomic, assign) CGRect finalCellFrame;
@property (nonatomic, weak)   UIView *selectCell;

@end

NS_ASSUME_NONNULL_END
