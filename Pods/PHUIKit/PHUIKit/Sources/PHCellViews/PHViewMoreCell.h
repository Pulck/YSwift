//
//  PHViewMoreCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHViewMoreCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * leftLbl;

/**
 显示隐藏cell底部分割线
 */
@property (nonatomic, assign) BOOL isLastItem;

@end

NS_ASSUME_NONNULL_END
