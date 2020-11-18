//
//  PHActionSheetView.m
//  FBSnapshotTestCase
//
//  Created by 秦平平 on 2019/10/31.
//

#import "PHActionSheetView.h"
#import "PHActionSheetCell.h"
#import <PHUtils/PHUtils.h>

static float const kActionSheetCellHeight = 54.f; /// cell指定高度
static float const kActionSheetX = 10.0f; /// 间隔
static float const kActionSheetHeaderHeight = 72.0f; /// 标题高度

@interface PHActionSheetView () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; /// 当前窗口
@property (nonatomic, strong) UIView *shadeView; /// 遮罩层
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; /// 点击背景阴影的手
@property (nonatomic, strong) UIView *headView; /// 标题背景视图
@property (nonatomic, strong) UIView *lineV; /// 分割线
@property (nonatomic, strong, readwrite) PHButtonPro *cancelBtn;  /// 取消按钮
@property (nonatomic, strong, readwrite) UIView *bottomView;  /// 取消按钮
@property (nonatomic, strong, readwrite) UILabel *titleLabel;  /// 标题

#pragma mark - Data
@property (nonatomic, assign) CGFloat windowWidth; /// 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; /// 窗口高度
@property (nonatomic, assign) CGFloat tableHeight; /// 窗口宽度
// Data
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSMutableArray<NSString *> *items;
@property (nonatomic, copy)   NSString *cancelTitle;

@end

@implementation PHActionSheetView

#pragma mark - Life cycle
- (instancetype)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray<NSString *> * _Nullable)otherTitles {
    if (self = [super init]) {
        self.backgroundColor = [UIColor ph_colorWithHexString:@"#F5F5F5"];
        self.title = title;
        self.cancelTitle = cancelTitle;
        self.items = [NSMutableArray arrayWithArray:otherTitles];
       [self initialize];
    }
    return self;
}

#pragma mark - Initialization
/*! @brief 初始化相关 */
- (void)initialize {
    // keyWindow
    self.keyWindow = [UIApplication sharedApplication].keyWindow;
    self.windowWidth = CGRectGetWidth(_keyWindow.bounds);
    self.windowHeight = CGRectGetHeight(_keyWindow.bounds);
    self.shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    self.shadeView.backgroundColor = [UIColor ph_colorWithHexString:@"#000000" alpha:.6f];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    // 判断是否有标题
    if (self.title && self.title.length > 0) {
        self.headView = [[UIView alloc] initWithFrame:CGRectZero];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text = self.title;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = [UIColor ph_colorWithHexString:@"#7D7E80"];
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.headView addSubview:self.titleLabel];
        self.lineV = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineV.backgroundColor = [UIColor ph_colorWithHexString:@"#E9E9E9"];
        [self.headView addSubview:self.lineV];
    }
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableHeaderView = self.headView;
    [self addSubview:self.tableView];
    //  关闭按钮
    self.cancelBtn = [[PHButtonPro alloc] initWithFrame:CGRectZero];
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelBtn setTitle:self.cancelTitle forState:(UIControlStateNormal)];
    [self.cancelBtn setTitleColor:[UIColor ph_colorWithHexString:@"#262626"] forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#262626" index:7] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#262626" index:3] forState:UIControlStateDisabled];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.cancelBtn];
    
    if (PH_Is_iPhoneX) {
        self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomView];
    }
}

/// 更新UI布局
- (void)layoutSubviews {
    [super layoutSubviews];
    [self ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
    self.headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kActionSheetHeaderHeight);
    [self.headView ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
    self.titleLabel.frame = CGRectMake(34, 16, CGRectGetWidth(self.bounds) - 68, 40);
    self.lineV.frame = CGRectMake(15, kActionSheetHeaderHeight - 0.5, CGRectGetWidth(self.bounds) - 30, 0.5);
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.tableHeight);
    [self.tableView ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
    CGFloat y = self.tableHeight > 0 ? kActionSheetX : 0;
    self.cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_tableView.frame) + y, CGRectGetWidth(self.bounds), kActionSheetCellHeight);
    if (self.otherTitleColor) {
        [self.cancelBtn setTitleColor:self.otherTitleColor forState:(UIControlStateNormal)];
    }
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(_tableView.frame) + y + kActionSheetCellHeight, CGRectGetWidth(self.bounds), PH_iPhoneXBottomY);
}

#pragma mark - Getter & Setter
- (void)setOtherTitleColor:(UIColor *)otherTitleColor{
    _otherTitleColor = otherTitleColor;
    [self setNeedsLayout];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kActionSheetCellHeight;
}

static NSString *kPopoverCellIdentifier = @"kPopoverCellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopoverCellIdentifier];
    if (!cell) {
        cell = [[PHActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPopoverCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.items[indexPath.section];
    if (self.otherTitleColor) {
        cell.titleLabel.textColor = self.otherTitleColor;
    }
    if (self.items.count-1 != indexPath.section) {
        cell.hideLine = NO;
    }else{
        cell.hideLine = YES;
    }
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     [self hide];
     if (self.itemAction) {
         self.itemAction(indexPath.section + 1, self.items[indexPath.section]);
     }
}

#pragma mark - Actions
/// 显示视图
- (void)show {
    if (self.items.count > 8) {
        self.tableHeight =  8 * kActionSheetCellHeight;
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableHeight =  self.items.count * kActionSheetCellHeight;
    }
    if (self.title && self.title.length > 0) {
        self.tableHeight = self.tableHeight + kActionSheetHeaderHeight;
    }
    self.shadeView.alpha = 0.f;
    [self.keyWindow addSubview:self.shadeView];
    // 刷新数据以获取具体的ContentSize
    [self.tableView reloadData];
    CGFloat y = self.tableHeight > 0 ? kActionSheetX : 0;
    CGFloat currentH = self.tableHeight + kActionSheetCellHeight + y;
    // 限制最高高度, 免得选项太多时超出屏幕
    if (currentH > self.windowHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        currentH = self.windowHeight;
    }
    self.frame = CGRectMake(0, self.windowHeight ,self.windowWidth, currentH + PH_iPhoneXBottomY);
    [self.keyWindow addSubview:self];
    //弹出动画
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        self.frame = CGRectMake(0, weakSelf.windowHeight - currentH - PH_iPhoneXBottomY ,weakSelf.windowWidth, currentH + PH_iPhoneXBottomY);
        weakSelf.shadeView.alpha = 1.f;
        weakSelf.cancelBtn.alpha = 1.f;
    } completion:^(BOOL finished) {

    }];
}

/// 点击外部隐藏弹窗
- (void)hide {
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.f;
        weakSelf.shadeView.alpha = 0.f;
        weakSelf.cancelBtn.alpha = 0.f;
        self.frame = CGRectMake(0, weakSelf.windowHeight, weakSelf.windowWidth, weakSelf.tableView.contentSize.height);
    } completion:^(BOOL finished) {
        [weakSelf.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/// 点击取消按钮事件
- (void)cancelBtnAction:(UIButton *)btn{
    [self hide];
    if (self.itemAction) {
        self.itemAction(0,btn.titleLabel.text);
    }
}

@end
