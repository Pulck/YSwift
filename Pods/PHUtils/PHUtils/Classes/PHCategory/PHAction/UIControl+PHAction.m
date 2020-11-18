//
//  UIControl+PHAction.m
//  PHActionControl
//
//  Created by dingw on 2019/12/6.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//

#import "UIControl+PHAction.h"
#import "NSObject+PHAction.h"
#import <objc/runtime.h>

@interface UIControl ()

/**
 事件响应回调
 */
@property (nonatomic, copy) void(^ph_actionBlock)(id sender);

@end

@implementation UIControl (PHAction)

- (void)ph_addActionBlock:(void(^)(id sender))actionBlock {
    [self ph_addControlEvents:(UIControlEventTouchUpInside) actionBlock:actionBlock];
}

- (void)ph_addControlEvents:(UIControlEvents)controlEvents actionBlock:(void(^)(id sender))actionBlock {
    if (actionBlock) {
        self.ph_actionBlock = actionBlock;
        [self addTarget:self action:@selector(ph_executeAction:) forControlEvents:controlEvents];
    }
}

- (void)ph_executeAction:(id)sender {
    if (self.ph_actionBlock) {
        self.ph_actionBlock(sender);
    }
}

- (void)setPh_actionBlock:(void (^)(id))ph_actionBlock {
    objc_setAssociatedObject(self, @selector(ph_actionBlock), ph_actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id))ph_actionBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)ph_addExecuteFirstTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock {
    [self ph_addControlEvents:(UIControlEventTouchUpInside) executeFirstTimeInterval:timeInterval actionBlock:actionBlock];
}

- (void)ph_addControlEvents:(UIControlEvents)controlEvents executeFirstTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock {
    [self ph_addControlEvents:controlEvents actionBlock:^(id  _Nonnull sender) {
        [self ph_executeFirstWithTimeInterval:timeInterval actionBlock:^{
            if (actionBlock) {
                actionBlock(sender);
            }
        }];
    }];
}

- (void)ph_addExecuteLastTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock {
    [self ph_addControlEvents:(UIControlEventTouchUpInside) executeLastTimeInterval:timeInterval actionBlock:actionBlock];
}

- (void)ph_addControlEvents:(UIControlEvents)controlEvents executeLastTimeInterval:(NSTimeInterval)timeInterval actionBlock:(void(^)(id sender))actionBlock {
    [self ph_addControlEvents:controlEvents actionBlock:^(id  _Nonnull sender) {
        [self ph_executeLastWithTimeInterval:timeInterval actionBlock:^{
            if (actionBlock) {
                actionBlock(sender);
            }
        }];
    }];
}

- (void)ph_addExecuteLastAfterDelay:(NSTimeInterval)delay actionBlock:(void(^)(id sender))actionBlock {
    [self ph_addControlEvents:(UIControlEventTouchUpInside) executeLastAfterDelay:delay actionBlock:actionBlock];
}

- (void)ph_addControlEvents:(UIControlEvents)controlEvents executeLastAfterDelay:(NSTimeInterval)delay actionBlock:(void(^)(id sender))actionBlock {
    [self ph_addControlEvents:controlEvents actionBlock:^(id  _Nonnull sender) {
        [self ph_executeLastAfterDelay:delay actionBlock:^{
            if (actionBlock) {
                actionBlock(sender);
            }
        }];
    }];
}

@end
