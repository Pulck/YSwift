//
//  PHCaptureView.m
//  PHCamera
//
//  Created by dingw on 2019/12/11.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//

#import "PHCaptureView.h"

// 视频默认存储地址
#define VIDEO_DEFAULT_OUTPUT_PATH [NSTemporaryDirectory() stringByAppendingString:kVideoOutputName]
// 视频存储名称
static NSString * const kVideoOutputName = @"ph_camera_captured_video.mov";

@interface PHCaptureView () <AVCaptureFileOutputRecordingDelegate>

// 媒体捕获会话，负责设备输入、输出之间的数据传输
@property (nonatomic, strong) AVCaptureSession *session;
// 负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput *cameraInput;
// 照片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
// 视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
// 拍摄预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
// 视频文件存储路径
@property (nonatomic, copy) NSString *videoFileOutputPath;
// 是否已添加过捕捉设备通知
@property (nonatomic, assign) BOOL isAddedCaptureDeviceNote;

@end

@implementation PHCaptureView

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置捕捉预览层大小
    if (self.videoPreviewLayer) {
        self.videoPreviewLayer.frame = self.bounds;
    }
}

#pragma mark --------------- 初始化捕获 ---------------
// 初始化捕捉会话、输入/输出对象、预览对象
- (void)initCapture {
    if (_session) {
        // 已创建会话
        return;
    }
    
    // 1、初始化媒体捕获会话
    [self initSesstion];
    
    // 2、初始化输入设备、输入对象
    if (![self initInput]) {
        return;
    }
    
    // 3、初始化输出对象
    [self initOutput];
    
    // 4、初始化拍摄预览图层
    [self initVideoPreviewLayer];
}

// 初始化媒体捕获会话
- (void)initSesstion {
    if (_session) { return; }
    _session = [[AVCaptureSession alloc] init];
    // 设置分辨率（高质量）
    if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        _session.sessionPreset = AVCaptureSessionPresetHigh;
    }
}

// 初始化输入设备、输入对象
- (BOOL)initInput {
    // 1.1、获取摄像头输入设备
    AVCaptureDevice *cameraDevice = [self getCameraDeviceWithPosition:(AVCaptureDevicePositionBack)];
    if (!cameraDevice) {
        NSLog(@"//////// 获取摄像头失败");
        return NO;
    }
    
    // 1.2、根据视频输入设备初始化设备输入对象，用于获取视频输入数据
    NSError *error = nil;
    if (!_cameraInput) {
        _cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraDevice error:&error];
        if (error) {
            NSLog(@"//////// 获取视频设备输入对象失败，error：%@",error.localizedDescription);
            return NO;
        }
    }
    
    // 1.3、视频设备输入对象添加到会话
    if ([_session canAddInput:_cameraInput]) {
        [_session addInput:_cameraInput];
    }else{
        NSLog(@"//////// 设备输入对象添加到会话失败");
        return NO;
    }
    
    // 2.1、获取音频输入设备
    AVCaptureDevice *audioDevice = [self getAudioDevice];
    if (audioDevice) {
        // 2.2、根据音频输入设备初始化设备输入对象，用于获取音频输入数据
        AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:&error];
        if (error) {
            NSLog(@"//////// 获取音频设备输入对象失败，error：%@",error.localizedDescription);
        }
        
        // 2.3、音频设备输入对象添加到会话
        if (audioInput && [_session canAddInput:audioInput]) {
            [_session addInput:audioInput];
        }
    }
    
    return YES;
}

// 初始化输出对象
- (void)initOutput {
    // 1、初始化照片输出对象
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *stillImageOutputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
        [_stillImageOutput setOutputSettings:stillImageOutputSettings];
    }
    
    // 2、初始化视频输出对象
    if (!_movieFileOutput) {
        _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    }
    
    // 3、设备输出对象添加到会话
    if ([_session canAddOutput:_stillImageOutput]) {
        // 照片
        [_session addOutput:_stillImageOutput];
    }else{
        NSLog(@"//////// 照片输出对象添加到会话失败");
    }
    
    if ([_session canAddOutput:_movieFileOutput]) {
        // 视频
        // 设置防抖
        AVCaptureConnection *connection = [_movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        [_session addOutput:_movieFileOutput];
    }else{
        NSLog(@"//////// 视频输出对象添加到会话失败");
    }
}

