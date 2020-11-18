//
//  PHHorizentalStableHeightProgressView.m
//  PHUIKit
//
//  Created by Hu, Yuping on 2020/8/25.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHHorizentalStableHeightProgressView.h"
#import "PHMacro.h"
#import "PHUtils.h"

static CGFloat progressDefaultH = 24; // 进度条的默认高度
static CGFloat progressDefaultW = 85; // 进度条的默认宽度

@interface PHHorizentalStableHeightProgressView ()
{
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *frontFillLayer;       //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
}
@end


@implementation PHHorizentalStableHeightProgressView

@synthesize progressValue = _progressValue;
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
    
    [self.layer addSublayer:backGroundLayer];
    [self.layer addSublayer:frontFillLayer];
}

#pragma mark -子控件约束
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width; // 控件的总宽度
    CGFloat height = self.bounds.size.height; // 控件的总高度
    if (height < 0) {
        height = progressDefaultH; // 设置水平进度条默认高度
    }
    
    // 设置背景的线条
    CGFloat bgY = 0;
    CGFloat bgW = width; //width - txtW - txtPadding;
    CGRect backGroundRect = CGRectMake(0, bgY, bgW, height);
    backGroundBezierPath = [UIBezierPath bezierPathWithRoundedRect:backGroundRect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(height/2.0, height/2.0)]; // 绘制带圆角的路径
    backGroundLayer.path = backGroundBezierPath.CGPath;
    //backGroundLayer.frame = backGroundRect;
    
    // 设置前景的线条
    CGFloat frontY = 0;
    CGFloat frontW = self.progressValue * bgW;
    CGRect foreGroundRect = CGRectMake(0, frontY, frontW, 0);
    frontFillBezierPath = [UIBezierPath bezierPathWithRoundedRect:foreGroundRect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(height, height)]; // 绘制带圆角的路径
    frontFillLayer.path = frontFillBezierPath.CGPath;
    //frontFillLayer.frame = foreGroundRect;
    
    // 设置整个View的Frame
    CGRect oldFrame = self.frame;
    self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
    
    //设置线宽
    //frontFillLayer.lineWidth = self.lineWidth;
    //backGroundLayer.lineWidth = self.lineWidth;
    //设置线条的填充颜色
    frontFillLayer.fillColor = self.progressColor.CGColor;
    //设置线条的背景颜色
    backGroundLayer.fillColor = self.progressBgColor.CGColor;
    //PHLog(@"%s, 当前的水平进度条的Bounds:%@", __FUNCTION__, NSStringFromCGRect(self.bounds));
}

/** 获取当前进度条的宽度和高度 */
- (CGSize)currentSize {
    //PHLog(@"%s, 当前的水平进度条的Bounds:%@", __FUNCTION__, NSStringFromCGRect(self.bounds));
    [self.superview layoutIfNeeded]; // 刷新父视图，获取自动布局的高度
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    if (height < 0) {
        height = progressDefaultH; // 设置水平进度条默认高度
    }
    if (width < 0) {
        width = progressDefaultW; // 设置水平进度条默认宽度
    }
    return CGSizeMake(width, height);
}

#pragma mark - 设置label文字和进度的方法
- (void)setProgressValue:(CGFloat)progressValue
{
    // 立即刷新视图获取当前View的Frame
    [self.superview setNeedsLayout];
    [self.superview setNeedsDisplay];
    [self.superview layoutIfNeeded]; // 刷新父视图，获取自动布局的高度
    //PHLog(@"%s, 当前的水平进度条的Bounds:%@", __FUNCTION__, NSStringFromCGRect(self.bounds));
    
    progressValue = MAX( MIN(progressValue, 1.0), 0.0);
    _progressValue = progressValue;
    CGFloat frontY = 0;
    CGFloat frontW = progressValue * self.bounds.size.width;
    CGFloat frontH = self.bounds.size.height;
    CGRect foreGroundRect = CGRectMake(0, frontY, frontW, frontH);
    frontFillBezierPath = [UIBezierPath bezierPathWithRoundedRect:foreGroundRect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(frontH, frontH)]; // 绘制带圆角的路径
    frontFillLayer.path = frontFillBezierPath.CGPath;
}

- (CGFloat)progressValue
{
    if (_progressValue < 0) {
        _progressValue = 0;
    }
    return _progressValue;
}

- (NSString *)progressValueStr {
    return [NSString stringWithFormat:@"%d%%", (int)(self.progressValue*100)];
}

#pragma make - 自定义进度条的属性
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

@end
