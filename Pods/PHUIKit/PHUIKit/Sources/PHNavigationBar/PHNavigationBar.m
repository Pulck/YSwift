//
//  PHNavigationBar.m
//  lottie-ios
//
//  Created by 秦平平 on 2019/11/19.
//

#import "PHNavigationBar.h"
#import "Masonry.h"
#import "PHUtils.h"
#import "UIImage+PHTint.h"

/// 导航栏返回通知
NSString * const kPHNavigationBarGoBackNotification = @"kPHNavigationBarGoBackNotification";

// 图片高
#define PHNavBar_Image_Hight 24

@interface PHNavigationBar ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@property (nonatomic, strong, readwrite) UIButton *goBackButton;

@property (nonatomic, strong, readwrite) PHButtonPro *rightButton1;

@property (nonatomic, strong, readwrite) PHButtonPro *rightButton2;

/// 是否为主题色背景
@property (nonatomic, assign, readwrite) BOOL mainColorBackground;

/// 按钮1传入的是否为图片
@property (nonatomic, assign, readwrite) BOOL item1Image;

/// 按钮2传入的是否为图片
@property (nonatomic, assign, readwrite) BOOL item2Image;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *leftItem;

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, copy) NSString *itemColorStr;

@property (nonatomic, copy) NSString *titleColorStr;
 
@end

@implementation PHNavigationBar

#pragma mark - Life cycle
- (instancetype)initWithTitle:(NSString *)title items:(NSArray<id>*)items {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, PH_SCREEN_WIDTH, PH_STATUS_BAR_HEIGHT + PH_NAVIGATION_BAR_HEIGHT);
        self.backgroundColor = [UIColor ph_colorWithHexString:@"#FFFFFF"];
        self.itemArray = items;
        self.title = title;
        self.titleColorStr = @"#262626";
        self.itemColorStr =  @"#262626";
        [self initSubView];
    }
    return self;
}

/**
 初始化方法
 */
- (instancetype)initWithTitle:(NSString *)title items:(NSArray<id>*)items mainColorBackground:(BOOL)mainColorBackground {
    if (self = [super init]) {
        self.mainColorBackground = mainColorBackground;
        self.frame = CGRectMake(0, 0, PH_SCREEN_WIDTH, PH_STATUS_BAR_HEIGHT + PH_NAVIGATION_BAR_HEIGHT);
        if (mainColorBackground == YES) {
            self.backgroundColor = [UIColor ph_colorWithHexString:@"#436BFF"];
        }else {
            self.backgroundColor = [UIColor ph_colorWithHexString:@"#FFFFFF"];
        }
        self.titleColorStr = self.mainColorBackground ? @"#FFFFFF" : @"#262626";
        self.itemColorStr = self.mainColorBackground ? @"#FFFFFF" : @"#262626";
        self.itemArray = items;
        self.title = title;
        [self initSubView];
    }
    return self;
}

#pragma mark - Initialization
- (void)initSubView {
    self.titleLabel.text = self.title;
    [self addSubview:self.leftItem];
    [self addSubview:self.titleLabel];
    [self addSubview:self.goBackButton];
    [self setupRightItemViews];
    [self addSubview:self.lineView];
    [self loadSubviewFrame];
}

- (void)setupRightItemViews {
    if (self.itemArray.count == 1) {
        [self addSubview:self.rightButton1];
        id item = [self.itemArray firstObject];
        if ([item isKindOfClass:[NSString class]]) { // 判断是否为字符串
            self.item1Image = NO;
            [self.rightButton1 setTitle:(NSString *)item forState:(UIControlStateNormal)];
        }else if ([item isKindOfClass:[UIImage class]]){ // 判断是否为图片
            self.item1Image = YES;
            [self.rightButton1 setImage:(UIImage *)item forState:UIControlStateNormal];
        }
    }
    if (self.itemArray.count == 2) {
        id item = [self.itemArray firstObject];
        if ([item isKindOfClass:[NSString class]]) { // 判断是否为字符串
            self.item1Image = NO;
            [self.rightButton1 setTitle:(NSString *)item forState:(UIControlStateNormal)];
        }else if ([item isKindOfClass:[UIImage class]]){ // 判断是否为图片
            self.item1Image = YES;
            [self.rightButton1 setImage:(UIImage *)item forState:UIControlStateNormal];
        }
        id lastItem = [self.itemArray lastObject];
        if ([lastItem isKindOfClass:[NSString class]]) { // 判断是否为字符串
            self.item2Image = NO;
            [self.rightButton2 setTitle:(NSString *)lastItem forState:(UIControlStateNormal)];
        }else if ([lastItem isKindOfClass:[UIImage class]]){ // 判断是否为图片
            self.item2Image = YES;
            [self.rightButton2 setImage:(UIImage *)lastItem forState:UIControlStateNormal];
        }
        [self addSubview:self.rightButton1];
        [self addSubview:self.rightButton2];
    }
    if (self.mainColorBackground) {
        [self imageWihtTintColor:[UIColor ph_colorWithHexString:@"#FFFFFF"]];
    }
}

- (void)loadSubviewFrame {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_equalTo(self).offset(PH_STATUS_BAR_HEIGHT);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(PH_NAVIGATION_BAR_HEIGHT);
    }];
    [self.leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.width.height.mas_equalTo(PH_NAVIGATION_BAR_HEIGHT);
        make.bottom.mas_equalTo(self);
    }];
    [self.goBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(PHNavBar_Image_Hight);
        make.height.mas_equalTo(PHNavBar_Image_Hight);
        make.centerY.mas_equalTo(self.leftItem.mas_centerY);
    }];
    [self rightItemFrame];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self);
    }];
}

