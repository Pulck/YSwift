//
//  PHGraphtextButton.h
//  PHUIKit
//
//  Created by liangc on 2019/12/25.
//  Copyright © 2019 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHGraphtextButtonIcon.h"
#import "PHGraphtextButtonTitle.h"

typedef NS_ENUM(NSUInteger, PHGraphtextButtonStyle) {
    PHGraphtextButtonStyleIconAndTitle,
    PHGraphtextButtonStyleTitleAndIcon
};

NS_ASSUME_NONNULL_BEGIN

@interface PHGraphtextButton : UIView

@property (nonatomic) BOOL isSelected;

@property (nonatomic) PHGraphtextButtonIcon *icon;
@property (nonatomic) PHGraphtextButtonTitle *title;

- (instancetype)initWithStyle:(PHGraphtextButtonStyle)style icon:(PHGraphtextButtonIcon *)icon title:(PHGraphtextButtonTitle *)title space:(CGFloat)space;

- (void)addTarget:(nullable id)target action:(nonnull SEL)seletor forControlEvents:(UIControlEvents)events;
- (void)removeTarget:(nullable id)target action:(nonnull SEL)seletor forControlEvents:(UIControlEvents)events;

- (void)setIcon:(nullable PHGraphtextButtonIcon *)icon title:(PHGraphtextButtonTitle *)title forSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
