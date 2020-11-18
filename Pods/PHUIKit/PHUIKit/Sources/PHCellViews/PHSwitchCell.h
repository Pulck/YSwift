//
//  PHSwitchCell.h
//  PHUIKit
//
//  Created by 朱力 on 2019/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PHSwitchDelegate <NSObject>

/**
 开关行为代理

 @param customModel 返回cell中存储的数据模型
 @param switchState 返回开关状态
 */
- (void)phSwitchAction:(id)customModel switchState:(BOOL)switchState;

@end

@interface PHSwitchCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, weak) id <PHSwitchDelegate> delegate;

/** 数据模型 */
@property (nonatomic, strong) id customModel;

/**
 左侧文本
 */
@property (nonatomic, strong) UILabel * leftTitle;

/**
 描述信息
 */
@property (nonatomic, strong) UILabel * leftDetail;

/**
 右侧开关
 */
@property (nonatomic, strong) UISwitch * rightSwitch;

/**
 显示隐藏cell底部分割线
 */
@property (nonatomic, assign) BOOL isLastItem;

@end

NS_ASSUME_NONNULL_END
