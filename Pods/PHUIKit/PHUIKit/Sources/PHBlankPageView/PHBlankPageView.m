//
//  PHBlankPageView.m
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/10.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHBlankPageView.h"
#import "Masonry.h"
#import "PHUtils.h"

@implementation PHBlankPageView
#pragma mark -- UI init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self constructSubViews];
    }
    return self;
}

- (void)constructSubViews {
    [self addSubview:self.icon];
    [self addSubview:self.titleLabel];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(130);
        make.centerY.equalTo(self).offset(-55);
        make.centerX.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(30);
        make.left.mas_equalTo(self).offset(56);
        make.right.mas_equalTo(self).offset(-56);
    }];
    [self addDesLabelView];
}

- (void)addDesLabelView {
    [self addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.width.height.mas_equalTo(self.titleLabel);
        make.centerX.mas_equalTo(self.titleLabel);
    }];
}

- (void)addSettingBtnViewWithTitle:(NSString *)title {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(130);
        make.centerY.equalTo(self).offset(-80);
        make.centerX.equalTo(self);
    }];
    _settingBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _settingBtn.backgroundColor = [UIColor ph_colorWithHexString:@"#436BFF"];
    [_settingBtn setTitle:title forState:(UIControlStateNormal)];
    [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_settingBtn addTarget:self action:@selector(settingAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _settingBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_settingBtn];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.desLabel.hidden == YES ? self.titleLabel.mas_bottom: self.desLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(@(230));
        make.height.mas_equalTo(@(44));
    }];
    _settingBtn.layer.cornerRadius = 22;
}

- (void)updateLayoutConstraints {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-20);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(90);
    }];
    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(56);
        make.right.mas_equalTo(self).offset(-56);
        make.height.mas_equalTo(@(20));
    }];
}

#pragma mark -- data

- (void)showBlankPageType:(PHBlankPageType)blankPageType {
    self.blankPageType = blankPageType;
    switch (blankPageType) {
        case PHBlankPageTypeData:{
            self.titleLabel.text = @"暂无数据";
            self.icon.image = PH_IMAGE_NAMED_FRAMEWORK(@"ph_icon_blankpage_data");
            break;
        }
        case PHBlankPageTypeNoAccess:{
            self.titleLabel.text = @"暂无权限";
            self.icon.image = PH_IMAGE_NAMED_FRAMEWORK(@"ph_icon_blankpage_access");
            break;
        }
    }
}

- (void)setContentTitle:(NSString * _Nullable)title{
    self.titleLabel.text = title;
}

/**
 更换图片
 
 @param imageView 图片名
 */
- (void)setImageWithImageView:(UIImage * _Nullable)imageView{
    if (imageView) {
        self.icon.image = imageView;
    }else{
        self.icon.image = PH_IMAGE_NAMED_FRAMEWORK(@"ph_icon_blankpage_data");
    }
}


#pragma mark - lazyInit

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = PH_IMAGE_NAMED_FRAMEWORK(@"ph_icon_blankpage_data");
        [_icon sizeToFit];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor ph_colorWithHexString:@"#595959"];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f] ;
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"暂无数据";
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.hidden = YES;
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.textColor = [UIColor ph_colorWithHexString:@"#BFBFBF"];
        _desLabel.font = [UIFont systemFontOfSize:14.0f] ;
        _desLabel.numberOfLines = 2;
        _desLabel.text = @"暂无数据";
    }
    return _desLabel;
}

+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView  isHalfScreen:(BOOL)isHalfScreen {
    PHBlankPageView * emptyView = [[PHBlankPageView alloc] initWithFrame:CGRectZero];
    [baseView addSubview:emptyView];
    if (isHalfScreen) {
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(baseView);
            make.left.mas_equalTo(baseView);
            make.right.mas_equalTo(baseView);
            make.bottom.mas_equalTo(baseView);
        }];
    }else {
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(baseView).offset(PH_STATUS_AND_NAVIGATION_HEIGHT);
            make.left.mas_equalTo(baseView);
            make.right.mas_equalTo(baseView);
            make.bottom.mas_equalTo(baseView);
        }];
    }
    emptyView.tag = 3008977;
    return emptyView;
}

/**
 全屏，显示空白页面

 @param baseView 显示视图
 @param blankPageType 显示类型
 @return 空白页面视图
 */
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView blankPageType:(PHBlankPageType)blankPageType {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:NO];
    [blankPageView showBlankPageType:blankPageType];
    return blankPageView;
}

