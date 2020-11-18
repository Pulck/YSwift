//
//  YXTAddressPicker.m
//  Pods
//
//  Created by hanjun on 16/9/13.
//
//

#import "PHTimePicker.h"
#import "PHUtils.h"
#define PHAddressPickerViewHeight 216

@interface PHTimePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSString * dateString;
    NSString * headTitle;
    NSString * resultString;
    NSString * province;
    NSInteger _level1Index;
    NSInteger _level2Index;
    
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
}

@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) UIView * headView;
@property (strong, nonatomic) UIPickerView * pickerView;
@property (strong, nonatomic) UIDatePicker * datePicker;
@property (assign, nonatomic) UIView * picker;
@property (nonatomic, strong) NSArray * level1Array;
@property (nonatomic, strong) NSArray * level2Array;
@property (nonatomic, strong) NSArray * provinceArray;
@property (nonatomic, strong) NSArray * cityArray;
@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, assign) BOOL isSpecialAction;
@property (nullable, nonatomic, strong) NSDate *  minDate;
@property (nullable, nonatomic, strong) NSDate * maxDate;
@property (nonatomic, assign) PHPickerType pickerType;

@end

@implementation PHTimePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * date = [NSDate date];
        dateString = [dateFormatter stringFromDate:date];
        NSCalendar *calendar0 = [NSCalendar currentCalendar];
        NSInteger unitFlags = NSCalendarUnitYear;
        NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        startYear=1900;
        yearRange=year+10;
    }
    return self;
}

