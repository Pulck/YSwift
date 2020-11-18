//
//  PHAlertView.m
//  Masonry
//
//  Created by 秦平平 on 2019/11/11.
//

#import "PHAlertView.h"
#import "Masonry.h"
#import "PHUtils.h"

static float const kAlertViewCellHeight = 48.f; /// cell指定高度
static float const kAlertSubViewX = 24.0f; /// 间隔
static float const kAlertViewTopY = 10.0f; /// 标题高度
static float const kAlertViewRadius = 16.0f; /// 圆角大小

@interface PHAlertView () <UITextViewDelegate>
#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow; /// 当前窗口
@property (nonatomic, strong) UIView *shadeView; /// 遮罩层
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; /// 点击背景阴影的手
@property (nonatomic, strong) UIImageView *imageView; /// 图片视图
@property (nonatomic, strong) UIView *textView; /// 副标题视图
#pragma mark - 输入框
@property (nonatomic, strong, readwrite) UITextField *textFieldView;/// 文本输入框视图
@property (nonatomic, strong) UILabel *placeholderLabel; /// 提示语视图
@property (nonatomic, strong) UILabel *numberLabel; /// 字数控制
@property (nonatomic, strong) UILabel *radioTitleLabel; /// 选择按钮描述
@property (nonatomic, strong) UIView *lineView; /// 分割线
@property (nonatomic, strong) UIView *lineView1; /// 竖分割线
@property (nonatomic, strong) UIView *lineView2; /// 分割线
@property (nonatomic, strong) UIButton *radioBtn; /// 选择按钮
@property (nonatomic, strong, readwrite) PHButtonPro *cancelBtn; /// 取消按钮
@property (nonatomic, strong, readwrite) PHButtonPro *doneBtn; /// 确定按钮
@property (nonatomic, strong, readwrite) PHButtonPro *otherBtn; /// 其它按钮
@property (nonatomic, strong, readwrite) UILabel *titleLabel; ///  标题
#pragma mark - Data
@property (nonatomic, assign) CGFloat windowWidth; /// 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight; /// 窗口高度
@property (nonatomic, copy)   NSString *title;  /// 标题
@property (nonatomic, copy)   NSString *message;   /// 副标题
@property (nonatomic, copy)   NSString *cancelTitle; /// 取消按钮标题
@property (nonatomic, strong) NSMutableArray<NSString *> *items; /// 其它按钮标题
@property (nonatomic, assign) NSInteger alertType; /// 展示类型
@property (nonatomic, strong) UIImage *image;   /// 图片
@property (nonatomic, assign) CGFloat lineTopY; /// 文本间距

@end

@implementation PHAlertView

#pragma mark - Life cycle
- (instancetype)initWithAlertType:(PHAlertTextType)type
                            title:(NSString * _Nullable)title
                          message:(NSString * __nullable)message
                      cancelTitle:(NSString * _Nullable)cancelTitle
                      otherTitles:(NSArray<NSString *> * _Nullable)otherTitles {
    if (self = [super init]) {
        NSInteger styleType = type;
        [self setupViewWithTitle:title message:message image:nil cancelTitle:cancelTitle otherTitles:otherTitles alertType:styleType];
    }
    return self;
}

- (instancetype)initWithAlertType:(PHAlertTextType)type
                            image:(UIImage * _Nullable)image
                            title:(NSString * _Nullable)title
                          message:(NSString * __nullable)message
                      cancelTitle:(NSString * _Nullable)cancelTitle
                      otherTitles:(NSArray<NSString *> * _Nullable)otherTitles {
    if (self = [super init]) {
        NSInteger styleType = type;
        [self setupViewWithTitle:title message:message image:image cancelTitle:cancelTitle otherTitles:otherTitles alertType:styleType];
    }
    return self;
}

