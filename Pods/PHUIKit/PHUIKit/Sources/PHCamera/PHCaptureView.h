//
//  PHCaptureView.h
//  PHCamera
//
//  Created by dingw on 2019/12/11.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// 开始录制回调
typedef void(^StartRecordVideoBlock)(AVCaptureFileOutput *output,NSURL *fileURL,NSArray<AVCaptureConnection *> *connections);
// 完成录制回调
typedef void(^FinishRecordVideoBlock)(AVCaptureFileOutput *output,NSURL *fileURL,NSArray<AVCaptureConnection *> *connections,NSError *error);

/**
 捕捉视图，包括拍照、录视频功能
 */
@interface PHCaptureView : UIView

/**
 是否正在运行
 */
@property (nonatomic, assign, readonly) BOOL isRunning;

/**
 设置闪光灯模式（拍照时亮）
 */
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

/**
 设置闪光灯模式（常亮）
 */
@property (nonatomic, assign) AVCaptureTorchMode torchMode;

/**
 设置聚焦模式
 */
@property (nonatomic, assign) AVCaptureFocusMode focusMode;

/**
 设置曝光模式
 */
@property (nonatomic, assign) AVCaptureExposureMode exposureMode;

/**
 开始录制回调
 */
@property (nonatomic, copy) StartRecordVideoBlock startRecordVideoBlock;

/**
 完成录制回调
 */
@property (nonatomic, copy) FinishRecordVideoBlock finishRecordVideoBlock;

/**
 开始捕获
 */
- (void)startCapture;

/**
 停止捕获
 */
- (void)stopCapture;

/**
 切换摄像头
 */
- (void)exchangeCamera;

/**
 获取图片
 
 @param completion 完成回调，imageData：图片数据，captureView：返回当前视图，error：错误
 */
- (void)getImageCompletion:(void(^)(NSData *imageData, PHCaptureView *captureView, NSError *error))completion;

/**
 开始视频录制
 */
- (void)startRecordVideo;

/**
 停止视频录制
 */
- (void)stopRecordVideo;

/**
 切换视频预览层方向
 */
- (void)changePreviewLayerVideoOrientation;

@end
