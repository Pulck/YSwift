//
//  PHPopupMenuCell.h
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/13.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHPopupMenuCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * iconImageView;

@property (nonatomic, assign) BOOL hideImage;

@property (nonatomic, assign) BOOL hideLine;

@end

NS_ASSUME_NONNULL_END
