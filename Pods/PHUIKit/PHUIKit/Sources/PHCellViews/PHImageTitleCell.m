//
//  PHImageTitleCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHImageTitleCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"
#import "PHMacro.h"

@interface PHImageTitleCell ()

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

/**
 右侧箭头
 */
@property (nonatomic, strong) UIImageView * arrowImage;

@end

@implementation PHImageTitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHImageTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHImageTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftImage];
        [self addSubview:self.leftLbl];
        [self addSubview:self.rightLbl];
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
    [self.leftImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        CGFloat imageWidth = self.leftImage.image.size.width < 24 ? 24 : self.leftImage.image.size.width;
        CGFloat imageHeight = self.leftImage.image.size.height < 24 ? 24 : self.leftImage.image.size.height;
        make.width.mas_equalTo(imageWidth);
        make.height.mas_equalTo(imageHeight);
    }];
    
    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.rightLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImage.mas_left).offset(-8);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo([self getMessageSize:self.rightLbl maxWidth:60].width);
    }];
    
    [self.leftLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(8);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(20);
        if ([NSString ph_isNilOrEmpty:self.rightLbl.text]) {
            make.right.equalTo(self.arrowImage.mas_left).offset(-8);
        } else {
            make.right.equalTo(self.rightLbl.mas_left).offset(-16);
        }
    }];
    
    //底部分割线
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLbl.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (UIImageView *)leftImage {
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] init];
        [_leftImage setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _leftImage;
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

- (UILabel *)rightLbl {
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] init];
        [_rightLbl setTextAlignment:NSTextAlignmentRight];
        [_rightLbl setFont:[UIFont systemFontOfSize:14]];
        [_rightLbl setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
    }
    return _rightLbl;
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

@end
