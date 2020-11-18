//
//  PHButton.m
//  downloadTest
//
//  Created by Tiany on 2020/2/6.
//  Copyright © 2020 yunxuetang. All rights reserved.
//

#import "PHButton.h"
#import <PHUtils/PHUtils.h>
#import <Masonry/Masonry.h>
#import "Lottie.h"

// 按钮字号
/** 大按钮通栏字号 16.0 */
static const CGFloat kBigButtonFont1        = 16.0;
///** 大按钮非通栏字号 14.0 */
//static const CGFloat kBigButtonFont2        = 14.0;
/** 中按钮字号 14.0 */
static const CGFloat kMiddleButtonFont      = 14.0;
/** 小按钮字号 12.0 */
static const CGFloat kSmallButtonFont       = 12.0;
// 按钮高度
/** 大按钮字号 44.0 */
static const CGFloat kBigButtonHeight       = 44.0;
/** 中按钮字号 36.0 */
static const CGFloat kMiddleButtonHeight    = 36.0;
/** 小按钮字号 28.0 */
static const CGFloat kSmallButtonHeight     = 28.0;
// 按钮默认主题色 (Normal)
/** 常规主题色 */
static NSString *kDefaultThemeNormalColor       = @"#436BFF";
/** 高亮主题色 */
static NSString *kDefaultThemeHighlightedColor  = @"#2E4DD9";
/** 禁用主题色 */
static NSString *kDefaultThemeDisabledColor     = @"#BDD2FF";
/** 加载主题色 */
static NSString *kDefaultThemeLoadingColor      = @"#436BFF";
// 按钮样式1主题色 (带主题色border)
/** 常规主题色 */
static NSString *kStyle1ThemeNormalColor       = @"#FFFFFF";
/** 高亮主题色 */
static NSString *kStyle1ThemeHighlightedColor  = @"#436BFF";
/** 禁用主题色 */
static NSString *kStyle1ThemeDisabledColor     = @"#FFFFFF";
/** 加载主题色 */
static NSString *kStyle1ThemeLoadingColor      = @"#FFFFFF";
//------ border color ------
/** 常规border */
static NSString *kStyle1BorderNormalColor       = @"#436BFF";
/** 高亮border */
static NSString *kStyle1BorderHighlightedColor  = @"#436BFF";
/** 禁用border */
static NSString *kStyle1BorderDisabledColor     = @"#BDD2FF";
/** 加载border */
static NSString *kStyle1BorderLoadingColor      = @"#436BFF";
// 按钮样式2主题色 (带主题色border)
/** 常规主题色 */
static NSString *kStyle2ThemeNormalColor       = @"#FFFFFF";
/** 高亮主题色 */
static NSString *kStyle2ThemeHighlightedColor  = @"#E9E9E9";
/** 禁用主题色 */
static NSString *kStyle2ThemeDisabledColor     = @"#E9E9E9";
/** 加载主题色 */
static NSString *kStyle2ThemeLoadingColor      = @"#FFFFFF";
//------ border color ------
/** 常规border */
static NSString *kStyle2BorderNormalColor       = @"#D9D9D9";
/** 高亮border */
static NSString *kStyle2BorderHighlightedColor  = @"#D9D9D9";
/** 禁用border */
static NSString *kStyle2BorderDisabledColor     = @"#E9E9E9";
/** 加载border */
static NSString *kStyle2BorderLoadingColor      = @"#D9D9D9";
//------ label color -------
static NSString *kStyle2LabelNormalColor         = @"#595959";
static NSString *kStyle2LabelHighlightedColor    = @"#595959";
static NSString *kStyle2LabelDisabledColor       = @"#BFBFBF";
static NSString *kStyle2LabelLoadingColor        = @"#BFBFBF";

// 按钮padding
/** 大按钮左右padding */
static const CGFloat kBigButtonPadding      = 45.0;
/** 中按钮左右padding */
static const CGFloat kMiddleButtonPadding   = 30.0;
/** 小按钮左右padding */
static const CGFloat kSmallButtonPadding    = 15.0;