// 初始化预览层
- (void)initVideoPreviewLayer {
    if (_videoPreviewLayer) { return; }
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    // 填充方式
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoPreviewLayer.frame = self.bounds;
    [self.layer addSublayer:_videoPreviewLayer];
    self.layer.masksToBounds = YES;
}

// 获取指定的摄像头（AVCaptureDevicePosition）
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == position) {
            return camera;
        }
    }
    return nil;
}

// 获取音频设备
- (AVCaptureDevice *)getAudioDevice {
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    return audioDevice;
}

// 开始捕获
- (void)startCapture {
    if (self.isRunning) {
        // 已开始会话
        return;
    }
    
    if (_session) {
        // 开始会话
        [_session startRunning];
        // 切换方向
        [self changePreviewLayerVideoOrientation];
        return;
    }
    
    // 创建捕捉
    [self initCapture];
    
    // 会话开始运行
    [_session startRunning];
    // 切换方向
    [self changePreviewLayerVideoOrientation];
}

// 停止捕获
- (void)stopCapture {
    if (self.isRunning) {
        [_session stopRunning];
    }
}

#pragma mark --------------- 设置 ---------------
// 是否正在运行会话
- (BOOL)isRunning {
    return self.session.isRunning;
}

// 设置闪光灯（拍照时亮）
- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    AVCaptureDevice *captureDevice = self.cameraInput.device;
    if (captureDevice.flashMode != flashMode && [captureDevice isFlashModeSupported:flashMode]) {
        [self changeDeviceProperty:^(AVCaptureDevice *device) {
            device.flashMode = flashMode;
        }];
    }
    _flashMode = flashMode;
}

// 设置闪光灯（常亮）
- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    AVCaptureDevice *captureDevice = self.cameraInput.device;
    if (captureDevice.torchMode != torchMode && [captureDevice isTorchModeSupported:torchMode]) {
        [self changeDeviceProperty:^(AVCaptureDevice *device) {
            device.torchMode = torchMode;
        }];
    }
    _torchMode = torchMode;
}

// 设置聚焦模式
- (void)setFocusMode:(AVCaptureFocusMode)focusMode {
    AVCaptureDevice *captureDevice = self.cameraInput.device;
    if (captureDevice.focusMode != focusMode && [captureDevice isFocusModeSupported:focusMode]) {
        [self changeDeviceProperty:^(AVCaptureDevice *device) {
            device.focusMode = focusMode;
        }];
    }
    _focusMode = focusMode;
}

// 设置曝光模式
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    AVCaptureDevice *captureDevice = self.cameraInput.device;
    if (captureDevice.exposureMode != exposureMode && [captureDevice isExposureModeSupported:exposureMode]) {
        [self changeDeviceProperty:^(AVCaptureDevice *device) {
            device.exposureMode = exposureMode;
        }];
    }
    _exposureMode = exposureMode;
}

// 设置AVCaptureDevice属性
- (void)changeDeviceProperty:(void(^)(AVCaptureDevice *device))propertyChangeBlock {
    AVCaptureDevice *captureDevice = self.cameraInput.device;
    NSError *error = nil;
    // 设置设备属性时需要上锁，设置完再打开锁
    if ([captureDevice lockForConfiguration:&error]) {
        // 上锁成功，设置属性
        if (propertyChangeBlock) {
            propertyChangeBlock(captureDevice);
        }
        [captureDevice unlockForConfiguration];
    }else{
        // 上锁失败
        NSLog(@"//////// 设置设备属性失败，error：%@",error.localizedDescription);
    }
}

