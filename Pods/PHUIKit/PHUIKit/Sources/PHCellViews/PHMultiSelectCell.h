//
//  PHMultiSelectCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHMultiSelectCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 启用时勾选Image
 */
@property (nonatomic, strong) UIImage * enableSelectImage;

/**
 启用时不勾选Image
 */
@property (nonatomic, strong) UIImage * enableUnSelectImage;

/**
 禁用时勾选Image
 */
@property (nonatomic, strong) UIImage * prohibitSelectImage;

/**
 禁用时不勾选Image
 */
@property (nonatomic, strong) UIImage * prohibitUnSelectImage;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * titleLbl;

/**
 设置cell启用状态及选中状态

 @param enable 启用状态（yes：启用，no：禁用）
 @param selectState 选中状态（yes：选中，no：未选中）
 */
- (void)enableAndSelectCell:(BOOL)enable selectState:(BOOL)selectState;

/**
 显示隐藏cell底部分割线
 */
@property (nonatomic, assign) BOOL isLastItem;

@end

NS_ASSUME_NONNULL_END
