//
//  UIView+PHToast.m
//  PHUIKit
//
//  Created by 朱力 on 2019/10/31.
//

#import "UIView+PHToast.h"
#import "UIView+Toast.h"
#import <PHUtils/PHUtils.h>
#import <Masonry/Masonry.h>
#import "Lottie.h"
#import "PHMacro.h"

static const CGFloat kImageToastSize = 120.0;
static const CGFloat kMinMessageLblWidth = 120.0;
static const CGFloat kMinImageLblWidth = 60.0;

@implementation UIView (PHToast)

/**
 1、弹出居中的普通吐丝
 2、消失时间1.5S
 3、点击不会自动消失
 4、不按队列弹出
 5、用户无法操作当前页面的功能，但可以操作导航
 
 @param message 吐丝的文字内容
 @param tapToDismiss 开启点击消失
 */
- (void)makePHToast:(NSString *)message
       tapToDismiss:(BOOL)tapToDismiss {
    [self initDefaultToastStyleAndManager];
    UIView * backView = [self prohibitTapView:tapToDismiss];
    
    UIView * toastView = [[UIView alloc] init];
    toastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    toastView.layer.cornerRadius = 4;
    [backView addSubview:toastView];
    
    UILabel * defaultLbl = [[UILabel alloc] init];
    [defaultLbl setText:message];
    [defaultLbl setFont:[UIFont systemFontOfSize:14]];
    [defaultLbl setTextColor:[UIColor whiteColor]];
    [defaultLbl setTextAlignment:NSTextAlignmentCenter];
    [defaultLbl setLineBreakMode:NSLineBreakByCharWrapping];
    [defaultLbl setNumberOfLines:0];
    [toastView addSubview:defaultLbl];
    
    CGSize lblSize = [self getMessageSize:defaultLbl maxWidth:backView.ph_width - 120];
    CGFloat lblWidth = lblSize.width > kMinMessageLblWidth ? lblSize.width : kMinMessageLblWidth;
    
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).offset(-[self toastTopValue]);
        make.width.mas_equalTo(lblWidth + 24);
        make.height.mas_equalTo(lblSize.height + 18);
    }];
    
    [defaultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toastView);
        make.width.mas_equalTo(lblWidth);
        make.height.mas_equalTo(lblSize.height);
    }];
    
    [self showToast:backView
           duration:[CSToastManager defaultDuration]
           position:[self toastPosition]
         completion:^(BOOL didTap) {
             
         }];
}

/**
 1、弹出指定时间和位置的普通吐丝
 2、点击不会自动消失
 3、不按队列弹出
 4、用户无法操作当前页面的功能，但可以操作导航
 
 @param message 吐丝的文字内容
 @param duration 吐丝的显示时间
 @param tapToDismiss 开启点击消失
 */
- (void)makePHToast:(NSString *)message
           duration:(NSTimeInterval)duration
       tapToDismiss:(BOOL)tapToDismiss {
    [self initDefaultToastStyleAndManager];
    UIView * backView = [self prohibitTapView:tapToDismiss];
    
    UIView * toastView = [[UIView alloc] init];
    toastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    toastView.layer.cornerRadius = 4;
    [backView addSubview:toastView];
    
    UILabel * defaultLbl = [[UILabel alloc] init];
    [defaultLbl setText:message];
    [defaultLbl setFont:[UIFont systemFontOfSize:14]];
    [defaultLbl setTextColor:[UIColor whiteColor]];
    [defaultLbl setTextAlignment:NSTextAlignmentCenter];
    [defaultLbl setLineBreakMode:NSLineBreakByCharWrapping];
    [defaultLbl setNumberOfLines:0];
    [toastView addSubview:defaultLbl];
    
    CGSize lblSize = [self getMessageSize:defaultLbl maxWidth:backView.ph_width - 120];
    CGFloat lblWidth = lblSize.width > kMinMessageLblWidth ? lblSize.width : kMinMessageLblWidth;
    
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).offset(-[self toastTopValue]);
        make.width.mas_equalTo(lblWidth + 24);
        make.height.mas_equalTo(lblSize.height + 18);
    }];
    
    [defaultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toastView);
        make.width.mas_equalTo(lblWidth);
        make.height.mas_equalTo(lblSize.height);
    }];
    
    [self showToast:backView
           duration:duration
           position:[self toastPosition]
         completion:^(BOOL didTap) {
             
         }];
}

