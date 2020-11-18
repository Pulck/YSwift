//
//  NSObject+PHAction.h
//  PHActionControl
//
//  Created by dingw on 2019/12/5.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 事件触发响应分类
 事件多次触发后，根据不同条件做拦截处理
 */
@interface NSObject (PHAction)

/**
 事件多次触发拦截，在一定时间内只执行第一次事件响应

 @param timeInterval 执行事件响应的时间间隔（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_executeFirstWithTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(void))actionBlock;

/**
 事件多次触发拦截，在一定时间内只执行最后一次事件响应

 @param timeInterval 执行事件响应的时间间隔（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_executeLastWithTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(void))actionBlock;

/**
 事件多次触发拦截
 1、事件一直触发时，不会执行响应
 2、事件停止触发后，延迟一段时间后执行响应

 @param delay 延迟时间（单位s）
 @param actionBlock 需要执行的事件响应
 */
- (void)ph_executeLastAfterDelay:(NSTimeInterval)delay actionBlock:(void(^)(void))actionBlock;

@end

NS_ASSUME_NONNULL_END
