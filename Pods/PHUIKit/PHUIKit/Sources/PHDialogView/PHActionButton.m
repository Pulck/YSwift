//
//  PHActionButton.m
//  AFNetworking
//
//  Created by zhuli on 2018/5/13.
//

#import "PHActionButton.h"
#import "UIColor+PH.h"
#import "NSString+PH.h"
#import "UIView+PH.h"
#import "UIImage+PH.h"

@interface PHActionButton ()
/**
 用来标记当前是xib还是纯代码（1，xib ；0 纯代码）
 */
@property (nonatomic, assign) NSInteger typeSign;
@end

@implementation PHActionButton

- (instancetype)initWithFrame:(CGRect)frame type:(YXYButtonType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)setup:(YXYButtonType)type {
    UIColor *normalColor = [NSString ph_isNilOrEmpty:self.mainColorStr]?[UIColor ph_colorWithHexString:@"1a81d1"]:[UIColor ph_colorWithHexString:self.mainColorStr];
    UIColor *highlightedColor = [NSString ph_isNilOrEmpty:self.mainHighlightColorStr]?[UIColor ph_colorWithHexString:@"1774BC"]:[UIColor ph_colorWithHexString:self.mainHighlightColorStr];
    UIColor *disabledColor = [[NSString ph_isNilOrEmpty:self.mainColorStr]?[UIColor ph_colorWithHexString:@"1a81d1"]:[UIColor ph_colorWithHexString:self.mainColorStr] colorWithAlphaComponent:0.3];
    CGFloat fontSize = 14;
    UIColor *titleColor = [UIColor whiteColor];
    UIColor *titleHighlightColor = [UIColor whiteColor];
    CGFloat cornerRadius = 0;
    CGFloat borderWidth = 0;
    CGColorRef borderColor = normalColor.CGColor;
    switch (type) {
        case YXYButtonTypeDefault:
            fontSize = 18;
            break;
        case YXYButtonTypeCorner:
            fontSize = 14;
            cornerRadius = self.ph_height/8.25;
            break;
        case YXYButtonTypeBorder:
            normalColor = [UIColor whiteColor];
            highlightedColor = [UIColor whiteColor];
            disabledColor = [UIColor whiteColor];
            fontSize = 14;
            titleColor = [NSString ph_isNilOrEmpty:self.mainColorStr]?[UIColor ph_colorWithHexString:@"1a81d1"]:[UIColor ph_colorWithHexString:self.mainColorStr];
            titleHighlightColor = [NSString ph_isNilOrEmpty:self.mainHighlightColorStr]?[UIColor ph_colorWithHexString:@"1774BC"]:[UIColor ph_colorWithHexString:self.mainHighlightColorStr];
            cornerRadius = self.ph_height/8.25;
            borderWidth = 1;
            borderColor = ([NSString ph_isNilOrEmpty:self.mainColorStr]?[UIColor ph_colorWithHexString:@"1a81d1"]:[UIColor ph_colorWithHexString:self.mainColorStr]).CGColor;
            break;
            
        default:
            break;
    }
    [self setBackgroundImage:[UIImage ph_createImageWithColor:normalColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage ph_createImageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage ph_createImageWithColor:disabledColor] forState:UIControlStateDisabled];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor;
}

- (void)setXibType:(NSInteger)xibType {
    self.typeSign = 1;
    _xibType = xibType;
    [self setup:_xibType];
}

- (void)setType:(YXYButtonType)type
{
    self.typeSign = 0;
    _type = type;
    [self setup:type];
}

- (void)setMainColorStr:(NSString *)mainColorStr {
    _mainColorStr = mainColorStr;
    if (self.typeSign == 1) { /// 使用xib, 需要再次调用
        [self setup:_xibType];
    }else {
        [self setup:_type];
    }
}