- (void)setupViewWithTitle:(NSString * __nullable)title
                   message:(NSString * __nullable)message
                     image:(UIImage * _Nullable)image
               cancelTitle:(NSString * _Nullable)cancelTitle
               otherTitles:(NSArray<NSString *> * _Nullable)otherTitles
                 alertType:(NSInteger)type {
    self.layer.cornerRadius = kAlertViewRadius;
    self.backgroundColor = [UIColor ph_colorWithHexString:@"#FFFFFF"];
    self.textNumber = 100;
    self.alertType = type;
    self.title = title;
    self.message = message;
    self.image = image;
    self.cancelTitle = cancelTitle;
    self.items = [NSMutableArray arrayWithArray:otherTitles];
    [self shadeBackgroundView];  // 蒙层背景视图
    [self setupMessageSubView]; // 标题
}
#pragma mark - Initialization
/// 遮罩蒙层
- (void)shadeBackgroundView {
    // keyWindow
    self.keyWindow = [UIApplication sharedApplication].keyWindow;
    self.windowWidth = CGRectGetWidth(self.keyWindow.bounds);
    self.windowHeight = CGRectGetHeight(self.keyWindow.bounds);
    self.shadeView = [[UIView alloc] initWithFrame:self.keyWindow.bounds];
    self.shadeView.backgroundColor = [UIColor ph_colorWithHexString:@"#000000" alpha:0.6];
    self.shadeView.alpha = 0.f;
    [self.keyWindow addSubview:self.shadeView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    [self.keyWindow addSubview:self];
    [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.keyWindow);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.keyWindow);
        make.centerY.mas_equalTo(self.keyWindow.mas_centerY);
        make.width.mas_equalTo(270);
        make.height.mas_lessThanOrEqualTo(PH_SCREEN_HEIGHT < PH_SCREEN_WIDTH ? 240 : 406);
    }];
    self.alpha = 0.f;
    [self layoutIfNeeded];
    [self setupTitleSubView];
}

/// 标题
- (void)setupTitleSubView {
    if (![NSString ph_isNilOrEmpty:self.title]) {
        self.titleLabel.text = self.title;
        [self addSubview:self.titleLabel];
    }
    // 分割线
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = [UIColor ph_colorWithHexString:@"#EBEDF0"];
    [self addSubview:self.lineView];
    
    if (![NSString ph_isNilOrEmpty:self.cancelTitle]) {
        //  关闭按钮
        [self.cancelBtn setTitle:self.cancelTitle forState:(UIControlStateNormal)];
        [self addSubview:self.cancelBtn];
    }
    if (self.items.count == 1) { // 按钮只有一个的时候
        [self addSubview:self.lineView1];  // 分割线
        self.doneBtn.layer.cornerRadius = kAlertViewRadius;
        [self.doneBtn setTitle:[self.items firstObject] forState:(UIControlStateNormal)];
        [self addSubview:self.doneBtn];
    }
    if (self.items.count == 2) { // 按钮显示两个的时候
        self.cancelBtn.layer.cornerRadius = 0;
        self.doneBtn.layer.cornerRadius = 0;
        [self addSubview:self.lineView1];
        [self.doneBtn setTitle:[self.items firstObject] forState:(UIControlStateNormal)];
        [self addSubview:self.doneBtn];
        [self addSubview:self.lineView2];
        self.otherBtn .layer.cornerRadius = kAlertViewRadius;
        [self.otherBtn setTitle:[self.items lastObject] forState:(UIControlStateNormal)];
        [self addSubview:self.otherBtn];
    }
}

- (void)numberInputTextView {
    // 输入框
    self.messageTextView.delegate = self;
    self.messageTextView.editable = YES;
    self.messageTextView.showsVerticalScrollIndicator = YES;
    self.messageTextView.textColor = [UIColor ph_colorWithHexString:@"#262626"];
    self.messageTextView.font = [UIFont systemFontOfSize:14.0f];
    self.messageTextView.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.messageTextView];
    // 提示语
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.placeholderLabel.textColor = [UIColor ph_colorWithHexString:@"#BFBFBF"];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
    self.placeholderLabel.numberOfLines = 0;
    [self.messageTextView addSubview:self.placeholderLabel];
    
    // 数字
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.numberLabel.textColor = [UIColor ph_colorWithHexString:@"#BFBFBF"];
    self.numberLabel.font = [UIFont systemFontOfSize:12.0f];
    self.numberLabel.text = [NSString stringWithFormat:@"0/%ld",(long)self.textNumber];
    [self.textView addSubview:self.numberLabel];
}

