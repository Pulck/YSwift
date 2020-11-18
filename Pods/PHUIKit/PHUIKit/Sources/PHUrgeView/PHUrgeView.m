//
//  PHUrgeView.m
//  PHUIKit
//
//  Created by 朱力 on 2020/8/19.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHUrgeView.h"
#import "Masonry.h"
#import "PHUtils.h"
#import "UIColor+PH.h"

#define urgeWidth 214
#define urgeHeight 78

@interface PHUrgeView()

@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, copy) NSString * descStr;
@property (nonatomic, strong) id urgeInfo;

@property (nonatomic, strong) UIImageView * backImageView;
@property (nonatomic, strong) UIView * infoContentView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIButton * touchButton;

@end

@implementation PHUrgeView

- (instancetype)initWithInfo:(NSString *)nameStr
                     descStr:(NSString *)descStr
                      urgeInfo:(id)urgeInfo
              sideslipAction:(BOOL)sideslipAction {
    CGRect myFrame = [self initUrgeFrame];
    if (self == [super initWithFrame:myFrame]) {
        self.nameStr = nameStr;
        self.descStr = descStr;
        self.urgeInfo = urgeInfo;
        [self initUrge];
        [self initData];
        [self initLayout];
        self.animationSpeeds = 0.2;
        if (sideslipAction) {
            [self initPan];
        }
    }
    return self;
}

- (CGRect)initUrgeFrame {
    float safeBottom = PH_Is_iPhoneX ? 34 : 0;
    float urgeTop = PH_SCREEN_HEIGHT - safeBottom - 81 - urgeHeight;
    CGRect urgeFrame = CGRectMake(PH_SCREEN_WIDTH, urgeTop, urgeWidth, urgeHeight);
    return urgeFrame;
}

- (void)initUrge {
    [self addSubview:self.backImageView];
    [self addSubview:self.headerImage];
    [self addSubview:self.infoContentView];
    [self.infoContentView addSubview:self.nameLabel];
    [self.infoContentView addSubview:self.descLabel];
    [self addSubview:self.touchButton];
}

- (void)initLayout {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(17);
        make.width.height.mas_equalTo(44);
        make.top.equalTo(self).mas_offset(12);
    }];
    
    [self.infoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).mas_offset(8);
        make.right.equalTo(self.mas_right).mas_offset(0);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.headerImage.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.infoContentView).mas_offset(0);
        make.height.mas_equalTo(22);
        make.right.equalTo(self.infoContentView.mas_right).mas_offset(-5);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoContentView).mas_offset(0);
        make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(18);
        make.right.equalTo(self.infoContentView.mas_right).mas_offset(-5);
    }];
    
    [self.touchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)initData {
    [self.nameLabel setText:self.nameStr];
    [self.descLabel setText:self.descStr];
}

- (void)resetData:(NSString *)nameStr
          descStr:(NSString *)descStr
           urgeInfo:(id)urgeInfo {
    self.nameStr = nameStr;
    self.descStr = descStr;
    self.urgeInfo = urgeInfo;
    if (self.animations) {
        [UIView animateWithDuration:self.animationSpeeds animations:^{
            [self.headerImage setAlpha:0];
            [self.nameLabel setAlpha:0];
            [self.descLabel setAlpha:0];
        } completion:^(BOOL finished) {
            [self initData];
            [UIView animateWithDuration:self.animationSpeeds animations:^{
                [self.headerImage setAlpha:1];
                [self.nameLabel setAlpha:1];
                [self.descLabel setAlpha:1];
            }];
        }];
    } else {
        [self initData];
    }
}

- (void)initPan {
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panUrgeView:)];
    panRecognizer.cancelsTouchesInView = NO;
    [self.touchButton addGestureRecognizer:panRecognizer];
}

- (void)panUrgeView:(UIPanGestureRecognizer *)recognizer {
    UIView * view = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat xValue = translation.x;
        if (xValue < 0) { xValue = 0; }
        [self setPh_x:PH_SCREEN_WIDTH - urgeWidth + xValue];
    } else if(recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        [_backImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_backImageView setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_urge_backimage", @"PHUIKit")];
    }
    return _backImageView;
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] init];
        [_headerImage.layer setCornerRadius:22];
        [_headerImage setClipsToBounds:YES];
    }
    return _headerImage;
}

- (UIView *)infoContentView {
    if (!_infoContentView) {
        _infoContentView = [[UIView alloc] init];
    }
    return _infoContentView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14]];
        [_nameLabel setTextColor:[UIColor ph_colorWithHexString:@"262626"]];
    }
    return _nameLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12]];
        [_descLabel setTextColor:[UIColor ph_colorWithHexString:@"757575"]];
    }
    return _descLabel;
}

- (UIButton *)touchButton {
    if (!_touchButton) {
        _touchButton = [[UIButton alloc] init];
        [_touchButton addTarget:self action:@selector(urgeTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchButton;
}

- (void)urgeTouched {
    if (self.urgeBlock) {
        self.urgeBlock(self.urgeInfo);
    }
    [self hideUrge:^(BOOL finished) { }];
}

- (void)showUrge:(void (^ __nullable)(BOOL finished))completion {
    if (self.animations) {
        [UIView animateWithDuration:self.animationSpeeds animations:^{
            [self setPh_x:PH_SCREEN_WIDTH - urgeWidth];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self setPh_x:PH_SCREEN_WIDTH - urgeWidth];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)hideUrge:(void (^ __nullable)(BOOL finished))completion {
    if (self.animations) {
        [UIView animateWithDuration:self.animationSpeeds animations:^{
            [self setPh_x:PH_SCREEN_WIDTH];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self setPh_x:PH_SCREEN_WIDTH];
        [self removeFromSuperview];
        if (completion) {
            completion(YES);
        }
    }
}

@end
