//
//  PHSegmentedControl.h
//  PHSegmentedControl
//
//  Created by 朱力 on 2019/12/4.
//

#import <UIKit/UIKit.h>

@class PHSegmentedControl;

typedef void (^IndexChangeBlock)(NSInteger index);
typedef NSAttributedString *(^YXTTitleFormatterBlock)(PHSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected);
/// 指示器的类型
typedef NS_ENUM(NSInteger, PHSegmentedControlSelectionStyle) {
    PHSegmentedControlSelectionStyleTextWidthStripe, // 指示器的宽度和文字的宽度相同
    PHSegmentedControlSelectionStyleFullWidthStripe, // 指示器的宽度和segment的宽度相同
    PHSegmentedControlSelectionStyleBox, // 覆盖整个segment的矩形
    PHSegmentedControlSelectionStyleArrow, // 三角小箭头 ，三角的方向取决于HMSegmentedControlSelectionIndicatorLocation
};

/// 指示器的位置
typedef NS_ENUM(NSInteger, PHSegmentedControlSelectionIndicatorLocation) {
    PHSegmentedControlSelectionIndicatorLocationUp,
    PHSegmentedControlSelectionIndicatorLocationDown,
	PHSegmentedControlSelectionIndicatorLocationNone // 不显示指示器
};

typedef NS_ENUM(NSInteger, PHSegmentedControlSegmentWidthStyle) {
    PHSegmentedControlSegmentWidthStyleFixed, // Segment 宽度平分
    PHSegmentedControlSegmentWidthStyleDynamic, // Segment 宽度等于文字的宽度 包含 inset
};

typedef NS_OPTIONS(NSInteger, PHSegmentedControlBorderType) {
    PHSegmentedControlBorderTypeNone = 0,
    PHSegmentedControlBorderTypeTop = (1 << 0),
    PHSegmentedControlBorderTypeLeft = (1 << 1),
    PHSegmentedControlBorderTypeBottom = (1 << 2),
    PHSegmentedControlBorderTypeRight = (1 << 3)
};

/// 数值为 -1 表示不选中任意 segment
enum {
    PHSegmentedControlNoSegment = -1   // Segment index for no selected segment
};

/**
 Segment 类型
 - HMSegmentedControlTypeText:          文字类型 （默认）
 - HMSegmentedControlTypeImages:        图片类型
 - HMSegmentedControlTypeTextImages:    图文类型
 */
typedef NS_ENUM(NSInteger, PHSegmentedControlType) {
    PHSegmentedControlTypeText,
    PHSegmentedControlTypeImages,
	PHSegmentedControlTypeTextImages
};

/**
 图片位置
 */
typedef NS_ENUM(NSInteger, PHSegmentedControlImagePosition) {
    PHSegmentedControlImagePositionBehindText, // <图片在文字后面（文字和图片重叠）
    PHSegmentedControlImagePositionLeftOfText, // <图片在文字左面
    PHSegmentedControlImagePositionRightOfText, // <图片在文字右面
    PHSegmentedControlImagePositionAboveText, // <图片在文字上面
    PHSegmentedControlImagePositionBelowText // <图片在文字下面
};

@interface PHSegmentedControl : UIControl

@property (nonatomic, strong) NSArray<NSString *> *secTitles;
@property (nonatomic, strong) NSArray<UIImage *> *secImgs;
@property (nonatomic, strong) NSArray<UIImage *> *selImgs;

/**
 点击回调函数 替代 addTarget:action:forControlEvents:
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;

/**
 用于自定义标题样式
 根据现有title 返回一个NSAttributedString
 */
@property (nonatomic, copy) YXTTitleFormatterBlock titleFormatter;

/**
 设置未选中状态的文本样式
 */
@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;

/*
 设置未选中状态的文本样式
 
 Attributes not set in this dictionary are inherited from `titleTextAttributes`.
 */
@property (nonatomic, strong) NSDictionary *selectedTitleTextAttributes UI_APPEARANCE_SELECTOR;

/**
 Segmented control 背景颜色
 
 Default is `[UIColor whiteColor]`
 */
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/**
 选中时指示器的颜色
 
 Default is `R:52, G:181, B:229`
 */
@property (nonatomic, strong) UIColor *selectionIndicatorColor UI_APPEARANCE_SELECTOR;

/**
 选中时指示器的矩形的颜色
 
 Default is selectionIndicatorColor
 */
@property (nonatomic, strong) UIColor *selectionIndicatorBoxColor UI_APPEARANCE_SELECTOR;

/**
 segments 之间 间隔线的颜色
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *verticalDividerColor UI_APPEARANCE_SELECTOR;

/**
 矩形指示器色块的透明度
 
 Default is `0.2f`
 */
@property (nonatomic) CGFloat selCurBoxOpacity;

/**
 segments 之间竖线的宽度
 
 Default is `1.0f`
 */
@property (nonatomic, assign) CGFloat verticalDividerWidth;

/**
 指定 SegmentControl 样式
 
 Default is `PHSegmentedControlTypeText`
 */
