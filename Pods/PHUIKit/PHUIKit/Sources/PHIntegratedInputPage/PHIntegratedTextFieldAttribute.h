//
//  PHIntegratedTextFieldAttribute.h
//  lottie-ios
//
//  Created by liangc on 2019/11/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PHIntegratedTextFieldAttribute : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic) NSTextAlignment inputAlignment;
@property (nonatomic) NSInteger inputLimit;
@property (nonatomic) UIColor *titleColor;

@property (nonatomic, copy) NSString *inputContent;

@end

NS_ASSUME_NONNULL_END
