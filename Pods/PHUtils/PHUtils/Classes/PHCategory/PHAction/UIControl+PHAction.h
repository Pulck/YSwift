//
//  UIControl+PHAction.h
//  PHActionControl
//
//  Created by dingw on 2019/12/6.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 事件触发响应分类
 1、使用block实现事件触发
 2、事件多次触发后，根据不同条件做拦截处理
 */
@interface UIControl (PHAction)

/**
 使用block实现事件触发，UIControlEvents：UIControlEventTouchUpInside

 @param actionBlock 事件触发实现
 */
- (void)ph_addActionBlock:(void(^)(id sender))actionBlock;

/**
 使用block实现事件触发

 @param controlEvents 事件触发的类型
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_addControlEvents:(UIControlEvents)controlEvents actionBlock:(void(^)(id sender))actionBlock;

/**
 一定时间内只执行第一次事件触发响应，UIControlEvents：UIControlEventTouchUpInside

 @param timeInterval 执行事件响应的时间间隔（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_addExecuteFirstTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock;

/**
 一定时间内只执行第一次事件触发响应

 @param controlEvents 事件触发的类型
 @param timeInterval 执行事件响应的时间间隔（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_addControlEvents:(UIControlEvents)controlEvents executeFirstTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock;

/**
 一定时间内只执行最后一次事件触发响应，UIControlEvents：UIControlEventTouchUpInside

 @param timeInterval 执行事件响应的时间间隔（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_addExecuteLastTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock;

/**
 一定时间内只执行最后一次事件触发响应

 @param controlEvents 事件触发的类型
 @param timeInterval 执行事件响应的时间间隔（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_addControlEvents:(UIControlEvents)controlEvents executeLastTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock;

/**
 延迟一段时间后执行最后一次事件触发响应，UIControlEvents：UIControlEventTouchUpInside
 1、事件一直触发时，不会执行响应
 2、事件停止触发后，延迟一段时间后执行响应

 @param delay 延迟时间（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_addExecuteLastAfterDelay:(NSTimeInterval)delay actionBlock:(void(^)(id sender))actionBlock;

/**
 延迟一段时间后执行最后一次事件触发响应
 1、事件一直触发时，不会执行响应
 2、事件停止触发后，延迟一段时间后执行响应

 @param controlEvents 事件触发的类型
 @param delay 延迟时间（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_addControlEvents:(UIControlEvents)controlEvents executeLastAfterDelay:(NSTimeInterval)delay actionBlock:(void(^)(id sender))actionBlock;

@end

NS_ASSUME_NONNULL_END
