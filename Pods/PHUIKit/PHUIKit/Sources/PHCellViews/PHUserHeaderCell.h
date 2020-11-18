//
//  PHUserHeaderCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PHTitleVerticalLayout) {
    //没有描述时标题居中
    PHTitleCentre,
    //标题置顶
    PHTitleTop,
};

typedef NS_ENUM(NSInteger, PHInfoVerticalLayout) {
    //没有描述时标题居中
    PHInfoCentre,
    //标题置顶
    PHInfoTop,
};

@interface PHUserHeaderCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 用户头像信息容器
 */
@property (nonatomic, strong) UIView * userInfoView;

/**
 用户头像
 */
@property (nonatomic, strong) UIImageView * userHeaderImage;

/**
 用户名
 */
@property (nonatomic, strong) UILabel * userNameLbl;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * titleLbl;

/**
 右侧详情（没有描述或者单行描述时默认居中）
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
