//
//  PHTextView.h
//  PHTextViewTest
//
//  Created by dingw on 2019/12/19.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UITextView子类，增加placeholder
 */
@interface PHTextView : UITextView

/**
 占位文字，默认：nil
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 占位文字颜色，默认：999999
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 占位文字字体，默认:[UIFont systemFontOfSize:16]
 */
@property (nonatomic, strong) UIFont *placeholderFont;

/**
 占位文字，属性字符串，默认nil
 */
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;

/**
 文字改变处理
 */
- (void)textDidChange;

@end

NS_ASSUME_NONNULL_END
