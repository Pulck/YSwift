//
//  PHSegmentedView.m
//  AFNetworking
//
//  Created by 朱力 on 2019/12/4.
//

#import "PHSegmentedView.h"
#import "UIColor+PH.h"
#import "UIView+PH.h"
#import "PHMacro.h"

static const CGFloat kBottomLineBottom = 0;
static const CGFloat kBottomLineHeight = 3.0;
static const CGFloat kBottomLineWidth = 18.0;
static const CGFloat kIndicatorLength = 24.0;
static const CGFloat kToLeftLength = 14.0;
static const CGFloat kTitlesFont = 15.0;
static const CGFloat kSelectMaxWidth = 20.0;
static const CGFloat kBottomLinePer = 1.0;
static const CGFloat kBottomLineCRadius = 2.0;

@interface PHSegmentedView ()
{
    UIView * ninaMaskView;
}

@property (nonatomic, strong) NSMutableArray * btnArray;
@property (nonatomic, strong) NSMutableArray * topTabArray;
@property (nonatomic, strong) UIView * topTabBottomLine;
@property (nonatomic, assign) CGFloat totalWidth;

/** 起始偏移量,为了判断滑动方向 */
@property (nonatomic, assign) CGFloat beginOffsetX;
@end

@implementation PHSegmentedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _bottomLineFromBottom = kBottomLineBottom;
    _bottomLineHeight = kBottomLineHeight;
    _bottomLineWidth = kBottomLineWidth;
    _extendedIndicatorLength = kIndicatorLength;
    _toLeftLength = kToLeftLength;
    _titlesFont = kTitlesFont;
    _selectMaxWidth = kSelectMaxWidth;
    if (@available(ios 8_2,*)) {
        _selecttitlesFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }else {
        _selecttitlesFont = [UIFont systemFontOfSize:18];
    }
    _topHeight = self.ph_height;
    _btnUnSelectColor = [UIColor ph_colorWithHexString:@"#595959"];
    _btnSelectColor = [UIColor ph_colorWithHexString:@"#262626"];
    _bottomLinePer = kBottomLinePer;
    _bottomLineColor = [UIColor ph_colorWithHexString:@"#436BFF"];
    _topTabColor = [UIColor ph_colorWithHexString:@"#ffffff"];
    _bottomLineCornerRadius = kBottomLineCRadius;
    return self;
}

#pragma mark - SetMethod
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
}

- (void)reloadTabItems:(NSArray *)newTitles {
    self.titleArray = newTitles;
    for (UIView *subView in self.topTab.subviews) {
        [subView removeFromSuperview];
    }
    _topTab.contentOffset = CGPointMake(0, 0);
    [self updateTopTabUI];
}

#pragma mark - LazyLoad

- (UIScrollView *)topTab {
    if (!_topTab) {
        _topTab = [[UIScrollView alloc] init];
        [self setTopTabDefault:_topTab];
    }
    return _topTab;
}

- (void)setTopTabDefault:(UIScrollView *)tab {
    tab.delegate = self;
    tab.backgroundColor = _topTabColor ?: [UIColor whiteColor];
    tab.tag = 917;
    tab.scrollEnabled = YES;
    tab.alwaysBounceHorizontal = YES;
    tab.showsHorizontalScrollIndicator = NO;
    tab.showsVerticalScrollIndicator = NO;
    tab.bounces = NO;
    tab.scrollsToTop = NO;
    if (@available(iOS 11.0, *)) {
        tab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)setTopTabColor:(UIColor *)topTabColor {
    _topTabColor = topTabColor;
    [self.topTab setBackgroundColor:_topTabColor];
}

#pragma mark - Load toptab
/** 设置reloadTabItems时调用 */
- (void)updateTopTabUI {
    self.topTab.frame = CGRectMake(0, 0, self.ph_width, self.topHeight);
    [self addSubview:self.topTab];
    self.btnArray = [NSMutableArray array];
    self.topTabArray = [NSMutableArray array];
    CGFloat tagTotalWidth = 0;
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self initButton:button iValue:i];
        tagTotalWidth += button.ph_width;
        if (!_topTabUnderLineHidden && i == self.baseDefaultPage) { // 滑块
            self.topTabBottomLine = [UIView new];
            self.topTabBottomLine.backgroundColor = _bottomLineColor;
            [_topTab addSubview:self.topTabBottomLine];
        }
    }
    if (self.autoFitWidth && _titleArray.count > 0) { // view宽固定，标签自动布局
        if (self.maxWidth > 0) {
            self.extendedIndicatorLength = (self.ph_width - self.maxWidth*_titleArray.count)/(_titleArray.count + 1); // 标签宽固定，根据标签个数+间距，间距自动调整
        }else {
            self.extendedIndicatorLength = (self.ph_width - tagTotalWidth)/(_titleArray.count + 1); // 根据文本宽和标签个数+间距，间距自动调整
        }
        self.toLeftLength = self.extendedIndicatorLength; // 间距与左右边距相等
    }
    [self updateViewSize];
}