// 切换摄像头
- (void)exchangeCamera {
    AVCaptureDevicePosition currentPosition = self.cameraInput.device.position;
    // 获取新的摄像头
    AVCaptureDevice *newCamera = nil;
    if (currentPosition == AVCaptureDevicePositionBack) {
        newCamera = [self getCameraDeviceWithPosition:(AVCaptureDevicePositionFront)];
    }else{
        newCamera = [self getCameraDeviceWithPosition:(AVCaptureDevicePositionBack)];
    }
    
    // 创建新输入对象
    NSError *error = nil;
    AVCaptureDeviceInput *newCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:&error];
    if (error) {
        NSLog(@"//////// 创建新摄像头输入对象失败");
        return;
    }
    
    // 改变会话配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    [self.session removeInput:self.cameraInput];
    if ([self.session canAddInput:newCameraInput]) {
        [self.session addInput:newCameraInput];
        self.cameraInput = newCameraInput;
    }
    [self.session commitConfiguration];
}

// 聚焦
- (void)focusAtPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *device) {
        // 自动聚焦
        if ([device isFocusModeSupported:(AVCaptureFocusModeAutoFocus)]) {
            device.focusMode = AVCaptureFocusModeAutoFocus;
        }
        // 聚焦点
        if ([device isFocusPointOfInterestSupported]) {
            device.focusPointOfInterest = point;
        }
        
        // 自动曝光
        if ([device isExposureModeSupported:(AVCaptureExposureModeAutoExpose)]) {
            device.exposureMode = AVCaptureExposureModeAutoExpose;
        }
        // 曝光点
        if ([device isExposurePointOfInterestSupported]) {
            device.exposurePointOfInterest = point;
        }
    }];
}

#pragma mark --------------- 图片 ---------------
// 获取图片
- (void)getImageCompletion:(void(^)(NSData *imageData, PHCaptureView *captureView, NSError *error))completion {
    AVCaptureConnection *captureConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    // 修改图片方向
    if (captureConnection.isVideoOrientationSupported) {
        captureConnection.videoOrientation = [self getVideoOrientation];
    }
    
    // 拍照
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        NSData *imageData = nil;
        if (imageDataSampleBuffer) {
            imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        }
        if (completion) {
            completion(imageData,self,error);
        }
    }];
}

#pragma mark --------------- 视频 ---------------
// 开始视频录制
- (void)startRecordVideo {
    if (!self.movieFileOutput || !self.isRunning || self.movieFileOutput.isRecording) {
        // 不存在视频输出对象或正在录制
        NSLog(@"//////// 不存在视频输出对象/捕获会话没有运行/正在录制");
        return;
    }
    
    // 修改视频方向
    AVCaptureConnection *captureConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if (captureConnection.isVideoOrientationSupported) {
        captureConnection.videoOrientation = [self getVideoOrientation];
    }
    
    // 视频存储地址
    if (self.videoFileOutputPath.length == 0) {
        self.videoFileOutputPath = VIDEO_DEFAULT_OUTPUT_PATH;
    }
    NSURL *fileUrl = [NSURL fileURLWithPath:self.videoFileOutputPath];
    
    // 开始录制
    [self.movieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
}

// 停止视频录制
- (void)stopRecordVideo {
    if (self.movieFileOutput.isRecording) {
        [self.movieFileOutput stopRecording];
    }
}

// 开始录制代理
- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    NSLog(@"//////// 开始录制视频");
    if (self.startRecordVideoBlock) {
        self.startRecordVideoBlock(output, fileURL, connections);
    }
}

// 结束录制代理
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"//////// 结束录制视频");
    if (self.finishRecordVideoBlock) {
        self.finishRecordVideoBlock(output, outputFileURL, connections, error);
    }
}

#pragma mark --------------- 视频/图片方向 ---------------
// 切换视频预览层方向
- (void)changePreviewLayerVideoOrientation {
    if (!self.isRunning) {
        return;
    }
    
    if (self.videoPreviewLayer.connection.isVideoOrientationSupported) {
        self.videoPreviewLayer.connection.videoOrientation = [self getVideoOrientation];
    }
}

// 获取视频方向
- (AVCaptureVideoOrientation)getVideoOrientation {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIDeviceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIDeviceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIDeviceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeLeft;
        default:
            return AVCaptureVideoOrientationPortrait;
    }
}

@end
