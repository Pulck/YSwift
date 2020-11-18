//
//  PHDialogView.m
//  AFNetworking
//
//  Created by zhuli on 2018/5/24.
//

#import "PHDialogView.h"
#import "Masonry.h"
#import "NSString+PH.h"
#import "UIColor+PH.h"
#import "UIView+PH.h"
#import "UIImage+PH.h"

static CGFloat kContentView_width = 580 / 2; // 宽度
static CGFloat MARGIN = 25; // 各控件之间的间距
static CGFloat kTextSpace = 5; // 文本上下留白
static CGFloat contentLineSpacing = 12;//内容行间距
static CGFloat maxContentHeight = 118;//内容最大高度限制

@interface PHDialogView ()<UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *actionArray;

/**
 用于标记是否创建过视图（layoutSubviews 多次调用问题）
 */
@property (nonatomic ,assign) BOOL haveAdd;

/**
 顶部图片
 */
@property (strong, nonatomic) UIImageView *headIcon;

/**
 顶部图片高
 */
@property (assign, nonatomic) CGFloat headIconH;

/**
 顶部图片最小高
 */
@property (assign, nonatomic) CGFloat headIconMinH;

/**
 中间内容高
 */
@property (nonatomic, assign) CGFloat contentLabelH;

/**
 弹框sub
 */
@property (nonatomic, strong) UIView *subContentView;

/**
 弹框高度
 */
@property (nonatomic, assign) CGFloat contentViewH;

/**
 底部按钮view
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 弹框样式
 */
@property (nonatomic, assign) PHDialogStyle type;

