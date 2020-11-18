//
//  PHDialogBaseView.h
//
//  Created by zhuli on 2018/4/27.
//  弹出框 显示隐藏 动画

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PHDialogBaseView : UIView

/**
 视图显示动画

 @param completion 动画结束回调
 */
- (void)apearWithAnimationCompletion:(void (^ __nullable)(BOOL finished))completion;

/**
 视图隐藏动画

 @param completion 动画结束回调
 */
- (void)dissApearWithAnimationCompletion:(void (^ __nullable)(BOOL finished))completion;

- (void)apearWithBottomAnimationCompletion:(void (^ __nullable)(BOOL finished))completion;

- (void)dissApearWithBottomAnimationCompletion:(void (^ __nullable)(BOOL finished))completion;
@end
