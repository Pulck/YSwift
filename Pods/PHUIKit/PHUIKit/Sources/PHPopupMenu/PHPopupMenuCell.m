//
//  PHPopupMenuCell.m
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/13.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHPopupMenuCell.h"
#import "PHUtils.h"
#import "Masonry.h"

@interface PHPopupMenuCell ()

@property (nonatomic, strong) UIView * separatorView;

@end

@implementation PHPopupMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_iconImageView];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor ph_colorWithHexString:@"#262626"];
    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:_titleLabel];
    _separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    _separatorView.backgroundColor = [UIColor ph_colorWithHexString:@"#E9E9E9"];
    [self.contentView addSubview:_separatorView];
    [self viewMakeConstraints];
    
}

- (void)viewMakeConstraints {
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-30);
        make.height.mas_equalTo(24);
    }];
    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setHideImage:(BOOL)hideImage {
    _hideImage = hideImage;
    if (_hideImage) {
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(30);
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView).offset(-30);
            make.height.mas_equalTo(24);
        }];
    }
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    _separatorView.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (!self.hideImage) {
        if (self.highlighted) {
            UIView *selectedView = [[UIView alloc] initWithFrame:self.selectedBackgroundView.frame];
            selectedView.backgroundColor = [UIColor ph_colorWithHexString:@"#f5f5f5"];
            self.selectedBackgroundView = selectedView;
            [self.selectedBackgroundView ph_addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(8, 8)];
        }else{
            self.backgroundColor = [UIColor clearColor];
        }
    }
}

@end
