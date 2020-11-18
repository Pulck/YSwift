//
//  PHHorizentalProgressView.m
//  PHUIKit
//
//  Created by Hu, Yuping on 2020/2/12.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHHorizentalProgressView.h"
#import "PHMacro.h"
#import "PHUtils.h"

static CGFloat txtPadding = 4; // 进度条文字和进度条的间距
static CGFloat progressDefaultH = 24; // 进度条的默认高度
static CGFloat progressDefaultW = 85; // 进度条的默认宽度

@interface PHHorizentalProgressView()
{
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *frontFillLayer;       //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
    UILabel *_contentLabel;              //中间的label
}

@end

@implementation PHHorizentalProgressView

@synthesize progressValue = _progressValue;
@synthesize lineWidth = _lineWidth;
//@synthesize lineColor = _lineColor;
@synthesize textColor = _textColor;
@synthesize textFont = _textFont;
@synthesize progressH = _progressH;
@synthesize progressW = _progressW;
@synthesize progressColor = _progressColor;
@synthesize progressBgColor = _progressBgColor;

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
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.text = @"0%";
    _contentLabel.font = [UIFont systemFontOfSize:12.0];
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel];
    
    [self.layer addSublayer:backGroundLayer];
    [self.layer addSublayer:frontFillLayer];
}

#pragma mark -子控件约束
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    //CGFloat width = self.bounds.size.width; // 控件的总宽度
    CGFloat height = self.bounds.size.height; // 控件的总高度
    if (height <= 0) {
        height = progressDefaultH; // 设置水平进度条默认高度
    }
    
    // 设置背景的线条
    CGFloat bgY = height/2.0 - self.progressH/2.0;
    CGFloat bgW = self.progressW; //width - txtW - txtPadding;
    CGRect backGroundRect = CGRectMake(0, bgY, bgW, self.progressH);
    backGroundBezierPath = [UIBezierPath bezierPathWithRoundedRect:backGroundRect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(self.progressH/2.0, self.progressH/2.0)]; // 绘制带圆角的路径
    backGroundLayer.path = backGroundBezierPath.CGPath;
    //backGroundLayer.frame = backGroundRect;
    
    // 设置前景的线条
    CGFloat frontY = height/2.0 - self.progressH/2.0;
    CGFloat frontW = self.progressValue * bgW;
    CGRect foreGroundRect = CGRectMake(0, frontY, frontW, self.progressH);
    frontFillBezierPath = [UIBezierPath bezierPathWithRoundedRect:foreGroundRect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(self.progressH/2.0, self.progressH/2.0)]; // 绘制带圆角的路径
    frontFillLayer.path = frontFillBezierPath.CGPath;
    //frontFillLayer.frame = foreGroundRect;
    
    // 设置文字的宽度
    //CGFloat txtW = [NSString ph_boundSizeWithString:_contentLabel.text font:_contentLabel.font size:CGSizeMake(CGFLOAT_MAX, height)].width; // 计算文字的宽度
    CGFloat txtW = [self getTextWidth]; // 计算文字宽度
    CGFloat txtX = bgW + txtPadding; //width - txtW; // 文字的X值
    CGRect txtFrame = CGRectMake(txtX, 0, txtW, height); // 设置文字的位置
    _contentLabel.frame = txtFrame;
    
    // 设置整个View的Frame
    CGRect oldFrame = self.frame;
    CGFloat width = bgW + txtPadding + txtW;
    self.progressViewW = width;
    self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
    
    //_contentLabel.frame = CGRectMake(0, 0, width - 4, 20);
    //_contentLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    //backGroundLayer.frame = self.bounds;
    
    //设置线宽
    frontFillLayer.lineWidth = self.lineWidth;
    backGroundLayer.lineWidth = self.lineWidth;
    //设置线条的填充颜色
    frontFillLayer.fillColor = self.progressColor.CGColor;
    //设置线条的背景颜色
    backGroundLayer.fillColor = self.progressBgColor.CGColor;
    //设置线条的文字颜色
    _contentLabel.textColor = self.textColor;
    //设置线条的文字字体
    _contentLabel.font = self.textFont;
    //刷新进度条的文字
    [self reloadTextValue];
}

/** 获取当前文字标签的宽度 */
- (CGFloat) getTextWidth {
    CGFloat height = self.bounds.size.height; // 当前视图的高度
    if (height <= 0) {
        height = progressDefaultH; // 设置水平进度条默认高度
    }
    CGFloat defaultWidth = ceilf([NSString ph_boundSizeWithString:[NSString stringWithFormat:@"%d%%", 100] font:_contentLabel.font size:CGSizeMake(CGFLOAT_MAX, height)].width);
    CGFloat actulWidth = ceilf([NSString ph_boundSizeWithString:_contentLabel.text font:_contentLabel.font size:CGSizeMake(CGFLOAT_MAX, height)].width);
    if (actulWidth > defaultWidth) {
        return actulWidth;
    } else {
        return defaultWidth;
    }
}

