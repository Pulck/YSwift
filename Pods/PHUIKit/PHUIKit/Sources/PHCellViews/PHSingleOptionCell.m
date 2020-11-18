//
//  PHSingleOptionCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHSingleOptionCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"
#import "PHMacro.h"

@interface PHSingleOptionCell()

/**
 当前启用状态
 */
@property (nonatomic, assign) BOOL currentEnableCell;

/**
 当前选中状态
 */
@property (nonatomic, assign) BOOL currentSelectState;

/**
 右侧勾选图标
 */
@property (nonatomic, strong) UIImageView * selectImageView;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

@end

@implementation PHSingleOptionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHSingleOptionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHSingleOptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.selectImageView];
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
    [self.selectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.selectImageView.image.size.width);
        make.height.mas_equalTo(self.selectImageView.image.size.width);
    }];
    
    //左侧文本
    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_equalTo(15);
        make.right.equalTo(self.selectImageView.mas_left).offset(-8);
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

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        [_selectImageView setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_list_check_enable", @"PHUIKit")];
        [_selectImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _selectImageView;
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

@end