/// 描述说明信息
- (void)setupMessageSubView {
    switch (self.alertType) {
        case PHAlertTypeTextShow:{
            if (![NSString ph_isNilOrEmpty:self.message]) {  //  副标题
                self.messageTextView.text = self.message;
                [self addSubview:self.messageTextView];
            }
            [self initSubViewFrame];
            break;
        }
        case PHAlertTypeInput:{
            self.textView = [[UIView alloc] initWithFrame:CGRectZero];
            self.textView.layer.cornerRadius = 4;
            self.textView.layer.borderWidth = 0.5;
            self.textView.layer.borderColor = [UIColor ph_colorWithHexString:@"#D9D9D9"].CGColor;
            [self addSubview:self.textView];
            [self addSubview:self.textFieldView];
            [self initSubViewFrame];
            break;
        }
        case PHAlertTypeTextRadio:{
            if (![NSString ph_isNilOrEmpty:self.message]) {  //  副标题
                self.messageTextView.text = self.message;
                [self addSubview:self.messageTextView];
            }
            self.radioTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            self.radioTitleLabel.font = [UIFont systemFontOfSize:14.0f];
            self.radioTitleLabel.text = @"保存本次设置，不再询问";
            self.radioTitleLabel.textColor = [UIColor ph_colorWithHexString:@"#8C8C8C"];
            [self addSubview:self.radioTitleLabel];
            self.radioBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            [self.radioBtn setImage:PH_IMAGE_NAMED_FRAMEWORK(@"ph_icon_alert_unselected") forState:(UIControlStateNormal)];
            [self.radioBtn setImage:PH_IMAGE_NAMED_FRAMEWORK(@"ph_icon_alert_selected") forState:(UIControlStateSelected)];
            [self.radioBtn addTarget:self action:@selector(radioAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:self.radioBtn];
            [self initSubViewFrame];
            break;
        }
        case PHAlertTypeLongInput:{
            self.textView = [[UIView alloc] initWithFrame:CGRectZero];
            self.textView.layer.cornerRadius = 4;
            self.textView.layer.borderWidth = 0.5;
            self.textView.layer.borderColor = [UIColor ph_colorWithHexString:@"#D9D9D9"].CGColor;
            [self addSubview:self.textView];
            [self numberInputTextView];
            [self initSubViewFrame];
            break;
        }
        case PHAlertImageTypeTop:{ // 图片显示在顶部
            if (![NSString ph_isNilOrEmpty:self.message]) {  //  副标题
                self.messageTextView.text = self.message;
                [self addSubview:self.messageTextView];
            }
            if (self.image) { // 添加图片
                self.imageView.image = self.image;
                [self addSubview:self.imageView];
                [self addImageToTopFrame];
                [self buttonSubViewFrame];
            }
            break;
        }
        default:
            break;
    }
}

/// 视图布局
- (void)initSubViewFrame {
    BOOL isInput = self.alertType != PHAlertTypeLongInput && self.alertType != PHAlertTypeInput;
    if (![NSString ph_isNilOrEmpty:self.title]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kAlertSubViewX);
            make.right.mas_equalTo(self).offset(-kAlertSubViewX);
            make.top.mas_equalTo(self).offset(kAlertSubViewX);
            make.height.mas_equalTo(kAlertSubViewX);
        }];
    }else if (isInput){  // 区分无标题时，颜色加重，字体变大
        self.messageTextView.textColor = [UIColor ph_colorWithHexString:@"#262626"];
        self.messageTextView.font = [UIFont systemFontOfSize:16.0f];
    }
    if (self.alertType == PHAlertTypeTextShow) {
        CGFloat messageHegiht = [self messageHeight];
        if (![NSString ph_isNilOrEmpty:self.message]) {
            [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(kAlertSubViewX);
                make.right.mas_equalTo(self).offset(-kAlertSubViewX);
                if (![NSString ph_isNilOrEmpty:self.title]) {
                    make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kAlertViewTopY);
                }else{
                    make.top.mas_equalTo(self).offset(kAlertSubViewX);
                }
                make.bottom.mas_equalTo(self.lineView.mas_top).offset(-self.lineTopY);
                make.height.mas_equalTo(messageHegiht);
            }];
        }
    }else if (self.alertType == PHAlertTypeInput){
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kAlertSubViewX);
            make.right.mas_equalTo(self).offset(-kAlertSubViewX);
            if (![NSString ph_isNilOrEmpty:self.title]) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
            }else{
                make.top.mas_equalTo(self).offset(kAlertSubViewX);
            }
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-kAlertSubViewX);
            make.height.mas_equalTo(@(40));
        }];
        [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textView).offset(8);
            make.top.mas_equalTo(self.textView).offset(8);
            make.right.mas_equalTo(self.textView).offset(-8);
            make.bottom.mas_equalTo(self.textView).offset(-8);
        }];

    }else if (self.alertType == PHAlertTypeTextRadio){
        CGFloat messageHegiht = [self messageHeight];
        if (![NSString ph_isNilOrEmpty:self.message]) {
            self.messageTextView.textAlignment = NSTextAlignmentLeft;
            [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(kAlertSubViewX);
                make.right.mas_equalTo(self).offset(-kAlertSubViewX);
                if (![NSString ph_isNilOrEmpty:self.title]) {
                    make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kAlertViewTopY);
                }else{
                    make.top.mas_equalTo(self).offset(kAlertSubViewX);
                }
                make.height.mas_equalTo(messageHegiht);
                make.bottom.mas_equalTo(self.radioBtn.mas_top).offset(-17);
            }];
        }
        [self.radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kAlertSubViewX);
            if (![NSString ph_isNilOrEmpty:self.title]) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kAlertViewTopY);
            }else{
                make.top.mas_equalTo(self.messageTextView.mas_bottom).offset(17);
            }
            make.width.height.mas_equalTo(18);
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-kAlertSubViewX);
        }];
        [self.radioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.radioBtn.mas_right).offset(8);
            make.top.mas_equalTo(self.radioBtn.mas_top);
            make.right.mas_equalTo(self.mas_right).offset(8);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-kAlertSubViewX);
        }];
    }else if (self.alertType == PHAlertTypeLongInput){ // 长文本输入
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kAlertSubViewX);
            make.right.mas_equalTo(self).offset(-kAlertSubViewX);
            if (![NSString ph_isNilOrEmpty:self.title]) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
            }else{
                make.top.mas_equalTo(self).offset(kAlertSubViewX);
            }
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-kAlertSubViewX);
            make.height.mas_equalTo(@(110));
        }];
        [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textView).offset(10);
            make.right.mas_equalTo(self.textView).offset(-10);
            make.top.mas_equalTo(self.textView).offset(8);
            make.bottom.mas_equalTo(self.textView).offset(-30);
            make.height.mas_equalTo(@(72));
        }];
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.messageTextView).offset(3);
            make.right.mas_equalTo(self.messageTextView).offset(-3);
            make.top.mas_equalTo(self.messageTextView);
            make.bottom.mas_equalTo(self.messageTextView);
        }];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.textView.mas_bottom).offset(-5);
            make.right.mas_equalTo(self.textView.mas_right).offset(-10);
            make.height.mas_equalTo(18);
        }];

    }
    [self buttonSubViewFrame];
}