/**
 1、弹出居中的带有图片和文字的吐丝
 2、建议传入36*36的图片
 3、图片和文本会组合居中在吐丝中
 4、文本会自动换行
 
 @param image 传入图片内容
 @param message 传入文本内容
 @param duration 吐丝的显示时间
 @param tapToDismiss 开启点击消失
 */
- (void)makeImagePHToast:(UIImage *)image
                 message:(NSString *)message
                duration:(NSTimeInterval)duration
            tapToDismiss:(BOOL)tapToDismiss {
    [self initDefaultToastStyleAndManager];
    UIView * backView = [self prohibitTapView:tapToDismiss];
    
    UIView * toastView = [[UIView alloc] init];
    toastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    toastView.layer.cornerRadius = 8;
    [backView addSubview:toastView];
    
    UIImageView * defaultImage = [[UIImageView alloc] initWithImage:image];
    [toastView addSubview:defaultImage];
    
    UILabel * defaultLbl = [[UILabel alloc] init];
    [defaultLbl setText:message];
    [defaultLbl setFont:[UIFont systemFontOfSize:14]];
    [defaultLbl setTextColor:[UIColor whiteColor]];
    [defaultLbl setTextAlignment:NSTextAlignmentCenter];
    [defaultLbl setLineBreakMode:NSLineBreakByCharWrapping];
    [defaultLbl setNumberOfLines:0];
    [toastView addSubview:defaultLbl];
    [self setImageToastLayout:image defaultLbl:defaultLbl toastView:toastView backView:backView defaultImage:defaultImage];
    [self showToast:backView duration:duration position:[self toastPosition] completion:^(BOOL didTap) {}];
}

- (void)setImageToastLayout:(UIImage *)image defaultLbl:(UILabel *)defaultLbl toastView:(UIView *)toastView backView:(UIView *)backView defaultImage:(UIImageView *)defaultImage {
    CGFloat maxImageSize = image.size.width > image.size.height ? image.size.width : image.size.height;
    CGSize lblSize = [self getMessageSize:defaultLbl maxWidth:kImageToastSize - 20];
    CGFloat toastWidth = lblSize.width + 20 > kImageToastSize ? lblSize.width + 20 : kImageToastSize;
    CGFloat toastHeight = maxImageSize + 8 + lblSize.height + 60;
    BOOL isWidthMax = toastWidth > toastHeight ? YES : NO;
    CGFloat reallyToastSize = isWidthMax ? toastWidth : toastHeight;
    
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).offset(-[self toastTopValue]);
        make.width.height.mas_equalTo(reallyToastSize);
    }];
    
    [defaultImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isWidthMax) {
            make.top.equalTo(toastView.mas_top).mas_equalTo(30 + (toastWidth - toastHeight) / 2.0);
        } else {
            make.top.equalTo(toastView.mas_top).mas_equalTo(30);
        }
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
        make.centerX.equalTo(toastView);
    }];
    
    [defaultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(defaultImage.mas_bottom).offset(8);
        make.width.mas_equalTo(lblSize.width);
        make.height.mas_equalTo(lblSize.height);
        make.centerX.equalTo(toastView);
    }];
}

/**
 1、弹出居中的指定类型图片和文字的吐丝
 2、图片和文本会组合居中在吐丝中
 3、文本会自动换行
 
 @param imageType 传入指定类型的图片
 @param duration 吐丝的显示时间
 @param tapToDismiss 开启点击消失
 */
