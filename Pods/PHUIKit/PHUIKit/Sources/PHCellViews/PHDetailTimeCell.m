//
//  PHDetailTimeCell.m
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import "PHDetailTimeCell.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "Masonry.h"

static const CGFloat kMaxTimeWidth = 213;

@interface PHDetailTimeCell ()

/**
 底部分割线
 */
@property (nonatomic, strong) UIView * splitLine;

/**
 内容竖分割线
 */
@property (nonatomic, strong) UIView * contentSplitLine;

/**
 底部内容视图
 */
@property (nonatomic, strong) UIView * bottomInfoView;

@end

@implementation PHDetailTimeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    PHDetailTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PHDetailTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.describeLbl];
        [self addSubview:self.splitLine];
        [self addSubview:self.bottomInfoView];
        [self.bottomInfoView addSubview:self.bottomText];
        [self.bottomInfoView addSubview:self.timeText];
        [self.bottomInfoView addSubview:self.otherText];
        [self.bottomInfoView addSubview:self.contentSplitLine];
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
    [self.bottomInfoView setHidden:self.hiddenBottomInfo];
    if ([NSString ph_isNilOrEmpty:self.otherText.text] || [NSString ph_isNilOrEmpty:self.timeText.text]) {
        [self.contentSplitLine setHidden:YES];
    } else {
        [self.contentSplitLine setHidden:NO];
    }
}

- (void)reLayoutControls {
    //计算描述的行数
    CGFloat detailLines = [self getMessageLines:self.describeLbl maxWidth:(self.bounds.size.width - 15 - 40)];
    //去除间隙后的底部视图的最大空间
    CGFloat maxBottomWidth = self.bounds.size.width - 30 - 16;
    CGFloat bottomTimeWidth = [self getMessageSize:self.timeText maxWidth:kMaxTimeWidth].width;
    //内容空间，去除时间和间隙后留给文字来源和其他信息的空间,均分去除时间和间隙后剩余的空间
    CGFloat bottomMaxWidth = (maxBottomWidth - bottomTimeWidth) / 2.0;
    CGFloat bottomTextWidth = [self getMessageSize:self.bottomText maxWidth:bottomMaxWidth].width;
    CGFloat bottomOtherWidth = [self getMessageSize:self.otherText maxWidth:bottomMaxWidth].width;
    //富裕空间会给与文字来源
    CGFloat freeSpace = maxBottomWidth - (bottomTextWidth + bottomTimeWidth + bottomOtherWidth);
    
    //左侧标题
    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self setUILayout:detailLines bottomTextWidth:bottomTextWidth bottomTimeWidth:bottomTimeWidth freeSpace:freeSpace];
    
    [self.contentSplitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomInfoView.mas_centerY);
        make.left.equalTo(self.timeText.mas_right).offset(3.5);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(13);
    }];
    
    [self.otherText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomInfoView);
        make.left.equalTo(self.timeText.mas_right).offset(8);
        make.right.equalTo(self.bottomInfoView.mas_right);
        make.height.mas_equalTo(18);
    }];
    
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setUILayout:(CGFloat)detailLines bottomTextWidth:(CGFloat)bottomTextWidth bottomTimeWidth:(CGFloat)bottomTimeWidth freeSpace:(CGFloat)freeSpace {
    [self.describeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
        make.height.mas_equalTo(detailLines > 1 ? 36 : 18);
    }];
    
    [self.bottomInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.describeLbl.mas_bottom).offset(8);
        make.height.mas_equalTo(18);
    }];
    
    [self.bottomText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomInfoView);
        make.left.equalTo(self.bottomInfoView.mas_left);
        make.width.mas_equalTo(bottomTextWidth + freeSpace);
        make.height.mas_equalTo(18);
    }];
    
    [self.timeText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomInfoView);
        make.left.equalTo(self.bottomText.mas_right).offset(8);
        make.width.mas_equalTo(bottomTimeWidth);
        make.height.mas_equalTo(18);
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

- (UILabel *)bottomText {
    if (!_bottomText) {
        _bottomText = [[UILabel alloc] init];
        [_bottomText setFont:[UIFont systemFontOfSize:14]];
        [_bottomText setTextAlignment:NSTextAlignmentLeft];
        [_bottomText setTextColor:[UIColor ph_colorWithHexString:@"#C8C9CC"]];
    }
    return _bottomText;
}

- (UILabel *)timeText {
    if (!_timeText) {
        _timeText = [[UILabel alloc] init];
        [_timeText setFont:[UIFont systemFontOfSize:14]];
        [_timeText setTextAlignment:NSTextAlignmentLeft];
        [_timeText setTextColor:[UIColor ph_colorWithHexString:@"#C8C9CC"]];
    }
    return _timeText;
}

- (UILabel *)otherText {
    if (!_otherText) {
        _otherText = [[UILabel alloc] init];
        [_otherText setFont:[UIFont systemFontOfSize:14]];
        [_otherText setTextAlignment:NSTextAlignmentLeft];
        [_otherText setTextColor:[UIColor ph_colorWithHexString:@"#C8C9CC"]];
    }
    return _otherText;
}

- (UIView *)bottomInfoView {
    if (!_bottomInfoView) {
        _bottomInfoView = [[UIView alloc] init];
    }
    return _bottomInfoView;
}

- (UIView *)contentSplitLine {
    if (!_contentSplitLine) {
        _contentSplitLine = [[UIView alloc] init];
        [_contentSplitLine setBackgroundColor:[UIColor ph_colorWithHexString:@"#C8C9CC"]];
    }
    return _contentSplitLine;
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