///  图片展示在顶部时的布局
- (void)addImageToTopFrame {
    if (self.image) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(112);
        }];
        [self layoutIfNeeded];
        [self.imageView ph_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(kAlertViewRadius, kAlertViewRadius)];
    }
    if (![NSString ph_isNilOrEmpty:self.title]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kAlertSubViewX);
            make.right.mas_equalTo(self).offset(-kAlertSubViewX);
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(kAlertViewTopY);
            make.height.mas_equalTo(kAlertSubViewX);
        }];
    }
    CGFloat messageHegiht = [self messageHeight];
    if (![NSString ph_isNilOrEmpty:self.message]) {
        [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kAlertSubViewX);
            make.right.mas_equalTo(self).offset(-kAlertSubViewX);
            if (![NSString ph_isNilOrEmpty:self.title]) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kAlertViewTopY);
            }else{
                make.top.mas_equalTo(self).offset(kAlertSubViewX);
            }
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-self.lineTopY);
            make.height.mas_equalTo(messageHegiht);
        }];
    }
}

/// 按钮布局
- (void)buttonSubViewFrame {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        if (self.alertType == PHAlertTypeInput){
            make.top.mas_equalTo(self.textView.mas_bottom).offset(kAlertSubViewX);
        }else if(![NSString ph_isNilOrEmpty:self.message]){
            make.top.mas_equalTo(self.messageTextView.mas_bottom).offset(kAlertSubViewX);
        }else{
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kAlertSubViewX);
        }
        if (![NSString ph_isNilOrEmpty:self.cancelTitle] && self.items.count == 0) {
           make.bottom.mas_equalTo(self.cancelBtn.mas_top);
        }else{
            make.bottom.mas_equalTo(self.doneBtn.mas_top);
        }
        make.height.mas_equalTo(0.5);
    }];
    if (self.items.count == 0) { ///  样式为1个按钮
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(kAlertViewCellHeight);
        }];
        [self layoutIfNeeded];
        [self.cancelBtn setButtonRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(kAlertViewRadius, kAlertViewRadius)];
    }else if (self.items.count == 1){ ///  样式为2个按钮
        if (![NSString ph_isNilOrEmpty:self.cancelTitle]) {
            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(16);
                make.bottom.mas_equalTo(self);
                make.width.mas_equalTo((270-32*2)/2);
                make.height.mas_equalTo(kAlertViewCellHeight);
            }];
            [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.cancelBtn.mas_right).offset(16);
                make.top.mas_equalTo(self.cancelBtn.mas_top);
                make.width.mas_equalTo(0.5);
                make.height.mas_equalTo(kAlertViewCellHeight);
            }];
            [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo((270-32*2)/2);
                make.left.mas_equalTo(self.lineView1.mas_right).offset(16);
                make.bottom.mas_equalTo(self);
                make.height.mas_equalTo(kAlertViewCellHeight);
            }];
        }else{
            [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self);
                make.bottom.mas_equalTo(self);
                make.height.mas_equalTo(kAlertViewCellHeight);
            }];
        }
        [self layoutIfNeeded];
        [self.cancelBtn setButtonRoundedCorners:UIRectCornerBottomLeft withRadii:CGSizeMake(kAlertViewRadius, kAlertViewRadius)];
        [self.doneBtn setButtonRoundedCorners:UIRectCornerBottomRight withRadii:CGSizeMake(kAlertViewRadius, kAlertViewRadius)];
    }else if(self.items.count == 2){  ///  样式为3个按钮
        [self threeButtonFrame];
    }
}

