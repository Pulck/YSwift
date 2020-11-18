//
//  PHActionSheetCell.h
//  PHUIKit
//
//  Created by 秦平平 on 2020/2/11.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHActionSheetCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) BOOL hideLine;

@end

NS_ASSUME_NONNULL_END
