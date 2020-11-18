//
//  PHUserAgentUtil.m
//  AFNetworking
//
//  Created by 耿葱 on 2020/11/9.
//

#import "PHUserAgentUtil.h"
#import <WebKit/WebKit.h>
#import "PHUtils.h"

@interface PHUserAgentUtil()
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) dispatch_group_t loadUAGroup;
@property (atomic, copy) NSString *userAgent;
@end
@implementation PHUserAgentUtil

+ (instancetype)sharedInstance {
    static PHUserAgentUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PHUserAgentUtil alloc] init];
    });
    return sharedInstance;
}

- (void)loadUserAgentWithCompletion:(void (^)(NSString *))completion {
    if (self.userAgent) {
        return completion(self.userAgent);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.wkWebView) {
            dispatch_group_notify(self.loadUAGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                completion(self.userAgent);
            });
        } else {
            self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
            self.loadUAGroup = dispatch_group_create();
            dispatch_group_enter(self.loadUAGroup);

            __weak typeof(self) weakSelf = self;
            [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable response, NSError *_Nullable error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (error || !response) {
                    PHLog(@"WKWebView evaluateJavaScript load UA error:%@", error);
                    completion(nil);
                } else {
                    strongSelf.userAgent = response;
                    completion(strongSelf.userAgent);
                }
                
                // 通过 wkWebView 控制 dispatch_group_leave 的次数
                if (strongSelf.wkWebView) {
                    dispatch_group_leave(strongSelf.loadUAGroup);
                }
                
                strongSelf.wkWebView = nil;
            }];
        }
    });
}
@end
