//
//  YXTAddressPicker.h
//  Pods
//
//  Created by hanjun on 16/9/13.
//
//  基于UIDatePicker空间，支持日期选择类型、一级选择、二级地址选择

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PHPickerType) {
    PHPickerTypeDateYMD,///日期类型（只支持 yyyy-MM-dd）默认
    PHPickerTypeDateYMDHM,//年月日,时分
    PHPickerTypeDateHM,//时分
    PHPickerTypeLevel1,///只有一级 （传入数组）
    PHPickerTypeLevel2,///有两级 （只支持component.yxt.com/v1/areas 接口返回的children =                     ();id = "0f27920d-bd9d-46e7-af7d-87c4784c9687";name = "\U5362\U6e7e\U533a 数据类型";）
};


@interface PHTimePicker : UIView

@property (nonatomic, copy) NSString * _Nullable cancelStr;
@property (nonatomic, copy) NSString * _Nullable doneStr;
@property (nonatomic, copy) NSString * _Nullable yearStr;
@property (nonatomic, copy) NSString * _Nullable monthStr;
@property (nonatomic, copy) NSString * _Nullable dayStr;
@property (nonatomic, copy) NSString * _Nullable hourStr;
@property (nonatomic, copy) NSString * _Nullable minuteStr;
@property (nonatomic, copy) NSString * _Nullable mainColor;


/**
 确定后回调（回调显示的字符，PHPickerTypeLevel2：返回的是『一级 二级』例如『上海市 南汇区』）
 */
@property (nonatomic,copy) void (^ _Nullable resultCompletion)(NSString * _Nullable result);

/**
 确定后回调 (PHPickerTypeDate 类型不支持。level1Index:一级的index,默认从0开始；level2Index:二级的index,默认从0开始；result:回调显示的字符，PHPickerTypeLevel2：返回的是『一级 二级』例如『上海市 南汇区』)
 */
@property (nonatomic,copy) void (^ _Nullable completionBlock)(NSInteger level1Index,NSInteger level2Index, NSString * _Nullable result);

/**
 PHTimePicker页面隐藏回调
 */
@property (nonatomic,copy) void (^ _Nullable cancelBlock)(void);

/**
 PHTimePicker左侧按钮回调
 */
@property (nonatomic,copy) void (^ _Nullable leftBtnBlock)(void);

/**
 当前日期格式戳
 */
@property (nullable, nonatomic, strong) NSString *dateFormat;

/**
 允许选择的最小日期，默认值：1900-1-1
 */
@property (nullable, nonatomic, copy) NSString *minStr;
/**
 允许选择的最大日期，默认值：当前年份+10
 */
@property (nullable, nonatomic, copy) NSString *maxStr;

/**
 表示选择分钟的增量，默认值：5分钟
 */
@property (nonatomic, assign) NSInteger minuteIncrease;

/**
 设置显示类型（需要和初始化一起设置）
 
 @param type PHPickerType
 @param data 数据
 @param title 标题
 @param specialActionName 特殊事件标题
 */
- (void)showPickerTypeWithSpecialAction:(PHPickerType)type data:(id _Nullable )data title:(NSString *_Nullable)title specialActionName:(NSString *_Nullable)specialActionName;

/**
 设置显示类型（需要和初始化一起设置）
 
 @param type PHPickerType
 @param data 数据
 @param title 标题
 */
- (void)showPickerType:(PHPickerType)type data:(id _Nullable )data title:(NSString *_Nullable)title;

/**
 设置默认值
 
 @param firstRow 第一列（从0开始）
 @param secondRow 第二列（只有一列传0，默认从0开始）
 @param animated animated
 */
- (void)selectFirstRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow animated:(BOOL)animated;

/**
 显示已经初始化的PHTimePicker
 */
- (void)show;

/**
 隐藏view
 */
- (void)hide;
@end
