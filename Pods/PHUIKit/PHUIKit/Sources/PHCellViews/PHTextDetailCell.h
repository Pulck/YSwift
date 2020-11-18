//
//  PHTextDetailCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHTextDetailCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 右侧详情开启红色模式
 */
@property (nonatomic, assign) BOOL redDetail;

/**
 不显示右侧箭头图标
 */
@property (nonatomic, assign) BOOL noArrow;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * leftLbl;

/**
 左侧详情
 */
@property (nonatomic, strong) UILabel * leftDetail;

/**
 右侧文本（样式可以按需设置）
 */
@property (nonatomic, strong) UILabel * rightDetail;

/**
 显示隐藏cell底部分割线
 */
@property (nonatomic, assign) BOOL isLastItem;

@end

NS_ASSUME_NONNULL_END
