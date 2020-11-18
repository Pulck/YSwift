//
//  PHSegmentedView.h
//  AFNetworking
//
//  Created by 朱力 on 2019/12/4.
//  支持滑动、选中字体放大等，适用于PHSegmentedControl无法满足的样式调整

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PHSegmentedViewIndexChangeBlock)(NSInteger index);

@interface PHSegmentedView : UIView <UIScrollViewDelegate>
/**  顶部tab  **/
@property (strong, nonatomic) UIScrollView *topTab;
/**  标题  **/
@property (strong, nonatomic) NSArray *titleArray;
 /** 设置默认选中按钮,从0开始记数，默认0 **/
@property (assign, nonatomic) NSInteger baseDefaultPage;
/** 下划线高度,默认3 **/
@property (assign, nonatomic) CGFloat bottomLineHeight;
/** 下划线宽，默认18，只对autoFitTitleLine=no有效 **/
@property (assign, nonatomic) CGFloat bottomLineWidth;
/** 下划线距底部间距，默认0 **/
@property (assign, nonatomic) CGFloat bottomLineFromBottom;
/** 滑块圆角 **/
@property (assign, nonatomic) CGFloat cornerRadiusRatio;
/** 默认标题字体大小，默认15 **/
@property (assign, nonatomic) CGFloat titlesFont;
/** 选中标题字体，默认18 UIFontWeightMedium ，注意是UIFont **/
@property (strong, nonatomic) UIFont *selecttitlesFont;
/** 设置按钮文本垂直位置， 每一个按钮实质是一个Button，默认是在topbab的中心显示文字 **/
@property (assign, nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
/** TopTab高度,默认背景高 **/
@property (assign, nonatomic) CGFloat topHeight;
/**
 TopTab宽度，默认0,文本自适应。设置宽度表示按钮最大显示宽度固定,文本小于这个宽度的自适应;同时需要设置selectMaxWidth
 **/
@property (assign, nonatomic) CGFloat maxWidth;
/** 选中TopTab宽度，与maxWidth同时使用，默认20 **/
@property (assign, nonatomic) CGFloat selectMaxWidth;
 /** 是否显示下方的下划线 default：no 显示 **/
@property (assign, nonatomic) BOOL topTabUnderLineHidden;
/** 下划线是否自适应标题宽度，默认NO,宽度固定 **/
@property (assign, nonatomic) BOOL autoFitTitleLine;
/** 下划线占比,默认1，只对autoFitTitleLine=YES有效 **/
@property (assign, nonatomic) CGFloat bottomLinePer;
/** 下划线圆角，默认圆角==2 **/
@property (assign, nonatomic) CGFloat bottomLineCornerRadius;
/** 下划颜色，默认#1a81d1 **/
@property (strong, nonatomic) UIColor *bottomLineColor;
/** 未选中的标题颜色,默认#666666 **/
@property (strong, nonatomic) UIColor *btnUnSelectColor;
/** 选中的标题颜色 **/
@property (strong, nonatomic) UIColor *btnSelectColor;
/** topTab背景颜色,默认whiteColor **/
@property (strong, nonatomic) UIColor *topTabColor;
/** 两个tab间距 */
@property(nonatomic, assign) CGFloat extendedIndicatorLength;
/** 距最左边间距，默认14 */
@property(nonatomic, assign) CGFloat toLeftLength;
/** 标签按宽等比例等分布局，间距自动调整。默认no(注意与maxWidth区别，maxWidth是标签最大宽固定，tab间距固定；autoFitWidth是间距自动适配)
 **/
@property (assign, nonatomic) BOOL autoFitWidth;
/**
 点击回调函数
 */
@property (nonatomic, copy) PHSegmentedViewIndexChangeBlock indexChangeBlock;

/**
 初始化

 @param frame frame
 @return id
 */
- (instancetype)initWithFrame:(CGRect)frame;


/**
 *  Reload toptab titles（初始化UI是在这个方法里，所以设置样式要在这个之前）
 *
 @param newTitles new titles
 */
- (void)reloadTabItems:(NSArray *)newTitles;

/**
 set选中某个

 @param index 选中哪一个，从0开始
 @param animated 是否开启动画
 */
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

/**
 未开发完，请不要使用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