- (void)setMainHighlightColorStr:(NSString *)mainHighlightColorStr {
    _mainHighlightColorStr = mainHighlightColorStr;
    if (self.typeSign == 1) { /// 使用xib, 需要再次调用
        [self setup:_xibType];
    }else {
        [self setup:_type];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.type == YXYButtonTypeBorder) {
        self.layer.borderColor = ([NSString ph_isNilOrEmpty:self.mainHighlightColorStr]?[UIColor ph_colorWithHexString:@"1774BC"]:[UIColor ph_colorWithHexString:self.mainHighlightColorStr]).CGColor;
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.type == YXYButtonTypeBorder) {
        self.layer.borderColor = ([NSString ph_isNilOrEmpty:self.mainColorStr]?[UIColor ph_colorWithHexString:@"1a81d1"]:[UIColor ph_colorWithHexString:self.mainColorStr]).CGColor;
    }
}

@end



#pragma matk - PHAction

@implementation PHAction

+ (instancetype __nullable)actionWithTitle:(nullable NSString *)title style:(PHActionStyle)style handler:(void (^ __nullable)(PHAction * __nullable action))handler {
    PHAction *action = [[PHAction alloc]init];
    action.title = title;
    action.style = style;
    action.block = handler;
    return action;
}

+ (instancetype __nullable)actionWithTitle:(nullable NSString *)title style:(PHActionStyle)style handler:(void (^ __nullable)(PHAction * __nullable action))handler button:(void (^ __nullable)( PHActionButton * __nullable button))button {
    PHAction *action = [[PHAction alloc]init];
    action.title = title;
    action.style = style;
    action.block = handler;
    action.btnblock = button;
    return action;
}

@end

#pragma matk - PHActionView

@interface PHActionView ()

@property (nonatomic, strong) NSMutableArray *actionArray;

/**
 用于标记是否创建过视图（layoutSubviews 多次调用问题）
 */
@property (nonatomic ,assign) BOOL haveAdd;
@end

@implementation PHActionView

- (NSMutableArray *)actionArray {
    if (_actionArray == nil) {
        _actionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _actionArray;
}

- (void)addAction:(PHAction *)action {
    [self.actionArray addObject:action];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.actionArray.count > 0 && !self.haveAdd) {
        UIColor *lineColor = [UIColor ph_colorWithHexString:@"CCCCCC"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.ph_width, 1)];
        [label setBackgroundColor:lineColor];
        [self addSubview:label];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, self.ph_height)];
        [leftLabel setBackgroundColor:lineColor];
        [self addSubview:leftLabel];
        
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.ph_height-1, self.ph_width, 1)];
        [bottomLabel setBackgroundColor:lineColor];
        [self addSubview:bottomLabel];
        self.haveAdd = YES;
        for (int i = 0; i < self.actionArray.count; i++) {
            PHAction *action = self.actionArray[i];
            PHActionButton *button = [[PHActionButton alloc] initWithFrame:CGRectMake((self.ph_width/self.actionArray.count)*i, 0, self.ph_width/self.actionArray.count, self.ph_height)];
            [button setType:YXYButtonTypeDefault];
            if (action.style != PHActionStyleBlue) {
                [button setBackgroundImage:[UIImage ph_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage ph_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
                [button setBackgroundImage:[UIImage ph_createImageWithColor:[[UIColor ph_colorWithHexString:@"1a81d1"] colorWithAlphaComponent:0.3]] forState:UIControlStateDisabled];
                [button setTitleColor:[UIColor ph_colorWithHexString:@"1a81d1"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor ph_colorWithHexString:@"1774BC"] forState:UIControlStateHighlighted];
            }
            [button setTitle:action.title forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self sendSubviewToBack:button];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.ph_width*(i+1), 0, 1, button.ph_height)];
            [label setBackgroundColor:lineColor];
            [self addSubview:label];
            if (action.style == PHActionStyleBlue) {
                [self bringSubviewToFront:button];
            }
            if (action.btnblock) {
                action.btnblock(button);
            }
        }
    }
}

- (void)clickAction:(UIButton *)button {
    PHAction *action = self.actionArray[button.tag];
    if (action.block) {
        action.block(action);
    }
}

@end
