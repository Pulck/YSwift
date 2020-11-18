//
//  PHSignDialogView.m
//  AFNetworking
//
//  Created by zhuli on 2018/4/27.
//

#import "PHSignDialogView.h"
#import "Masonry.h"
#import "UIColor+PH.h"
#import "UIImage+PH.h"

@interface PHSignDialogView ()
@property (nonatomic, strong) UIControl *bgView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) int yunDouCount;
@end

@implementation PHSignDialogView

- (instancetype)initWithFrame:(CGRect)frame yunDouCount:(int)yunDouCount {
    
    if (self = [super initWithFrame:frame]) {
        [self _constructSubView];
        [self _addLayoutConstraints];
        self.yunDouCount = yunDouCount;
    }
    return self;
    
}

- (void)_constructSubView {
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
}

- (void)_addLayoutConstraints {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(240));
        make.height.equalTo(@(250));
    }];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //设置所需的圆角位置以及大小
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    _contentView.layer.mask = maskLayer;
}

#pragma mark - Actions
- (void)removeFromSupView {
    
    [self dissApearWithAnimationCompletion:^(BOOL finished) {
        
    }];
}

#pragma mark - lazyInit
- (UIView *)contentView {
    if (nil == _contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;
}

- (UIControl *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIControl alloc] init];
        [_bgView setBackgroundColor:[UIColor ph_colorWithHexString:@"#00000" alpha:0.2]];
        [_bgView addTarget:self action:@selector(removeFromSupView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}



@end
