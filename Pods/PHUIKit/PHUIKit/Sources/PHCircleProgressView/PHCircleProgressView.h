//
//  PHCircleProgressView.h
//  PHUIKit
//
//  Created by Hu, Yuping on 2020/1/2.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHCircleProgressView : UIView

//进度值0-1.0之间
@property (nonatomic,assign)CGFloat progressValue;

//进度条的线宽
@property (nonatomic, assign) CGFloat lineWidth;

// 进度条的颜色
@property (nonatomic, strong) UIColor *lineColor;

// 进度条的背景颜色
@property (nonatomic, strong) UIColor *lineBgColor;

// 进度条文字的颜色
@property (nonatomic, strong) UIColor *textColor;

// 进度条的字体大小
@property (nonatomic, strong) UIFont *textFont;

// 进度条%的字体大小
@property (nonatomic, strong) UIFont *unitFont;

// 进度条的宽度和高度
@property (nonatomic, assign, readonly) CGSize currentSize;

@end

NS_ASSUME_NONNULL_END