- (void)rightItemFrame {
    if (self.itemArray.count == 1) {
        [self.rightButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-15);
            if (self.item1Image) {
                make.width.mas_equalTo(PHNavBar_Image_Hight);
            }
            make.height.mas_equalTo(PHNavBar_Image_Hight);
            make.centerY.mas_equalTo(self.leftItem.mas_centerY);
        }];
    }else if (self.itemArray.count == 2){
        [self.rightButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-15);
            if (self.item1Image) {
                make.width.mas_equalTo(PHNavBar_Image_Hight);
            }
            make.height.mas_equalTo(PHNavBar_Image_Hight);
            make.centerY.mas_equalTo(self.leftItem.mas_centerY);
        }];
        [self.rightButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightButton1.mas_left).offset(self.item1Image ? -20 : -12);
            if (self.item2Image) {
                make.width.mas_equalTo(PHNavBar_Image_Hight);
            }
            make.height.mas_equalTo(PHNavBar_Image_Hight);
            make.centerY.mas_equalTo(self.leftItem.mas_centerY);
        }];
    }
}

- (void)showRightItems:(NSArray<id>*)items {
    self.itemArray = items;
    [self setupRightItemViews];
    [self rightItemFrame];
}

#pragma mark - Actions
- (void)goBack:(UIButton *)button {
    // 发送返回通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kPHNavigationBarGoBackNotification object:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }else if (self.goBackBlock) {
        self.goBackBlock(button);
    }else{
        [self.ph_responderViewController.navigationController popViewControllerAnimated:YES];
    }
}

- (void)itemAction:(PHButtonPro *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemAction:)]) {
        [self.delegate itemAction:button.tag];
    }else if (self.itemIndexBlock) {
        self.itemIndexBlock(button,button.tag);
    }
}

- (void)imageWihtTintColor:(UIColor *)color {
    if (self.item1Image) {
        UIImage *image1 = self.rightButton1.imageView.image;
        [self.rightButton1 setImage:[image1 imageWithGradientTintColor:color] forState:(UIControlStateNormal)];
    }
    if (self.item2Image) {
        UIImage *image2 = self.rightButton2.imageView.image;
        [self.rightButton2 setImage:[image2 imageWithGradientTintColor:color] forState:(UIControlStateNormal)];
    }
    UIImage *gobackImage = self.goBackButton.currentBackgroundImage;
    [self.goBackButton setBackgroundImage:[gobackImage imageWithGradientTintColor:color] forState:UIControlStateNormal];
    
}

#pragma mark - Getter & Setter
- (UIView *)leftItem { // 创建一个自定义按钮
    if (!_leftItem) {
        self.goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.goBackButton setBackgroundImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_icon_nav_back_black",@"PHUIKit") forState:UIControlStateNormal];
        [self.goBackButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        _leftItem = [[UIView alloc] initWithFrame:CGRectZero];
        _leftItem.backgroundColor = [UIColor clearColor];
        [_leftItem addSubview:self.goBackButton];
        // 添加监听
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
        [_leftItem addGestureRecognizer:tap];
    }
    return _leftItem;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor ph_colorWithHexString:self.titleColorStr];
    }
    return _titleLabel;
}

- (PHButtonPro *)rightButton1 {
    if (!_rightButton1) {  // 暂时写一个颜色
        _rightButton1 = [[PHButtonPro alloc] initWithFrame:CGRectZero];
        _rightButton1.tag = 1;
        [_rightButton1 setTitleColor:[UIColor ph_colorWithHexString:self.itemColorStr] forState:(UIControlStateNormal)];
        [_rightButton1 setTitleColor:[UIColor ph_colorPaletteWitHexString:self.itemColorStr index:7] forState:(UIControlStateHighlighted)];
        [_rightButton1 setTitleColor:[UIColor ph_colorPaletteWitHexString:self.itemColorStr index:3] forState:(UIControlStateDisabled)];
        _rightButton1.titleLabel.textAlignment = NSTextAlignmentRight;
        _rightButton1.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_rightButton1 addTarget:self action:@selector(itemAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightButton1;
}

- (PHButtonPro *)rightButton2 {
    if (!_rightButton2) {   // 暂时写一个颜色
        _rightButton2 = [[PHButtonPro alloc] initWithFrame:CGRectZero];
        _rightButton2.tag = 2;
        [_rightButton2 setTitleColor:[UIColor ph_colorWithHexString:self.itemColorStr] forState:(UIControlStateNormal)];
        [_rightButton2 setTitleColor:[UIColor ph_colorPaletteWitHexString:self.itemColorStr index:7] forState:(UIControlStateHighlighted)];
        [_rightButton2 setTitleColor:[UIColor ph_colorPaletteWitHexString:self.itemColorStr index:3] forState:(UIControlStateDisabled)];
        _rightButton2.titleLabel.textAlignment = NSTextAlignmentRight;
        _rightButton2.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_rightButton2 addTarget:self action:@selector(itemAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightButton2;
}

- (UIView *)lineView { // 目前不知道是否需要添加
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor ph_colorWithHexString:@"#E9E9E9"];
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    self.lineView.hidden = !showLine;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setHideBackItem:(BOOL)hideBackItem {
    _hideBackItem = hideBackItem;
    self.leftItem.hidden = hideBackItem;
    self.goBackButton.hidden = hideBackItem;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
