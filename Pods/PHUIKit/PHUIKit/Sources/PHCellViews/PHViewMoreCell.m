//
//  PHViewMoreCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHViewMoreCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"
#import "PHMacro.h"

@interface PHViewMoreCell ()

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

/**
 右侧箭头
 */
@property (nonatomic, strong) UIImageView * arrowImage;

@end

@implementation PHViewMoreCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHViewMoreCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHViewMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftLbl];
        [self addSubview:self.arrowImage];
        [self addSubview:self.splitLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUIsHiddenState];
    [self reLayoutControls];
}

- (void)setUIsHiddenState {
    [self.splitLine setHidden:self.isLastItem];
}

- (void)reLayoutControls {
    //右侧箭头
    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    //左侧文本
    [self.leftLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.arrowImage.mas_left).offset(-8);
        make.height.mas_equalTo(20);
    }];
    
    //底部分割线
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLbl.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (UILabel *)leftLbl {
    if (!_leftLbl) {
        _leftLbl = [[UILabel alloc] init];
        [_leftLbl setTextAlignment:NSTextAlignmentLeft];
        [_leftLbl setFont:[UIFont systemFontOfSize:16]];
        [_leftLbl setTextColor:[UIColor ph_colorWithHexString:@"#1989FA"]];
    }
    return _leftLbl;
}

- (UIImageView *)arrowImage {
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] init];
        [_arrowImage setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_list_arrow", @"PHUIKit")];
        [_arrowImage setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _arrowImage;
}

- (UIView *)splitLine {
    if (!_splitLine) {
        _splitLine = [[UIView alloc] init];
        [_splitLine setBackgroundColor:[UIColor ph_colorWithHexString:@"#EBEDF0"]];
    }
    return _splitLine;
}

- (CGSize)getMessageSize:(UILabel *)messageLabel maxWidth:(CGFloat)maxWidth minWidth:(CGFloat)minWidth {
    CGSize maxSizeMessage = CGSizeMake(maxWidth, 18);
    CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
    expectedSizeMessage.width = expectedSizeMessage.width < minWidth ? minWidth : expectedSizeMessage.width;
    expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width), MIN(maxSizeMessage.height, expectedSizeMessage.height));
    return expectedSizeMessage;
}

@end
