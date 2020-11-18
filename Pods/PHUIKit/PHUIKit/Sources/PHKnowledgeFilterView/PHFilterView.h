//
//  PHFilterView.h
//  lottie-ios
//
//  Created by Hu, Yuping on 2019/11/19.
//  下拉列表视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PHFilterTableViewCell;

/** 设置Cell的标题 */
typedef void(^PHKngFilterSetCellTitleBlock)(NSString *title, BOOL selected, BOOL disabled);

/** 设置Cell的数据源 */
typedef void(^PHKngCellForRowBlock)(NSIndexPath *indexPath, PHKngFilterSetCellTitleBlock rowBlock);

/** 选中Cell时的点击事件 */
typedef void(^PHKngFilterDidSelectCellBlock)(NSIndexPath *indexPath, PHFilterTableViewCell *tableCell);

/** 取消选中Cell时的点击事件 */
typedef void(^PHKngFilterDidDeslectCellBlock)(NSIndexPath *indexPath, PHFilterTableViewCell *tableCell);

@interface PHFilterView : UIView


/**
 设置每个Cell的标题的Block
 */
@property (nonatomic, copy) PHKngCellForRowBlock cellForRowBlock;


/**
 选中当前的Cell执行的回调方法
 */
@property (nonatomic, copy) PHKngFilterDidSelectCellBlock didSelectCellBlock;


/**
 取消选中当前的Cell执行的回调方法
 */
@property (nonatomic, copy) PHKngFilterDidDeslectCellBlock didDeslectCellBlock;

/**
 实例化当前的列表视图
 
 @param rowCount 设置行数
 @return 返回一个列表实例对象
 */
- (instancetype) initFilterViewWithRowCount:(NSUInteger)rowCount;

/**
 设置当前Table的行数

 @param count Table的行数
 */
- (void) resetRowCount:(NSUInteger)count;

/**
 将当前的列表展示到对应的视图上

 @param baseView 父视图
 @param rect 相对于父视图的坐标系的区域
 @param animated 是否带动画
 */
- (void) addToView:(UIView *)baseView inRect:(CGRect)rect withAnimation:(BOOL)animated;

/**
 重新注册TableView的Cell
 @param cellClass 继承自PHFilterTableViewCell
 */
- (void) registerTableCellWithClass:(nullable Class)cellClass;

/**
 清除下拉列表
 */
- (void) dismiss;

@end

NS_ASSUME_NONNULL_END
