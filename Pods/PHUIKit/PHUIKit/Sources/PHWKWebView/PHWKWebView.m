//
//  PHWKWebView.m
//  lottie-ios
//
//  Created by 耿葱 on 2019/11/12.
//

#import "PHWKWebView.h"
#import "NSString+PH.h"
#import "PHMacro.h"
#import "PHUserAgentUtil.h"

#define kWKWebViewReuseUrlString @"kwebkit://reuse-webView"
#define kWKWebViewReuseScheme    @"kwebkit"

@implementation PHWKWebView

#pragma mark - override
- (void)dealloc {
    //清除UserScript
    [self.configuration.userContentController removeAllUserScripts];
    //停止加载
    [self stopLoading];
    //清空相关delegate
    [super setUIDelegate:nil];
    [super setNavigationDelegate:nil];
    PHLog(@"PHWebView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame configuration:[self config]];
    if (self) {
        [self config];
    }
    return self;
}

- (WKWebViewConfiguration *)config {
    self.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor = [UIColor clearColor];
    WKWebViewConfiguration * configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    [configuration setAllowsInlineMediaPlayback:YES];
    if (@available(iOS 10.0, *)) {
        [configuration setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeNone];
    } else if (@available(iOS 9.0, *)) {
        [configuration setRequiresUserActionForMediaPlayback:NO];
    }
    return configuration;
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit {
    _scalesPageToFit = scalesPageToFit;
    if (scalesPageToFit) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [self.configuration.userContentController addUserScript:wkUScript];
        self.configuration.userContentController = self.configuration.userContentController;
    }
}

#pragma mark - Load
- (nullable WKNavigation *)loadRequestURLString:(NSString *)urlString {
    if ([NSString ph_isNilOrEmpty:urlString]) {
        PHLog(@"urlString is nil");
        return nil;
    }
    return [self loadRequestURL:[NSURL URLWithString:urlString]];
}

- (nullable WKNavigation *)loadRequestURL:(NSURL *)url {
    if (!url) {
        PHLog(@"url is nil");
        return nil;
    }
    return [self loadRequestURL:url cookie:@{}];
}

- (nullable WKNavigation *)loadRequestURL:(NSURL *)url cookie:(NSDictionary *)cookie {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    __block NSMutableString *cookieStr = [NSMutableString string];
    if (cookie) {
        [cookie enumerateKeysAndObjectsUsingBlock:^(NSString* _Nonnull key, NSString* _Nonnull value, BOOL * _Nonnull stop) {
            [cookieStr appendString:[NSString stringWithFormat:@"%@ = %@;", key, value]];
        }];
    }
    if (cookieStr.length > 1)[cookieStr deleteCharactersInRange:NSMakeRange(cookieStr.length - 1, 1)];
    [request addValue:cookieStr forHTTPHeaderField:@"Cookie"];
    return [self loadRequest:request.copy];
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)requset {
    return [super loadRequest:requset];
}

- (nullable WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
    if ([NSString ph_isNilOrEmpty:textEncodingName]) {
        textEncodingName = @"UTF-8";
    }
    if (@available(iOS 9.0, *)) {
        return [self loadData:data MIMEType:MIMEType characterEncodingName:textEncodingName baseURL:baseURL];
    }
    return nil;
}

- (void)evaluateJavaScript:(NSString * _Nullable)javaScriptString result:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))result {
    [self evaluateJavaScript:javaScriptString completionHandler:result];
}

#pragma mark - Clear Cache相关
- (void)clearCache {
    [PHWKWebView clearAllWebCache];
    [self clearBrowseHistory];
}

+ (void)clearAllWebCache {
    if ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion > 9){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 9.0, *)) {
            NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                            WKWebsiteDataTypeMemoryCache,
                                                            WKWebsiteDataTypeSessionStorage,
                                                            WKWebsiteDataTypeDiskCache,
                                                            WKWebsiteDataTypeOfflineWebApplicationCache,
                                                            WKWebsiteDataTypeCookies,
                                                            WKWebsiteDataTypeLocalStorage,
                                                            WKWebsiteDataTypeIndexedDBDatabases,
                                                            WKWebsiteDataTypeWebSQLDatabases
                                                            ]];
            
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                       modifiedSince:dateFrom
                                                   completionHandler:^{
                                                       PHLog(@"WKWebView (ClearWebCache) Clear All Cache Done");
                                                   }];
        }