- (void)internalConfig {
    _backView = [[UIView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.6;
    [self addSubview:_backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backView addGestureRecognizer:tap];
    
    [self addSubview:self.picker];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, self.picker.frame.origin.y - 43.5, self.frame.size.width, 43.5)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(15, 0, 60, 43.5);
    self.leftBtn.backgroundColor = [UIColor clearColor];
    self.leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.leftBtn setTitleColor:[UIColor ph_colorWithHexString:self.mainColor] forState:UIControlStateNormal];
    [self.leftBtn setTitle:self.cancelStr forState:UIControlStateNormal];
    [self.leftBtn sizeToFit];
    self.leftBtn.frame = CGRectMake(20, 0, self.leftBtn.ph_width+10, 43.5);
    [self.leftBtn addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:self.leftBtn];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-200.0/2.0, 0, 200, 43.5)];
    label.font = [UIFont boldSystemFontOfSize:16];
    [label setTextColor:[UIColor ph_colorWithHexString:@"#262626"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.text= headTitle;
    [_headView addSubview:label];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width - 62 - 15, 0, 62, 43.5);
    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor ph_colorWithHexString:self.mainColor] forState:UIControlStateNormal];
    [button setTitle:self.doneStr forState:UIControlStateNormal];
    [button addTarget:self action:@selector(completionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    [self addSubview:_headView];
}

//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate {
    if (!currentDate) {
        currentDate = [NSDate date];
    }
    //获取当前时间
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:currentDate];
    
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    NSInteger second=[comps second];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    selectedSecond =second;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    if (self.pickerType == PHPickerTypeDateYMDHM) {
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
    }else if (self.pickerType == PHPickerTypeDateYMD){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
    }else if (self.pickerType == PHPickerTypeDateHM){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - 选择对应月份的天数
- (NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month {
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        day=31;
        break;
        case 4:
        case 6:
        case 9:
        case 11:
        day=30;
        break;
        case 2: {
            if(((year%4==0)&&(year%100!=0))||(year%400==0)) {
                day=29;
                break;
            } else {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

- (void)showPickerTypeWithSpecialAction:(PHPickerType)type data:(id)data title:(NSString *)title specialActionName:(NSString *)specialActionName {
    [self showPickerType:type data:data title:title];
    CGFloat btnWidth = ceilf([NSString ph_boundSizeWithString:specialActionName font:[UIFont systemFontOfSize:15] size:CGSizeMake(self.ph_width, 43.5)].width);
    [self.leftBtn setPh_width:(btnWidth < 60 ? 60 : btnWidth)];
    [self.leftBtn setTitle:specialActionName forState:UIControlStateNormal];
    self.isSpecialAction = YES;
}

- (void)showPickerType:(PHPickerType)type data:(id)data title:(NSString *)title{
    self.pickerType = type;
    headTitle = title;
    switch (type) {
        case PHPickerTypeDateYMD: {
            NSDate *normalDate = [NSDate ph_formatTimeString:(NSString *)data formatterStr:@"yyyy-MM-dd HH:mm" timeZone:nil];
            [self setCurrentDate:normalDate];
            self.picker = self.pickerView;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateString = [dateFormatter stringFromDate:normalDate];
            break;
        }
        case PHPickerTypeDateYMDHM: {
            NSDate *ymdhmDate = [NSDate ph_formatTimeString:(NSString *)data formatterStr:@"yyyy-MM-dd HH:mm" timeZone:nil];
            [self setCurrentDate:ymdhmDate];
            self.picker = self.pickerView;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            dateString = [dateFormatter stringFromDate:ymdhmDate];
            break;
        }
        case PHPickerTypeDateHM: {
            NSDate *hmDate = [NSDate ph_formatTimeString:(NSString *)data formatterStr:@"yyyy-MM-dd HH:mm" timeZone:nil];
            self.picker = self.datePicker;
            self.datePicker.datePickerMode = UIDatePickerModeTime;
            if (hmDate) {
                [self.datePicker setDate:hmDate animated:YES];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            dateString = [dateFormatter stringFromDate:hmDate];
            break;
        }
        case PHPickerTypeLevel1: {
            if ([data isKindOfClass:[NSArray class]]) {
                self.level1Array = data;
                if (self.level1Array.count > 0) {
                    resultString = self.level1Array[0];
                }
            }else{
                return;
            }
            _level1Index = 0;
            _level2Index = 0;
            self.picker = self.pickerView;
            break;
        }
        case PHPickerTypeLevel2: {
            if ([data isKindOfClass:[NSArray class]]) {
                self.level2Array = data;
                self.provinceArray = self.level2Array;
                if (self.provinceArray.count > 0) {
                    self.cityArray = self.provinceArray[0][@"children"];
                    province = self.provinceArray[0][@"name"];
                    if (self.cityArray.count > 0) {
                        resultString = [NSString stringWithFormat:@"%@ %@",province,self.cityArray[0][@"name"]];
                    }
                    _level1Index = 0;
                    _level2Index = 0;
                }
            }else{
                return;
            }
            self.picker = self.pickerView;
            break;
        }
        default:
            self.picker = self.pickerView;
            break;
    }
    
    [self internalConfig];
    [self show];
}

- (void)show {
    PH_WeakSelf
    self.hidden = NO;
    self.backView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.picker.frame = CGRectMake(0, self.frame.size.height - PHAddressPickerViewHeight, self.frame.size.width, PHAddressPickerViewHeight);
        weakSelf.headView.frame = CGRectMake(0, self.picker.frame.origin.y - 43.5, self.frame.size.width, 43.5);
        [weakSelf ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        [weakSelf.headView ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        weakSelf.backView.alpha = 0.3;
    }];
}

- (void)hide {
    PH_WeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+44, self.frame.size.width, PHAddressPickerViewHeight);
        weakSelf.headView.frame = CGRectMake(0, self.picker.frame.origin.y, self.frame.size.width, 43.5);
        [weakSelf ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        [weakSelf.headView ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(16, 16)];
        weakSelf.backView.alpha = 0;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

///选项默认值
- (void)selectFirstRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow animated:(BOOL)animated {
    if (self.pickerType==PHPickerTypeLevel1) {
        if (_level1Array.count > firstRow) {
            [self.pickerView selectRow:firstRow inComponent:0 animated:animated];
        }
    }else if (self.pickerType==PHPickerTypeLevel2) {
        if (self.provinceArray.count > firstRow) {
            [self.pickerView selectRow:firstRow inComponent:0 animated:animated];
        }
        if (self.cityArray.count > secondRow) {
            [self.pickerView selectRow:secondRow inComponent:1 animated:animated];
        }
    }
}

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    if (self.pickerType == PHPickerTypeDateYMDHM) {
        return 5;
    }else if (self.pickerType == PHPickerTypeDateYMD){
        return 3;
    }
    else if (self.pickerType == PHPickerTypeDateHM){
        return 2;
    }
    else if (self.pickerType==PHPickerTypeLevel1){
        return 1;
    }else if (self.pickerType==PHPickerTypeLevel2){
        return 2;
    }
    return 0;
}

//返回数组总数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickerType==PHPickerTypeLevel1) {
        return _level1Array.count;
    }else if (self.pickerType==PHPickerTypeLevel2){
        switch (component) {
            case 0: {
                return self.provinceArray.count;
                break;
            }
            case 1: {
                return self.cityArray.count;
                break;
            }
            default:
                break;
        }
    }else if (self.pickerType == PHPickerTypeDateYMDHM) {
        switch (component) {
            case 0: {
                return yearRange;
                break;
            }
            case 1: {
                return 12;
                break;
            }
            case 2: {
                return dayRange;
                break;
            }
            case 3: {
                return 24;
                break;
            }
            case 4: {
                return 60;
                break;
            }
            default:
                break;
        }
    }else if (self.pickerType == PHPickerTypeDateYMD){
        switch (component) {
            case 0: {
                return yearRange;
                break;
            }
            case 1: {
                return 12;
                break;
            }
            case 2: {
                return dayRange;
                break;
            }
            default:
                break;
        }
    }else if (self.pickerType == PHPickerTypeDateHM){
        switch (component) {
            case 0: {
                return yearRange;
                break;
            }
            case 1: {
                return 12;
                break;
            }
            default:
                break;
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.pickerType==PHPickerTypeLevel1) {
        return _level1Array[row];
    }else if (self.pickerType==PHPickerTypeLevel2){
        switch (component) {
            case 0: {
                return [[self.provinceArray objectAtIndex:row] objectForKey:@"name"];
                break;
            }
            case 1: {
                return [[self.cityArray objectAtIndex:row] objectForKey:@"name"];
                break;
            }
            default:
                break;
        }
    }else if (self.pickerType == PHPickerTypeDateYMDHM) {
        switch (component) {
            case 0: {
                return [NSString stringWithFormat:@"%ld%@",(long)(startYear + row),self.yearStr];
                break;
            }
            case 1: {
                return [NSString stringWithFormat:@"%ld%@",(long)row+1,self.monthStr];
                break;
            }
            case 2: {
                return [NSString stringWithFormat:@"%ld%@",(long)row+1,self.dayStr];
                break;
            }
            case 3: {
                return [NSString stringWithFormat:@"%ld%@",(long)row,self.hourStr];
                break;
            }
            case 4: {
                return [NSString stringWithFormat:@"%ld%@",(long)row,self.minuteStr];
                break;
            }
            default:
                break;
        }
    }else if (self.pickerType == PHPickerTypeDateYMD){
        switch (component) {
            case 0: {
                return [NSString stringWithFormat:@"%ld%@",(long)(startYear + row),self.yearStr];
                break;
            }
            case 1: {
                return [NSString stringWithFormat:@"%ld%@",(long)row+1,self.monthStr];
                break;
            }
            case 2: {
                return [NSString stringWithFormat:@"%ld%@",(long)row+1,self.dayStr];
                break;
            }
            default:
                break;
        }
    }else if (self.pickerType == PHPickerTypeDateHM){
        switch (component) {
            case 0: {
                return [NSString stringWithFormat:@"%ld%@",(long)(startYear + row),self.yearStr];
                break;
            }
            case 1: {
                return [NSString stringWithFormat:@"%ld%@",(long)row+1,self.monthStr];
                break;
            }
            default:
                break;
        }
    }
    return 0;
}

//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerType==PHPickerTypeLevel1) {
        if (_level1Array.count > 0) {
            resultString = _level1Array[row];
            _level1Index = row;
        }
    }else if (self.pickerType==PHPickerTypeLevel2){
        switch (component) {
                case 0:
            {
                if (self.provinceArray.count > 0 && self.cityArray.count > 0) {
                    self.cityArray = self.provinceArray[row][@"children"];
                    [thePickerView reloadComponent:1];
                    [thePickerView selectRow:0 inComponent:1 animated:YES];
                    province = self.provinceArray[row][@"name"];
                    resultString = [NSString stringWithFormat:@"%@ %@",province, self.cityArray[0][@"name"]];
                    _level1Index = row;
                    _level2Index = 0;
                }
                break;
            }
                case 1:
            {
                if (self.cityArray.count > 0) {
                    resultString = [NSString stringWithFormat:@"%@ %@",province, self.cityArray[row][@"name"]];
                    _level2Index = row;
                }
                break;
            }
            default:
                break;
        }
    }else if (self.pickerType == PHPickerTypeDateYMDHM || self.pickerType == PHPickerTypeDateYMD) {
        switch (component) {
                case 0:
            {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
                case 1:
            {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
                case 2:
            {
                selectedDay=row+1;
            }
                break;
                case 3:
            {
                selectedHour=row;
            }
                break;
                case 4:
            {
                selectedMinute=row;
            }
                break;
                
            default:
                break;
        }
        if (self.pickerType == PHPickerTypeDateYMD) {
            dateString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
        } else {
            dateString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *pickCell = (UILabel *)[thePickerView viewForRow:row forComponent:component];
        [pickCell setFont:[UIFont boldSystemFontOfSize:16.f]];
    });
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // 设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            [singleLine setPh_height:0.5];
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
//    if (row == [pickerView selectedRowInComponent:component]) {
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.f]];
//    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)completionButtonAction:(UIButton *)sender {
    if ([self anySubViewScrolling:self.picker]) { // scrollView 如果正在滚动，不处理
        return;
    }
    if (_resultCompletion) {
        if (_pickerType==PHPickerTypeDateYMD) {
            _resultCompletion(dateString);
        }else if (_pickerType==PHPickerTypeDateYMDHM) {
            _resultCompletion(dateString);
        }else if (_pickerType==PHPickerTypeDateHM) {
            _resultCompletion(dateString);
        }else{
            _resultCompletion(resultString);
        }
    }
    if (_completionBlock) {
        if (_pickerType == PHPickerTypeLevel1 || _pickerType == PHPickerTypeLevel2) {
            _completionBlock(_level1Index,_level2Index,resultString);
        }
    }
    [self hide];
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

- (void)cancleButtonAction:(UIButton *)sender {
    if (self.isSpecialAction) {
        PH_WeakSelf
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.picker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+44, self.frame.size.width, PHAddressPickerViewHeight);
            weakSelf.headView.frame = CGRectMake(0, self.picker.frame.origin.y, self.frame.size.width, 43.5);
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            weakSelf.hidden = YES;
        }];
        if (self.leftBtnBlock) {
            self.leftBtnBlock();
        }
    } else {
        [self hide];
    }
}

- (UIPickerView*)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) + PHAddressPickerViewHeight, self.frame.size.width, PHAddressPickerViewHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerView selectRow:0 inComponent:0 animated:NO];
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) + PHAddressPickerViewHeight, self.frame.size.width, PHAddressPickerViewHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        if (self.minuteIncrease == 0) {
            self.minuteIncrease = 5;
        }
        _datePicker.minuteInterval = self.minuteIncrease;
        if ([NSString ph_isNilOrEmpty:self.minStr]) {
            self.minDate = [NSDate ph_formatTimeString:@"1900-1-1" formatterStr:@"yyyy-MM-dd" timeZone:nil];
        }else{
            self.minDate = [NSDate ph_formatTimeString:self.minStr formatterStr:@"yyyy-MM-dd" timeZone:nil];
        }
        if ([NSString ph_isNilOrEmpty:self.maxStr]) {
            [NSDate ph_formatTimeString:[NSString stringWithFormat:@"%ld-1-1",yearRange] formatterStr:@"yyyy-MM-dd" timeZone:nil];
            self.maxDate = [NSDate ph_formatTimeString:[NSString stringWithFormat:@"%ld-1-1",yearRange] formatterStr:@"yyyy-MM-dd" timeZone:nil];
        }else{
            self.maxDate = [NSDate ph_formatTimeString:self.maxStr formatterStr:@"yyyy-MM-dd" timeZone:nil];
        }
        _datePicker.minimumDate = self.minDate;
        _datePicker.maximumDate = self.maxDate;
        //        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        //        _datePicker.locale = locale;
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        
    }
    return _datePicker;
}

- (void)datePickerValueChanged:(UIDatePicker *)datePiker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:self.dateFormat];
    dateString = [dateFormatter stringFromDate:datePiker.date];;
}


@end