- (void)initButton:(UIButton *)button iValue:(NSInteger)iValue {
    button.contentVerticalAlignment = self.contentVerticalAlignment;
    button.tag = iValue;
    button.frame = CGRectZero;
    [button setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:_titlesFont];
    [button setTitle:_titleArray[iValue] forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topTab addSubview:button];
    [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnArray addObject:button];
    if (self.autoFitWidth) {
        [button sizeToFit];
    }
}

/** UI布局 */
- (void)updateViewSize {
    self.totalWidth = self.toLeftLength;
    for (int i = 0; i < _btnArray.count; i++) {
        UIButton *button = _btnArray[i];
        [self buildButtonItemStyle:button itemIndex:i];
        [self buildButtonItemFrame:button itemIndex:i];
        self.totalWidth = button.ph_x + button.ph_width + (i == _titleArray.count - 1 ? self.toLeftLength:0); // 加上距右的间距
        if (self.autoFitWidth && i == self.baseDefaultPage) { // autoFitWidth==yes，select情况，自动放大
            CGFloat tempWith = button.ph_width;
            [button setTitleColor:_btnSelectColor forState:UIControlStateNormal];
            button.titleLabel.font = _selecttitlesFont;
//            [button sizeToFit];
            if (self.maxWidth > 0 && button.ph_width > self.maxWidth) { // maxWidth>0 && self.autoFitWidth==yes，select情况，自动放大，center不变
                button.frame = CGRectMake(button.ph_x - (self.selectMaxWidth - tempWith)/2.0, 0, self.selectMaxWidth, _topHeight);
            }else {
                button.frame = CGRectMake(button.ph_x - (button.ph_width - tempWith)/2.0, 0, button.ph_width, _topHeight);
            }
        }
        if (!_topTabUnderLineHidden && i == self.baseDefaultPage) {
            [self updateBottomLineBtnSize:button];
        }
    }
    if (self.autoFitWidth) {
        _topTab.contentSize = CGSizeMake(self.ph_width, self.ph_height);
    } else {
        _topTab.contentSize = CGSizeMake(self.totalWidth, self.ph_height);
    }
}

/**
 设置tab项的样式

 @param button tab项
 @param itemIndex tab项索引
 */
- (void)buildButtonItemStyle:(UIButton *)button itemIndex:(NSInteger)itemIndex {
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (self.autoFitWidth) { // 为了后期其他人看代码逻辑清晰，请不要合这个判断的代码
        [button setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:_titlesFont];
    }else {
        if (itemIndex == self.baseDefaultPage) {
            [button setTitleColor:_btnSelectColor forState:UIControlStateNormal];
            button.titleLabel.font = _selecttitlesFont;
        }else {
            [button setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:_titlesFont];
        }
        [button sizeToFit];
    }
}

/**
 设置tab项的位置

 @param button tab项
 @param itemIndex tab项索引
 */
