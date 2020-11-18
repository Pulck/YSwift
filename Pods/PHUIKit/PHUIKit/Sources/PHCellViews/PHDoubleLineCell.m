//
//  PHDoubleLineCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHDoubleLineCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"
#import "PHMacro.h"

@interface PHDoubleLineCell ()

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

/**
 右侧箭头
 */
@property (nonatomic, strong) UIImageView * arrowImage;

@end

@implementation PHDoubleLineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHDoubleLineCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHDoubleLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.detailLbl];
        [self addSubview:self.describeLbl];
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
    [self.arrowImage setHidden:self.noArrow];
}

- (void)reLayoutControls {
    CGFloat detailLines = [self getMessageLines:self.describeLbl maxWidth:(self.bounds.size.width - 15 - 40)];
    [self layoutDetailLbl:detailLines];
    [self layoutTitleLbl];
    [self layoutArrowImage:detailLines];
    [self layoutDescribeLbl:detailLines];
    
    //底部分割线
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)layoutDetailLbl:(CGFloat)detailLines {
    //右侧详细信息
    [self.detailLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.noArrow) {
            make.right.equalTo(self.mas_right).offset(-16);
        } else {
            make.right.equalTo(self.arrowImage.mas_left).offset(-8);
        }
        if (detailLines > 1) {
            make.centerY.equalTo(self.titleLbl.mas_centerY);
        } else {
            make.centerY.equalTo(self.mas_centerY);
        }
        make.width.mas_equalTo([self getMessageSize:self.detailLbl maxWidth:60].width);
        make.height.mas_equalTo(18);
    }];
}

- (void)layoutTitleLbl {
    //左侧标题
    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(20);
        if ([NSString ph_isNilOrEmpty:self.detailLbl.text]) {
            if (self.noArrow) {
                make.right.equalTo(self.mas_right).offset(-16);
            } else {
                make.right.equalTo(self.arrowImage.mas_left).offset(-8);
            }
        } else {
            make.right.equalTo(self.detailLbl.mas_left).offset(-16);
        }
    }];
}

- (void)layoutArrowImage:(CGFloat)detailLines {
    //右侧箭头
    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.width.height.mas_equalTo(16);
    }];
}

- (void)layoutDescribeLbl:(CGFloat)detailLines {
    //左侧描述
    [self.describeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        if (self.noArrow) {
            make.right.equalTo(self.mas_right).offset(-16);
        } else {
            make.right.equalTo(self.arrowImage.mas_left).offset(-8);
        }
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-16);
        if (detailLines > 1) {
            make.height.mas_equalTo(36);
        } else {
            make.height.mas_equalTo(18);
        }
    }];
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        [_titleLbl setTextAlignment:NSTextAlignmentLeft];
        [_titleLbl setFont:[UIFont systemFontOfSize:16]];
        [_titleLbl setTextColor:[UIColor ph_colorWithHexString:@"#323233"]];
    }
    return _titleLbl;
}

- (UILabel *)detailLbl {
    if (!_detailLbl) {
        _detailLbl = [[UILabel alloc] init];
        [_detailLbl setFont:[UIFont systemFontOfSize:14]];
        [_detailLbl setTextAlignment:NSTextAlignmentRight];
        [_detailLbl setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
    }
    return _detailLbl;
}

- (UILabel *)describeLbl {
    if (!_describeLbl) {
        _describeLbl = [[UILabel alloc] init];
        [_describeLbl setFont:[UIFont systemFontOfSize:14]];
        [_describeLbl setNumberOfLines:0];
        [_describeLbl setTextAlignment:NSTextAlignmentLeft];
        [_describeLbl setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
    }
    return _describeLbl;
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

- (CGSize)getMessageSize:(UILabel *)messageLabel maxWidth:(CGFloat)maxWidth {
    CGSize maxSizeMessage = CGSizeMake(maxWidth, 18);
    CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
    expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width), MIN(maxSizeMessage.height, expectedSizeMessage.height));
    return expectedSizeMessage;
}

- (CGFloat)getMessageLines:(UILabel *)messageLabel maxWidth:(CGFloat)maxWidth {
    CGSize maxSizeMessage = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
    expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width), MIN(maxSizeMessage.height, expectedSizeMessage.height));
    if (expectedSizeMessage.height > 18) {
        return 2;
    }
    return 0;
}

@end
