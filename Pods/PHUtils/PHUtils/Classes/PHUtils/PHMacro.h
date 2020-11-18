//
//  PHMacro.h
//  Pods
//
//  Created by Hu, Yuping on 2019/10/31.
//

#ifndef PHMacro_h
#define PHMacro_h

#if DEBUG

#define PHLog(FORMAT, ...) fprintf(stderr, "[%s:%d行] %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define PHLog(FORMAT, ...) nil
#endif

/// 判断是否为iPhoneX系列，全面屏手机（横屏和竖屏都做了判断）
#define PH_Is_iPhoneX ([NSObject ph_iphoneX])

/// iPhoneX BottomY
#define PH_iPhoneXBottomY (PH_Is_iPhoneX ? 34 : 0)

/// iPhoneX TopY
#define PH_iPhoneXTopY (PH_Is_iPhoneX ? 44 : 0)

#define PH_WeakSelf __weak __typeof(self) weakSelf = self;


//----------------------尺寸大小-------------------------
// 状态栏高度
#define PH_STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
// NavBar高度
#define PH_NAVIGATION_BAR_HEIGHT 44
// Tabbar高度
#define PH_TABBAR_HEIGHT 49
// 状态栏 ＋ 导航栏 高度
#define PH_STATUS_AND_NAVIGATION_HEIGHT ((PH_STATUS_BAR_HEIGHT) + (PH_NAVIGATION_BAR_HEIGHT))

// 获取屏幕 宽度、高度
#define PH_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define PH_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 是否为3.5inch
#define PH_35INCH ([UIScreen mainScreen].bounds.size.height == 480.0)
// 是否为4inch
#define PH_4INCH ([UIScreen mainScreen].bounds.size.height == 568.0)
// 是否为4.7inch
#define PH_47INCH ([UIScreen mainScreen].bounds.size.height == 667.0)
// 是否为5.5inch
#define PH_55INCH ([UIScreen mainScreen].bounds.size.height == 736.0)
// 是否为iPhoneX
#define PH_iPhoneXINCH ([UIScreen mainScreen].bounds.size.height == 812.0)

#define PH_isLHP ([[UIApplication sharedApplication] statusBarFrame].size.height == 44)

#define PH_NARBAR (PH_STATUS_BAR_HEIGHT + PH_NAVIGATION_BAR_HEIGHT)

#define PH_WIDTH_ZOOM (PH_SCREEN_WIDTH/320.0)
#define PH_HEIGHT_ZOOM (PH_SCREEN_HEIGHT/480.0)

// 首页继续学习高度
#define KEEP_STUDY_HEIGHT 40

//-----------------兼容iPhoneX-------------------
#define PH_IPHONEX_BOTTOM_BAR 34

//----------------------颜色类---------------------------

// 颜色常用定义
#define PH_WHITE_COLOR [UIColor whiteColor]

// 获取RGB颜色
#define PH_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define PH_RGB(r,g,b) PH_RGBA(r,g,b,1.0f)
// 获取16进制颜色
#define PH_HEX(x) [UIColor colorWithRGB:x alpha:1.0f]
#define PH_HEXA(x,y) [UIColor colorWithRGB:x alpha:y]
#define PH_HEXString(x) [UIColor ph_colorWithHexString:x]

// 全局背景色
#define PH_GLOBALBG PH_RGB(211, 211, 211)
// 随机色
#define PH_RANDOMCOLOR PH_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// 清除背景色
#define PH_CLEARCOLOR [UIColor clearColor]
// ViewController的背景颜色
#define PH_VC_BgColor PH_HEX(@"#f4f4f4")

// 字体
#define PH_VIEW_FONT(x) [UIFont systemFontOfSize:x]

//-----------------------日期格式--------------------------
#define PH_DATE_SHORT @"HH:mm"


//----------------------沙盒目录---------------------------
// Documents目录
#define PH_DOC_DIR     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
// Library目录
#define PH_LIB_DIR     [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
// Library下的cache目录
#define PH_LIB_CACHE_DIR  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// tmp下的cache目录,这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息
#define PH_TMP_DIR        NSTemporaryDirectory()

//--------------------------bundle----------------------------
// 获取mainBundle
#define PH_BUNDLE_MAIN [NSBundle mainBundle]
// 获取当前class所在bundle
#define PH_BUNDLE_CLASS [NSBundle bundleForClass:[self class]]
// 获取kClass所在bundle
#define PH_BUNDLE_FOR_CLASS(kClass) [NSBundle bundleForClass:[kClass class]]
// 根据全路径获取bundle
#define PH_BUNDLE_FRAMEWORK(kFrameworkName) [NSBundle bundleWithPath:[PH_BUNDLE_MAIN.bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Frameworks/%@.framework",kFrameworkName?:@""]]]

