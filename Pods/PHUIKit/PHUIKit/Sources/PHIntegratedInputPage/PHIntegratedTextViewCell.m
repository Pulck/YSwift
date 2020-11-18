//
//  PHIntegratedTextViewCell.m
//  PHUIKit
//
//  Created by liangc on 2019/11/11.
//

#import "PHIntegratedTextViewCell.h"
#import "Masonry/Masonry.h"
#import "PHUtils/PHUtils.h"

NSString * const phIntegratedTextViewCellIdentifier = @"IntegratedMutilineInput";

@interface PHIntegratedTextViewCell () <UITextViewDelegate>

@property (nonatomic) UITextView *textView;
@property (nonatomic) UILabel *indicatorLabel;
@property (nonatomic) UITextView *placeholderArea;
@property (nonatomic) UIView *separateLine;

@end

@implementation PHIntegratedTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.limit = 300;
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(16);
        make.trailing.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(59);
    }];
    
    [self.contentView addSubview:self.placeholderArea];
    [self.placeholderArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView);
    }];
    
    [self.contentView addSubview:self.indicatorLabel];
    [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(8);
        make.trailing.equalTo(self.textView);
        make.leading.greaterThanOrEqualTo(self.textView);
    }];
    
    [self.contentView addSubview:self.separateLine];
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indicatorLabel.mas_bottom).offset(8);
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
}


#pragma mark - <UITextViewDelegate>

- (void)textViewDidChange:(UITextView *)textView {
    [self updateNumberIndicatorWithLength:textView.text.length];
    
    if (textView.text.length > 0) {
        self.placeholderArea.hidden = YES;
    } else {
        self.placeholderArea.hidden = NO;
    }
}

#pragma mark - private

- (void)updateNumberIndicatorWithLength:(NSInteger)length {
    NSString *numberString = [NSString stringWithFormat:@"%ld", length];
    NSString *limitString = [NSString stringWithFormat:@"/%ld", self.limit];
    
    NSMutableAttributedString *numberAttributedString;
    if (length > self.limit) {
        numberAttributedString = [[NSMutableAttributedString alloc]initWithString:numberString attributes:@{NSForegroundColorAttributeName : [UIColor ph_colorWithHexString:@"FF4444"]}];
    } else {
         numberAttributedString = [[NSMutableAttributedString alloc]initWithString:numberString attributes:@{NSForegroundColorAttributeName : [UIColor ph_colorWithHexString:@"999999"]}];
    }
    
    NSAttributedString *limitAttributedString = [[NSAttributedString alloc]initWithString:limitString attributes:@{NSForegroundColorAttributeName : [UIColor ph_colorWithHexString:@"999999"]}];
    [numberAttributedString appendAttributedString:limitAttributedString];
    
    self.indicatorLabel.attributedText = numberAttributedString.copy;
}

#pragma mark - Lazy Init

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [UITextView new];
        _textView.textColor = [UIColor ph_colorWithHexString:@"333333"];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)indicatorLabel {
    if (_indicatorLabel == nil) {
        _indicatorLabel = [UILabel new];
        _indicatorLabel.textColor = [UIColor ph_colorWithHexString:@"999999"];
        _indicatorLabel.text = [NSString stringWithFormat:@"0/%ld", self.limit];
        
        [_indicatorLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_indicatorLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    }
    return _indicatorLabel;
}

- (UITextView *)placeholderArea {
    if (_placeholderArea == nil) {
        _placeholderArea = [UITextView new];
        _placeholderArea.font = [UIFont systemFontOfSize:14];
        _placeholderArea.textColor = [UIColor ph_colorWithHexString:@"999999"];
        _placeholderArea.text = @"预设内容";
        _placeholderArea.editable = NO;
        _placeholderArea.userInteractionEnabled = NO;
        
        _placeholderArea.backgroundColor = UIColor.clearColor;
        for (UIView *view in _placeholderArea.subviews) {
            view.backgroundColor = UIColor.clearColor;
        }
    }
    return _placeholderArea;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [UIView new];
        _separateLine.backgroundColor = [UIColor ph_colorWithHexString:@"EBEDF0"];
    }
    
    return _separateLine;
}

@end
