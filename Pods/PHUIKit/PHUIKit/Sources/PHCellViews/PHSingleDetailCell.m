//
//  PHSingleDetailCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHSingleDetailCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"
#import "PHMacro.h"

@interface PHSingleDetailCell()

/**
 当前启用状态
 */
@property (nonatomic, assign) BOOL currentEnableCell;

/**
 当前选中状态
 */
@property (nonatomic, assign) BOOL currentSelectState;

/**
 勾选图标
 */
@property (nonatomic, strong) UIImageView * selectImageView;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

@end

@implementation PHSingleDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHSingleDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHSingleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.selectImageView];
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
    CGSize selImageSize = self.selectImageView.image.size;
    CGSize detialImageSize = self.detailImage.image.size;
    
    //左侧选择图标
    [self.selectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(selImageSize.width);
        make.height.mas_equalTo(selImageSize.height);
    }];
    
    //选项内容
    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImageView.mas_right).offset(10);
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

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        [_selectImageView setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_list_check_enable", @"PHUIKit")];
        [_selectImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _selectImageView;
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
        [_detailBtn addTarget:self action:@selector(selectDetail) forControlEvents:UIControlEventTouchUpInside];
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

- (void)enableCell:(BOOL)enable selectState:(BOOL)selectState {
    self.currentEnableCell = enable;
    self.currentSelectState = selectState;
    if (self.currentEnableCell) {//启用时
        [self.titleLbl setTextColor:[UIColor ph_colorWithHexString:@"#323233"]];
        if (self.currentSelectState) {//选中时
            if (self.enableSelectImage) {//外部配置存在时
                [self.selectImageView setImage:self.enableSelectImage];
            } else {
                [self.selectImageView setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_list_check_enable", @"PHUIKit")];
            }
        } else {//未选中时
            if (self.enableUnSelectImage) {//外部配置存在时
                [self.selectImageView setImage:self.enableUnSelectImage];
            } else {
                [self.selectImageView setImage:[UIImage new]];
            }
        }
    } else {//禁用时
        [self.titleLbl setTextColor:[UIColor ph_colorWithHexString:@"#C8C9CC"]];
        if (self.currentSelectState) {//选中时
            if (self.prohibitSelectImage) {//外部配置存在时
                [self.selectImageView setImage:self.prohibitSelectImage];
            } else {
                [self.selectImageView setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_list_check_unenable", @"PHUIKit")];
            }
        } else {//未选中时
            if (self.prohibitUnSelectImage) {//外部配置存在时
                [self.selectImageView setImage:self.prohibitUnSelectImage];
            } else {
                [self.selectImageView setImage:[UIImage new]];
            }
        }
    }
    [self reLayoutControls];
}

- (CGSize)getMessageSize:(UILabel *)messageLabel maxWidth:(CGFloat)maxWidth {
    CGSize maxSizeMessage = CGSizeMake(maxWidth, 18);
    CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
    expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, expectedSizeMessage.width), MIN(maxSizeMessage.height, expectedSizeMessage.height));
    return expectedSizeMessage;
}

- (void)selectDetail {
    if (self.delegate && [self.delegate respondsToSelector:@selector(phSelectDetailAction:)]) {
        [self.delegate phSelectDetailAction:self.customModel];
    }
}

@end
