//
//  PHCircleProgressView.m
//  PHUIKit
//
//  Created by Hu, Yuping on 2020/1/2.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHCircleProgressView.h"
#import "PHUtils.h"

static CGFloat progressDefaultH = 75; // 进度条的默认高度
static CGFloat progressDefaultW = 75; // 进度条的默认宽度

@interface PHCircleProgressView()
{
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *frontFillLayer;       //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
    UILabel *_contentLabel;              //中间的label
}

@end

@implementation PHCircleProgressView

@synthesize progressValue = _progressValue;
@synthesize lineWidth = _lineWidth;
@synthesize lineColor = _lineColor;
@synthesize textColor = _textColor;
@synthesize textFont = _textFont;
@synthesize lineBgColor = _lineBgColor;
@synthesize unitFont = _unitFont;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
        
    }
    return self;
    
}

//初始化创建图层
- (void)setUp
{
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = nil;
    
    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.fillColor = nil;
    
    //创建中间label
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.text = @"0%";
    _contentLabel.font = [UIFont systemFontOfSize:12.0];
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel];
    
    [self.layer addSublayer:backGroundLayer];
    [self.layer addSublayer:frontFillLayer];
    
    //设置颜色
    //frontFillLayer.strokeColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:0/255.0 alpha:1.0].CGColor;
    //_contentLabel.textColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:0/255.0 alpha:1.0];
    //backGroundLayer.strokeColor = [UIColor colorWithRed:190/255.0 green:255/255.0 blue:167/255.0 alpha:1.0].CGColor;
    
}

#pragma mark -子控件约束
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    if (width <= 0) {
        width = progressDefaultW;
    }
    CGFloat height = self.bounds.size.height;
    if (height <= 0) {
        height = progressDefaultH;
    }
    
    // 设置整个View的Frame
    CGRect oldFrame = self.frame;
    self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
    // 设置进度显示Label的Frame和Center
    _contentLabel.frame = CGRectMake(0, 0, width - 4, height - 4);
    _contentLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 设置背景圆弧的路径
    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:0 endAngle:M_PI*2
                                                       clockwise:YES];
    backGroundLayer.path = backGroundBezierPath.CGPath;
    
    // 设置填充圆弧的路径
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:-0.25*2*M_PI endAngle:(2*M_PI)*self.progressValue - 0.25*2*M_PI clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
    frontFillLayer.lineCap = kCALineCapRound; // 设置圆弧的两端为弧形
    
    //设置线宽
    frontFillLayer.lineWidth = self.lineWidth;
    backGroundLayer.lineWidth = self.lineWidth;
    //设置线条的填充颜色
    frontFillLayer.strokeColor = self.lineColor.CGColor;
    //设置线条的背景颜色
    backGroundLayer.strokeColor = self.lineBgColor.CGColor;
    //设置线条的文字颜色
    //_contentLabel.textColor = self.textColor;
    //设置线条的文字字体
    //_contentLabel.font = self.textFont;
    [self reloadTextValue]; // 刷新当前的文字
}

/** 获取当前进度条的宽度和高度 */
- (CGSize)currentSize {
    
    [self.superview layoutIfNeeded]; // 刷新父视图，获取自动布局的高度
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.height;
    if (height <= 0) {
        height = progressDefaultH;
    }
    if (width <= 0) {
        width = progressDefaultW;
    }
    return CGSizeMake(width, height);
}

- (void)setProgressValue:(CGFloat)progressValue
{
    progressValue = MAX( MIN(progressValue, 1.0), 0.0);
    _progressValue = progressValue;
    CGFloat width = self.bounds.size.width;
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:-0.25*2*M_PI endAngle:(2*M_PI)*progressValue - 0.25*2*M_PI clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
    [self reloadTextValue]; // 刷新当前进度条的文字
}
- (CGFloat)progressValue
{
    if (_progressValue < 0) {
        _progressValue = 0;
    }
    return _progressValue;
}

