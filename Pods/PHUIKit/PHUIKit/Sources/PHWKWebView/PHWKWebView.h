//
//  PHWKWebView.h
//  lottie-ios
//
//  Created by 耿葱 on 2019/11/12.
//

#import <WebKit/WebKit.h>

/**
 UserAgent的使用类型
 
 - PHCustomUserAgentTypeDefault: 使用系统默认的
 - PHCustomUserAgentTypeReplace: 替换所有UA
 - PHCustomUserAgentTypeAppend: 在原UA后面追加字符串
 */
typedef NS_ENUM(NSUInteger, PHCustomUserAgentType) {
    PHCustomUserAgentTypeDefault,
    PHCustomUserAgentTypeReplace,
    PHCustomUserAgentTypeAppend,
};
NS_ASSUME_NONNULL_BEGIN

@interface PHWKWebView : WKWebView
/**
 页面缩放适配
 */
@property (nonatomic, assign) BOOL scalesPageToFit;

#pragma mark - load相关
/**
 使用URL字符串加载页面

 @param urlString URL字符串
 @return 给定请求的新导航
 */
- (nullable WKNavigation *)loadRequestURLString:(NSString *)urlString;

/**
 使用URL字符串加载页面

 @param url 需要请求的URL
 @return 给定请求的新导航
 */
- (nullable WKNavigation *)loadRequestURL:(NSURL *)url;

/**
 创建带cookie的请求加载页面

 @param url 需要加载的URL
 @param cookie 需要加载的cookie
 @return 给定请求的新导航
 */
- (nullable WKNavigation *)loadRequestURL:(NSURL *)url cookie:(NSDictionary *)cookie;

/**
 加载请求

 @param requset 需要加载的请求
 @return 给定请求的新导航
 */
- (nullable WKNavigation *)loadRequest:(NSURLRequest *)requset;

/**
 设置网页内容和基本URL

 @param data 用来作为网页内容的数据
 @param MIMEType 数据的MIME类型
 @param textEncodingName 数据的字符编码名称(如果不传，则使用"UTF-8")
 @param baseURL 用于解析文档中相对URL的URL
 @return 给定请求的新导航
 */
- (nullable WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;

#pragma mark - clear相关
/**
 清理缓存和历史记录
 */
- (void)clearCache;

/**
 清理缓存
 */
+ (void)clearAllWebCache;

/**
 清理历史记录
 */
- (void)clearBrowseHistory;

#pragma mark - userAgent相关
/// 添加UserAgent
/// @param type 添加类型（替换原有UA、新的UA追加在原来的UA后、使用默认UA）
/// @param customUserAgent 需要新加的UA字符串
/// @param completionHandler 完成回调
- (void)addUserAgentWithType:(PHCustomUserAgentType)type
             customUserAgent:(NSString *)customUserAgent
           completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler;

#pragma mark - localStorage相关
/**
 添加localStorage

 @param key 添加的localStorage的key
 @param value 添加的localStorage的value
 @param completionHandler 添加结果
 */
- (void)addlocalStorageItem:(NSString *)key value:(NSString *)value completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler;

/**
 移除某条localStorage

 @param key 移除的localStorage的key
 @param completionHandler 移除结果
 */
- (void)removeLocalStorageItem:(NSString *)key completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler;

/**
 添加localStorage

 @param key 获取的localStorage的key
 @param completionHandler 获取结果
 */
- (void)getLocalStorageItem:(NSString *)key completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler;

/**
 清空localStorage

 @param completionHandler 清空结果
 */
- (void)clearLocalStorage:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
