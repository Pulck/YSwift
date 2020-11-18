//
//  PHFilterTableViewCell.m
//  lottie-ios
//
//  Created by Hu, Yuping on 2019/11/19.
//

#import "PHFilterTableViewCell.h"
#import "UIColor+PH.h"
#import "NSString+PH.h"
#import "Masonry.h"
#import "PHMacro.h"
#import "PHUtils.h"


static NSString  * const normalColorStr = @"#595959";      // 默认的文字颜色
static NSString  * const highlightColorStr = @"#436BFF";   // 高亮时的文字颜色
static NSString  * const disabledColorStr = @"#BFBFBF";    // 禁用时的文字颜色
static NSString  * const lineColorStr = @"#EEEEEE";        // 分割线的颜色

@interface PHFilterTableViewCell(){
    /** 默认Cell的文字颜色 */
    UIColor *_normalColor;
    /** 选中Cell时的高亮文字颜色 */
    UIColor *_highlightColor;
    /** 禁用Cell时的文字颜色 */
    UIColor *_disabledColor;
    /** 分割线的颜色 */
    UIColor *_lineColor;
}
/** Cell的标题 */
@property (nonatomic, strong) UILabel *titleLB;
/** Cell右边的指示箭头 */
@property (nonatomic, strong) UIImageView *rightArrowImgV;
/** Cell的分割线 */
@property (nonatomic, strong) UIView *lineV;
@end

@implementation PHFilterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加标题
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.textColor = [self normalColor]; // 设置的当前的字体颜色
        titleLB.font = [UIFont systemFontOfSize:16.0]; // 设置当前的字体大小
        titleLB.textAlignment = NSTextAlignmentLeft; // 设置当前的文字居中对齐
        [self addSubview:titleLB];
        self.titleLB = titleLB;
        
        // 添加右边的勾选框
        UIImageView *rightArrowImgV = [[UIImageView alloc] initWithImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_cell_selected", @"PHUIKit")];
        rightArrowImgV.hidden = YES;
        [self addSubview:rightArrowImgV];
        self.rightArrowImgV = rightArrowImgV;
        
        // 添加分割线
        UIView *lineV = [[UIView alloc] init];
        lineV.backgroundColor = [self lineColor]; // 设置当前的分割线的颜色
        [self addSubview:lineV];
        self.lineV = lineV;
        
        // 添加约束
        CGFloat leftMargin = 20;
        CGFloat imgW = 16;
        [rightArrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-leftMargin);
            make.width.height.mas_equalTo(imgW);
            make.centerY.equalTo(self);
        }];
        CGFloat lbRightMargin = 10;
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(leftMargin);
            make.right.equalTo(rightArrowImgV.mas_left).with.offset(-lbRightMargin);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(leftMargin);
            make.right.equalTo(self.mas_right).with.offset(-leftMargin);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 设置右边的选中的图标 */
- (void)setRightArrowImg:(UIImage *)image {
    if (image) {
        [self.rightArrowImgV setImage:image];
    }
}

#pragma mark - 设置选中和未选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (self.disabled) {
        self.titleLB.textColor = [self disabledColor];
        self.lineV.backgroundColor = [self lineColor];
        self.rightArrowImgV.hidden = YES;
    } else {
        if (selected) {
            self.titleLB.textColor = [self highlightColor];
            self.lineV.backgroundColor = [self lineColor];
            self.rightArrowImgV.hidden = NO;
        } else {
            self.titleLB.textColor = [self normalColor];
            self.lineV.backgroundColor = [self lineColor];
            self.rightArrowImgV.hidden = YES;
        }
    }
}

# pragma mark - 禁用当前的Cell
- (void)setDisabled:(BOOL)disabled {
    if (disabled == YES) { // 禁用当前的Cell
        _disabled = YES;
        self.titleLB.textColor = [self disabledColor];
        self.userInteractionEnabled = NO;
        self.rightArrowImgV.hidden = YES;
    } else { // 启用当前的Cell
        _disabled = NO;
        self.titleLB.textColor = [self normalColor];
        self.userInteractionEnabled = YES;
    }
}

# pragma mark - 设置Cell的标题
- (void)setCellText:(NSString *)title {
    if ([NSString ph_isNilOrEmpty:title]) {
        self.titleLB.text = @"";
    } else {
        self.titleLB.text = title;
    }
}

# pragma mark - 设置各种颜色
- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor ph_colorWithHexString:normalColorStr];
    }
    return _normalColor;
}

- (void)setNormalColor:(UIColor *)normalColor {
    if (!normalColor || ![normalColor isKindOfClass:[UIColor class]]) {
        return;
    }
    _normalColor = normalColor;
}

- (UIColor *)highlightColor {
    if (!_highlightColor) {
        _highlightColor = [UIColor ph_colorWithHexString:highlightColorStr];
    }
    return _highlightColor;
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    if (!highlightColor || ![highlightColor isKindOfClass:[UIColor class]]) {
        return;
    }
    _highlightColor = highlightColor;
}

- (UIColor *)disabledColor {
    if (!_disabledColor) {
        _disabledColor = [UIColor ph_colorWithHexString:disabledColorStr];
    }
    return _disabledColor;
}

- (void)setDisabledColor:(UIColor *)disabledColor {
    if (!disabledColor || ![disabledColor isKindOfClass:[UIColor class]]) {
        return;
    }
    _disabledColor = disabledColor;
}

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor ph_colorWithHexString:lineColorStr];
    }
    return _lineColor;
}

- (void)setLineColor:(UIColor *)lineColor {
    if (!lineColor || ![lineColor isKindOfClass:[UIColor class]]) {
        return;
    }
    _lineColor = lineColor;
}

@end