- (void)makePHToastByType:(PHToastImageType)imageType
                  message:(NSString *)message
                 duration:(NSTimeInterval)duration
             tapToDismiss:(BOOL)tapToDismiss {
    [self initDefaultToastStyleAndManager];
    UIView * backView = [self prohibitTapView:tapToDismiss];
    
    UIView * toastView = [[UIView alloc] init];
    toastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    toastView.layer.cornerRadius = 8;
    [backView addSubview:toastView];
    
    UIImageView * defaultImage = [[UIImageView alloc] initWithImage:[self takeDefaultImageByType:imageType]];
    [toastView addSubview:defaultImage];
    
    UILabel * defaultLbl = [[UILabel alloc] init];
    [defaultLbl setText:message];
    [defaultLbl setFont:[UIFont systemFontOfSize:14]];
    [defaultLbl setTextColor:[UIColor whiteColor]];
    [defaultLbl setTextAlignment:NSTextAlignmentCenter];
    [defaultLbl setLineBreakMode:NSLineBreakByCharWrapping];
    [defaultLbl setNumberOfLines:0];
    [toastView addSubview:defaultLbl];
    [self setToastLayout:defaultImage defaultLbl:defaultLbl toastView:toastView backView:backView];
    [self showToast:backView duration:duration position:[self toastPosition] completion:^(BOOL didTap) { }];
}

- (void)setToastLayout:(UIImageView *)defaultImage defaultLbl:(UILabel *)defaultLbl toastView:(UIView *)toastView backView:(UIView *)backView {
    CGFloat maxImageSize = defaultImage.image.size.width > defaultImage.image.size.height ? defaultImage.image.size.width : defaultImage.image.size.height;
    CGSize lblSize = [self getMessageSize:defaultLbl maxWidth:kImageToastSize - 20];
    CGFloat toastWidth = lblSize.width + 20 > kImageToastSize ? lblSize.width + 20 : kImageToastSize;
    CGFloat toastHeight = maxImageSize + 8 + lblSize.height + 60;
    BOOL isWidthMax = toastWidth > toastHeight ? YES : NO;
    CGFloat reallyToastSize = isWidthMax ? toastWidth : toastHeight;
    
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).offset(-[self toastTopValue]);
        make.width.height.mas_equalTo(reallyToastSize);
    }];
    
    [defaultImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isWidthMax) {
            make.top.equalTo(toastView.mas_top).mas_equalTo(30 + (toastWidth - toastHeight) / 2.0);
        } else {
            make.top.equalTo(toastView.mas_top).mas_equalTo(30);
        }
        make.width.mas_equalTo(defaultImage.image.size.width);
        make.height.mas_equalTo(defaultImage.image.size.height);
        make.centerX.equalTo(toastView);
    }];
    
    [defaultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(defaultImage.mas_bottom).offset(8);
        make.width.mas_equalTo(lblSize.width);
        make.height.mas_equalTo(lblSize.height);
        make.centerX.equalTo(toastView);
    }];
}

/**
 1、弹出等待吐丝（圆环转圈样式）
 
 @param tapToDismiss 开启点击消失
 @param completion 点击消失回调
 */
- (void)makePHActiveToast:(BOOL)tapToDismiss
                      msg:(NSString * __nullable)msg
               completion:(void(^)(BOOL didTap))completion {
    [self initDefaultToastStyleAndManager];
    UIView * backView = [self prohibitTapView:tapToDismiss];
    
    UIView * toastView = [[UIView alloc] init];
    toastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    toastView.layer.cornerRadius = 8;
    [backView addSubview:toastView];
    
    LOTAnimationView * rotateAnimation = [LOTAnimationView animationWithFilePath:[self rotateAnimation]];
    [toastView addSubview:rotateAnimation];
    rotateAnimation.loopAnimation = YES;
    [rotateAnimation play];
    
    UILabel * defaultLbl = [[UILabel alloc] init];
    [defaultLbl setText:msg];
    [defaultLbl setFont:[UIFont systemFontOfSize:14]];
    [defaultLbl setTextColor:[UIColor whiteColor]];
    [defaultLbl setTextAlignment:NSTextAlignmentCenter];
    [defaultLbl setLineBreakMode:NSLineBreakByCharWrapping];
    [defaultLbl setNumberOfLines:0];
    [toastView addSubview:defaultLbl];
    
    [self setActiveLayout:rotateAnimation defaultLbl:defaultLbl toastView:toastView backView:backView];
    
    [self showToast:backView
           duration:NSIntegerMax
           position:[self toastPosition]
         completion:^(BOOL didTap) {
             !completion ?:completion(didTap);
         }];
}