/** 获取当前进度条的宽度和高度 */
- (CGSize)currentSize {
    
    [self.superview layoutIfNeeded]; // 刷新父视图，获取自动布局的高度
    
    CGFloat height = self.frame.size.height;
    if (height <= 0) {
        height = progressDefaultH; // 设置水平进度条默认高度
    }
    CGFloat width = self.progressW + txtPadding + [self getTextWidth];
    if (width <= 0) {
        width = progressDefaultW; // 设置水平进度条默认宽度
    }
    return CGSizeMake(width, height);
}

#pragma mark - 设置label文字和进度的方法
- (void)setProgressValue:(CGFloat)progressValue
{
    progressValue = MAX( MIN(progressValue, 1.0), 0.0);
    _progressValue = progressValue;
    CGFloat frontY = self.bounds.size.height/2.0 - self.progressH/2.0;
    CGFloat frontW = progressValue * self.bounds.size.width;
    CGRect foreGroundRect = CGRectMake(0, frontY, frontW, self.progressH);
    frontFillBezierPath = [UIBezierPath bezierPathWithRoundedRect:foreGroundRect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(self.progressH/2.0, self.progressH/2.0)]; // 绘制带圆角的路径
    frontFillLayer.path = frontFillBezierPath.CGPath;
    [self reloadTextValue]; // 刷新当前的进度条内部的文字
}

- (CGFloat)progressValue
{
    if (_progressValue < 0) {
        _progressValue = 0;
    }
    return _progressValue;
}

/** 设置当前进度条的值 */
- (void)reloadTextValue {
    _contentLabel.text = [NSString stringWithFormat:@"%d%%", (int)(self.progressValue*100)];
}

#pragma make - 自定义进度条的属性
// 获取进度条的宽度
- (CGFloat)lineWidth {
    if (_lineWidth <= 0.001) {
        return 1;
    } else {
        return _lineWidth;
    }
}

// 设置进度条的宽度
- (void)setLineWidth:(CGFloat)lineWidth {
    if (lineWidth < 0) {
        _lineWidth = 1; // 默认线宽为 1pt
    } else {
        _lineWidth = lineWidth; // 自定义线宽
    }
    
    [self layoutSubviews]; // 刷新当前视图
}

// 获取进度条的高度
- (CGFloat)progressH {
    if (_progressH <= 0.001) {
        return 6;
    } else {
        return _progressH;
    }
}

// 设置进度条的高度
- (void)setProgressH:(CGFloat)progressH {
    if (progressH < 0) {
        _progressH = 6; // 默认高度为 6pt
    } else {
        _progressH = progressH; // 自定义高度
    }
    
    [self layoutSubviews]; // 刷新当前视图
}

// 获取进度条的宽度
- (CGFloat)progressW {
    if (_progressW <= 0.001) {
        return 50;
    } else {
        return _progressW;
    }
}

// 设置进度条的高
- (void)setProgressW:(CGFloat)progressW {
    if (progressW < 0) {
        _progressW = 50; // 默认长度为 50pt
    } else {
        _progressW = progressW; // 自定义高度
    }
    [self layoutSubviews]; // 刷新当前视图
}

// 获取进度条颜色
- (UIColor *)progressColor {
    if (!_progressColor) {
        return [UIColor ph_colorWithHexString:@"#436BFF"];
    } else {
        return _progressColor;
    }
}

// 设置进度条颜色
- (void)setProgressColor:(UIColor *)progressColor {
    if (!progressColor) {
        _progressColor = [UIColor ph_colorWithHexString:@"#436BFF"];
    } else {
        _progressColor = progressColor;
    }
    [self layoutSubviews]; // 刷新当前视图
}

// 获取进度条背景色
- (UIColor *)progressBgColor {
    if (!_progressBgColor) {
        return [UIColor ph_colorPaletteWitHexString:@"#436BFF" index:2];
    } else {
        return _progressBgColor;
    }
}

// 设置进度条背景色
- (void)setProgressBgColor:(UIColor *)progressBgColor {
    if (!progressBgColor) {
        _progressBgColor = [UIColor ph_colorPaletteWitHexString:@"#436BFF" index:2];
    } else {
        _progressBgColor = progressBgColor;
    }
    [self layoutSubviews]; // 刷新当前视图
}

// 获取文字的颜色
- (UIColor *)textColor {
    if (!_textColor) {
        return [UIColor ph_colorWithHexString:@"#8C8C8C"];
    } else {
        return _textColor;
    }
}

// 设置文字的颜色
- (void)setTextColor:(UIColor *)textColor {
    if (!textColor) {
        _textColor = [UIColor ph_colorWithHexString:@"#8C8C8C"];
    } else {
        _textColor = textColor;
    }
    
    [self layoutSubviews];  // 刷新当前视图
}

// 设置文字的字体大小
- (UIFont *)textFont {
    if (!_textFont) {
        return [UIFont systemFontOfSize:12.0];
    } else {
        return _textFont;
    }
}

- (void)setTextFont:(UIFont *)textFont {
    if (!textFont) {
        _textFont = [UIFont systemFontOfSize:12.0];
    } else {
        _textFont = textFont;
    }
    
    [self layoutSubviews]; // 刷新当前视图
}

@end