@property (nonatomic, assign) PHSegmentedControlType type;

/**
 指定 指示器的样式
 
 Default is `PHSegmentedControlSelectionStyleTextWidthStripe`
 */
@property (nonatomic, assign) PHSegmentedControlSelectionStyle selectionStyle;

/**
 指定 segment 的宽度计算样式
 
 Default is `PHSegmentedControlSegmentWidthStyleFixed` 默认平分宽度
 */
@property (nonatomic, assign) PHSegmentedControlSegmentWidthStyle segmentWidthStyle;

/**
 选择指示器的位置
 
 Default is `PHSegmentedControlSelectionIndicatorLocationUp`
 */
@property (nonatomic, assign) PHSegmentedControlSelectionIndicatorLocation selCursorSite;

/*
 指定 border 样式
 
 Default is `PHSegmentedControlBorderTypeNone`
 */
@property (nonatomic, assign) PHSegmentedControlBorderType borderType;

/**
 指定图片位置 仅对HMSegmentedControlTypeTextImages类型的设置有效
 
 Default is `PHSegmentedControlImagePositionBehindText` 默认文字覆盖在图片上
 */
@property (nonatomic) PHSegmentedControlImagePosition imagePosition;

/**
 指定图片和文字之间的间距 仅对HMSegmentedControlTypeTextImages类型的设置有效
 
 Default is `0,0`
 */
@property (nonatomic) CGFloat textImageSpacing;

/**
 指定 border 的颜色
 
 Default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 指定border的宽度
 
 Default is `1.0f`
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 Default is YES. 设置是否准许用户拖拽
 */
@property(nonatomic, getter = isUserDraggable) BOOL userDraggable;

/**
 Default is YES. Set to NO to deny any touch events by the user.
 */
@property(nonatomic, getter = isTouchEnabled) BOOL touchEnabled;

/**
 区分指示符是否仅文字长度。
 */
@property(nonatomic, assign) BOOL isTextWidth;

/**
 是否显示 segments 之间的竖线
 默认为 NO
 */
@property(nonatomic, getter = isVerticalDividerEnabled) BOOL verticalDividerEnabled;

@property (nonatomic, getter=shouldStretchSegmentsToScreenSize) BOOL stretchSegmentsToScreenSize;

/**
 选中 segment 的 index
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/**
 指示器的高度
 Height of the selection indicator. Only effective when `PHSegmentedControlSelectionStyle` is either `PHSegmentedControlSelectionStyleTextWidthStripe` or `PHSegmentedControlSelectionStyleFullWidthStripe`.
 
 Default is 5.0
 */
@property (nonatomic, readwrite) CGFloat selCursorHeight;

/**
 指示器圆角
 */
@property (nonatomic, assign) BOOL indicatorCorner;

/**
 box 圆角（背景）
 */
@property (nonatomic, assign) BOOL boxCorner;

/**
 Edge insets for the selection indicator.
 NOTE: This does not affect the bounding box of PHSegmentedControlSelectionStyleBox
 
 When PHSegmentedControlSelectionIndicatorLocationUp is selected, bottom edge insets are not used
 
 When PHSegmentedControlSelectionIndicatorLocationDown is selected, top edge insets are not used
 
 Defaults are top: 0.0f
             left: 0.0f
           bottom: 0.0f
            right: 0.0f
 */
@property (nonatomic, readwrite) UIEdgeInsets selectionIndicatorEdgeInsets;

/**
 指定指示器左右两边比文字多出或减少的距离   只对 HMSegmentedControlTypeText 设置有效 默认0.000
 */
@property(nonatomic, assign) CGFloat extendedIndicatorLength;

/**
 Inset left and right edges of segments.
 
 Default is UIEdgeInsetsMake(0, 5, 0, 5)
 */
@property (nonatomic, readwrite) UIEdgeInsets segmentEdgeInset;

@property (nonatomic, readwrite) UIEdgeInsets enlargeEdgeInset;

@property (nonatomic, readwrite) UIEdgeInsets boxEdgeInset;

/**
 Default is YES. 用户选择时是否开启动画
 */
@property (nonatomic) BOOL shouldAnimateUserSelection;

/**
 指示线宽 （selectionStyle = PHSegmentedControlSelectionStyleTextWidthStripe 用）
 */
@property (nonatomic, assign) NSInteger yxtIndicatorWidth;

- (id)initWithSectionTitles:(NSArray<NSString *> *)secTitles;
- (id)initWithSelImgs:(NSArray<UIImage *> *)secImgs selImgs:(NSArray<UIImage *> *)selImgs;
- (instancetype)initWithSelImgs:(NSArray<UIImage *> *)secImgs selImgs:(NSArray<UIImage *> *)selImgs titles:(NSArray<NSString *> *)secTitles;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setIndexChangeBlock:(IndexChangeBlock)indexChangeBlock;
- (void)setTitleFormatter:(YXTTitleFormatterBlock)titleFormatter;

@end