- (void)setActiveLayout:(LOTAnimationView *)rotateAnimation defaultLbl:(UILabel *)defaultLbl toastView:(UIView *)toastView backView:(UIView *)backView {
    CGSize lblSize = [self getMessageSize:defaultLbl maxWidth:kImageToastSize - 20];
    
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView).offset(-[self toastTopValue]);
        make.width.height.mas_equalTo(kImageToastSize);
    }];
    
    [rotateAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        if (defaultLbl.text.length == 0) {
            make.center.equalTo(toastView);
        } else {
            make.width.height.mas_equalTo(44);
            make.top.mas_offset((kImageToastSize - (44 + 8 + lblSize.height)) / 2.0);
            make.centerX.equalTo(toastView);
        }
    }];
    
    [defaultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rotateAnimation.mas_bottom).offset(8);
        make.width.mas_equalTo(lblSize.width);
        make.height.mas_equalTo(lblSize.height);
        make.centerX.equalTo(toastView);
    }];
    
}

- (void)makePHActiveToast:(NSString *)msg {
    [self makePHActiveToast:NO msg:msg completion:^(BOOL didTap) { }];
}

/**
 1、弹出等待吐丝儿（圆环转圈样式）
 */
- (void)makePHActiveToast {
    [self makePHActiveToast:NO msg:nil completion:^(BOOL didTap) { }];
}

- (NSString *)rotateAnimation {
    NSString *path = [PH_BUNDLE_FOR_CLASS(NSClassFromString(@"PHButton")) pathForResource:@"PHToast.bundle" ofType:nil];
    return [path stringByAppendingPathComponent:@"data.json"];
}

/**
 让最顶层的吐丝消失（不影响弹出队列）
 */
- (void)hidePHToast {
    [self hideToast];
}

/**
 隐藏所有吐丝，包括队列中的
 */
- (void)hideAllPHToast {
    [self hideAllToasts];
}

- (void)initDefaultToastStyleAndManager {
    CSToastStyle * style = [CSToastManager sharedStyle];
    style.messageColor = [UIColor whiteColor];
    style.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    style.cornerRadius = 8;
    [CSToastManager setTapToDismissEnabled:NO];
    [CSToastManager setQueueEnabled:NO];
    [CSToastManager setDefaultDuration:1.5];
}

- (UIImage *)takeDefaultImageByType:(PHToastImageType)imgType {
    if (imgType == PHImageSuccess) {
        return PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_toast_success", @"PHUIKit");
    } else {
        return PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_toast_failure", @"PHUIKit");
    }
}

- (NSString *)takeDefaultTextByType:(PHToastImageType)imgType {
    if (imgType == PHImageSuccess) {
        return @"成功文案";
    } else {
        return @"失败文案";
    }
}

- (NSValue *)toastPosition {
    CGPoint position = CGPointMake(PH_SCREEN_WIDTH / 2.0, PH_SCREEN_HEIGHT / 2.0 + [self toastTopValue]);
    NSValue * positionValue = [NSValue valueWithCGPoint:position];
    return positionValue;
}

- (CGFloat)toastTopValue {
    return ([NSObject ph_iphoneX] ? 44 : 32);
}

/**
 如果不允许点击就把吐丝放这个里面
 
 @param tapToDismiss 开启点击消失
 @return 弹框遮罩
 */
- (UIView *)prohibitTapView:(BOOL)tapToDismiss {
    [CSToastManager setTapToDismissEnabled:tapToDismiss];
    CGFloat backViewWidth = self.bounds.size.width;
    CGFloat backViewHeight = self.bounds.size.height - ([NSObject ph_iphoneX] ? 88 : 64);//普通手机
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backViewWidth, backViewHeight)];//普通手机
    backView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    return backView;
}

- (CGSize)getMessageSize:(UILabel *)messageLabel maxWidth:(CGFloat)maxWidth {
    CGSize maxSizeMessage = CGSizeMake(maxWidth, 36);
    CGSize expectedSizeMessage = [messageLabel sizeThatFits:maxSizeMessage];
    CGSize minSize = CGSizeMake(expectedSizeMessage.width < kMinImageLblWidth ? kMinImageLblWidth : expectedSizeMessage.width, expectedSizeMessage.height);
    expectedSizeMessage = CGSizeMake(MIN(maxSizeMessage.width, minSize.width), MIN(maxSizeMessage.height, minSize.height));
    return expectedSizeMessage;
}

@end
