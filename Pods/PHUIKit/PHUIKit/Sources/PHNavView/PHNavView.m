//
//  PHNavView.m
//  PHUIKit
//
//  Created by 朱力 on 2020/8/19.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHNavView.h"
#import "Masonry.h"
#import "PHUtils.h"
#import "UIColor+PH.h"
#import "UIImageView+WebCache.h"

@interface PHNavView()

//数据
@property (nonatomic, strong) id headerStr;//头像
@property (nonatomic, strong) NSArray * noticeArray;//公告内容
@property (nonatomic, assign) NSInteger msgCount;//消息数量

//头像
@property (nonatomic, strong) UIImageView * headerImage;

//公告视图
@property (nonatomic, strong) UIView * rollView;
@property (nonatomic, strong) UIView * rollContentView;
@property (nonatomic, strong) UIImageView * leftShadow;
@property (nonatomic, strong) UIImageView * rightShadow;

//搜索按钮
@property (nonatomic, strong) UIButton * searchBtn;

//消息按钮和小红点
@property (nonatomic, strong) UIButton * msgBtn;
@property (nonatomic, strong) UILabel * msgRedDot;

//扫码按钮
@property (nonatomic, strong) UIButton * scanBtn;

//滚动速度(越小越快，默认1pt15毫秒)
@property (nonatomic, assign) CGFloat rollSpeed;

//滚动区的实际宽度
@property (nonatomic, assign) CGFloat rollContentWidth;
//滚动时长控制
@property (nonatomic, assign) CGFloat rollDuration;

@end

@implementation PHNavView

- (instancetype)initWithInfo:(id)headerStr
                  noticeArray:(NSArray *)noticeArray
                     msgCount:(NSUInteger)msgCount
                     rollSpeed:(CGFloat)rollSpeed {
    CGRect myFrame = [self initNavFrame];
    if (self == [super initWithFrame:myFrame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.headerStr = headerStr;
        self.noticeArray = noticeArray;
        self.msgCount = msgCount;
        if (rollSpeed == 0) {
            self.rollSpeed = 20.0 / 1000;
        }
        [self initNav];
        [self initData];
        [self initLayout];
        [self playNotice];
    }
    return self;
}

- (CGRect)initNavFrame {
    CGRect navFrame = CGRectMake(0, 0, PH_SCREEN_WIDTH, PH_Is_iPhoneX ? 88 : 64);
    return navFrame;
}

- (void)initNav {
    //头像
    self.headerImage = [[UIImageView alloc] init];
    [self.headerImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.headerImage.layer setCornerRadius:14];
    [self.headerImage setClipsToBounds:YES];
    [self.headerImage setUserInteractionEnabled:YES];
    [self.headerImage setMultipleTouchEnabled:YES];
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUserAction)];
    [self.headerImage addGestureRecognizer:singleTap];
    [self addSubview:self.headerImage];
    
    //公告
    self.rollView = [[UIView alloc] init];
    [self.rollView setClipsToBounds:YES];
    UITapGestureRecognizer * rollViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNoticeAction:)];
    [self.rollView addGestureRecognizer:rollViewTap];
    [self addSubview:self.rollView];
    
    self.rollContentView = [[UIView alloc] init];
    [self.rollContentView setUserInteractionEnabled:NO];
    [self.rollView addSubview:self.rollContentView];
    
    self.leftShadow = [[UIImageView alloc] initWithImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_nav_shadow_left", @"PHUIKit")];
    [self.leftShadow setContentMode:UIViewContentModeScaleAspectFill];
    [self.rollView addSubview:self.leftShadow];
    
    self.rightShadow = [[UIImageView alloc] initWithImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_nav_shadow_right", @"PHUIKit")];
    [self.rightShadow setContentMode:UIViewContentModeScaleAspectFill];
    [self.rollView addSubview:self.rightShadow];
    
    //搜索
    self.searchBtn = [[UIButton alloc] init];
    [self.searchBtn setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_nav_search", @"PHUIKit") forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(goSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchBtn];
    
    //消息
    self.msgBtn = [[UIButton alloc] init];
    [self.msgBtn setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_nav_msg", @"PHUIKit") forState:UIControlStateNormal];
    [self.msgBtn addTarget:self action:@selector(goMsgAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.msgBtn];
    self.msgRedDot = [[UILabel alloc] init];
    [self.msgRedDot.layer setCornerRadius:8];
    [self.msgRedDot setTextColor:[UIColor whiteColor]];
    [self.msgRedDot setTextAlignment:NSTextAlignmentCenter];
    [self.msgRedDot setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10]];
    [self.msgRedDot.layer setBackgroundColor:[UIColor ph_colorWithHexString:@"F5222D"].CGColor];
    [self.msgRedDot setUserInteractionEnabled:NO];
    [self addSubview:self.msgRedDot];
    
    //扫码
    self.scanBtn = [[UIButton alloc] init];
    [self.scanBtn setImage:PH_IMAGE_NAMED_FRAMEWORK_NAME(@"ph_nav_scan", @"PHUIKit") forState:UIControlStateNormal];
    [self.scanBtn addTarget:self action:@selector(goScanAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.scanBtn];
}

- (void)initLayout {
    PH_WeakSelf
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).mas_offset(15);
        make.bottom.equalTo(weakSelf).mas_offset(-8);
        make.width.height.mas_equalTo(28);
    }];
    
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).mas_offset(-16);
        make.centerY.equalTo(weakSelf.headerImage);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.scanBtn.mas_left).mas_offset(-16);
        make.centerY.equalTo(weakSelf.headerImage);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.msgRedDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.msgBtn.mas_left).mas_offset(13);
        make.bottom.equalTo(weakSelf.msgBtn.mas_bottom).mas_offset(-11);
        CGFloat msgWidth = ceilf([NSString ph_boundSizeWithString:weakSelf.msgRedDot.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:10] size:CGSizeMake(weakSelf.ph_width, 16)].width) + 8;
        msgWidth = msgWidth < 16 ? 16 : msgWidth;
        make.width.mas_equalTo(msgWidth);
        make.height.mas_equalTo(16);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.msgBtn.mas_left).mas_offset(-16);
        make.centerY.equalTo(weakSelf.headerImage);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.rollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerImage.mas_right).mas_offset(8);
        make.right.equalTo(weakSelf.searchBtn.mas_left).mas_offset(-16);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(weakSelf.headerImage);
    }];
    
    [self.leftShadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.rollView);
        make.top.equalTo(weakSelf.rollView);
        make.bottom.equalTo(weakSelf.rollView);
        make.width.mas_equalTo(4);
    }];
    
    [self.rightShadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.rollView);
        make.top.equalTo(weakSelf.rollView);
        make.bottom.equalTo(weakSelf.rollView);
        make.width.mas_equalTo(4);
    }];
    
    [self layoutIfNeeded];
    [self.rollContentView setFrame:CGRectMake(self.rollView.ph_width, 0, self.rollView.ph_width, 22)];
    self.rollDuration = self.rollSpeed * (self.rollContentWidth + self.rollView.ph_width);
}

