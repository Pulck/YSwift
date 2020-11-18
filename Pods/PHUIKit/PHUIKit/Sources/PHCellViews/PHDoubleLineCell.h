//
//  PHDoubleLineCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHDoubleLineCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * titleLbl;

/**
 右侧详情
 */
@property (nonatomic, strong) UILabel * detailLbl;

/**
 左侧描述
 */
@property (nonatomic, strong) UILabel * describeLbl;

/**
 显示隐藏cell底部分割线
 */
@property (nonatomic, assign) BOOL isLastItem;

/**
 不显示右侧箭头图标
 */
@property (nonatomic, assign) BOOL noArrow;

@end

NS_ASSUME_NONNULL_END
