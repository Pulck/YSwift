//
//  PHPickerView.m
//  PHUIKit
//
//  Created by 秦平平 on 2019/11/4.
//

#import "PHPickerView.h"
#import "UIView+PH.h"
#import "PHUtils.h"

static float const PHPickerViewHeight =  216; /// pickview高度
static float const PHPickerCellHeight = 44; /// 单元格高度

@interface PHPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSString * headTitle; // 标题
    NSString * resultString; // 当前选中文本
    NSInteger _level1Index; // 当前选中下标
}
#pragma mark - UI
@property (nonatomic,strong) UIView *backView;  /// 遮罩层
@property (nonatomic,strong) UIView *headView;  /// 标题栏
@property (strong, nonatomic) UIPickerView *pickerView;  /// 选择视图
@property (assign, nonatomic) UIView * picker;      /// 接收视图
@property (nonatomic, strong, readwrite) UILabel * titleLabel; /// 标题
@property (nonatomic, strong, readwrite) UIButton * cancleBtn; /// 取消按钮
@property (nonatomic, strong, readwrite) UIButton * doneBtn; /// 确定按钮

#pragma mark - data
@property (nonatomic, strong) NSArray * level1Array;   /// 选择视图数据
@property (nonatomic, assign) BOOL isSpecialAction;

@end

@implementation PHPickerView

#pragma mark - Initialization
- (void)internalConfig {
    _backView = [[UIView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.4;
    [self addSubview:_backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backView addGestureRecognizer:tap];
    [self addSubview:self.picker];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, self.picker.frame.origin.y - PHPickerCellHeight, self.frame.size.width, PHPickerCellHeight)];
    _headView.backgroundColor = [UIColor ph_colorWithHexString:@"#FFFFFF"];
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBtn.frame = CGRectMake(15, 0, 60, PHPickerCellHeight);
    self.cancleBtn.backgroundColor = [UIColor clearColor];
    self.cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancleBtn setTitleColor:[UIColor ph_colorWithHexString:@"#1989FA"] forState:UIControlStateNormal];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleBtn sizeToFit];
    self.cancleBtn.frame = CGRectMake(15, 0, self.cancleBtn.ph_width + 10, PHPickerCellHeight);
    [self.cancleBtn addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:self.cancleBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-200.0/2.0, 0, 200, PHPickerCellHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor ph_colorWithHexString:@"#262626"];
    self.titleLabel.text= headTitle;
    [_headView addSubview:self.titleLabel];
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.doneBtn.frame = CGRectMake(self.frame.size.width - 62 - 15, 0, 62, PHPickerCellHeight);
    self.doneBtn.backgroundColor = [UIColor clearColor];
    self.doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.doneBtn setTitleColor:[UIColor ph_colorWithHexString:@"#1989FA"] forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(completionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:self.doneBtn];
    [self addSubview:_headView];
}

#pragma mark - 传对应的数据
- (void)showPickerWithTitle:(NSString *)title data:(NSArray *)data{
    self.isSpecialAction = YES;
    headTitle = title;
    if ([data isKindOfClass:[NSArray class]]) {
        self.level1Array = data;
        if (self.level1Array.count > 0) {
            resultString = self.level1Array[0];
        }
    }else{
        return;
    }
    _level1Index = 0;
    self.picker = self.pickerView;
    [self internalConfig];
    [self show];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
///选项默认值
- (void)selectRow:(NSInteger)row animated:(BOOL)animated {
    if (_level1Array.count > row) {
        [self.pickerView selectRow:row inComponent:0 animated:animated];
    }
}

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

//返回数组总数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return _level1Array.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _level1Array[row];
}

//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_level1Array.count > 0) {
        resultString = _level1Array[row];
        _level1Index = row;
        UILabel *pickCell = (UILabel *)[thePickerView viewForRow:row forComponent:component];
        [pickCell setFont:[UIFont boldSystemFontOfSize:16.f]];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // 设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor ph_colorWithHexString:@"#E9E9E9"];
        }
    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor ph_colorWithHexString:@"#FFFFFF"]];
        [pickerLabel setTextColor:[UIColor ph_colorWithHexString:@"#262626"]];
        [pickerLabel setFont:[UIFont systemFontOfSize:14.f]];
    }
    if (row == [pickerView selectedRowInComponent:component]) {
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.f]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return PHPickerCellHeight;
}

/// 判断是否是scrollView，且scrollView是否是正在滚动
- (BOOL)anySubViewScrolling:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Actions
- (void)completionButtonAction:(UIButton *)sender {
    if ([self anySubViewScrolling:self.picker]) { // scrollView 如果正在滚动，不处理
        return;
    }
    if (_completionBlock) {
        _completionBlock(_level1Index,resultString);
    }
    [self hide];
}

- (void)cancleButtonAction:(UIButton *)sender {
    if (self.isSpecialAction) {
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.backView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + PHPickerCellHeight, self.frame.size.width, PHPickerViewHeight);
            weakSelf.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + PHPickerCellHeight, self.frame.size.width, PHPickerViewHeight);
            weakSelf.headView.frame = CGRectMake(0, self.picker.frame.origin.y, self.frame.size.width, PHPickerCellHeight);
            self->_backView.alpha = 0;
        } completion:^(BOOL finished) {
            weakSelf.hidden = YES;
        }];
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    } else {
        [self hide];
    }
}

- (void)show {
    __weak __typeof(self) weakSelf = self;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        self->_backView.alpha = 0.4;
        weakSelf.picker.frame = CGRectMake(0, self.frame.size.height - PHPickerViewHeight - PH_iPhoneXBottomY, self.frame.size.width, PHPickerViewHeight + PH_iPhoneXBottomY);
        weakSelf.headView.frame = CGRectMake(0, self.picker.frame.origin.y - PHPickerCellHeight, self.frame.size.width, PHPickerCellHeight);
        [weakSelf ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        [weakSelf.headView ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
    }];
}

- (void)hide {
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height + PHPickerCellHeight, self.frame.size.width, PHPickerViewHeight  + PH_iPhoneXBottomY);
        weakSelf.headView.frame = CGRectMake(0, self.picker.frame.origin.y, self.frame.size.width, PHPickerCellHeight);
        [weakSelf ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        [weakSelf.headView ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        self->_backView.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

#pragma mark - Getter & Setter
- (UIPickerView*)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) + PHPickerViewHeight, self.frame.size.width, PHPickerViewHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }
    return _pickerView;
}

@end
