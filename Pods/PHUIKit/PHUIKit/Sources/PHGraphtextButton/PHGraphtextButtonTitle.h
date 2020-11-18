//
//  PHGraphtextButtonTitle.h
//  PHUIKit
//
//  Created by liangc on 2019/12/25.
//  Copyright © 2019 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHGraphtextButtonTitle : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIColor *color;
@property (nonatomic) UIFont *font;

@property (nonatomic, copy) NSAttributedString *attributeText;

@end

NS_ASSUME_NONNULL_END
