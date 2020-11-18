//
//  PHBadgeView.m
//  Masonry
//
//  Created by Hu, Yuping on 2019/11/6.
//

#import "PHBadgeView.h"
#import <objc/runtime.h>
#import <PHUtils/PHUtils.h>

#define kBadgeDefaultFont                ([UIFont boldSystemFontOfSize:16])
#define kBadgeDefaultMaximumBadgeNumber                     99

static const CGFloat kBadgeDefaultRedDotRadius = 4.f;
static char badgeLabelKey;
static char badgeBgColorKey;
static char badgeFontKey;
static char badgeTextColorKey;
static char badgeFrameKey;
static char badgeMaximumBadgeNumberKey;
static char badgeRadiusKey;

@interface PHBadgeView()

@property (nonatomic, assign) CGPoint  badgeCenterOffset;
@property (nonatomic, assign) NSInteger badgeMaximumBadgeNumber;
@property (nonatomic, assign) CGFloat badgeRadius;

@end

@implementation PHBadgeView

+ (PHBadgeView *)bageView {
    return [[self alloc] init];
}

+ (instancetype)showRedDotBadge {
    PHBadgeView *badgeView = [self bageView];
    [badgeView setBadgeCenterOffset:CGPointZero];
    return badgeView;
}

+ (instancetype)showNumberBadgewithValue:(NSInteger)value {
    PHBadgeView *badgeView = [self bageView];
    [badgeView showNumberBadgeWithValue:value];
    [badgeView setBadgeCenterOffset:CGPointZero];
    return badgeView;
}

- (void)showNumberBadgeWithValue:(NSInteger)value {
    if (value < 0) {
        return;
    }
    [self badgeInit];
    self.badge.hidden = (value == 0);
    self.badge.font = self.badgeFont;
    self.badge.text = (value > self.badgeMaximumBadgeNumber ?
                       [NSString stringWithFormat:@"%@+", @(self.badgeMaximumBadgeNumber)] :
                       [NSString stringWithFormat:@"%@", @(value)]);
    [self adjustLabelWidth:self.badge];
    CGRect frame = self.badge.frame;
    frame.size.width += 10;
    frame.size.height += 6;
    if(CGRectGetWidth(frame) < CGRectGetHeight(frame)) {
        frame.size.width = CGRectGetHeight(frame);
    }
    self.badge.frame = frame;
    self.badge.layer.cornerRadius = CGRectGetHeight(self.badge.frame) / 2;
}

/// 懒加载
- (void)badgeInit {
    if (self.badgeBgColor == nil) {
        self.badgeBgColor = [UIColor ph_colorWithHexString:@"FF4444"];
    }
    if (self.badgeTextColor == nil) {
        self.badgeTextColor = [UIColor whiteColor];
    }
    if (nil == self.badge) {
        CGFloat redotWidth = kBadgeDefaultRedDotRadius *2;
        CGRect frm = CGRectMake(CGRectGetWidth(self.frame), 0, redotWidth, redotWidth);
        self.badge = [[UILabel alloc] initWithFrame:frm];
        self.badge.textAlignment = NSTextAlignmentCenter;
        //self.badge.center = CGPointMake(CGRectGetWidth(self.frame) + 2 + self.badgeCenterOffset.x, self.badgeCenterOffset.y);
        self.badge.backgroundColor = self.badgeBgColor;
        self.badge.textColor = self.badgeTextColor;
        self.badge.text = @"";
        self.badge.layer.cornerRadius = CGRectGetWidth(self.badge.frame) / 2;
        self.badge.layer.masksToBounds = YES;
        self.badge.hidden = NO;
        self.badgeFont = [UIFont systemFontOfSize:10.0f];
        [self addSubview:self.badge];
        [self bringSubviewToFront:self.badge];
    }
}

- (void)clearBadge {
    self.badge.hidden = YES;
}

/// 如果存在就不隐藏
- (void)resumeBadge {
    if (self.badge && self.badge.hidden == YES) {
        self.badge.hidden = NO;
    }
}