- (void)buildButtonItemFrame:(UIButton *)button itemIndex:(NSInteger)itemIndex {
    if (self.autoFitWidth) {
        button.frame = CGRectMake(itemIndex * (self.ph_width / self.titleArray.count), 0, self.ph_width / self.titleArray.count, _topHeight);
    } else {
        if (self.maxWidth > 0 && button.ph_width > self.maxWidth) {
            if (itemIndex == self.baseDefaultPage && !self.autoFitWidth) { // maxWidth>0 && self.autoFitWidth==yes，先按Normal情况处理
                button.frame = CGRectMake(self.totalWidth + (itemIndex > 0 ? self.extendedIndicatorLength:0), 0, self.selectMaxWidth, _topHeight); // 对按钮进行布局
            }else {
                button.frame = CGRectMake(self.totalWidth + (itemIndex > 0 ? self.extendedIndicatorLength:0), 0, self.maxWidth, _topHeight); // 对按钮进行布局
            }
        }else {
            button.frame = CGRectMake(self.totalWidth + (itemIndex > 0 ? self.extendedIndicatorLength:0), 0, button.ph_width, _topHeight); // 对按钮进行布局
        }
    }
}

- (void)updateBottomLineBtnSize:(UIButton *)button {
    CGFloat currentTemp = button.ph_x;
    CGFloat currentWidthTemp = button.ph_width;
    if (_autoFitTitleLine) {
        self.topTabBottomLine.frame = CGRectMake(button.ph_x + (button.ph_width - button.ph_width*self.bottomLinePer)/2.0, self.ph_height - self.bottomLineFromBottom - self.bottomLineHeight, button.ph_width*self.bottomLinePer, self.bottomLineHeight);
    }else {
        self.topTabBottomLine.frame = CGRectMake(button.ph_x + (button.ph_width - self.bottomLineWidth)/2.0, self.ph_height- self.bottomLineFromBottom - self.bottomLineHeight, self.bottomLineWidth, self.bottomLineHeight);
    }
    if (_bottomLineCornerRadius > 0) {
        self.topTabBottomLine.layer.masksToBounds = YES;
        self.topTabBottomLine.layer.cornerRadius = _bottomLineCornerRadius;
    }
    if (((_topTab.contentOffset.x < currentTemp) && (currentTemp+currentWidthTemp < _topTab.contentOffset.x+self.ph_width)) || (self.autoFitWidth && self.ph_width <= PH_SCREEN_WIDTH)) {
        return;
    }
    if (currentTemp+currentWidthTemp > self.ph_width && (self.totalWidth - currentTemp < self.ph_width) && (currentTemp+currentWidthTemp > _topTab.contentOffset.x)) { // 右边出来 还可以再优化
        if (self.autoFitWidth || button.tag == _btnArray.count - 1) { // 等分模式，不需要;右滑最后一个也不需要多滑动
            _topTab.contentOffset = CGPointMake(self.totalWidth-self.ph_width, 0);
        }else {
            _topTab.contentOffset = CGPointMake(self.totalWidth-self.ph_width+_extendedIndicatorLength+10, 0); // +10的目的，让用户可以看到还有标签未显示出来
        }
    }else { // 左边出来
        if (self.autoFitWidth) { // 等分模式，不需要
            _topTab.contentOffset = CGPointMake(currentTemp, 0);
        }else {
            if (button.tag == 0) { // 第一个左边多移动一个边距，解决切换式标签距左对齐了
                _topTab.contentOffset = CGPointMake(currentTemp - _toLeftLength, 0);
            }else { // 除第一个标签外，其他最左边多移动一个tab间距
                _topTab.contentOffset = CGPointMake(currentTemp - _extendedIndicatorLength - 10, 0); // -10的目的，让用户可以看到还有标签未显示出来
            }
        }
    }
}

