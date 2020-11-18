//
//  PHIntegratedTextViewCell.h
//  PHUIKit
//
//  Created by liangc on 2019/11/11.
//

#import <UIKit/UIKit.h>
#import "PHIntegratedInputPageDefine.h"

NS_ASSUME_NONNULL_BEGIN

PHInput_EXTERN NSString * const phIntegratedTextViewCellIdentifier;

@interface PHIntegratedTextViewCell : UITableViewCell

@property (nonatomic) NSInteger limit;

@end

NS_ASSUME_NONNULL_END
