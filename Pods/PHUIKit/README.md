<p align="center">
<img src="https://gitlab.yunxuetang.com.cn/ios_sdk/YXTCourseSDK/raw/master/Picture/logo.png" alt="YXTToolKitsSDK" title="YXTToolKitsSDK" width="408"/>
</p>

<p align="center">
<img src="https://img.shields.io/badge/platform-iOS-yellow.svg">
<img src="https://img.shields.io/badge/language-ObjectiveC-red.svg">
<img src="https://img.shields.io/badge/support-iOS%208%2B-blue.svg">
<img src="https://img.shields.io/badge/license-MIT%20License-brightgreen.svg">
<img src="https://img.shields.io/cocoapods/v/DaisyNet.svg?style=flat">
</p>

**功能思维脑图：**
<p align="center">
<img src="/Resources/mindmap.png" height = "613" alt="思维脑图" align=center />
</p>

### 如有问题，欢迎提出，不足之处，欢迎纠正，欢迎star ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

<p align="center">
**效果图展示：**
</p>
<p align="center">
<img src="/Resources/download.gif" width = "300" height = "600" alt="图片名称" align=center />
<img src="/Resources/button.gif" width = "300" height = "600" alt="button按钮动画" align=center />
<img src="/Resources/star.gif" width = "300" height = "600" alt="star动画" align=center />
<img src="/Resources/actionsheet.gif" width = "300" height = "600" alt="actionsheet弹框" align=center />
<img src="/Resources/dialog.gif" width = "300" height = "600" alt="dialog弹框" align=center />
<img src="/Resources/Toast.gif" width = "300" height = "600" alt="Toast" align=center />
<img src="/Resources/cell.gif" width = "300" height = "600" alt="cell" align=center />
<img src="/Resources/refresh.gif" width = "300" height = "600" alt="下拉刷新和上拉加载" align=center />
<img src="/Resources/prgressbar.gif" width = "300" height = "600" alt="圆形进度条和水平进度条" align=center />
<img src="/Resources/reddot.gif" width = "300" height = "600" alt="小红点" align=center />
<img src="/Resources/tag.gif" width = "300" height = "600" alt="标签" align=center />
<img src="/Resources/photobrowser.gif" width = "300" height = "600" alt="图片浏览器" align=center />
<img src="/Resources/lottie.gif" width = "300" height = "600" alt="Lottie换肤" align=center />
</p>


**UI组件常规功能流程图：**

![image](/Resources/flowchart.png)

## 资源占用描述

| SDK类型        |静态库大小         |二进制大小 |二进制增量   | __TEXT大小 |__TEXT增量|
| :------------- |:-------------| :-----|:-----|:-----|:-----|
| UI组件  | 无静态库 |  54M  |  0M  | 54M | 0M |

资源占用：

| 资源名称       | 资源描述           |资源大小  |资源大小增量  |
| :------------- |:-------------| :-----|:-----|
|SDK资源   | 图片和文件 |3.5MB |0MB |
|Zoom SDK   | 静态库 |127.9MB | |

## 兼容性

| 类别        | 兼容范围  |
| :------------- |:-------------|
| 系统    | 支持iOS 8.0及以上系统 |
| 架构    | armv7/v7s/64虚拟机运行 |
| 网络    | 支持移动网络、WIFI等网络环境 |
| 开发环境    | Xcode9.0 |

## 使用
* 配置API环境
```objectivec
[[YXTMeetingSDK sharedSDK] initSDKWithSource:@"your source"
                                  sourceType:@"your sourceType" 
                                   h5BaseUrl:@"your h5BaseUrl" 
                                  apiBaseUrl:@"your apiBaseUrl" 
                           meetingApiBaseURL:@"your meetingApiBaseURL" 
                        meetingPayApiBaseURL:@"your meetingPayApiBaseURL" 
                               zoomSDKDomain:@"your zoomSDKDomain"];
```

* 配置用户信息
```objectivec
[[YXTMeetingSDK sharedSDK] enableSDKPlatform:YXTPlatformTypeLeCaiVIP
                              apiEnvironment:YXTAPIEnvironmentProduction
                                     orgCode:nil IMCard:^(id param) {
                                        //do something
                               } tokenInvild:^(id param) {
                                        //do something
                                } buyTrigger:^(id param) {
                                        //do something
                               } unbindPhone:^{
                                        //do something
                                             }];
```
## PHUIKit
PHUIKit 是一组功能丰富的 iOS UI组件。

为了尽量复用代码，这个项目中的某些组件之间有比较强的依赖关系。为了方便其他开发者使用，我从中拆分出以下独立组件：

* 下拉列表 — 功能强大的 iOS 下拉列表UI组合。
* ButtonSegment — 简洁美观的 iOS ButtonSegment控件。
* Tab — 功能强大的 iOS Tab控件。
* 对话框 — 简洁美观 iOS 对话框。
* Button — 简洁美观的 iOS 自定义按钮。
* 导航栏 — iOS 自定义导航栏。
* Toast — iOS Toast。
* 列表 — iOS Cell。

## Installation
```
CocoaPods

1.在 Podfile 中添加 pod 'PHUIKit'。
2.执行 pod install 或 pod update。
3.导入 <PHUIKit/PHUIKit.h>。

Manually

1.下载 PHUIKit 文件夹内的所有内容。
2.将 PHUIKit 内的源文件添加(拖放)到你的工程。
3.导入 PHUIKit.h。
```

## Dependency
```
# MeetingSDK dependency
pod 'GTMBase64', ' 1.0.0'                
pod 'MBProgressHUD' , '0.9.2'    
pod 'AFNetworking', '3.1.0'
pod 'OSCache', '1.2.1'
pod 'OrderedDictionary', '1.2'
pod 'Toast', '3.1.0'
pod 'MJExtension', '3.0.13'
pod 'MJRefresh', '3.1.12'
pod 'SDWebImage', '3.8.2'
pod 'SVProgressHUD', '2.1.2'
```

## History
暂无

## Author

* Email: gengc@yxt.com
* 博客园:  http://www.cnblogs.com/gc1991
* 简  书:  http://www.jianshu.com/u/a851198ccb9c

[1]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/3.7
[2]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/3.6.1
[3]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/3.6
[4]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/3.5
[5]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/3.8
[6]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/3.9
[7]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/4.0
[8]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/4.1
[9]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/4.2
[10]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/4.3
[11]: https://gitlab.yunxuetang.com.cn/ios_sdk/YXTMeetingSDK/tree/4.4