/**
 按钮动Loading动画
 
 - PHButtonLoadingStyleWhite: 白色
 - PHButtonLoadingStyleGray: 灰色
 */
typedef NS_ENUM(NSUInteger,PHButtonLoadingStyle) {
    PHButtonLoadingStyleWhite = 0, // 白色
    PHButtonLoadingStyleGray // 灰色
};

@interface PHButton ()

/** 按钮标题 */
@property (nonatomic, strong) UILabel *btnLabel;

/** 按钮icon */
@property (nonatomic, strong) UIView *iconView;

/** 当前按钮的类型 */
@property (nonatomic, assign) PHButtonType currentButtonType;

/** 当前按钮的状态 */
@property (nonatomic, assign) PHButtonState currentButtonState;

/** 当前按钮的样式 */
@property (nonatomic, assign) PHButtonStyle currentButtonStyle;

/** 记录点击按钮的位置 */
@property (nonatomic, assign) CGPoint locationPoint;

/** 记录最大可移动的Y数值 */
@property (nonatomic, assign) CGFloat maxYMoveValue;

/** 记录最大可移动的X数值 */
@property (nonatomic, assign) CGFloat maxXMoveValue;

/** 按钮动画效果 */
@property (strong, nonatomic) LOTAnimationView *lottieAnimation;

//---------- 外部改变颜色（换肤）----------
/** 当前按钮标题颜色Noraml */
@property (nonatomic, strong) UIColor *titleColorForNormal;

/** 当前按钮标题颜色Highlighted */
@property (nonatomic, strong) UIColor *titleColorForHighlighted;

/** 当前按钮标题颜色Disabled */
@property (nonatomic, strong) UIColor *titleColorForDisabled;

/** 当前按钮标题颜色Loadding */
@property (nonatomic, strong) UIColor *titleColorForLoadding;

/** 当前按钮背景颜色Noraml */
@property (nonatomic, strong) UIColor *bgColorForNormal;

/** 当前按钮背景颜色Highlighted */
@property (nonatomic, strong) UIColor *bgColorForHighlighted;

/** 当前按钮背景颜色Disabled */
@property (nonatomic, strong) UIColor *bgColorForDisabled;

/** 当前按钮背景颜色Loadding */
@property (nonatomic, strong) UIColor *bgColorForLoadding;

@property (nonatomic, strong) LOTKeypath *keypath1;

@property (nonatomic, strong) LOTColorValueCallback *colorCallback1;

@end

@implementation PHButton

#pragma mark - 创建按钮
+ (instancetype)buttonWithType:(PHButtonType)buttonType {
    PHButton *button = [[self alloc] init];
    [button setButtonWithType:buttonType];
    return button;
}

- (instancetype)init {
    if (self = [super init]) {
        self = [self initButtonUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [self initButtonUI];
    }
    return self;
}

// 根据按钮类型初始化按钮UI
- (instancetype)initButtonUI {
    // 图标
    UIView *iconView = [[UIView alloc] init];
//    iconView.backgroundColor = [UIColor blackColor]; // 测试
    iconView.hidden = YES;
    [self addSubview:iconView];
    _iconView = iconView;
    
    // 标题
    UILabel *btnLabel = [[UILabel alloc] init];
    btnLabel.font = [UIFont systemFontOfSize:kBigButtonFont1];
    btnLabel.textColor = [UIColor ph_colorWithHexString:@"#FFFFFF"];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    btnLabel.numberOfLines = 1;
    btnLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:btnLabel];
    _btnLabel = btnLabel;
    
    // 背景
    self.backgroundColor = [UIColor ph_colorWithHexString:kDefaultThemeNormalColor];
    self.layer.cornerRadius = kBigButtonHeight * 0.5;
    
    return self;
}