///   3个按钮样式
- (void)threeButtonFrame {
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.height.mas_equalTo(kAlertViewCellHeight);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.doneBtn.mas_bottom);
        make.bottom.mas_equalTo(self.otherBtn.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    [self.otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.height.mas_equalTo(kAlertViewCellHeight);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.otherBtn.mas_bottom);
        make.bottom.mas_equalTo(self.cancelBtn.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.lineView2.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(kAlertViewCellHeight);
    }];
    [self layoutIfNeeded];
    [self.cancelBtn setButtonRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(kAlertViewRadius, kAlertViewRadius)];
}

- (CGFloat)messageHeight {
    CGFloat padding = self.messageTextView.textContainer.lineFragmentPadding;
    CGSize subTitleSize = [NSString ph_boundSizeWithString:self.message font:self.messageTextView.font size:CGSizeMake(270 - kAlertSubViewX * 2 - padding * 2, MAXFLOAT)];
    if(subTitleSize.height > 40) {
        self.messageTextView.textAlignment = NSTextAlignmentLeft;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:self.messageTextView.font,
                                     NSForegroundColorAttributeName:self.messageTextView.textColor,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.messageTextView.typingAttributes = attributes;
        self.messageTextView.attributedText = [[NSAttributedString alloc] initWithString:self.messageTextView.text attributes:attributes];
        CGSize messageSize = [self.messageTextView.attributedText boundingRectWithSize:CGSizeMake(270 - kAlertSubViewX * 2 - padding * 2, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil].size;
        subTitleSize.height = messageSize.height;
    }
    
    self.lineTopY = kAlertSubViewX;
    if (subTitleSize.height > 290) {
        self.messageTextView.textAlignment = NSTextAlignmentLeft;
        self.lineTopY = 7;
        subTitleSize.height = 290;
    }
    return subTitleSize.height;
}

#pragma mark - Actions
/// 显示视图
- (void)show {
    [self layoutIfNeeded];
    //弹出动画
    self.layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        self.shadeView.alpha = 1.0f;
        self.alpha = 1.f;
        self.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

/// 点击外部隐藏弹窗
- (void)hide {
    [UIView animateWithDuration:.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shadeView.alpha = 0.f;
        self.alpha = 0.f;
        self.layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)hideKeyboard {
    [self.messageTextView endEditing:YES];
}

/// 点击取消按钮事件
- (void)cancelBtnAction:(PHButtonPro *)btn{
    if (self.cancelAction) {
        self.cancelAction(btn.titleLabel.text);
    }
    [self hide];
}

/// 点击辅助按钮事件
- (void)doneBtnAction:(PHButtonPro *)btn{
    NSString *text = @"";
    if (self.alertType == PHAlertTypeInput && ![NSString ph_isNilOrEmpty:self.textFieldView.text]) {
        text = self.textFieldView.text;
    }else if (self.alertType == PHAlertTypeLongInput) {
        text = self.messageTextView.text;
        if ([text ph_stringByTrimmingWhitespaceAndNewline].length == 0 || [text ph_stringByTrimmingWhitespaceAndNewline].length > self.textNumber) {
            if (self.textNumberAction) {
                self.textNumberAction([text ph_stringByTrimmingWhitespaceAndNewline]);
            }
            return;
        }
    }
    
    if (self.itemAction) {
        self.itemAction(btn.tag, btn.titleLabel.text, text);
    }
    [self hide];
}

/// 点击辅助按钮事件
- (void)otherBtnAction:(PHButtonPro *)btn{
    NSString *text = @"";
    if (self.alertType == PHAlertTypeInput && ![NSString ph_isNilOrEmpty:self.textFieldView.text]) {
        text = self.textFieldView.text;
    }else if (self.alertType == PHAlertTypeLongInput) {
        text = self.messageTextView.text;
        if ([text ph_stringByTrimmingWhitespaceAndNewline].length == 0 || [text ph_stringByTrimmingWhitespaceAndNewline].length > self.textNumber) {
            if (self.textNumberAction) {
                self.textNumberAction([text ph_stringByTrimmingWhitespaceAndNewline]);
            }
            return;
        }
    }

    if (self.itemAction) {
        self.itemAction(btn.tag, btn.titleLabel.text, text);
    }
    [self hide];
}

- (void)radioAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.radioAction) {
        self.radioAction(btn.selected);
    }
}

#pragma mark - UITextViewDelegate
//////////事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //判断类型，如果不是UITextView类型，收起键盘
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            UITextView* tv = (UITextView*)view;
            [tv resignFirstResponder];
        }
    }
}

