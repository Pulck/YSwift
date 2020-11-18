//
//  PHDetailActionCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PHDetailActionDelegate <NSObject>

/**
 详情点击行为
 
 @param customModel 返回cell中存储的数据模型
 */
- (void)phDetailAction:(id)customModel;

@end

@interface PHDetailActionCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, weak) id <PHDetailActionDelegate> delegate;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * titleLbl;

/**
 详情文本
 */
@property (nonatomic, strong) UILabel * detailLbl;

/**
 详情图标
 */
@property (nonatomic, strong) UIImageView * detailImage;

/**
 详情按钮
 */
@property (nonatomic, strong) UIButton * detailBtn;

/**
 显示隐藏cell底部分割线
 */
@property (nonatomic, assign) BOOL isLastItem;

@end

NS_ASSUME_NONNULL_END
