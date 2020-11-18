//
//  PHIntegratedTextFieldCell.m
//  PHUIKit
//
//  Created by 梁琛 on 2019/11/7.
//

#import "PHIntegratedTextFieldCell.h"
#import "PHIntegratedInputPageDefine.h"
#import "Masonry/Masonry.h"
#import "PHUtils/PHUtils.h"

NSString * const pHIntegratedTextFieldCellIdentifier = @"IntegratedNormalInput";

@interface PHIntegratedTextFieldCell ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *textField;
@property (nonatomic) UIView *separateLine;

@end

@implementation PHIntegratedTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        self.textFieldAlignment = NSTextAlignmentLeft;
        self.maxInputLength = 0;
    }
    
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(13);
    }];
    
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(16);
        make.trailing.equalTo(self.contentView).offset(-13);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.contentView addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        make.bottom.trailing.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(16);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setter

- (void)setBottomLineStyle:(PHIntegrateSeparatorStyle)bottomLineStyle {
    _bottomLineStyle = bottomLineStyle;
    
    switch (bottomLineStyle) {
        case PHIntegrateSeparatorStyleSingle: {
            [self.separateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
                make.bottom.trailing.equalTo(self.contentView);
                make.leading.equalTo(self.contentView).offset(16);
                make.height.mas_equalTo(0.5);
            }];
        }
            break;
        case PHIntegrateSeparatorStyleNone: {
            [self.separateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
                make.leading.bottom.trailing.equalTo(self.contentView);
                make.height.mas_equalTo(0);
            }];
        }
        case PHIntegrateSeparatorStyleGroup: {
            [self.separateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
                make.leading.bottom.trailing.equalTo(self.contentView);
                make.height.mas_equalTo(18);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action Event

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.maxInputLength <= 0) return;
    
    NSInteger maxLength = self.maxInputLength;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:maxLength];
            }
        } else { //有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else { //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > maxLength) {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
    
}

#pragma mark - Lazy Init

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.text =@"标题";
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [UITextField new];
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.textAlignment = self.textFieldAlignment;
        _textField.placeholder = @"内容";
        [_textField setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _textField;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [UIView new];
        _separateLine.backgroundColor = [UIColor ph_colorWithHexString:@"EBEDF0"];
    }
    
    return _separateLine;
}

@end
