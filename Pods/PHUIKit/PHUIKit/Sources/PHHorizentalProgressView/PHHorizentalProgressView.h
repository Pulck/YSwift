//
//  PHHorizentalProgressView.h
//  PHUIKit
//
//  Created by Hu, Yuping on 2020/2/12.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHHorizentalProgressView : UIView

//进度值0-1.0之间
@property (nonatomic,assign) CGFloat progressValue;

//进度条的线宽
@property (nonatomic, assign) CGFloat lineWidth;

//进度条的高度，默认是6
@property (nonatomic, assign) CGFloat progressH;

//进度条的宽度，默认是50
@property (nonatomic, assign) CGFloat progressW;

//进度条整个的宽度
@property (nonatomic, assign) CGFloat progressViewW;

// 进度条的颜色
@property (nonatomic, strong) UIColor *progressColor;

// 进度条的背景颜色
@property (nonatomic, strong) UIColor *progressBgColor;

// 进度条文字的颜色
@property (nonatomic, strong) UIColor *textColor;

// 进度条的字体大小
@property (nonatomic, strong) UIFont *textFont;

// 进度条的宽度和高度
@property (nonatomic, assign, readonly) CGSize currentSize;

@end

NS_ASSUME_NONNULL_END
