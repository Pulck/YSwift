//
//  PHButtonSegmentView.m
//  PHUIKit
//
//  Created by liangc on 2019/11/6.
//

#import "PHButtonSegmentView.h"
#import "Masonry.h"
#import "UIColor+PH.h"

@interface PHButtonSegmentView ()

// 按钮
@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;

/// 按住状态
@property (nonatomic) BOOL isLeftTouching;
@property (nonatomic) BOOL isRightTouching;

@end

@implementation PHButtonSegmentView

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认可点击
        _enable = YES;
        _isLeftTouching = NO;
        _isRightTouching = NO;
        
        // 设置默认颜色值
        _leftTitleColor = [UIColor ph_colorWithHexString:@"1A81D1" alpha:1];
        _leftDisableTitleColor = [UIColor ph_colorWithHexString:@"1A81D1" alpha:0.4];
        
        _rightTitleColor = [UIColor ph_colorWithHexString:@"FFFFFF" alpha:1];
        _rightDisableTitleColor = [UIColor ph_colorWithHexString:@"FFFFFF" alpha:0.4];
        
        _leftBackGroundColor = [UIColor ph_colorWithHexString:@"F4F5FB" alpha:1];
        _leftTouchColor = [UIColor ph_colorWithHexString:@"E5E6EC" alpha:1];
        
        _rightBackgroundColor = [UIColor ph_colorWithHexString:@"2E86F6" alpha:1];
        _rightTouchColor = [UIColor ph_colorWithHexString:@"2A78DC" alpha:1];
        
        // 布局视图
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private method

// 布局视图
- (void)setupSubviews {
    // 按钮高度与视图高度相等，宽度为视图的一半
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self);
        make.leading.equalTo(self.leftButton.mas_trailing);
        make.height.width.equalTo(self.leftButton);
    }];
}

#pragma mark - Life cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置圆角
    CGFloat cornerRadius = self.bounds.size.height / 2;
    
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

#pragma mark - Actions

// 按钮按下后松开
- (void)buttonTouchUp:(UIButton *)sender {
    // 认为按钮被选择，并且切换按钮背景色为默认颜色
    if (sender == self.leftButton) {
        self.isLeftTouching = NO;
        sender.backgroundColor = self.leftBackGroundColor;
        // 点击事件结束，让另一个按钮可点击
        self.rightButton.enabled = YES;
        // 按住过程中被切换为不可点击状态，不触发回调
        if (self.enable
            && self.delegate
            && [self.delegate respondsToSelector:@selector(didSelectLeftSegmentButton)]) {
            [self.delegate didSelectLeftSegmentButton];
        }
    } else {
        self.isRightTouching = NO;
        // 点击事件结束，让另一个按钮可点击
        sender.backgroundColor = self.rightBackgroundColor;
        // 不允许同时点击
        self.leftButton.enabled = YES;
        // 按住过程中被切换为不可点击状态，不触发回调
        if (self.enable
            && self.delegate
            && [self.delegate respondsToSelector:@selector(didSelectRightSegmentButton)]) {
            [self.delegate didSelectRightSegmentButton];
        }
    }
}

// 按钮按下
- (void)buttonTouchDown:(UIButton *)sender {
    // 切换按钮背景色为点击时的颜色
    if (sender == self.leftButton) {
        self.isLeftTouching = YES;
        sender.backgroundColor = self.leftTouchColor;
        // 不允许同时点击
        self.rightButton.enabled = NO;
    } else {
        self.isRightTouching = YES;
        sender.backgroundColor = self.rightTouchColor;
        // 不允许同时点击
        self.leftButton.enabled = NO;
    }
}
#pragma mark - Getter & Setter

// 设置左侧按钮标题
- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
}

// 设置右侧侧按钮标题
- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
}

// 设置按钮的可点击状态
- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.userInteractionEnabled = enable;
    
    if (enable) {
        [self.leftButton setTitleColor:self.leftTitleColor forState:UIControlStateNormal];
        [self.rightButton setTitleColor:self.rightTitleColor forState:UIControlStateNormal];
        
    } else {
        [self.leftButton setTitleColor:self.leftDisableTitleColor forState:UIControlStateNormal];
        [self.rightButton setTitleColor:self.rightDisableTitleColor forState:UIControlStateNormal];
    }
}

#pragma mark Color

- (void)setLeftTouchColor:(UIColor *)leftTouchColor {
    _leftTouchColor = leftTouchColor;
    if (self.isLeftTouching) {
        self.leftButton.backgroundColor = leftTouchColor;
    }
}

- (void)setLeftBackGroundColor:(UIColor *)leftBackGroundColor {
    _leftBackGroundColor = leftBackGroundColor;
    if (!self.isLeftTouching) {
        self.leftButton.backgroundColor = leftBackGroundColor;
    }
}

- (void)setRightTouchColor:(UIColor *)rightTouchColor {
    _rightTouchColor = rightTouchColor;
    if (self.isRightTouching) {
        self.rightButton.backgroundColor = rightTouchColor;
    }
}

- (void)setRightBackgroundColor:(UIColor *)rightBackgroundColor {
    _rightBackgroundColor = rightBackgroundColor;
    if (!self.isRightTouching) {
        self.rightButton.backgroundColor = rightBackgroundColor;
    }
}

- (void)setLeftTitleColor:(UIColor *)leftTitleColor {
    _leftTitleColor = leftTitleColor;
    if (self.enable) {
        [self.leftButton setTitleColor:leftTitleColor forState:UIControlStateNormal];
    }
}

- (void)setLeftDisableTitleColor:(UIColor *)leftDisableTitleColor {
    _leftDisableTitleColor = leftDisableTitleColor;
    if (!self.enable) {
        [self.leftButton setTitleColor:leftDisableTitleColor forState:UIControlStateNormal];
    }
}

- (void)setRightTitleColor:(UIColor *)rightTitleColor {
    _rightTitleColor = rightTitleColor;
    if (self.enable) {
        [self.rightButton setTitleColor:rightTitleColor forState:UIControlStateNormal];
    }
}

- (void)setRightDisableTitleColor:(UIColor *)rightDisableTitleColor {
    _rightDisableTitleColor = rightDisableTitleColor;
    if (!self.enable) {
        [self.rightButton setTitleColor:rightDisableTitleColor forState:UIControlStateNormal];
    }
}

#pragma mark  Lazy Init

- (UIButton *)leftButton {
    if (_leftButton == nil) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.backgroundColor = self.leftBackGroundColor;
        [_leftButton setTitle:@"次要操作" forState:UIControlStateNormal];
        [_leftButton setTitleColor:self.leftTitleColor  forState:UIControlStateNormal];
        
        [_leftButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = self.rightBackgroundColor;
        [_rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_rightButton setTitle:@"主要操作" forState:UIControlStateNormal];
        [_rightButton setTitleColor:self.rightTitleColor  forState:UIControlStateNormal];
        
        [_rightButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _rightButton;
}

@end
