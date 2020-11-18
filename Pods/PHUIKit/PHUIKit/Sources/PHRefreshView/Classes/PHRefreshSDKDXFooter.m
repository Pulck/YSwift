//
//  PHRefreshSDKDXFooter.m
//  Masonry
//
//  Created by Hu, Yuping on 2019/11/11.
//

#import "PHRefreshSDKDXFooter.h"
#import "Lottie.h"
#import "UIScrollView+MJRefresh.h"
#import "NSString+PH.h"
#import "PHMacro.h"
#import "PHUtils.h"

@interface PHRefreshSDKDXFooter()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
//    UIView *_leftLineView;
//    UIView *_rightLineView;
}
/**
 上拉刷新动画“yxtsdk_tools_refreshFooter_json”
 */
@property (nonatomic, weak) LOTAnimationView *footerLottie;

/** 一个新的拖拽 */
@property (assign, nonatomic, getter=isOneNewPan) BOOL oneNewPan;

/** 上拉加载到底了显示的文案 */
@property (nonatomic, copy) NSString *common_loadcomplete_text;
/** 上拉加载失败的文案 */
@property (nonatomic, copy) NSString *tools_refresh_label_failed_text;
/** 加载中的文案 */
@property (nonatomic, copy) NSString *common_loading_text;

@end

@implementation PHRefreshSDKDXFooter
- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mj_label]];
        _stateLabel.textColor = [UIColor ph_colorWithHexString:@"#8C8C8C"];
    }
    return _stateLabel;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;
    
    //添加下拉刷新动画
    NSString *path = [NSString stringWithFormat:@"%@/ph_refresh_view.bundle", [PH_BUNDLE_FRAMEWORK(@"PHUIKit") resourcePath]];
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
    
    self.footerLottie = lottieAnimation;
    [self addSubview:self.footerLottie];
    //    [self.footerLottie play];
    [self.footerLottie setLoopAnimation:YES];
    
    // 监听label
    self.stateLabel.textColor = [UIColor ph_colorWithHexString:@"#8C8C8C"];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
//    lineView.frame = CGRectMake(0, 0, 63, 0.5);
//    _leftLineView.hidden = YES;
//    _leftLineView = lineView;
//    [self addSubview:_leftLineView];
//
//    UIView *lineView1 = [[UIView alloc] init];
//    lineView1.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
//    lineView1.frame = CGRectMake(0, 0, 63, 0.5);
//    _rightLineView.hidden = YES;
//    _rightLineView = lineView1;
//    [self addSubview:_rightLineView];
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.state == MJRefreshStatePulling || self.state == MJRefreshStateRefreshing) {
        if (![NSString ph_isNilOrEmpty:self.stateLabel.text]) { // 若当前的上拉加载时的文案不为空，则修改加载指示符号的Frame，让动画和文案水平位置排放
            CGFloat txtWidth = [NSString ph_boundSizeWithString:self.stateLabel.text font:self.stateLabel.font size:CGSizeMake(CGFLOAT_MAX, self.mj_h)].width; // 获取文字的宽度
            CGFloat lottieW = 20; // Lottie动画的宽度
            CGFloat padding = 8; // Lottie动画和文字的间距
            CGFloat lottieX = self.mj_w/2.0 - (txtWidth + lottieW + padding)/2.0; // lottie的X值
            CGFloat lottieY = self.mj_h/2.0 - lottieW/2.0; // lottie的Y值
            CGFloat txtX = lottieX + lottieW + padding; // 文案的X值
            CGFloat txtY = 0; // 文案的Y值
            self.footerLottie.frame = CGRectMake(lottieX, lottieY, lottieW, lottieW); // 设置lottiez动画的位置
            self.stateLabel.frame = CGRectMake(txtX, txtY, txtWidth, self.mj_h); // 设置文案的位置
        }
    }else if (self.state == MJRefreshStateIdle || self.state == MJRefreshStateNoMoreData) {
        self.footerLottie.bounds = CGRectMake(0,0,20,20);
        self.footerLottie.center =  CGPointMake(self.mj_w * 0.5,  self.mj_h * 0.5);
        
        if (self.stateLabel.constraints.count) return;
        // 状态标签
        self.stateLabel.frame = self.bounds;
//        CGFloat widthTemp = [NSString ph_boundSizeWithString:self.stateLabel.text font:self.stateLabel.font size:CGSizeMake(CGFLOAT_MAX, self.mj_h)].width;
//        _rightLineView.mj_y = self.mj_h/2.0;
//        _rightLineView.mj_x = self.mj_w/2.0 + widthTemp/2.0 +15; // 右边按钮布局
//        _leftLineView.mj_y = self.mj_h/2.0;
//        _leftLineView.mj_x = self.mj_w/2.0 - widthTemp/2.0 - 15 - _leftLineView.mj_w; // 左边按钮布局
    }
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        self.footerLottie.hidden = NO;
        [self.footerLottie play];
        self.stateLabel.text = self.common_loading_text;
        [self stateLabelHidden:NO];
    } else if (state == MJRefreshStateIdle) {
        self.footerLottie.hidden = YES;
        [self.footerLottie stop];
        self.scrollView.mj_insetB = 0;
        [self stateLabelHidden:YES];
    }else if (state == MJRefreshStateNoMoreData) {
        self.footerLottie.hidden = YES;
        [self.footerLottie stop];
        self.stateLabel.text = self.common_loadcomplete_text;
        self.scrollView.mj_insetB = self.mj_h;
        [self stateLabelHidden:NO];
    }
}

#pragma mark - 公共方法
- (void)ph_refreshFailture
{
    [super ph_refreshFailture];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MJRefreshStateIdle;
        self.stateLabel.text = self.tools_refresh_label_failed_text;
        self.scrollView.mj_insetB = self.mj_h;
        [self stateLabelHidden:NO];
    });
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == MJRefreshStateIdle) {
        self.scrollView.mj_insetB = 0;
        [self stateLabelHidden:YES];
        [self beginRefreshing];
    }
}

- (void)stateLabelHidden:(BOOL)hidden {
    [self.stateLabel setHidden:hidden];
    if (self.state == MJRefreshStateNoMoreData) {
//        _rightLineView.hidden = NO;
//        _leftLineView.hidden = NO;
        [self.stateLabel setUserInteractionEnabled:NO];
    }else {
//        _rightLineView.hidden = YES;
//        _leftLineView.hidden = YES;
        [self.stateLabel setUserInteractionEnabled:YES];
    }
}

#pragma mark - Get方法
- (NSString *)common_loadcomplete_text {
    if (!_common_loadcomplete_text) {
        _common_loadcomplete_text = @"我是有底线的";
    }
    return _common_loadcomplete_text;
}

- (NSString *)tools_refresh_label_failed_text {
    if (!_tools_refresh_label_failed_text) {
        _tools_refresh_label_failed_text = @"加载失败，点我重试吧";
    }
    return _tools_refresh_label_failed_text;
}

- (NSString *)common_loading_text {
    if (!_common_loading_text) {
        _common_loading_text = @"加载中...";
    }
    return _common_loading_text;
}

@end