/**
 弹框样式
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

@end

@implementation PHDialogView

- (NSMutableArray *)actionArray {
    if (_actionArray == nil) {
        _actionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _actionArray;
}

- (void)addAction:(PHAction *)action {
    [self.actionArray addObject:action];
}

- (instancetype __nullable)initWithFrame:(CGRect)frame image:(UIImage * __nullable )image title:(NSString * __nullable )title message:(nullable NSString *)message type:(PHDialogStyle)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        [self _constructSubViewsWithTitle:title message:message image:image type:type];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(nullable NSString *)title message:(nullable NSString *)message {
    self.textAlignment = NSTextAlignmentCenter;
    return [self initWithFrame:frame image:image title:title message:message type:PHDialogStyleDefault];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(nullable NSString *)title message:(nullable NSString *)message type:(PHDialogStyle)type textAlignment:(NSTextAlignment)textAlignment {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = textAlignment;
        [self _constructSubViewsWithTitle:title message:message image:image type:type];
    }
    return self;
}

- (void)_constructSubViewsWithTitle:(nullable NSString *)title message:(nullable NSString *)message image:(UIImage *)image type:(PHDialogStyle)type {
    self.type = type;
    // 添加毛玻璃效果
    UIBlurEffect *blurEff = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
    // 创建显示的毛玻璃类
    UIVisualEffectView *visualEffV = [[UIVisualEffectView alloc]initWithEffect:blurEff];
    visualEffV.frame = self.bounds;
    visualEffV.alpha = 0.8;
    // 添加毛玻璃效果
    [self addSubview:visualEffV];
    self.contentViewH = 0;
    self.headIconH = 0;
    self.headIconMinH = 100;
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.subContentView];
    
    if (image) {
        self.headIcon = [[UIImageView alloc]initWithImage:image];
        [self.contentView addSubview:self.headIcon];
        self.headIcon.layer.masksToBounds = NO;
        self.headIconH = (kContentView_width/image.size.width)*image.size.height;//根据图片大小布局
        if (self.headIconMinH > self.headIconH) {///图片高度默认不低于100，如果实际图低于100，就按实际图显示（但是像升级箭头的暂时无法完美支持）
            self.headIconMinH = self.headIconH;
        }
    }
    if (![NSString ph_isNilOrEmpty:title]) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.titleLabel.textColor = [UIColor ph_colorWithHexString:@"1a81d1"];
        [self.subContentView addSubview:self.titleLabel];
    }
    if (![NSString ph_isNilOrEmpty:message]) {
        self.contentLabel = [[UITextView alloc] init];
        self.contentLabel.text = message;
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.contentLabel.text
                                                                           attributes:[self labelSpacing:contentLineSpacing
                                                                                                fontSize:14]];
        self.contentLabel.textContainer.lineFragmentPadding = 0;
        self.contentLabel.textContainerInset = UIEdgeInsetsZero;
        self.contentLabel.delegate = self;
        self.contentLabel.textColor = [UIColor ph_colorWithHexString:@"666666"];
        [self.contentLabel setTextAlignment:self.textAlignment];
        [self.subContentView addSubview:self.contentLabel];
        CGSize titleSize = [self yxt_getSizeWithStr:message width:kContentView_width
                                                dic:[self labelSpacing:contentLineSpacing
                                                              fontSize:14]];
        self.contentLabelH = (titleSize.height > maxContentHeight ? maxContentHeight : titleSize.height)+1;
    }
    
    [self _addLayoutConstraints];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

- (CGSize)yxt_getSizeWithStr:(NSString *)str width:(float)width dic:(NSDictionary *)dic {
    NSDictionary * attribute = dic;
    CGSize tempSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attribute
                                        context:nil].size;
    return tempSize;
}

- (void)_addLayoutConstraints {
    if (self.type == PHDialogStyleBottom) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(self.contentViewH);
        }];
        [self.subContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(self.contentViewH);
        }];
    }else {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kContentView_width);
            make.height.mas_equalTo(self.contentViewH);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.subContentView mas_updateConstraints:^(MASConstraintMaker *make) {///make.left.right.bottom.equalTo(self.contentView); 没有用这个是因为UI显示不对，重构时可以看看是什么原因
            make.width.mas_equalTo(kContentView_width);
            make.height.mas_equalTo(self.contentViewH);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
    if (self.contentLabel) {
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.subContentView).offset(-20);
            make.height.mas_equalTo(self.contentLabelH);
            make.bottom.equalTo(self.subContentView.mas_bottom).offset(-MARGIN+kTextSpace);
            make.centerX.equalTo(self.subContentView.mas_centerX);
        }];
        self.contentViewH += (MARGIN+self.contentLabelH-kTextSpace);
    }
    if (self.titleLabel) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.subContentView);
            make.height.mas_equalTo(22);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        self.contentViewH += (MARGIN+25);
    }
    if (self.headIcon) {
        [self.headIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.subContentView);
            make.height.mas_equalTo(self.headIconH);
            make.centerX.equalTo(self.subContentView.mas_centerX);
        }];
        self.contentViewH += self.headIconMinH;
        [self.headIcon sizeToFit];
    }
    self.contentViewH += MARGIN-kTextSpace;// 按钮上始终有个间距
}

- (void)_updateLayoutConstraints {///目前先满足现有需求，后期需要排期对各种按钮进行动态适配
    if (self.bottomView) {
        if (self.type == PHDialogStyleBottom) {
            self.bottomView.frame = CGRectMake(0, self.contentViewH - 50, [UIScreen mainScreen].bounds.size.width, 50);
        } else {
            self.bottomView.frame = CGRectMake(0, self.contentViewH - 50, kContentView_width, 50);
        }
    }
    if (self.contentLabel) {///message 内容各种情况布局
        self.contentViewH -= self.contentLabelH;///contentLabelH 改变 父视图contentViewH 跟着变
        if ([NSString ph_isNilOrEmpty:self.contentLabel.text]) {///初始化后，设置contentLabel为空，改布局
            self.contentLabelH = 0;
            self.contentViewH -= kTextSpace;//减去给的固定留白
        }else {
            self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.contentLabel.text
                                                                               attributes:[self labelSpacing:contentLineSpacing
                                                                                                    fontSize:14]];
            CGSize titleSize = [self yxt_getSizeWithStr:self.contentLabel.text width:kContentView_width
                                                    dic:[self labelSpacing:contentLineSpacing
                                                                  fontSize:14]];
            self.contentLabelH = (titleSize.height > maxContentHeight ? maxContentHeight : titleSize.height) + 1;
            self.contentViewH += self.contentLabelH;
            [self.contentLabel setTextAlignment:self.textAlignment];
        }
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.contentLabelH);
            if (self.bottomView) {
                if ([NSString ph_isNilOrEmpty:self.contentLabel.text]) {
                    make.bottom.equalTo(self.subContentView.mas_bottom).offset(-50-MARGIN);
                }else {
                    make.bottom.equalTo(self.subContentView.mas_bottom).offset(-50-MARGIN+kTextSpace);
                }
            }
        }];
    }
    
    if (self.titleLabel) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if ([NSString ph_isNilOrEmpty:self.titleLabel.text]) {
                make.height.mas_equalTo(0);
                //                self.contentViewH -= 20;
                //                self.contentViewH = MARGIN;//固定间距
            }else {
                make.height.mas_equalTo(20);
            }
            if (self.contentLabel) {
                if ([NSString ph_isNilOrEmpty:self.contentLabel.text]) {
                    make.bottom.equalTo(self.contentLabel.mas_top);
                }else if ([NSString ph_isNilOrEmpty:self.titleLabel.text]) {
                    make.bottom.equalTo(self.contentLabel.mas_top);
                }else {
                    make.bottom.equalTo(self.contentLabel.mas_top).offset(-MARGIN);
                }
            }else {///处理为空时布局
                if (self.actionArray.count > 0) {
                    make.bottom.equalTo(self.subContentView.mas_bottom).offset(-MARGIN-50);
                }else {
                    make.bottom.equalTo(self.subContentView.mas_bottom).offset(-MARGIN+kTextSpace);
                }
            }
        }];
    }
    if (self.headIcon) {
        [self.headIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.titleLabel) {
                make.bottom.equalTo(self.titleLabel.mas_top).offset(-MARGIN);
            }else if(self.contentLabel) {
                make.bottom.equalTo(self.contentLabel.mas_top).offset(-MARGIN);
            }else {
                if (self.actionArray.count > 0) {
                    make.bottom.equalTo(self.subContentView.mas_bottom).offset(-MARGIN-50);
                }else {
                    make.bottom.equalTo(self.subContentView.mas_bottom).offset(-MARGIN);
                }
            }
        }];
    }
    [self.subContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentViewH);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentViewH);
    }];
}

- (NSMutableDictionary *)labelSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing - (fontSize*1.1933 - fontSize);
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setValue:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    return attributes;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _initAction];
    [self _updateLayoutConstraints];
    
}
///初始化底部按钮
- (void)_initAction {
    if (self.actionArray.count > 0 && !self.haveAdd) {
        self.bottomView = [[UIView alloc]init];
        [self.subContentView addSubview:self.bottomView];
        if (self.type == PHDialogStyleBottom) {
            self.bottomView.frame = CGRectMake(0, self.contentViewH - 50, [UIScreen mainScreen].bounds.size.width, 50);
        }else {
            self.bottomView.frame = CGRectMake(0, self.contentViewH - 50, kContentView_width, 50);
        }
        self.contentViewH += 50;
        
        UIColor *lineColor = [UIColor ph_colorWithHexString:@"f1f0ee"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.ph_width, 1)];
        [label setBackgroundColor:lineColor];
        [self.bottomView addSubview:label];
        
        self.haveAdd = YES;
        for (int i = 0; i < self.actionArray.count; i++) {
            PHAction *action = self.actionArray[i];
            PHActionButton *button = [[PHActionButton alloc] initWithFrame:CGRectMake((self.bottomView.ph_width/self.actionArray.count)*i, 0, self.bottomView.ph_width/self.actionArray.count, self.bottomView.ph_height)];
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
            [self.bottomView addSubview:button];
            [self.bottomView sendSubviewToBack:button];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(button.ph_width*(i+1), 0, 1, button.ph_height)];
            [label setBackgroundColor:lineColor];
            [self.bottomView addSubview:label];
            if (action.style == PHActionStyleBlue) {
                [self bringSubviewToFront:button];
            }
            if (action.btnblock) {
                action.btnblock(button);
            }
        }
    }
}

- (void)clickAction:(PHActionButton *)button {
    PHAction *action = self.actionArray[button.tag];
    if (action.block) {
        action.block(action);
    }
}

- (UIView *)subContentView {
    if(!_subContentView){
        _subContentView = [[UIView alloc]init];
        if (self.type == PHDialogStyleDefault) {
            _subContentView.layer.cornerRadius = 5;
            _subContentView.layer.masksToBounds = YES;
        }
        _subContentView.backgroundColor = [UIColor whiteColor];
    }
    return _subContentView;
}

- (UIView *)contentView {
    if(!_contentView){
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

@end

