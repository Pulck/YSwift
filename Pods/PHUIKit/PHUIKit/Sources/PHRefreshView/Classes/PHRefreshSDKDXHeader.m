//
//  PHRefreshSDKDXHeader.m
//  Masonry
//
//  Created by Hu, Yuping on 2019/11/11.
//

#import "PHRefreshSDKDXHeader.h"
#import <PHUtils/PHUtils.h>
#import <PHUtils/PHMacro.h>
#import "Lottie.h"
#import "UIColor+PH.h"
//#import "NSBundle+YXT.h"

@interface PHRefreshSDKDXHeader ()
///**
// 下拉刷新文本“正在刷新...”
// */
//@property (nonatomic, weak) UILabel *headerLabel;

/**
 下拉刷新动画“yxtsdk_tools_refresh_json”
 */
@property (nonatomic, weak) LOTAnimationView *headerLottie;

/**
 下拉刷新header contentOffset的Y （用来控制开始/暂停动画）
 */
@property (nonatomic, assign) CGFloat headerContentOffsetY;

@end

@implementation PHRefreshSDKDXHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 83;
    
    //添加下拉刷新动画
    NSString *path = [NSString stringWithFormat:@"%@/ph_refresh_view.bundle", [PH_BUNDLE_FRAMEWORK(@"PHUIKit") resourcePath]];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSBundle *mainB = [NSBundle bundleWithPath:path];
    LOTAnimationView *lottieAnimation = nil;
    if ([fm fileExistsAtPath:path]) {
        lottieAnimation = [LOTAnimationView animationNamed:@"yxtsdk_tools_refresh_json" inBundle:mainB];
    } else {
        path = [NSString stringWithFormat:@"%@/ph_refresh_view.bundle", [[NSBundle mainBundle] resourcePath]];
        mainB = [NSBundle bundleWithPath:path];
        lottieAnimation = [LOTAnimationView animationNamed:@"yxtsdk_tools_refresh_json" inBundle:mainB];
    }
    //LOTAnimationView *lottieAnimation = [LOTAnimationView animationNamed:@"yxtsdk_tools_refresh_json" inBundle:mainB];
    
    self.headerLottie = lottieAnimation;
    [self addSubview:self.headerLottie];
    [self.headerLottie play];
    [self.headerLottie setLoopAnimation:YES];
    self.headerContentOffsetY = -100;
    
    
    //    // 添加下拉刷新文本
    //    UILabel *label = [[UILabel alloc] init];
    //    label.textColor = [UIColor yxt_colorWithHexString:@"999999"];
    //    label.text = [NSBundle photo_localizedStringForKey:@"yxtsdk_tools_refresh_headerTitle"];
    //    label.textAlignment = NSTextAlignmentLeft;
    //    self.headerLabel = label;
    //    [self.headerLottie addSubview:self.headerLabel];
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.headerLottie.bounds = CGRectMake(0,0,122,73);
    self.headerLottie.center =  CGPointMake(self.mj_w * 0.5,  self.mj_h * 0.5);
    if (self.headerContentOffsetY <  self.scrollView.contentOffset.y) {
        self.headerContentOffsetY = self.scrollView.contentOffset.y;
    }
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollView.contentOffset.y < self.headerContentOffsetY && !self.headerLottie.isAnimationPlaying) {
        [self.headerLottie play];
    }else if (self.scrollView.contentOffset.y == self.headerContentOffsetY && self.headerLottie.isAnimationPlaying){
        [self.headerLottie pause];
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    //    if (pullingPercent > 1.0) { return; }
    
    //    self.headerLottie.bounds = CGRectMake(0,0,136*pullingPercent,120*pullingPercent);
    //    self.headerLottie.center = CGPointMake(self.mj_w * 0.5,  self.mj_h - self.headerLottie.mj_h/2.0-5);
    //
    //    self.headerLabel.font = [UIFont systemFontOfSize:12.0*pullingPercent];
    //    self.headerLabel.bounds = CGRectMake(0, 0, 100, 14*pullingPercent);
    //    self.headerLabel.center = CGPointMake(self.headerLottie.mj_w * 0.5+120*0.5,  self.headerLottie.mj_h - (14/2.0+6)*pullingPercent);
    
}
@end

@interface PHRefreshSDKDXSubHeader ()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/**
 下拉刷新动画“yxtsdk_tools_refreshFooter_json”
 */

@property (nonatomic, weak) LOTAnimationView *headerLottie;

/**
 下拉刷新header contentOffset的Y （用来控制开始/暂停动画）
 */
@property (nonatomic, assign) CGFloat headerContentOffsetY;

/** 刷新中的文案 */
@property (nonatomic, copy) NSString *common_loading_text;

@end

@implementation PHRefreshSDKDXSubHeader : MJRefreshHeader
- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mj_label]];
        _stateLabel.textColor = [UIColor ph_colorWithHexString:@"#8C8C8C"];
    }
    return _stateLabel;
}

