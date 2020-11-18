//
//  PHToolViewHandler.h
//  AFNetworking
//
//  Created by Hu, Yuping on 2020/1/4.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBIBDataProtocol.h>
#import <YBImageBrowser/YBIBOrientationReceiveProtocol.h>
#import <YBImageBrowser/YBIBOperateBrowserProtocol.h>

@class YBIBSheetView;
@class PHBottomView;

NS_ASSUME_NONNULL_BEGIN

@protocol PHToolViewHandler <YBIBGetBaseInfoProtocol, YBIBOperateBrowserProtocol, YBIBOrientationReceiveProtocol>

@required

/**
 容器视图准备好了，可进行子视图的添加和布局
 */
- (void)yb_containerViewIsReadied;

/**
 隐藏视图
 
 @param hide 是否隐藏
 */
- (void)yb_hide:(BOOL)hide;

@optional

/// 当前数据
@property (nonatomic, copy) id<YBIBDataProtocol>(^yb_currentData)(void);

/**
 页码变化了
 */
- (void)yb_pageChanged;

/**
 偏移量变化了
 
 @param offsetX 当前偏移量
 */
- (void)yb_offsetXChanged:(CGFloat)offsetX;

/**
 响应长按手势
 */
- (void)yb_respondsToLongPress;

@end

@interface PHToolViewHandler : NSObject <PHToolViewHandler>

/// 弹出表单视图
@property (nonatomic, strong) YBIBSheetView *sheetView;

/// 顶部显示页码视图
@property (nonatomic, strong) PHBottomView *bottomView;

@end

NS_ASSUME_NONNULL_END