- (void)setButtonWithType:(PHButtonType)buttonType {
    // 记录当前按钮类型
    _currentButtonType = buttonType;
    // 按钮类型
    switch (buttonType) {
        case PHButtonTypeBig:
        {
            self.layer.cornerRadius = kBigButtonHeight * 0.5;
            self.btnLabel.font = [UIFont systemFontOfSize:kBigButtonFont1];
        }
            break;
        case PHButtonTypeMiddle:
        {
            self.layer.cornerRadius = kMiddleButtonHeight * 0.5;
            self.btnLabel.font = [UIFont systemFontOfSize:kMiddleButtonFont];
        }
            break;
        case PHButtonTypeSmall:
        {
            self.layer.cornerRadius = kSmallButtonHeight * 0.5;
            self.btnLabel.font = [UIFont systemFontOfSize:kSmallButtonFont];
        }
            break;
    }
}

#pragma mark - 设置标题
- (void)setTitle:(nullable NSString *)title forState:(PHButtonState)state {
    _currentButtonState = state;
    // 标题赋值
    self.btnLabel.text = title;
}

- (void)setTitleColor:(nullable UIColor *)color forState:(PHButtonState)state {
    switch (state) {
        case PHButtonStateNormal:
            self.titleColorForNormal = color;
            break;
        case PHButtonStateHighlighted:
            self.titleColorForHighlighted = color;
            break;
        case PHButtonStateDisabled:
            self.titleColorForDisabled = color;
            break;
        case PHButtonStateLoading:
            self.titleColorForLoadding = color;
            break;
    }
    [self setButtonStyle:_currentButtonStyle forState:state];
}

- (void)setBackgroundColor:(nullable UIColor *)color forState:(PHButtonState)state {
    switch (state) {
        case PHButtonStateNormal:
            self.bgColorForNormal = color;
            break;
        case PHButtonStateHighlighted:
            self.bgColorForHighlighted = color;
            break;
        case PHButtonStateDisabled:
            self.bgColorForDisabled = color;
            break;
        case PHButtonStateLoading:
            self.bgColorForLoadding = color;
            break;
    }
    [self setButtonStyle:_currentButtonStyle forState:state];
}

// 设置按钮标题及背景
- (void)setButtonStyle:(PHButtonStyle)style forState:(PHButtonState)state {
    _currentButtonStyle = style;
    // 按钮样式
    switch (style) {
        case PHButtonStyleNormal:
            [self setNormalButtonProperty:state];
            break;
        case PHButtonStyleValue1:
            [self setStyle1ButtonProperty:state];
            break;
        case PHButtonStyleValue2:
            [self setStyle2ButtonProperty:state];
            break;
        case PHButtonStyleValue3:
            [self setStyle3ButtonProperty:state];
            break;
    }
}

// 设置常规按钮标题及背景
- (void)setNormalButtonProperty:(PHButtonState)state {
    switch (state) {
        case PHButtonStateNormal:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = _bgColorForNormal ?: PH_HEXString(kDefaultThemeNormalColor);
                self.btnLabel.textColor = _titleColorForNormal ?: PH_HEXString(@"#FFFFFF");
            }
        }
            break;
        case PHButtonStateHighlighted:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = _bgColorForHighlighted ?: PH_HEXString(kDefaultThemeHighlightedColor);
                self.btnLabel.textColor = _titleColorForHighlighted ?: PH_HEXString(@"#FFFFFF");
            }
        }
            break;
        case PHButtonStateDisabled:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = _bgColorForDisabled ?: PH_HEXString(kDefaultThemeDisabledColor);
                self.btnLabel.textColor = _titleColorForDisabled ?: PH_HEXString(@"#FFFFFF");
            }
        }
            break;
        case PHButtonStateLoading:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = _bgColorForLoadding ?: PH_HEXString(kDefaultThemeLoadingColor);
                self.btnLabel.textColor = _titleColorForLoadding ?: [UIColor ph_colorWithHexString:@"#FFFFFF" alpha:0.4];
            }
        }
            break;
    }
}