- (void)prepare {
    [super prepare];
    // 设置控件的高度
    self.mj_h = 30;
    self.headerContentOffsetY = -100;
    //添加下拉刷新动画
    NSString *path = [NSString stringWithFormat:@"%@/ph_refresh_view.bundle",  [PH_BUNDLE_FRAMEWORK(@"PHUIKit") resourcePath]];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSBundle *mainB = [NSBundle bundleWithPath:path];
    LOTAnimationView *lottieAnimation = nil;
    if ([fm fileExistsAtPath:path]) {
        lottieAnimation = [LOTAnimationView animationNamed:@"yxtsdk_tools_refreshFooter_json" inBundle:mainB];
    } else {
        path = [NSString stringWithFormat:@"%@/ph_refresh_view.bundle", [[NSBundle mainBundle] resourcePath]];
        mainB = [NSBundle bundleWithPath:path];
        lottieAnimation = [LOTAnimationView animationNamed:@"yxtsdk_tools_refreshFooter_json" inBundle:mainB];
    }
    //LOTAnimationView *lottieAnimation = [LOTAnimationView animationNamed:@"yxtsdk_tools_refreshFooter_json" inBundle:mainB];
    
    // 监听状态label
    self.stateLabel.textColor = [UIColor ph_colorWithHexString:@"#8C8C8C"];
    
    self.headerLottie = lottieAnimation;
    [self addSubview:self.headerLottie];
    [self.headerLottie play];
    [self.headerLottie setLoopAnimation:YES];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.headerLottie.bounds = CGRectMake(0,0,20,20);
    self.headerLottie.center =  CGPointMake(self.mj_w * 0.5,  self.mj_h * 0.5);
    if (self.headerContentOffsetY <  self.scrollView.contentOffset.y) {
        self.headerContentOffsetY = self.scrollView.contentOffset.y;
    }
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    // 设置加载文字的状态
    if (self.state == MJRefreshStatePulling || self.state == MJRefreshStateRefreshing) {
        if (![NSString ph_isNilOrEmpty:self.stateLabel.text]) { // 若当前的上拉加载时的文案不为空，则修改加载指示符号的Frame，让动画和文案水平位置排放
            CGFloat txtWidth = [NSString ph_boundSizeWithString:self.stateLabel.text font:self.stateLabel.font size:CGSizeMake(CGFLOAT_MAX, self.mj_h)].width; // 获取文字的宽度
            CGFloat lottieW = 20; // Lottie动画的宽度
            CGFloat padding = 8; // Lottie动画和文字的间距
            CGFloat lottieX = self.mj_w/2.0 - (txtWidth + lottieW + padding)/2.0; // lottie的X值
            CGFloat lottieY = self.mj_h/2.0 - lottieW/2.0; // lottie的Y值
            CGFloat txtX = lottieX + lottieW + padding; // 文案的X值
            CGFloat txtY = 0; // 文案的Y值
            self.headerLottie.frame = CGRectMake(lottieX, lottieY, lottieW, lottieW); // 设置lottiez动画的位置
            self.stateLabel.frame = CGRectMake(txtX, txtY, txtWidth, self.mj_h); // 设置文案的位置
        }
    }else if (self.state == MJRefreshStateIdle || self.state == MJRefreshStateNoMoreData) {
        self.headerLottie.bounds = CGRectMake(0,0,20,20);
        self.headerLottie.center =  CGPointMake(self.mj_w * 0.5,  self.mj_h * 0.5);
    }
    
    // 设置当前的动画的状态
    if (self.scrollView.contentOffset.y < self.headerContentOffsetY && !self.headerLottie.isAnimationPlaying) {
        [self.headerLottie play];
    }else if (self.scrollView.contentOffset.y == self.headerContentOffsetY && self.headerLottie.isAnimationPlaying){
        [self.headerLottie pause];
    }
    
}

#pragma mark - 重载父类的设置状态的方法
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        [self.stateLabel setText:self.common_loading_text];
        [self.stateLabel setHidden:NO];
        //self.footerLottie.hidden = NO;
        //[self.footerLottie play];
        //self.stateLabel.text = self.common_loading_text;
        //[self stateLabelHidden:NO];
    } else if (state == MJRefreshStateIdle) {
        [self.stateLabel setHidden:YES];
        //self.footerLottie.hidden = YES;
        //[self.footerLottie stop];
        //self.scrollView.mj_insetB = 0;
        //[self stateLabelHidden:YES];
    }else if (state == MJRefreshStateNoMoreData) {
        [self.stateLabel setHidden:YES];
        //self.footerLottie.hidden = YES;
        //[self.footerLottie stop];
        //self.stateLabel.text = self.common_loadcomplete_text;
        //self.scrollView.mj_insetB = self.mj_h;
        //[self stateLabelHidden:NO];
    }
}

#pragma mark - 获取当前的文案
- (NSString *)common_loading_text {
    if (!_common_loading_text) {
        _common_loading_text = @"刷新中...";
    }
    return _common_loading_text;
}
@end
