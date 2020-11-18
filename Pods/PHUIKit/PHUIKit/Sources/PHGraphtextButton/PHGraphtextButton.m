//
//  PHGraphtextButton.m
//  PHUIKit
//
//  Created by liangc on 2019/12/25.
//  Copyright © 2019 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHGraphtextButton.h"
#import "Masonry/Masonry.h"

@interface PHGraphtextButton ()

@property (nonatomic) UIButton *button;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *iconImageView;

@property (nonatomic) CGFloat space;

@property (nonatomic) NSMutableDictionary<NSNumber *, PHGraphtextButtonIcon *> *stateIcon;
@property (nonatomic) NSMutableDictionary<NSNumber *, PHGraphtextButtonTitle *> *stateTitle;

@end

@implementation PHGraphtextButton

- (instancetype)initWithStyle:(PHGraphtextButtonStyle)style icon:(PHGraphtextButtonIcon *)icon title:(PHGraphtextButtonTitle *)title space:(CGFloat)space {
    self = [super init];
    if (self) {
        self.icon = icon;
        self.title = title;
        self.space = space;
        self.stateIcon = @{}.mutableCopy;
        self.stateTitle = @{}.mutableCopy;
        
        [self initializeTitle];
        [self initializeTitleIcon];
        
        switch (style) {
            case PHGraphtextButtonStyleIconAndTitle:
                [self layoutIconAndTitleStyleView];
                break;
            case PHGraphtextButtonStyleTitleAndIcon:
                [self layoutTitleAndIconStyleView];
                break;
        }
    }
    return self;
}

#pragma mark - Private Method

- (void)layoutIconAndTitleStyleView {
    CGSize iconSize = self.icon.size;
    
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.width.mas_equalTo(iconSize.width);
        make.height.mas_equalTo(iconSize.height);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self);
        make.bottom.lessThanOrEqualTo(self);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(self.space);
        make.trailing.equalTo(self);
        make.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)layoutTitleAndIconStyleView {
    CGSize iconSize = self.icon.size;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(self.space);
        make.trailing.equalTo(self);
        make.width.mas_equalTo(iconSize.width);
        make.height.mas_equalTo(iconSize.height);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self);
        make.bottom.lessThanOrEqualTo(self);
    }];
    
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)initializeTitle {
    if (self.title.attributeText) {
        self.titleLabel.attributedText = self.title.attributeText;
    } else {
        self.titleLabel.text = self.title.text;
        self.titleLabel.font = self.title.font;
        self.titleLabel.textColor = self.title.color;
    }
}

- (void)initializeTitleIcon {
    self.iconImageView.image = self.icon.image;
}

#pragma mark - Setter

- (void)setIcon:(PHGraphtextButtonIcon *)icon {
    _icon = icon;

    self.iconImageView.image = icon.image;
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(icon.size.width);
        make.height.mas_equalTo(icon.size.height);
    }];
}

- (void)setTitle:(PHGraphtextButtonTitle *)title {
    _title = title;
    
    if (title.attributeText) {
        self.titleLabel.text = nil;
        self.titleLabel.attributedText = title.attributeText;
    } else {
        self.titleLabel.text = title.text;
        self.titleLabel.textColor = title.color;
        self.titleLabel.font = title.font;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    NSNumber *selectedNumber = [NSNumber numberWithBool:isSelected];
    PHGraphtextButtonIcon *icon = self.stateIcon[selectedNumber];
    PHGraphtextButtonTitle *title = self.stateTitle[selectedNumber];
    
    if (icon) {
        self.icon = icon;
    }
    
    if (title) {
        self.title = title;
    }
}

#pragma mark - Public Method

- (void)addTarget:(nullable id)target action:(nonnull SEL)seletor forControlEvents:(UIControlEvents)events {
    [self.button addTarget:target action:seletor forControlEvents:events];
}

- (void)removeTarget:(nullable id)target action:(nonnull SEL)seletor forControlEvents:(UIControlEvents)events {
    [self.button removeTarget:target action:seletor forControlEvents:events];
}

- (void)setIcon:(PHGraphtextButtonIcon *)icon title:(nonnull PHGraphtextButtonTitle *)title forSelected:(BOOL)selected {
    [self.stateIcon addEntriesFromDictionary:@{[NSNumber numberWithBool:selected] : icon}];
    [self.stateTitle addEntriesFromDictionary:@{[NSNumber numberWithBool:selected] : title}];
}


#pragma mark - Lazy Init

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    
    return _button;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [UIImageView new];
    }
    
    return _iconImageView;
}

@end