// 即将开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
// 已经开始编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

// 编辑即将结束
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}
// 编辑已经结束
- (void)textViewDidEndEditing:(UITextView *)textView {
    
}
// 文本视图在用户输入新字符或删除现有字符时调用此方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location == 0 && range.length == 1) {
        [self.placeholderLabel setHidden:NO];
    }else{
        [self.placeholderLabel setHidden:YES];
    }
    if (range.location > self.textNumber){
        //控制输入文本的长度
        textView.text = [textView.text substringToIndex:self.textNumber];
    }
    if ([text isEqualToString:@"\n"]){
        //禁止输入换行
        return NO;
    }
    return YES;
}
// 输入的内容已经变化时调用此方法
- (void)textViewDidChange:(UITextView *)textView {
    [self updateNumberLabelStyle:[textView.text length]];
}

/// 字数颜色更新
/// @param value 字数
- (void)updateNumberLabelStyle:(NSInteger)value {
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)value,(long)self.textNumber];
    NSString *pointStr = [NSString stringWithFormat:@"%ld",(long)value];
    NSRange range = [self.numberLabel.text rangeOfString:pointStr];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.numberLabel.text];
        if (value == 0) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor ph_colorWithHexString:@"#BFBFBF"] range:range];
        }else if (self.messageTextView.markedTextRange == nil && value > self.textNumber){
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor ph_colorWithHexString:@"#F5222D"] range:range];
        }else{
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor ph_colorWithHexString:@"#262626"] range:range];
        }
        [self.numberLabel setAttributedText:attributedString];
    }
}