#pragma mark - BtnMethod
- (void)touchAction:(UIButton *)button {
    [self setSelectedIndex:button.tag animated:YES];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index > _btnArray.count - 1) {
        return;
    }
    self.baseDefaultPage = index;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateViewSize];
        }];
    }else {
        [self updateViewSize];
    }
    if (self.indexChangeBlock) {
        self.indexChangeBlock(self.baseDefaultPage);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView animated:(BOOL)animated {
    // 这个if条件的意思是scrollView的滑动不是由手指拖拽产生
    if (!scrollView.isDragging && !scrollView.isDecelerating) { return; }
    // 当滑到边界时，继续通过scrollView的bouces效果滑动时，直接return
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width-scrollView.bounds.size.width) {return;}
    // 当前偏移量
    CGFloat currentOffSetX = scrollView.contentOffset.x;
    // 偏移进度
    CGFloat offsetProgress = currentOffSetX / scrollView.bounds.size.width;
    CGFloat progress = offsetProgress - floor(offsetProgress);
    NSInteger fromIndex = 0; NSInteger toIndex = 0;
    // 初始值不要等于scrollView.contentOffset.x,因为第一次进入此方法时，scrollView.contentOffset.x的值已经有一点点偏移了，不是很准确
    self.beginOffsetX = scrollView.bounds.size.width * self.baseDefaultPage;
    // 以下注释的“拖拽”一词很准确，不可说成滑动，例如:当手指向右拖拽，还未拖到一半时就松开手，接下来scrollView则会往回滑动，这个往回，就是向左滑动，这也是_beginOffsetX不可时刻纪录的原因，如果时刻纪录，那么往回(向左)滑动时会被视为“向左拖拽”,然而，这个往回却是由“向右拖拽”而导致的
    if (currentOffSetX - self.beginOffsetX > 0) { // 向左拖拽了
        // 求商,获取上一个item的下标
        fromIndex = currentOffSetX / scrollView.bounds.size.width;
        // 当前item的下标等于上一个item的下标加1
        toIndex = toIndex >= self.titleArray.count ? fromIndex : fromIndex + 1;
    } else if (currentOffSetX - self.beginOffsetX < 0) {  // 向右拖拽了
        toIndex = currentOffSetX / scrollView.bounds.size.width;
        fromIndex = toIndex + 1; progress = 1.0 - progress;
    } else { progress = 1.0; fromIndex = self.baseDefaultPage; toIndex = fromIndex; }
    if (currentOffSetX == scrollView.bounds.size.width * fromIndex) {// 滚动停止了
        progress = 1.0; toIndex = fromIndex;
        if (self.baseDefaultPage != toIndex) { self.baseDefaultPage = toIndex; [self updateViewSize]; }
    }
    [self moveTrackerWithProgress:progress fromIndex:fromIndex toIndex:toIndex currentOffsetX:currentOffSetX beginOffsetX:self.beginOffsetX];
}

/**
 这个方法才开始真正滑动跟踪器，上面都是做铺垫
 */
- (void)moveTrackerWithProgress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex currentOffsetX:(CGFloat)currentOffsetX beginOffsetX:(CGFloat)beginOffsetX {
    
    UIButton *fromButton = _btnArray[fromIndex];
    UIButton *toButton = _btnArray[toIndex];
    
    // 2个按钮之间的距离
    CGFloat xDistance = toButton.center.x - fromButton.center.x;
    // 2个按钮宽度的差值
    CGFloat wDistance = toButton.frame.size.width - fromButton.frame.size.width;
    
    CGRect newFrame = self.topTabBottomLine.frame;
    CGPoint newCenter = self.topTabBottomLine.center;
    newCenter.x = fromButton.center.x + xDistance * progress;
    newFrame.size.width = _bottomLineWidth ? _bottomLineWidth : (fromButton.frame.size.width + wDistance * progress);
    self.topTabBottomLine.frame = newFrame;
    self.topTabBottomLine.center = newCenter;
    [self zoomForTitleWithProgress:progress fromButton:fromButton toButton:toButton];
    
}

- (void)zoomForTitleWithProgress:(CGFloat)progress fromButton:(UIButton *)fromButton toButton:(UIButton *)toButton {
    CGFloat diff = self.selecttitlesFont.pointSize/self.titlesFont - 1;
    if (diff > 0) {
        fromButton.transform = CGAffineTransformMakeScale((1 - progress) * diff + 1, (1 - progress) * diff + 1);
        toButton.transform = CGAffineTransformMakeScale(progress * diff + 1, progress * diff + 1);
    }
}

@end
