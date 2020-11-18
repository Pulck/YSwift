//
//  PHSwitchCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHSwitchCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"

@interface PHSwitchCell ()

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

@end

@implementation PHSwitchCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.leftTitle];
        [self addSubview:self.leftDetail];
        [self addSubview:self.rightSwitch];
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
    //右侧开关
    [self.rightSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    //左侧文本
    [self.leftTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        if ([NSString ph_isNilOrEmpty:self.leftDetail.text]) {
            make.centerY.equalTo(self.mas_centerY);
        } else {
            make.top.equalTo(self.mas_top).offset(15);
        }
        make.right.equalTo(self.rightSwitch.mas_left).offset(-16);
        make.height.mas_equalTo(20);
    }];
    
    //左侧详情
    [self.leftDetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.leftTitle.mas_bottom).offset(8);
        make.height.mas_equalTo(18);
        make.right.equalTo(self.rightSwitch.mas_left).offset(-16);
    }];
    
    //底部分割线
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitle.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (UILabel *)leftTitle {
    if (!_leftTitle) {
        _leftTitle = [[UILabel alloc] init];
        [_leftTitle setTextAlignment:NSTextAlignmentLeft];
        [_leftTitle setFont:[UIFont systemFontOfSize:16]];
        [_leftTitle setTextColor:[UIColor ph_colorWithHexString:@"#323233"]];
    }
    return _leftTitle;
}

- (UILabel *)leftDetail {
    if (!_leftDetail) {
        _leftDetail = [[UILabel alloc] init];
        [_leftDetail setFont:[UIFont systemFontOfSize:14]];
        [_leftDetail setTextAlignment:NSTextAlignmentLeft];
        [_leftDetail setTextColor:[UIColor ph_colorWithHexString:@"#969799"]];
    }
    return _leftDetail;
}

- (UISwitch *)rightSwitch {
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch setOnTintColor:[UIColor ph_colorWithHexString:@"#3388FF"]];
        [_rightSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

- (UIView *)splitLine {
    if (!_splitLine) {
        _splitLine = [[UIView alloc] init];
        [_splitLine setBackgroundColor:[UIColor ph_colorWithHexString:@"#EBEDF0"]];
    }
    return _splitLine;
}

- (void)switchChange:(UISwitch *)switchBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(phSwitchAction:switchState:)]) {
        [self.delegate phSwitchAction:self.customModel switchState:switchBtn.on];
    }
}

@end