- (void)initData {
    if ([self.headerStr isKindOfClass:[NSString class]]) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.headerStr] placeholderImage:nil];
    }
    if ([self.headerStr isKindOfClass:[UIImage class]]) {
        [self.headerImage setImage:self.headerStr];
    }
    
    [self initRollViewData];
    
    NSString * msgCountStr = [NSString stringWithFormat:@"%ld", (long)self.msgCount];
    if (self.msgCount > 99) {
        msgCountStr = @"99+";
    }
    [self.msgRedDot setText:msgCountStr];
    [self.msgRedDot setHidden:self.msgCount == 0];
}

- (void)initRollViewData {
    if (self.noticeArray && self.noticeArray.count > 0) {
        self.rollContentWidth = 0;
        [self.leftShadow setHidden:NO];
        [self.rightShadow setHidden:NO];
        [self.rollView setHidden:NO];
        NSInteger index = 0;
        for (NSString * noticeStr in self.noticeArray) {
            if (![NSString ph_isNilOrEmpty:noticeStr]) {
                [self rollLabel:noticeStr rollIndex:index];
                index++;
            }
        }
        if (self.rollContentWidth > 0) {
            [self.rollContentView setPh_width:self.rollContentWidth];
        } else {
            [self hideRollView];
        }
    } else {
        [self hideRollView];
    }
}

- (void)hideRollView {
    [self.leftShadow setHidden:YES];
    [self.rightShadow setHidden:YES];
    [self.rollView setHidden:YES];
}

