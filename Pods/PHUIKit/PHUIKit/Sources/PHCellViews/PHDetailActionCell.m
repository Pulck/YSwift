//
//  PHDetailActionCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHDetailActionCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"
#import "PHMacro.h"

@interface PHDetailActionCell()

/**
 勾选图标
 */
@property (nonatomic, strong) UIImageView * selectImageView;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

@end

@implementation PHDetailActionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHDetailActionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHDetailActionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.detailLbl];
        [self addSubview:self.detailImage];
        [self addSubview:self.detailBtn];
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
    CGSize detialImageSize = self.detailImage.image.size;
    
    //标题内容
    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.detailLbl.mas_left).offset(-8);
    }];
    
    //右侧详情
    [self.detailLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo([self getMessageSize:self.detailLbl maxWidth:60].width);
        make.right.equalTo(self.detailImage.mas_left).offset(-8);
    }];
    
    //右侧详情图标
    [self.detailImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(detialImageSize.width);
        make.height.mas_equalTo(detialImageSize.height);
    }];
    
    //右侧详情按钮
    [self.detailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLbl.mas_left);
        make.right.equalTo(self.detailImage.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //底部分割线
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
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
        [_detailLbl setTextAlignment:NSTextAlignmentLeft];
        [_detailLbl setFont:[UIFont systemFontOfSize:14]];
        [_detailLbl setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
    }
    return _detailLbl;
}

- (UIImageView *)detailImage {
    if (!_detailImage) {
        _detailImage = [[UIImageView alloc] init];
        [_detailImage setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_list_detail", @"PHUIKit")];
        [_detailImage setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _detailImage;
}

- (UIButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc] init];
        [_detailBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBtn;
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

- (void)detailAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(phDetailAction:)]) {
        [self.delegate phDetailAction:self.customModel];
    }
}

@end
