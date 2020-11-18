//
//  PHDetailTimeCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHDetailTimeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * titleLbl;

/**
 左侧描述
 */
@property (nonatomic, strong) UILabel * describeLbl;

/**
 底部文字来源
 */
@property (nonatomic, strong) UILabel * bottomText;

/**
 底部时间
 */
@property (nonatomic, strong) UILabel * timeText;

/**
 底部其他信息
 */
@property (nonatomic, strong) UILabel * otherText;

/**
 隐藏底部信息
 */
@property (nonatomic, assign) BOOL hiddenBottomInfo;

/**
 显示隐藏cell底部分割线
 */
@property (nonatomic, assign) BOOL isLastItem;

@end

NS_ASSUME_NONNULL_END