#pragma mark - Getter & Setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

/// 标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor ph_colorWithHexString:@"#323233"];
        _titleLabel.font = [UIFont boldSystemFontOfSize: 16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

/// 副标题/ 说明
- (UITextView *)messageTextView  {
    if (!_messageTextView) {
        _messageTextView = [[UITextView alloc] initWithFrame:CGRectZero];
//        _messageTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应
        _messageTextView.textColor = [UIColor ph_colorWithHexString:@"#8C8C8C"];
        _messageTextView.font = [UIFont systemFontOfSize:14.0f];
        _messageTextView.editable = NO;
        _messageTextView.textAlignment = NSTextAlignmentCenter;
        _messageTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _messageTextView;
}

- (UITextField *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[UITextField alloc] initWithFrame:CGRectZero];
        _textFieldView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应
        _textFieldView.textColor = [UIColor ph_colorWithHexString:@"#262626"];
        _textFieldView.font = [UIFont systemFontOfSize:16.0f];
        _textFieldView.textAlignment = NSTextAlignmentLeft;
    }
    return _textFieldView;
}

/// 取消按钮
- (PHButtonPro *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[PHButtonPro alloc] initWithFrame:CGRectZero];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.layer.cornerRadius = kAlertViewRadius;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitleColor:[UIColor ph_colorWithHexString:@"#262626"] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#262626" index:7] forState:UIControlStateHighlighted];
        [_cancelBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#262626" index:3] forState:UIControlStateDisabled];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

/// 横线
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView1.backgroundColor = [UIColor ph_colorWithHexString:@"#EBEDF0"];
    }
    return _lineView1;
}

/// 辅助标题
- (PHButtonPro *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[PHButtonPro alloc] initWithFrame:CGRectZero];
        _doneBtn.tag = 1;
        _doneBtn.backgroundColor = [UIColor whiteColor];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_doneBtn setTitleColor:[UIColor ph_colorWithHexString:@"#436BFF"] forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#436BFF" index:7] forState:UIControlStateHighlighted];
        [_doneBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#436BFF" index:3] forState:UIControlStateDisabled];
        [_doneBtn addTarget:self action:@selector(otherBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _doneBtn;
}

/// 横线
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView2.backgroundColor = [UIColor ph_colorWithHexString:@"#EBEDF0"];
    }
    return _lineView2;
}

/// 辅助标题
- (PHButtonPro *)otherBtn {
    if (!_otherBtn) {
        _otherBtn = [[PHButtonPro alloc] initWithFrame:CGRectZero];
        _otherBtn.tag = 2;
        _otherBtn.backgroundColor = [UIColor whiteColor];
        _otherBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_otherBtn setTitleColor:[UIColor ph_colorWithHexString:@"#262626"] forState:UIControlStateNormal];
        [_otherBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#262626" index:7] forState:UIControlStateHighlighted];
        [_otherBtn setTitleColor:[UIColor ph_colorPaletteWitHexString:@"#262626" index:3] forState:UIControlStateDisabled];
        [_otherBtn addTarget:self action:@selector(otherBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _otherBtn;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (self.placeholderLabel) {
        self.placeholderLabel.text = placeholder;
    }else{
        _textFieldView.placeholder = placeholder;
        _textFieldView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor ph_colorWithHexString:@"#BFBFBF"]}];
    }
}

- (void)setTextKeyboardType:(UIKeyboardType)textKeyboardType {
    _textKeyboardType = textKeyboardType;
    self.textFieldView.keyboardType = self.textKeyboardType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
    _autocorrectionType = autocorrectionType;
    self.textFieldView.autocorrectionType = self.autocorrectionType;
    self.messageTextView.autocorrectionType = self.autocorrectionType;
}

- (void)setDefaultText:(NSString *)defaultText {
    _defaultText = defaultText;
    self.messageTextView.text = defaultText;
    [self updateNumberLabelStyle:[self.messageTextView.text length]];
}

@end
