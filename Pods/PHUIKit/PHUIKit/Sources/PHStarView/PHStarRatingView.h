//
//  PHStarRatingView.h
//  PHKnowledgeDemo
//
//  Created by Tiany on 2020/1/2.
//  Copyright © 2020 yunxuetang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kBACKGROUND_STAR @"ph_backgroundStar@3x"
#define kFOREGROUND_STAR @"ph_foregroundStar@3x"
#define kNUMBER_OF_STAR  5

@class PHStarRatingView;

@protocol PHStarRatingViewDelegate <NSObject>

@optional
- (void)starRatingView:(PHStarRatingView *)view score:(float)score;

@end

@interface PHStarRatingView : UIView

/**
 *  打星个数，不支持修改，请使用kNUMBER_OF_STAR
 */
@property (nonatomic, readonly) int numberOfStar;

/** 间距 */
@property (nonatomic, assign) float paddingOfStar;

/**
 *  仅仅展示星星，不支持移动打星，默认支持移动打星星
 */
@property (nonatomic, assign) BOOL onlyShowStar;

@property (nonatomic, weak) id <PHStarRatingViewDelegate> delegate;

/**
 *  Init PHStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return PHStarRatingViewObject
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(int)number;

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 5 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 5 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
