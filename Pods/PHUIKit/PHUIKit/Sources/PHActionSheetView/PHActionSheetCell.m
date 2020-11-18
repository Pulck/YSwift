//
//  PHActionSheetCell.m
//  PHUIKit
//
//  Created by 秦平平 on 2020/2/11.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHActionSheetCell.h"
#import <Masonry/Masonry.h>
#import <PHUtils/PHUtils.h>

@interface PHActionSheetCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation PHActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor ph_colorWithHexString:@"#262626"];
    [self.contentView addSubview:self.titleLabel];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor ph_colorWithHexString:@"#E9E9E9"];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    self.lineView.hidden = _hideLine;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
