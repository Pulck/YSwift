//
//  PHTextDetailCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHTextDetailCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"
#import "PHMacro.h"

@interface PHTextDetailCell ()

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

/**
 右侧箭头
 */
@property (nonatomic, strong) UIImageView * arrowImage;

@end

@implementation PHTextDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHTextDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHTextDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftLbl];
        [self addSubview:self.leftDetail];
        [self addSubview:self.rightDetail];
        [self addSubview:self.arrowImage];
        [self addSubview:self.splitLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self redStyle];
    [self setUIsHiddenState];
    [self reLayoutControls];
}

- (void)setUIsHiddenState {
    [self.splitLine setHidden:self.isLastItem];
    [self.arrowImage setHidden:self.noArrow];
}

- (void)redStyle {
    if (self.redDetail) {
        [self.rightDetail setBackgroundColor:[UIColor ph_colorWithHexString:@"#FF4444"]];
        [self.rightDetail setTextColor:[UIColor ph_colorWithHexString:@"#FFFFFF"]];
        [self.rightDetail setFont:[UIFont systemFontOfSize:12]];
        [self.rightDetail.layer setCornerRadius:8];
        [self.rightDetail setTextAlignment:NSTextAlignmentCenter];
    } else {
        [self.rightDetail setBackgroundColor:[UIColor clearColor]];
        [self.rightDetail setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
        [self.rightDetail setFont:[UIFont systemFontOfSize:14]];
        [self.rightDetail setTextAlignment:NSTextAlignmentRight];
        [self.rightDetail.layer setCornerRadius:0];
    }
}

- (void)reLayoutControls {
    //右侧箭头
    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(16);
    }];
    
    [self layoutRightDetail];
    [self layoutLeftLbl];
    [self layoutLeftDetail];
    
    //底部分割线
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLbl.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)layoutRightDetail {
    //右侧详情
    [self.rightDetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.noArrow) {
            make.right.equalTo(self.mas_right).offset(-16);
        } else {
            make.right.equalTo(self.arrowImage.mas_left).offset(-8);
        }
        make.centerY.equalTo(self.mas_centerY);
        if (self.redDetail) {
            make.height.mas_equalTo(16);
            CGFloat deltaWidth = self.rightDetail.text.length > 1 ? 8 : 0;
            make.width.mas_equalTo([self getMessageSize:self.rightDetail maxWidth:60 minWidth:16].width + deltaWidth);
        } else {
            make.height.mas_equalTo(18);
            make.width.mas_equalTo([self getMessageSize:self.rightDetail maxWidth:60 minWidth:18].width);
        }
    }];
}

- (void)layoutLeftLbl {
    //左侧文本
    [self.leftLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        if ([NSString ph_isNilOrEmpty:self.leftDetail.text]) {
            if ([NSString ph_isNilOrEmpty:self.rightDetail.text]) {
                if (self.noArrow) {
                    make.right.equalTo(self.mas_right).offset(-16);
                } else {
                    make.right.equalTo(self.arrowImage.mas_left).offset(-8);
                }
            } else {
                make.right.equalTo(self.rightDetail.mas_left).offset(-16);
            }
        } else {
            make.width.mas_equalTo([self getMessageSize:self.leftLbl maxWidth:66 minWidth:16].width);
        }
        make.height.mas_equalTo(20);
    }];
}

- (void)layoutLeftDetail {
    //左侧详情
    [self.leftDetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLbl.mas_right).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(18);
        if ([NSString ph_isNilOrEmpty:self.rightDetail.text]) {
            if (self.noArrow) {
                make.right.equalTo(self.mas_right).offset(-16);
            } else {
                make.right.equalTo(self.arrowImage.mas_left).offset(-8);
            }
        } else {
            make.right.equalTo(self.rightDetail.mas_left).offset(-16);
        }
    }];
}

- (UILabel *)leftLbl {
    if (!_leftLbl) {
        _leftLbl = [[UILabel alloc] init];
        [_leftLbl setTextAlignment:NSTextAlignmentLeft];
        [_leftLbl setFont:[UIFont systemFontOfSize:16]];
        [_leftLbl setTextColor:[UIColor ph_colorWithHexString:@"#323233"]];
    }
    return _leftLbl;
}

- (UILabel *)leftDetail {
    if (!_leftDetail) {
        _leftDetail = [[UILabel alloc] init];
        [_leftDetail setFont:[UIFont systemFontOfSize:14]];
        [_leftDetail setTextAlignment:NSTextAlignmentLeft];
        [_leftDetail setTextColor:[UIColor ph_colorWithHexString:@"#323233"]];
    }
    return _leftDetail;
}

- (UILabel *)rightDetail {
    if (!_rightDetail) {
        _rightDetail = [[UILabel alloc] init];
        [_rightDetail setTextAlignment:NSTextAlignmentRight];
        [_rightDetail setFont:[UIFont systemFontOfSize:14]];
        [_rightDetail setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
        [_rightDetail setClipsToBounds:YES];
    }
    return _rightDetail;
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