// 设置Style1按钮标题及背景
- (void)setStyle1ButtonProperty:(PHButtonState)state {
    switch (state) {
        case PHButtonStateNormal:
        {
            if (_currentButtonState == state) {
                if (_bgColorForNormal) {
                    self.backgroundColor = PH_HEXString(kStyle1ThemeNormalColor);
                    self.layer.borderColor = _bgColorForNormal.CGColor;
                    self.btnLabel.textColor = _bgColorForNormal;
                } else {
                    self.backgroundColor = PH_HEXString(kStyle1ThemeNormalColor);
                    self.layer.borderColor = PH_HEXString(kStyle1BorderNormalColor).CGColor;
                    self.btnLabel.textColor = _titleColorForNormal ?: PH_HEXString(kStyle1BorderNormalColor);
                }
                self.layer.borderWidth = 1.0;
            }
        }
            break;
        case PHButtonStateHighlighted:
        {
            if (_currentButtonState == state) {
                if (_bgColorForHighlighted) {
                    self.backgroundColor = _bgColorForHighlighted;
                    self.layer.borderColor = _bgColorForHighlighted.CGColor;
                } else {
                    self.backgroundColor = PH_HEXString(kStyle1ThemeHighlightedColor);
                    self.layer.borderColor = PH_HEXString(kStyle1BorderHighlightedColor).CGColor;
                }
                self.layer.borderWidth = 1.0;
                self.btnLabel.textColor = _titleColorForHighlighted ?: [UIColor whiteColor];
            }
        }
            break;
        case PHButtonStateDisabled:
        {
            if (_currentButtonState == state) {
                if (_bgColorForDisabled) {
                    self.backgroundColor = PH_HEXString(kStyle1ThemeDisabledColor);
                    self.layer.borderColor = _bgColorForDisabled.CGColor;
                    self.btnLabel.textColor = _bgColorForDisabled;
                } else {
                    self.backgroundColor = PH_HEXString(kStyle1ThemeDisabledColor);
                    self.layer.borderColor = PH_HEXString(kStyle1BorderDisabledColor).CGColor;
                    self.btnLabel.textColor = _titleColorForDisabled ?: PH_HEXString(kStyle1BorderDisabledColor);
                }
                self.layer.borderWidth = 1.0;
            }
        }
            break;
        case PHButtonStateLoading:
        {
            if (_currentButtonState == state) {
                if (_bgColorForLoadding) {
                    self.backgroundColor = PH_HEXString(kStyle1ThemeLoadingColor);
                    self.layer.borderColor = _bgColorForLoadding.CGColor;
                    self.btnLabel.textColor = _bgColorForLoadding;
                    [self setLottieColor:_bgColorForLoadding];
                } else {
                    self.backgroundColor = PH_HEXString(kStyle1ThemeLoadingColor);
                    self.layer.borderColor = PH_HEXString(kStyle1BorderLoadingColor).CGColor;
                    self.btnLabel.textColor = _titleColorForLoadding ?: PH_HEXString(kStyle1BorderLoadingColor);
                    [self setLottieColor:PH_HEXString(kStyle1BorderLoadingColor)];
                }
                self.layer.borderWidth = 1.0;
            }
//            [self setLoadingViewStyle:PHButtonLoadingStyleGray];
        }
            break;
    }
}

// 设置Style2按钮标题及背景
- (void)setStyle2ButtonProperty:(PHButtonState)state {
    switch (state) {
        case PHButtonStateNormal:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = PH_HEXString(kStyle2ThemeNormalColor);
                self.layer.borderColor = PH_HEXString(kStyle2BorderNormalColor).CGColor;
                self.layer.borderWidth = 1.0;
                self.btnLabel.textColor = _titleColorForNormal ?: PH_HEXString(kStyle2LabelNormalColor);
            }
        }
            break;
        case PHButtonStateHighlighted:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = PH_HEXString(kStyle2ThemeHighlightedColor);
                self.layer.borderColor = PH_HEXString(kStyle2ThemeHighlightedColor).CGColor;
                self.layer.borderWidth = 1.0;
                self.btnLabel.textColor = _titleColorForHighlighted ?: PH_HEXString(kStyle2LabelHighlightedColor);
            }
        }
            break;
        case PHButtonStateDisabled:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = PH_HEXString(kStyle2ThemeDisabledColor);
                self.layer.borderColor = PH_HEXString(kStyle2BorderDisabledColor).CGColor;
                self.layer.borderWidth = 1.0;
                self.btnLabel.textColor = _titleColorForDisabled ?: PH_HEXString(kStyle2LabelDisabledColor);
            }
        }
            break;
        case PHButtonStateLoading:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = PH_HEXString(kStyle2ThemeLoadingColor);
                self.layer.borderColor = PH_HEXString(kStyle2LabelLoadingColor).CGColor;
                self.layer.borderWidth = 1.0;
                self.btnLabel.textColor = _titleColorForLoadding ?: PH_HEXString(kStyle2LabelLoadingColor);
            }
        }
            break;
    }
}

