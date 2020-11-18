//
//  PHTextView.m
//  PHTextViewTest
//
//  Created by dingw on 2019/12/19.
//  Copyright © 2019 江苏云学堂网络科技有限公司. All rights reserved.
//

#import "PHTextView.h"
#import "PHUtils.h"

@interface PHTextView ()

// 占位符label
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation PHTextView

- (void)dealloc {
    NSLog(@"//////// PHTextView dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 文字改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 文字改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_placeholderLabel) {
        // 适配占位符视图
        UIEdgeInsets inset = self.textContainerInset;
        CGFloat borderWidth = self.layer.borderWidth;
        CGFloat padding = self.textContainer.lineFragmentPadding;
        CGFloat x = inset.left + padding + borderWidth;
        CGFloat y = inset.top + borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - (inset.right + padding + borderWidth);
        CGFloat height = [_placeholderLabel sizeThatFits:(CGSizeMake(width, 20))].height;
        CGFloat maxHeight = CGRectGetHeight(self.bounds) - borderWidth * 2 - inset.top - inset.bottom;
        if (height > maxHeight) {
            height = maxHeight;
        }
        _placeholderLabel.frame = CGRectMake(x, y, width, height);
    }
}

// 文字改变
- (void)textDidChange {
    // 占位符显示/隐藏
    if (!self.text.length) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor ph_colorWithHexString:@"999999"];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.numberOfLines = 0;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = placeholderFont;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.placeholderLabel.attributedText = attributedPlaceholder;
}

@end