/** 设置当前进度条的富文本 */
- (void)reloadTextValue {
    NSMutableAttributedString *mutAttributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%%", (int)(self.progressValue*100)]];
    [mutAttributeStr addAttribute:NSFontAttributeName value:self.textFont range:NSMakeRange(0, mutAttributeStr.length - 1)];
    [mutAttributeStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, mutAttributeStr.length - 2)];
    [mutAttributeStr addAttribute:NSFontAttributeName value:self.unitFont range:NSMakeRange(mutAttributeStr.length - 1, 1)];
    [mutAttributeStr addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(mutAttributeStr.length - 2, mutAttributeStr.length - 1)];
    _contentLabel.attributedText = mutAttributeStr;
}

#pragma make - 自定义进度条的属性
// 获取进度条的宽度
- (CGFloat)lineWidth {
    if (_lineWidth <= 0.001) {
        return 6;
    } else {
        return _lineWidth;
    }
}

// 设置进度条的宽度
- (void)setLineWidth:(CGFloat)lineWidth {
    if (lineWidth < 0) {
        _lineWidth = 6; // 默认线宽为 6pt
    } else {
        _lineWidth = lineWidth; // 自定义线宽
    }
    
    [self layoutSubviews]; // 刷新当前视图
}

// 获取进度条颜色
- (UIColor *)lineColor {
    if (!_lineColor) {
        return [UIColor ph_colorWithHexString:@"#436BFF"];
    } else {
        return _lineColor;
    }
}

// 设置进度条的颜色
- (void)setLineColor:(UIColor *)lineColor {
    if (!lineColor) {
        _lineColor = [UIColor ph_colorWithHexString:@"#436BFF"];
    } else {
        _lineColor = lineColor;
    }
    [self layoutSubviews];  // 刷新当前视图
}

// 获取进度条的背景颜色
- (UIColor *)lineBgColor {
    if (!_lineBgColor) {
        return [UIColor ph_colorPaletteWitHexString:@"#436BFF" index:2];
    } else {
        return _lineBgColor;
    }
}

// 设置进度条的背景颜色
- (void)setLineBgColor:(UIColor *)lineBgColor {
    if (!lineBgColor) {
        _lineBgColor = [UIColor ph_colorPaletteWitHexString:@"#436BFF" index:2];
    } else {
        _lineBgColor = lineBgColor;
    }
    [self layoutSubviews]; // 刷新当前视图
}

// 获取文字的颜色
- (UIColor *)textColor {
    if (!_textColor) {
        return [UIColor ph_colorWithHexString:@"#436BFF"];
    } else {
        return _textColor;
    }
}

// 设置文字的颜色
- (void)setTextColor:(UIColor *)textColor {
    if (!textColor) {
        _textColor = [UIColor ph_colorWithHexString:@"#436BFF"];
    } else {
        _textColor = textColor;
    }
    
    [self layoutSubviews];  // 刷新当前视图
}

// 设置文字的字体大小
- (UIFont *)textFont {
    if (!_textFont) {
        return [UIFont systemFontOfSize:20.0];
    } else {
        return _textFont;
    }
}

- (void)setTextFont:(UIFont *)textFont {
    if (!textFont) {
        _textFont = [UIFont systemFontOfSize:20.0];
    } else {
        _textFont = textFont;
    }
    
    [self layoutSubviews]; // 刷新当前视图
}

// 设置%的字体大小
- (UIFont *)unitFont {
    if (!_unitFont) {
        return [UIFont systemFontOfSize:20.0];
    } else {
        return _unitFont;
    }
}

- (void)setUnitFont:(UIFont *)unitFont {
    if (!unitFont) {
        _unitFont = [UIFont systemFontOfSize:20.0];
    } else {
        _unitFont = unitFont;
    }

    [self layoutSubviews]; // 刷新当前视图
}

@end
