//
//  DragLeftInteractiveTransition.h
//  AwemeDemo
//
//  Created by 朱力 on 2019/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DragLeftInteractiveTransition : UIPercentDrivenInteractiveTransition

/** 是否正在拖动返回 标识是否正在使用转场的交互中 */
@property (nonatomic, assign) BOOL isInteracting;


/**
 设置需要返回的VC
 
 @param viewController 控制器实例
 */
-(void)wireToViewController:(UIViewController *)viewController;


@end

NS_ASSUME_NONNULL_END