#pragma mark --  other private methods
/// 计算内容
- (void)adjustLabelWidth:(UILabel *)label {
    [label setNumberOfLines:1];
    NSString *s = label.text;
    UIFont *font = [label font];
    CGSize size = CGSizeMake(50,10);
    CGSize labelsize;
    
    if (![s respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    } else {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        if (@available(iOS 7.0, *)) {
            labelsize = [s boundingRectWithSize:size
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{ NSFontAttributeName:font, NSParagraphStyleAttributeName : style}
                                        context:nil].size;
        } else {
            // Fallback on earlier versions
        }
    }
    CGRect frame = label.frame;
    frame.size = CGSizeMake(ceilf(labelsize.width), ceilf(labelsize.height));
    [label setFrame:frame];
}

#pragma mark -- setter/getter
- (UILabel *)badge {
    return objc_getAssociatedObject(self, &badgeLabelKey);
}

- (void)setBadge:(UILabel *)label {
    objc_setAssociatedObject(self, &badgeLabelKey, label, OBJC_ASSOCIATION_RETAIN);
}

- (UIFont *)badgeFont {
    id font = objc_getAssociatedObject(self, &badgeFontKey);
    return font == nil ? kBadgeDefaultFont : font;
}

- (void)setBadgeFont:(UIFont *)badgeFont {
    objc_setAssociatedObject(self, &badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN);
    if (!self.badge) {
        [self badgeInit];
    }
    self.badge.font = badgeFont;
}

- (UIColor *)badgeBgColor {
    return objc_getAssociatedObject(self, &badgeBgColorKey);
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor {
    if (!badgeBgColor) { // 判断当前的背景颜色是否为空
        return;
    }
    objc_setAssociatedObject(self, &badgeBgColorKey, badgeBgColor, OBJC_ASSOCIATION_RETAIN);
    if (!self.badge) {
        [self badgeInit];
    }
    self.badge.backgroundColor = badgeBgColor;
}

- (UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &badgeTextColorKey);
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    if (!badgeTextColor) { // 判断当前的背景颜色是否为空
        return;
    }
    objc_setAssociatedObject(self, &badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN);
    if (!self.badge) {
        [self badgeInit];
    }
    self.badge.textColor = badgeTextColor;
}

- (CGRect)badgeFrame {
    id obj = objc_getAssociatedObject(self, &badgeFrameKey);
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]] && [obj count] == 4) {
        CGFloat x = [obj[@"x"] floatValue];
        CGFloat y = [obj[@"y"] floatValue];
        CGFloat width = [obj[@"width"] floatValue];
        CGFloat height = [obj[@"height"] floatValue];
        return  CGRectMake(x, y, width, height);
    } else
        return CGRectZero;
}

- (void)setBadgeFrame:(CGRect)badgeFrame {
    NSDictionary *frameInfo = @{@"x" : @(badgeFrame.origin.x), @"y" : @(badgeFrame.origin.y),
                                @"width" : @(badgeFrame.size.width), @"height" : @(badgeFrame.size.height)};
    objc_setAssociatedObject(self, &badgeFrameKey, frameInfo, OBJC_ASSOCIATION_RETAIN);
    if (!self.badge) {
        [self badgeInit];
    }
    self.badge.frame = badgeFrame;
}

- (CGPoint)badgeCenterOffset {
    return CGPointZero;
}

- (void)setBadgeCenterOffset:(CGPoint)badgeCenterOff {
    if (!self.badge) {
        [self badgeInit];
    }
}

- (void)setBadgeRadius:(CGFloat)badgeRadius {
    objc_setAssociatedObject(self, &badgeRadiusKey, [NSNumber numberWithFloat:badgeRadius], OBJC_ASSOCIATION_RETAIN);
    if (!self.badge) {
        [self badgeInit];
    }
}

- (CGFloat)badgeRadius {
    return [objc_getAssociatedObject(self, &badgeRadiusKey) floatValue];
}

- (NSInteger)badgeMaximumBadgeNumber {
    id obj = objc_getAssociatedObject(self, &badgeMaximumBadgeNumberKey);
    if(obj != nil && [obj isKindOfClass:[NSNumber class]])
    {
        return [obj integerValue];
    }
    else
        return kBadgeDefaultMaximumBadgeNumber;
}

- (void)setBadgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber {
    NSNumber *numObj = @(badgeMaximumBadgeNumber);
    objc_setAssociatedObject(self, &badgeMaximumBadgeNumberKey, numObj, OBJC_ASSOCIATION_RETAIN);
    if (!self.badge) {
        [self badgeInit];
    }
}

#pragma mark - 重新设置当前View的背景颜色
- (void)resetColor {
    if (self.badgeBgColor == nil) {
        self.badge.backgroundColor = [UIColor ph_colorWithHexString:@"FF4444"];
    } else {
        self.badge.backgroundColor = self.badgeBgColor;
    }
    
    if (self.badgeTextColor == nil) {
        self.badge.textColor = [UIColor whiteColor];
    } else {
        self.badge.textColor = self.badgeTextColor;
    }
}

/** 获取当前角标的Size信息 */
- (CGSize)fetchBadgeSize {
    
    CGSize textSize = CGSizeZero;
    NSString *badgeText = self.badge.text;
    if ([NSString ph_isNilOrEmpty:badgeText]) {
        textSize = CGSizeMake(2*kBadgeDefaultRedDotRadius, 2*kBadgeDefaultRedDotRadius);
    } else {
        textSize = [self calculateTextHeightWithString:badgeText];
        textSize.width += 10;
        textSize.height += 6;
        if(textSize.width < textSize.height) {
            textSize.width = textSize.height;
        }
    }
    
    return textSize;
}

/**
 计算字符串的Size信息
 @param valueStr 字符串
 @return 字符串的Size大小
 */
- (CGSize)calculateTextHeightWithString:(NSString *)valueStr {
    NSString *s = valueStr;
    UIFont *font = self.badgeFont;
    CGSize size = CGSizeMake(50,10);
    CGSize labelsize;
    
    if (![s respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    } else {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        if (@available(iOS 7.0, *)) {
            labelsize = [s boundingRectWithSize:size
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{ NSFontAttributeName:font, NSParagraphStyleAttributeName : style}
                                        context:nil].size;
        } else {
            // Fallback on earlier versions
        }
    }
    
    return CGSizeMake(ceilf(labelsize.width), ceilf(labelsize.height));
}

@end
