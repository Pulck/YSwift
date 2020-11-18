//
//  PHWatermarkView.h
//  PHUIKit
//
//  Created by 秦平平 on 2020/2/4.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHWatermarkView : UIImageView


/**
 设置水印

 @param frame frame
 @param markText 文本
 @param markFont 字体
 @param markColor 色值
 */
- (void)showWaterMarkWithFrame:(CGRect)frame markText:(NSString *)markText markFont: (CGFloat)markFont
                     markColor: (UIColor *)markColor;

@end

NS_ASSUME_NONNULL_END