// 设置Style3按钮标题及背景
- (void)setStyle3ButtonProperty:(PHButtonState)state {
    switch (state) {
        case PHButtonStateNormal:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = [UIColor whiteColor];
                self.btnLabel.textColor = _titleColorForNormal ?: PH_HEXString(kDefaultThemeNormalColor);
            }
        }
            break;
        case PHButtonStateHighlighted:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = [UIColor whiteColor];
                self.btnLabel.textColor = _titleColorForNormal ?: PH_HEXString(kDefaultThemeHighlightedColor);
            }
        }
            break;
        case PHButtonStateDisabled:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = [UIColor whiteColor];
                self.btnLabel.textColor = _titleColorForNormal ?: PH_HEXString(kDefaultThemeDisabledColor);
            }
        }
            break;
        case PHButtonStateLoading:
        {
            if (_currentButtonState == state) {
                self.backgroundColor = [UIColor whiteColor];
                self.btnLabel.textColor = _titleColorForNormal ?: PH_HEXString(kDefaultThemeLoadingColor);
            }
        }
            break;
    }
}

#pragma mark - Setter
- (void)setButtonStyle:(PHButtonStyle)buttonStyle {
    _buttonStyle = buttonStyle;
    // 设置标题上及背景样式
    [self setButtonStyle:buttonStyle forState:_currentButtonState];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    // 按钮类型
    if (enabled) {
        // 设置标题上及背景样式
        _currentButtonState = PHButtonStateNormal;
        [self setButtonStyle:_buttonStyle forState:PHButtonStateNormal];
    } else {
        // 设置标题上及背景样式
        _currentButtonState = PHButtonStateDisabled;
        [self setButtonStyle:_buttonStyle forState:PHButtonStateDisabled];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
}

#pragma mark - 设置约束
- (void)setButtonBothSidesConstraints {
    switch (_currentButtonType) {
        case PHButtonTypeBig:
        {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kBigButtonHeight);
            }];
            [self.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self.mas_left).offset(kBigButtonPadding);
                make.right.equalTo(self.mas_right).offset(-kBigButtonPadding);
            }];
        }
            break;
        case PHButtonTypeMiddle:
        {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kMiddleButtonHeight);
            }];
            [self.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self.mas_left).offset(kMiddleButtonPadding);
                make.right.equalTo(self.mas_right).offset(-kMiddleButtonPadding);
            }];
        }
            break;
        case PHButtonTypeSmall:
        {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kSmallButtonHeight);
            }];
            [self.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self.mas_left).offset(kSmallButtonPadding);
                make.right.equalTo(self.mas_right).offset(-kSmallButtonPadding);
            }];
        }
            break;
    }
}