/// 空白页面
/// @param baseView 显示视图
/// @param blankPageType 空白页面类型
/// @param isHalfScreen 是否半屏。YES 半屏， NO ，全屏
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView blankPageType:(PHBlankPageType)blankPageType isHalfScreen:(BOOL)isHalfScreen {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:isHalfScreen];
    [blankPageView showBlankPageType:blankPageType];
    if (isHalfScreen) {
        [blankPageView updateLayoutConstraints];
    }
    return blankPageView;
}

/// 空白页面支持更换标题
/// @param baseView 显示视图
/// @param contentTitle 标题
/// @param isHalfScreen 是否半屏。YES 半屏， NO ，全屏
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView contentTitle:(NSString * _Nullable)contentTitle isHalfScreen:(BOOL)isHalfScreen {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:isHalfScreen];
    blankPageView.titleLabel.text = contentTitle;
    if (isHalfScreen) {
        blankPageView.titleLabel.hidden = YES;
        blankPageView.desLabel.hidden = NO;
        blankPageView.desLabel.text = contentTitle;
        [blankPageView updateLayoutConstraints];
    }else {
        blankPageView.titleLabel.text = contentTitle;
    }
    return blankPageView;
}

/// 全屏支持更换标题和图片
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
+ (PHBlankPageView *)showBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:NO];
    if (contentImage) {
        blankPageView.icon.image = contentImage;
    }
    blankPageView.titleLabel.text = contentTitle;
    return blankPageView;
}

/// 自定义位置支持更换标题和图片
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
+ (PHBlankPageView *)showCustomerBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:YES];
    if (contentImage) {
        blankPageView.icon.image = contentImage;
    }
    blankPageView.titleLabel.text = contentTitle;
    return blankPageView;
}

/// 半屏支持更换标题和图片
/// @param baseView 添加在某个view上
/// @param contentImage 图片
/// @param contentTitle 标题
+ (PHBlankPageView *)showHalfScreenBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:YES];
    blankPageView.desLabel.hidden = NO;
    blankPageView.titleLabel.hidden = YES;
    blankPageView.desLabel.text = contentTitle;
    [blankPageView updateLayoutConstraints];
    return blankPageView;
}

/// 全屏显示带按钮的空白页面
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
/// @param buttonTitle 按钮标题
+ (PHBlankPageView *)showGuideBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle buttonTitle:(NSString * _Nullable)buttonTitle {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:NO];
    if (contentImage) {
        blankPageView.icon.image = contentImage;
    }
    blankPageView.titleLabel.text = contentTitle;
    [blankPageView addSettingBtnViewWithTitle:buttonTitle];
    return blankPageView;
}

/// 全屏显示描述+按钮的空白页面
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
/// @param descriptor 副标题
/// @param buttonTitle 按钮标题
+ (PHBlankPageView *)showDesGuideBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle descriptor:(NSString * _Nullable)descriptor buttonTitle:(NSString * _Nullable)buttonTitle {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:NO];
    if (contentImage) {
        blankPageView.icon.image = contentImage;
    }
    blankPageView.titleLabel.text = contentTitle;
    blankPageView.desLabel.hidden = NO;
    blankPageView.desLabel.text = descriptor;
    [blankPageView addSettingBtnViewWithTitle:buttonTitle];
    return blankPageView;
}

/// 显示带副标题，不带按钮的空白页面
/// @param baseView 显示视图
/// @param contentImage 图片
/// @param contentTitle 标题
/// @param descriptor 副标题
/// @param isHalfScreen 是否全屏，半屏
+ (PHBlankPageView *)showDescriptorBlankPageOnView:(UIView * _Nullable)baseView contentImage:(UIImage * _Nullable)contentImage contentTitle:(NSString * _Nullable)contentTitle descriptor:(NSString * _Nullable)descriptor isHalfScreen:(BOOL)isHalfScreen {
    PHBlankPageView * blankPageView = [PHBlankPageView showBlankPageOnView:baseView isHalfScreen:isHalfScreen];
    if (contentImage) {
        blankPageView.icon.image = contentImage;
    }
    blankPageView.titleLabel.text = contentTitle;
    blankPageView.desLabel.hidden = NO;
    blankPageView.desLabel.text = descriptor;
    return blankPageView;
}

/**
 移除
 
 @param baseView 视图
 */
+ (void)removeBlankPageOnView:(UIView * _Nullable)baseView{
    [[baseView viewWithTag:3008977] removeFromSuperview];
}

/// 按钮点击事件
/// @param btn 按钮
- (void)settingAction:(UIButton *)btn {
    if (self.itemAction) {
        self.itemAction(btn);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
