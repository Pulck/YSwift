//
//  PHIntegratedTextFieldCell.h
//  PHUIKit
//
//  Created by 梁琛 on 2019/11/7.
//

#import <UIKit/UIKit.h>
#import "PHIntegratedInputPageDefine.h"

NS_ASSUME_NONNULL_BEGIN

PHInput_EXTERN NSString * const pHIntegratedTextFieldCellIdentifier;

@interface PHIntegratedTextFieldCell : UITableViewCell

@property (nonatomic) PHIntegrateSeparatorStyle bottomLineStyle;
@property (nonatomic) NSTextAlignment textFieldAlignment;
@property (nonatomic) NSInteger maxInputLength;

@end

NS_ASSUME_NONNULL_END