- (void)setButtonLoadingConstraints {
    [self setButtonWithType:_currentButtonType];
    switch (_currentButtonType) {
        case PHButtonTypeBig:
        {
            self.btnLabel.hidden = NO;
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kBigButtonHeight);
            }];
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(20);
                make.centerY.equalTo(self.mas_centerY);
            }];
            [self.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self.iconView.mas_right).offset(10);
                make.centerX.equalTo(self.mas_centerX).offset(15);
            }];
            [self.lottieAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(self.iconView);
            }];
        }
            break;
        case PHButtonTypeMiddle:
        {
            self.btnLabel.hidden = NO;
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kMiddleButtonHeight);
            }];
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(20);
                make.centerY.equalTo(self.mas_centerY);
            }];
            [self.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self.iconView.mas_right).offset(10);
                make.centerX.equalTo(self.mas_centerX).offset(15);
            }];
            [self.lottieAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(self.iconView);
            }];
        }
            break;
        case PHButtonTypeSmall:
        {
            self.btnLabel.hidden = YES;
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.mas_equalTo(kSmallButtonHeight);
            }];
            [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(20);
                make.centerY.equalTo(self.mas_centerY);
                make.centerX.equalTo(self.mas_centerX);
            }];
            [self.lottieAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(self.iconView);
            }];
        }
            break;
    }
}

- (void)updateButtonConstraints {
    switch (_currentButtonState) {
        case PHButtonStateNormal:
        case PHButtonStateHighlighted:
        case PHButtonStateDisabled:
        {
            self.iconView.hidden = YES;
            // 设置按钮左右的约束
            [self setButtonBothSidesConstraints];
        }
            break;
        case PHButtonStateLoading:
        {
            self.iconView.hidden = NO;
            // 设置按钮Loading的约束
            [self setButtonLoadingConstraints];
        }
            break;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateButtonConstraints];
}

#pragma mark - 执行触发的方法
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    if (self.isEnabled == NO || self.isUserInteractionEnabled == NO) {
        return NO;
    }
    // 按钮类型
    if (_currentButtonState == PHButtonStateNormal) {
        // 设置标题上及背景样式
        _currentButtonState = PHButtonStateHighlighted;
        [self setButtonStyle:_buttonStyle forState:_currentButtonState];
        
        // 取当前point
        self.locationPoint = [touch locationInView:self];
        self.maxYMoveValue = CGRectGetMaxY(self.frame) - self.frame.size.height;
        self.maxXMoveValue = CGRectGetMaxX(self.frame) - self.frame.size.width;
    } else {
        return NO;
    }
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat originalY = self.locationPoint.y;
    CGFloat originalX = self.locationPoint.x;
    BOOL maxXMoveValue = ABS(currentPoint.x - originalX) > self.maxXMoveValue;
    BOOL maxYMoveValue = ABS(currentPoint.y - originalY) > self.maxYMoveValue;
    if (maxXMoveValue || maxYMoveValue) {
        // 设置标题上及背景样式
        _currentButtonState = PHButtonStateNormal;
        [self setButtonStyle:_buttonStyle forState:_currentButtonState];
    } else {
        // 设置标题上及背景样式
        _currentButtonState = PHButtonStateHighlighted;
        [self setButtonStyle:_buttonStyle forState:_currentButtonState];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    // 设置标题上及背景样式
    _currentButtonState = PHButtonStateNormal;
    [self setButtonStyle:_buttonStyle forState:_currentButtonState];
}

#pragma mark - Lottie换肤
- (void)setLottieColor:(UIColor *)color {
    self.keypath1 = [LOTKeypath keypathWithString:@"**.Color"];
    self.colorCallback1 = [LOTColorValueCallback withCGColor:color.CGColor];
    [self.lottieAnimation setValueDelegate:self.colorCallback1 forKeypath:self.keypath1];
}

// 白色Loading路径
- (NSString *)whiteLoadingPath {
    NSString *path = [PH_BUNDLE_FRAMEWORK(@"PHUIKit") pathForResource:@"PHButton.bundle" ofType:nil];
    return [path stringByAppendingPathComponent:@"white/data.json"];
}

-(LOTAnimationView *)lottieAnimation {
    if (!_lottieAnimation) {
        _lottieAnimation = [LOTAnimationView animationWithFilePath:[self whiteLoadingPath]];
        [_lottieAnimation play];
        [_lottieAnimation setLoopAnimation:YES];
        [self.iconView addSubview:_lottieAnimation];
    }
    return _lottieAnimation;
}



@end