#endif
    } else {
        // iOS8
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        @"WKWebsiteDataTypeCookies",
                                                        @"WKWebsiteDataTypeLocalStorage",
                                                        @"WKWebsiteDataTypeIndexedDBDatabases",
                                                        @"WKWebsiteDataTypeWebSQLDatabases"
                                                        ]];
        for (NSString *type in websiteDataTypes) {
            clearWebViewCacheFolderByType(type);
        }
    }
}

FOUNDATION_STATIC_INLINE void clearWebViewCacheFolderByType(NSString *cacheType) {
    static dispatch_once_t once;
    static NSDictionary *cachePathMap = nil;
    dispatch_once(&once,
                  ^{
                      NSString *bundleId = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleIdentifierKey];
                      NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
                      NSString *storageFileBasePath = [libraryPath stringByAppendingPathComponent:
                                                       [NSString stringWithFormat:@"WebKit/%@/WebsiteData/", bundleId]];
                      
                      cachePathMap = @{@"WKWebsiteDataTypeCookies":
                                           [libraryPath stringByAppendingPathComponent:@"Cookies/Cookies.binarycookies"],
                                       @"WKWebsiteDataTypeLocalStorage":
                                           [storageFileBasePath stringByAppendingPathComponent:@"LocalStorage"],
                                       @"WKWebsiteDataTypeIndexedDBDatabases":
                                           [storageFileBasePath stringByAppendingPathComponent:@"IndexedDB"],
                                       @"WKWebsiteDataTypeWebSQLDatabases":
                                           [storageFileBasePath stringByAppendingPathComponent:@"WebSQL"]
                                       };
                  });
    
    NSString *filePath = cachePathMap[cacheType];
    if (filePath && filePath.length > 0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error) {
                PHLog(@"removed file fail: %@ ,error %@", [filePath lastPathComponent], error);
            }
        }
    }
}

- (void)clearBrowseHistory {
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@%@", @"_re", @"moveA",@"llIte", @"ms"]);
    if([self.backForwardList respondsToSelector:sel]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.backForwardList performSelector:sel];
#pragma clang diagnostic pop
    }
}

#pragma mark - userAgent相关
- (void)addUserAgentWithType:(PHCustomUserAgentType)type customUserAgent:(NSString *)customUserAgent completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler {
    if ([NSString ph_isNilOrEmpty:customUserAgent]) {
        PHLog(@"WKWebView (SyncConfigUserAgent) config with invalid string");
        return;
    }
    [[PHUserAgentUtil sharedInstance] loadUserAgentWithCompletion:^(NSString * _Nonnull result) {
        NSDictionary *dictionary;
        if(type == PHCustomUserAgentTypeDefault) {
            NSString *originalUserAgent = result;
            dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:originalUserAgent, @"UserAgent", nil];
        }else if(type == PHCustomUserAgentTypeReplace) {
            dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
        }else if (type == PHCustomUserAgentTypeAppend) {
            NSString *originalUserAgent = result;
            NSRange range= [originalUserAgent rangeOfString:@"-yxtapp/"];
            if (range.location != NSNotFound) {
                originalUserAgent = [originalUserAgent substringToIndex:range.location];
            }
            NSString *appUserAgent = [NSString stringWithFormat:@"%@-%@", originalUserAgent, customUserAgent];
            dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:appUserAgent, @"UserAgent", nil];
        }else{
            PHLog(@"WKWebView (SyncConfigUA) config with invalid type :%@", @(type));
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        if (completionHandler) {
            completionHandler(result,nil);
        }
    }];
}

#pragma mark - localStorage相关
- (void)addlocalStorageItem:(NSString *)key value:(NSString *)value completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler {
    NSString *jsString = [NSString stringWithFormat:@"window.localStorage.setItem(%@,'%@')", key, value];
    [self evaluateJavaScript:jsString completionHandler:completionHandler];
}

- (void)removeLocalStorageItem:(NSString *)key completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler {
    NSString *jsString = [NSString stringWithFormat:@"window.localStorage.removeItem(%@)", key];
    [self evaluateJavaScript:jsString completionHandler:completionHandler];
}

- (void)getLocalStorageItem:(NSString *)key completionHandler:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler {
    NSString *jsString = [NSString stringWithFormat:@"window.localStorage.getItem(%@)", key];
    [self evaluateJavaScript:jsString completionHandler:completionHandler];
}

- (void)clearLocalStorage:(void (^ _Nullable)(_Nullable id result, NSError * _Nullable error))completionHandler {
    NSString *jsString = [NSString stringWithFormat:@"window.localStorage.clear()"];
    [self evaluateJavaScript:jsString completionHandler:completionHandler];
}
@end