//--------------------------图片----------------------------
// 读取bundle 图片资源
#define PH_IMAGE_NAME(kName) [UIImage imageNamed:kName]
// 获取bundle中image对象
#define PH_IMAGE_NAMED_BUNDLE(kImageName,kBundle) [UIImage imageNamed:kImageName?:@"" inBundle:kBundle?:PH_BUNDLE_MAIN compatibleWithTraitCollection:nil]
// 获取framework中image对象，根据当前class所在bundle获取
#define PH_IMAGE_NAMED_FRAMEWORK(kImageName) PH_IMAGE_NAMED_BUNDLE(kImageName, PH_BUNDLE_CLASS)
// 获取framework中image对象，需要传入framnework name，根据全路径创建的bundle获取
#define PH_IMAGE_NAMED_FRAMEWORK_NAME(kImageName,kFrameworkName) PH_IMAGE_NAMED_BUNDLE(kImageName, PH_BUNDLE_FRAMEWORK(kFrameworkName))


//----------------------数据库路径---------------------------

#define PH_DATABASE_SQLITE_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"yxt_databaseStorage.sqlite"]
#define PH_CachesNumberFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"17025263828298"]
#define PH_CourseFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CourseDownload.sqlite"]
#define PH_DownFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"download"]


//----------------------应用名称版本---------------------------
// 应用BundleID
#define PH_BUNDLEID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
// 应用名称
#define PH_APPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// 应用软件版本
#define PH_APPSHORTVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 应用软件build版本 一般作为开发内部使用
#define PH_APPBUILDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// 系统当前iOS版本
#define PH_APPCUREENT_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define PH_IOS7LATER ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define PH_IOS8LATER ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define PH_IOS9LATER ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define PH_IOS9_1LATER ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define PH_IOS11LATER ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define PH_IOS11BEFORE ([UIDevice currentDevice].systemVersion.floatValue < 11.0f)

//----------------------其他---------------------------
// 解决block的循环引用,建议使用__weak，防止野指针错误.
#define WEAKSELF __weak __typeof(self) weakSelf = self;
// 大于等于8.0的ios版本
#define PH_iOS8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
// NSUserDefaults实例化
#define PH_USERDEFAULT [NSUserDefaults standardUserDefaults]
// 多语言
//#define PH_I18N_STR(key)    NSLocalizedString(key, @"")
// 通知中心
#define PH_DEFAULTCENTER    [NSNotificationCenter defaultCenter]
// 当前屏幕
#define PH_KEY_WINDOW [UIApplication sharedApplication].keyWindow
// 跳转storyboard
#define PH_PUSH_STORYBOARDVC(storyboardName,vcIdentity) [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:vcIdentity] animated:YES]
// 获取指定storyboard
#define PH_STORYBOARDVC(storyboardName,vcIdentity) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:vcIdentity]
// 跳转Controller
#define PH_PUSHVC(vc) [self.navigationController pushViewController:vc animated:YES]

// 为Nil Or Null
#define PH_IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
// 不为Nil Or Null
#define PH_NOTNull(_ref)   (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
// 字符串类不为nil
#define PH_NSSTRING_NONNULL(string)   (![NSString ph_isNilOrEmpty:string])

//--------------------项目定义--------------------------

#define PH_TIMER 10.0

#pragma mark --用户
#define IS_DEFAULT_TABBAR @"isDefaultTabbar" //是否使用默认tabbar配置
#define IS_SETTING_TABBAR @"isSettingTabbar" //是否设置过tabbar设置

#define WINDOW_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define WINDOW_WIDTH     [[UIScreen mainScreen] bounds].size.width

#define PHThemeColor     @"#1a81d1"
#define PHBackImage      @"image.dxskin_common_back_nav_left_white"    //换肤

#define PHBackImageForSDK      @"common_back_nav_left"   // 固定颜色

#define PHTitleColor     [UIColor blackColor]
#define PHNavBGColor     [UIColor whiteColor]
#define PHNavTitleFontSize    18

#pragma mark --NSUserDefaults
#define DEFAULTS [NSUserDefaults standardUserDefaults]

#endif /* PHMacro_h */
