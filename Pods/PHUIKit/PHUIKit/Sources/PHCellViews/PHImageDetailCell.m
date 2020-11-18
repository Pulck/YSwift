//
//  PHImageDetailCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHImageDetailCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"

@interface PHImageDetailCell ()

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

@end

@implementation PHImageDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHImageDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHImageDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftImage];
        [self addSubview:self.leftLbl];
        [self addSubview:self.leftDetailLbl];
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
    CGFloat imageWidth = self.leftImage.image.size.width < 64 ? 64 : self.leftImage.image.size.width;
    CGFloat imageHeight = self.leftImage.image.size.height < 64 ? 64: self.leftImage.image.size.height;
    //取得描述的行数（cell宽度-描述左边的间距（- 15 - imageWidth - 8）-描述右边的间距（16））
    CGFloat detailLines = [self getMessageLines:self.leftDetailLbl maxWidth:(self.bounds.size.width - 15 - imageWidth - 8 - 16)];
    
    [self.leftImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(imageWidth);
        make.height.mas_equalTo(imageHeight);
    }];
    
    [self.leftLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(8);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
    
    [self.leftDetailLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.leftLbl.mas_bottom).offset(8);
        if (detailLines > 1) {
            make.height.mas_equalTo(36);
        } else {
            make.height.mas_equalTo(18);
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

- (UILabel *)leftDetailLbl {
    if (!_leftDetailLbl) {
        _leftDetailLbl = [[UILabel alloc] init];
        [_leftDetailLbl setTextAlignment:NSTextAlignmentLeft];
        [_leftDetailLbl setFont:[UIFont systemFontOfSize:14]];
        [_leftDetailLbl setNumberOfLines:0];
        [_leftDetailLbl setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
    }
    return _leftDetailLbl;
}

- (UIView *)splitLine {
    if (!_splitLine) {
        _splitLine = [[UIView alloc] init];
        [_splitLine setBackgroundColor:[UIColor ph_colorWithHexString:@"#EBEDF0"]];
    }
    return _splitLine;
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
