//
//  PHFilterView.m
//  lottie-ios
//
//  Created by Hu, Yuping on 2019/11/19.
//

#import "PHFilterView.h"
#import "PHUtils.h"
#import "Masonry.h"
#import "PHFilterTableViewCell.h"

@interface PHFilterView()<UITableViewDataSource, UITableViewDelegate>
/** 黑色的背景遮罩 */
@property (nonatomic, strong) UIView *bgView;
/** 筛选的TableView */
@property (nonatomic, strong) UITableView *phFilterTableView;
/** 当前的数据行数 */
@property (nonatomic, assign) NSUInteger rowCount;
/** 设置当前的行高 */
@property (nonatomic, assign) NSUInteger rowHeight;
@end

@implementation PHFilterView

- (void)dealloc {
    PHLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加背景遮罩
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = [UIColor ph_colorWithHexString:@"#9D9D9D" alpha:0.75];
        [self addSubview:bgView];
        self.bgView = bgView;
        // 添加背景的点击事件
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShadowBgWithGesture:)];
        bgView.userInteractionEnabled = YES;
        [bgView addGestureRecognizer:gesture];
        
        // 添加筛选列表
        UITableView *filterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            filterTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:filterTableView];
        filterTableView.dataSource = self;
        filterTableView.delegate = self;
        self.phFilterTableView = filterTableView;
        [self.phFilterTableView registerClass:[PHFilterTableViewCell class] forCellReuseIdentifier:@"phFilterView"];
        // 添加约束
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        [filterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(self.mas_height).with.multipliedBy(0.5);
        }];
    }
    return self;
}

- (instancetype)initFilterViewWithRowCount:(NSUInteger)rowCount {
    PHFilterView *filterView = [self initWithFrame:CGRectZero];
    if (filterView) {
        filterView.rowCount = rowCount;
    }
    return filterView;
}

#pragma mark - 当前的数据行数
- (NSUInteger)rowCount {
    if (_rowCount < 0) {
        _rowCount = 0;
    }
    return _rowCount;
}

- (void) resetRowCount:(NSUInteger)count {
    if (count < 0) {
        _rowCount = 0;
    } else {
        _rowCount = count;
    }
}

#pragma mark - 数据源实现方法
- (NSInteger)numberOfSectionsInPHFilterTableView:(UITableView *)phFilterTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifer = @"phFilterView";
    PHFilterTableViewCell *tableCell = (PHFilterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
    
    // 设置TableViewCell的值
    __block PHFilterTableViewCell *blockCell = tableCell;
    __block NSIndexPath *blockIndexPath = indexPath;
    __block UITableView *blockTableView = tableView;
    PHKngFilterSetCellTitleBlock filterSetTitleBlock = ^(NSString * _Nonnull title, BOOL selected, BOOL disabled) {
        if ([NSString ph_isNilOrEmpty:title]) {
            title = @"";
        }
        [blockCell setCellText:title]; // 设置标题
        // 设置当前TableViewCell是否选中
        if (selected) {
            [blockTableView selectRowAtIndexPath:blockIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [blockCell setSelected:YES animated:YES];
            [blockCell setHighlighted:YES animated:YES];
        } else {
            [blockTableView deselectRowAtIndexPath:blockIndexPath animated:YES];
            [blockCell setSelected:NO animated:YES];
            [blockCell setHighlighted:NO animated:YES];
        }
        // 设置当前TableViewCell是否禁用
        [tableCell setDisabled:disabled];
    };
    
    if (self.cellForRowBlock) { // 外部实现此回调，并把要设置的title传递进来
        self.cellForRowBlock(indexPath, filterSetTitleBlock);
    }
    
    
    // 设置cell的背景
    tableCell.selectedBackgroundView = [[UIView alloc] init];
    
    return tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rowHeight > 0) {
        return self.rowHeight;
    } else {
        return 55;
    }
}

#pragma mark - 点击事件的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHFilterTableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!tableCell.disabled) {
        if (self.didSelectCellBlock) {
            self.didSelectCellBlock(indexPath, tableCell);
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHFilterTableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!tableCell.disabled) {
        if (self.didDeslectCellBlock) {
            self.didDeslectCellBlock(indexPath, tableCell);
        }
    }
}

#pragma mark - 点击当前的遮罩时，移除当前的视图
- (void) dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.phFilterTableView.hidden = YES;
        self.bgView.hidden = YES;
    } completion:^(BOOL finished) {
        [self.phFilterTableView removeFromSuperview];
        [self.bgView removeFromSuperview];
        self.phFilterTableView = nil;
        self.bgView = nil;
        [self removeFromSuperview];
    }];
}

- (void) addToView:(UIView *)baseView inRect:(CGRect)rect withAnimation:(BOOL)animated {
    if (!baseView) { // 父视图为空时，直接返回
        return;
    }
    [baseView addSubview:self]; // 添加当前视图
    [baseView bringSubviewToFront:self];
    // 添加约束
    CGFloat marginLeft = rect.origin.x - 0;
    CGFloat marginTop = rect.origin.y - 0;
    CGFloat marginRight = rect.size.width - baseView.frame.size.width + marginLeft;
    CGFloat marginBottom = rect.size.height - baseView.frame.size.height + marginTop;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView.mas_left).with.offset(marginLeft);
        make.top.equalTo(baseView.mas_top).with.offset(marginTop);
        make.right.equalTo(baseView.mas_right).with.offset(marginRight);
        make.bottom.equalTo(baseView.mas_bottom).with.offset(marginBottom);
    }];
    
    self.phFilterTableView.hidden = YES;
    
    if (animated) { // 带动画的展示
        // 初始隐藏背景显示列表
        self.phFilterTableView.hidden = NO;
        self.bgView.hidden = YES;
        // 清除下拉列表的高度
        [self.phFilterTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
        // 添加弹性动画
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:25.0 options:0 animations:^{
            self.bgView.hidden = NO;
            [self.phFilterTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.equalTo(self.mas_height).with.multipliedBy(0.5);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    } else { // 不带动画的展示
        self.phFilterTableView.hidden = NO;
    }
    
    // 刷新当前的TableView
    [self.phFilterTableView reloadData];
}

- (void) hideShadowBgWithGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.view) {
        [self dismiss];
    }
}

- (void)registerTableCellWithClass:(Class)cellClass {
    if (!cellClass) {
        return;
    }
    [self.phFilterTableView registerClass:cellClass forCellReuseIdentifier:@"phFilterView"]; // 重新注册Cell的类型
}

@end
