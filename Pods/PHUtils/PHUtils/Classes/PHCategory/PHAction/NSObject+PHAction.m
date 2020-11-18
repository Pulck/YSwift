//
//  NSObject+PHAction.m
//  PHActionControl
//
//  Created by dingw on 2019/12/5.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//

#import "NSObject+PHAction.h"
#import <objc/runtime.h>

@interface NSObject ()

/**
 是否正在执行第一次事件响应流程，当响应结束才会开始下一次事件响应流程
 */
@property (nonatomic, assign) BOOL ph_isExecutingFirst_NSObject;

/**
 第一次事件响应回调
 */
@property (nonatomic, copy) void(^ph_firstActionBlock_NSObject)(void);

/**
 是否正在执行最后一次间隔响应流程，当响应结束才会开始下一次事件响应流程
 */
@property (nonatomic, assign) BOOL ph_isExecutingLastTimeInterval_NSObject;

/**
 最后一次间隔响应回调
 */
@property (nonatomic, copy) void(^ph_lastTimeIntervalActionBlock_NSObject)(void);
/**
 最后一次延迟响应回调
 */
@property (nonatomic, copy) void(^ph_lastAfterDelayActionBlock_NSObject)(void);

@end

@implementation NSObject (PHAction)

- (void)ph_executeFirstWithTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(void))actionBlock {
    if (actionBlock) {
        if (timeInterval > 0) {
            self.ph_firstActionBlock_NSObject = actionBlock;
            if (!self.ph_isExecutingFirst_NSObject) {
                // 设置拦截
                self.ph_isExecutingFirst_NSObject = YES;
                [self performSelector:@selector(ph_executeFirstAction) withObject:nil];
                // 放弃拦截
                [self performSelector:@selector(resetPh_isExecutingFirst_NSObject) withObject:nil afterDelay:timeInterval];
            }
        }else{
            actionBlock();
        }
    }
}

// 重置是否正在执行第一次事件响应流程为 NO
- (void)resetPh_isExecutingFirst_NSObject {
    self.ph_isExecutingFirst_NSObject = NO;
}

- (void)ph_executeFirstAction {
    if (self.ph_firstActionBlock_NSObject) {
        self.ph_firstActionBlock_NSObject();
    }
}

- (void)setPh_isExecutingFirst_NSObject:(BOOL)ph_isExecutingFirst_NSObject {
    objc_setAssociatedObject(self, @selector(ph_isExecutingFirst_NSObject), @(ph_isExecutingFirst_NSObject), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ph_isExecutingFirst_NSObject {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPh_firstActionBlock_NSObject:(void (^)(void))ph_firstActionBlock_NSObject {
    objc_setAssociatedObject(self, @selector(ph_firstActionBlock_NSObject), ph_firstActionBlock_NSObject, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))ph_firstActionBlock_NSObject {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)ph_executeLastWithTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(void))actionBlock {
    if (actionBlock) {
        if (timeInterval > 0) {
            self.ph_lastTimeIntervalActionBlock_NSObject = actionBlock;
            if (!self.ph_isExecutingLastTimeInterval_NSObject) {
                // 设置拦截
                self.ph_isExecutingLastTimeInterval_NSObject = YES;
                [self performSelector:@selector(ph_executeLastTimeIntervalAction) withObject:nil afterDelay:timeInterval];
            }
        }else{
            actionBlock();
        }
    }
}

- (void)ph_executeLastTimeIntervalAction {
    // 放弃拦截
    self.ph_isExecutingLastTimeInterval_NSObject = NO;
    if (self.ph_lastTimeIntervalActionBlock_NSObject) {
        self.ph_lastTimeIntervalActionBlock_NSObject();
    }
}

- (void)setPh_isExecutingLastTimeInterval_NSObject:(BOOL)ph_isExecutingLastTimeInterval_NSObject {
    objc_setAssociatedObject(self, @selector(ph_isExecutingLastTimeInterval_NSObject), @(ph_isExecutingLastTimeInterval_NSObject), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ph_isExecutingLastTimeInterval_NSObject {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPh_lastTimeIntervalActionBlock_NSObject:(void (^)(void))ph_lastTimeIntervalActionBlock_NSObject {
    objc_setAssociatedObject(self, @selector(ph_lastTimeIntervalActionBlock_NSObject), ph_lastTimeIntervalActionBlock_NSObject, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))ph_lastTimeIntervalActionBlock_NSObject {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)ph_executeLastAfterDelay:(NSTimeInterval)delay actionBlock:(void(^)(void))actionBlock {
    if (actionBlock) {
        if (delay > 0) {
            self.ph_lastAfterDelayActionBlock_NSObject = actionBlock;
            SEL selector = @selector(ph_executeLastAfterDelayAction);
            // 结束上一次响应
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
            // 开始新的响应
            [self performSelector:selector withObject:nil afterDelay:delay];
        }else{
            actionBlock();
        }
    }
}

- (void)ph_executeLastAfterDelayAction {
    if (self.ph_lastAfterDelayActionBlock_NSObject) {
        self.ph_lastAfterDelayActionBlock_NSObject();
    }
}

- (void)setPh_lastAfterDelayActionBlock_NSObject:(void (^)(void))ph_lastAfterDelayActionBlock_NSObject {
    objc_setAssociatedObject(self, @selector(ph_lastAfterDelayActionBlock_NSObject), ph_lastAfterDelayActionBlock_NSObject, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))ph_lastAfterDelayActionBlock_NSObject {
    return objc_getAssociatedObject(self, _cmd);
}

@end
