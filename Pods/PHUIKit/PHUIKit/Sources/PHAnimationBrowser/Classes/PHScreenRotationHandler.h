//
//  PHScreenRotationHandler.h
//  图片浏览Demo
//
//  Created by Hu, Yuping on 2019/12/27.
//  Copyright © 2019 江苏云学堂信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PHAnimationImageBrowser;

NS_ASSUME_NONNULL_BEGIN

@interface PHScreenRotationHandler : NSObject

- (instancetype)initWithBrowser:(PHAnimationImageBrowser *)browser;

- (void)startObserveStatusBarOrientation;

- (void)startObserveDeviceOrientation;

- (void)clear;

- (void)configContainerSize:(CGSize)size;

- (CGSize)containerSizeWithOrientation:(UIDeviceOrientation)orientation;

@property (nonatomic, assign, readonly, getter=isRotating) BOOL rotating;

@property (nonatomic, assign, readonly) UIDeviceOrientation currentOrientation;

@property (nonatomic, assign) UIInterfaceOrientationMask supportedOrientations;

@property (nonatomic, assign) NSTimeInterval rotationDuration;

@end

NS_ASSUME_NONNULL_END
