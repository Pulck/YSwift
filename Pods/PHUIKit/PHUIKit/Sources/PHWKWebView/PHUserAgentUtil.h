//
//  PHUserAgentUtil.h
//  AFNetworking
//
//  Created by 耿葱 on 2020/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHUserAgentUtil : NSObject
+ (instancetype)sharedInstance;
- (void)loadUserAgentWithCompletion:(void (^)(NSString *))completion;
@end

NS_ASSUME_NONNULL_END
