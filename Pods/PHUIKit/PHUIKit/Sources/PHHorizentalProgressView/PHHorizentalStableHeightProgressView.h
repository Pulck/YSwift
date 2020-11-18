//
//  PHHorizentalStableHeightProgressView.h
//  PHUIKit
//
//  Created by Hu, Yuping on 2020/8/25.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHHorizentalStableHeightProgressView : UIView

//进度值0-1.0之间
@property (nonatomic,assign) CGFloat progressValue;

//进度值的百分比
@property (nonatomic, copy) NSString *progressValueStr;

// 进度条的颜色
@property (nonatomic, strong) UIColor *progressColor;

// 进度条的背景颜色
@property (nonatomic, strong) UIColor *progressBgColor;

// 进度条的宽度和高度
@property (nonatomic, assign, readonly) CGSize currentSize;

@end

NS_ASSUME_NONNULL_END