- (void)rollLabel:(NSString *)rollStr rollIndex:(NSInteger)rollIndex {
    CGFloat noticeWidth = ceilf([NSString ph_boundSizeWithString:rollStr font:[UIFont fontWithName:@"PingFangSC-Regular" size:12] size:CGSizeMake(10000, 16)].width);
    if (self.rollContentWidth > 0) {
        self.rollContentWidth += 50;
    }
    UIButton * rollLbl = [[UIButton alloc] initWithFrame:CGRectMake(self.rollContentWidth, (22.0 - 17.0) / 2.0, noticeWidth, 17)];
    [rollLbl setTitle:rollStr forState:UIControlStateNormal];
    [rollLbl.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [rollLbl.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    [rollLbl setTitleColor:[UIColor ph_colorWithHexString:@"595959"] forState:UIControlStateNormal];
    [rollLbl setTag:rollIndex];
    [self.rollContentView addSubview:rollLbl];
    self.rollContentWidth += noticeWidth;
}

- (void)playNotice {
    if (self.noticeArray.count > 0) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.toValue = [NSNumber numberWithFloat:-(self.rollContentWidth + self.rollView.ph_width)];
        animation.duration = self.rollDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.repeatCount = HUGE_VALF;
        [self.rollContentView.layer addAnimation:animation forKey:@"kNotices"];
    }
}

- (void)reSetheaderStr:(id)headerStr {
    self.headerStr = headerStr;
    if ([self.headerStr isKindOfClass:[NSString class]]) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.headerStr] placeholderImage:nil];
    }
    if ([self.headerStr isKindOfClass:[UIImage class]]) {
        [self.headerImage setImage:self.headerStr];
    }
}

- (void)reSetNoticeArray:(NSArray *)noticeArray {
    self.noticeArray = noticeArray;
    self.rollContentWidth = 0;
    [self.rollContentView.layer removeAnimationForKey:@"kNotices"];
    for (UIButton * noticeItem in self.rollContentView.subviews) {
        [noticeItem removeFromSuperview];
    }
    [self initRollViewData];
    [self layoutIfNeeded];
    self.rollDuration = self.rollSpeed * (self.rollContentWidth + self.rollView.ph_width);
    [self playNotice];
}

- (void)reSetMsgCount:(NSInteger)msgCount {
    PH_WeakSelf
    self.msgCount = msgCount;
    NSString * msgCountStr = [NSString stringWithFormat:@"%ld", (long)self.msgCount];
    if (self.msgCount > 99) {
        msgCountStr = @"99+";
    }
    [self.msgRedDot setText:msgCountStr];
    [self.msgRedDot setHidden:self.msgCount == 0];
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.msgRedDot mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.msgBtn.mas_left).mas_offset(13);
            make.bottom.equalTo(weakSelf.msgBtn.mas_bottom).mas_offset(-11);
            CGFloat msgWidth = ceilf([NSString ph_boundSizeWithString:weakSelf.msgRedDot.text font:[UIFont fontWithName:@"PingFangSC-Medium" size:10] size:CGSizeMake(weakSelf.ph_width, 16)].width) + 8;
            msgWidth = msgWidth < 16 ? 16 : msgWidth;
            make.width.mas_equalTo(msgWidth);
            make.height.mas_equalTo(16);
        }];
        [weakSelf layoutIfNeeded];
    }];
}

- (void)goUserAction {
    PH_WeakSelf
    [self ph_executeFirstWithTimeInterval:1.0 actionBlock:^{
        if (weakSelf.navBlock) {
            weakSelf.navBlock(PHNavHeaderAction, 0);
        }
    }];
}

- (void)goNoticeAction:(UITapGestureRecognizer*)sender {
    PH_WeakSelf
    [self ph_executeFirstWithTimeInterval:1.0 actionBlock:^{
        CGPoint touchPoint = [sender locationInView:weakSelf.rollView];
        CGFloat playingX = [weakSelf.rollContentView.layer.presentationLayer frame].origin.x;
        CGPoint realPoint = CGPointZero;
        if (fabs(playingX) <= weakSelf.rollView.ph_width) {
            realPoint = CGPointMake(touchPoint.x - playingX, touchPoint.y);
        } else {
            realPoint = CGPointMake(fabs(playingX) + touchPoint.x, touchPoint.y);
        }
        for (UIButton * itemBtn in weakSelf.rollContentView.subviews) {
            if (itemBtn.ph_x <= realPoint.x && (itemBtn.ph_x + itemBtn.ph_width) >= realPoint.x) {
                if (weakSelf.navBlock) {
                    weakSelf.navBlock(PHNavNoticeAction, itemBtn.tag);
                }
                break;
            }
        }
    }];
}

- (void)goSearchAction {
    PH_WeakSelf
    [self ph_executeFirstWithTimeInterval:1.0 actionBlock:^{
        if (weakSelf.navBlock) {
            weakSelf.navBlock(PHNavSearchAction, 0);
        }
    }];
}

- (void)goMsgAction {
    PH_WeakSelf
    [self ph_executeFirstWithTimeInterval:1.0 actionBlock:^{
        if (weakSelf.navBlock) {
            weakSelf.navBlock(PHNavMessageAction, 0);
        }
    }];
}

- (void)goScanAction {
    PH_WeakSelf
    [self ph_executeFirstWithTimeInterval:1.0 actionBlock:^{
        if (weakSelf.navBlock) {
            weakSelf.navBlock(PHNavScanAction, 0);
        }
    }];
}

@end
