//
//  PHStarRatingView.m
//  PHKnowledgeDemo
//
//  Created by Tiany on 2020/1/2.
//  Copyright © 2020 yunxuetang. All rights reserved.
//

#import "PHStarRatingView.h"
#import <PHUtils/PHUtils.h>
#import <Masonry/Masonry.h>

#define kPADDING_OF_STAR  5

@interface PHStarRatingView ()

@property (nonatomic, readwrite) int numberOfStar;
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL notFirstLoad;
@end

@implementation PHStarRatingView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStar:kNUMBER_OF_STAR];
}

- (void)setPaddingOfStar:(float)paddingOfStar {
    _paddingOfStar = paddingOfStar;
    [self layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberOfStar = kNUMBER_OF_STAR;
    self.paddingOfStar = kPADDING_OF_STAR;
    [self commonInit];
}

/**
 *  初始化PHStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return PHStarRatingViewObject
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(int)number {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self buildStarBackgroundViewWithImage:[self imageWithImageName:kBACKGROUND_STAR]];
    [self buildStarForegroundViewWithImage:[self imageWithImageName:kFOREGROUND_STAR]];
}

#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 5 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate {
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished) {}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 5 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
//    //NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
//    // 转换分值
//    score = MAX( MIN(score / self.numberOfStar, 1.0), 0.0);

    // 转换分值
    score = roundf(MAX(score, 0.0));
    self.score = score;
//    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate){
        [UIView animateWithDuration:0.2 animations:^{
//             [self changeStarForegroundViewWithPoint:point];
            [self changeStarForegroundViewWithScore:score];
        } completion:^(BOOL finished) {
            if (completion){
                completion(finished);
            }
        }];
    } else {
//        [self changeStarForegroundViewWithPoint:point];

        [self changeStarForegroundViewWithScore:score];
    }
}

#pragma mark - Touche Event

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.onlyShowStar) {
        return;
    }
    _notFirstLoad = YES;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point)) {
//        [self changeStarForegroundViewWithPoint:point];
        float score = roundf(point.x / (self.frame.size.height + self.paddingOfStar));
        [self changeStarForegroundViewWithScore:score];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.onlyShowStar) {
        return;
    }
    _notFirstLoad = YES;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [UIView animateWithDuration:0.2 animations:^{
//        [self changeStarForegroundViewWithPoint:point];
        float score = roundf(point.x / (self.frame.size.height + self.paddingOfStar));
        [self changeStarForegroundViewWithScore:score];
    }];
}

#pragma mark - Build Star View

/**
 *  通过图片构建星星视图
 */
- (void)buildStarBackgroundViewWithImage:(UIImage *)image {
    UIView *starBackgroundView = [[UIView alloc] init];
    [self addSubview:starBackgroundView];
    _starBackgroundView = starBackgroundView;
    
    starBackgroundView.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [starBackgroundView addSubview:imageView];
    }
    
//    // 测试
//    starBackgroundView.backgroundColor = [UIColor blueColor];
}

- (void)buildStarForegroundViewWithImage:(UIImage *)image {
    UIView *starForegroundView = [[UIView alloc] init];
    [self addSubview:starForegroundView];
    _starForegroundView = starForegroundView;

    starForegroundView.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [starForegroundView addSubview:imageView];
    }
    
//    // 测试
//    starForegroundView.backgroundColor = [UIColor redColor];
}

- (void)updateBackgroundViewConstraints {
    [self.starBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    [self.starBackgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            if (idx == 0) {
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.equalTo(self);
                    make.width.mas_equalTo(self.frame.size.height);
                }];
            } else {
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self);
                    make.left.mas_equalTo(idx * (self.frame.size.height + self.paddingOfStar));
                    make.width.mas_equalTo(self.frame.size.height);

                }];
            }
            [self.starBackgroundView addSubview:imageView];
        }
    }];
}

- (void)updateForegroundViewConstraints {
    if (_notFirstLoad == NO) {
        [self.starForegroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_equalTo(self.score * (self.frame.size.height + self.paddingOfStar));
        }];
        
        [self.starForegroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)obj;
                if (idx == 0) {
                    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.bottom.equalTo(self);
                        make.width.mas_equalTo(self.frame.size.height);
                    }];
                } else {
                    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.equalTo(self);
                        make.left.mas_equalTo(idx * (self.frame.size.height + self.paddingOfStar));
                        make.width.mas_equalTo(self.frame.size.height);
                    }];
                }
                [self.starForegroundView addSubview:imageView];
            }
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新背景视图
    [self updateBackgroundViewConstraints];

    // 更新前景视图
    [self updateForegroundViewConstraints];
}

#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    
    if (p.x < 0) {
        p.x = 0;
    }
    if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    NSString *str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    float starWith = (self.frame.size.height + self.paddingOfStar)  * self.numberOfStar - self.paddingOfStar;
    p.x = score * starWith;
    
    [self.starForegroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(p.x);
    }];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]) {
        [self.delegate starRatingView:self score:score];
    }
}

- (void)changeStarForegroundViewWithScore:(CGFloat)score {
    
    CGPoint p = CGPointMake(score , 0);
    
    float starWith = (self.frame.size.height + self.paddingOfStar)  * self.numberOfStar - self.paddingOfStar;
    p.x = score * (self.frame.size.height + self.paddingOfStar);

    if (starWith <= p.x) {
        p.x = starWith;
    }
    
    [self.starForegroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(p.x);
    }];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]) {
        [self.delegate starRatingView:self score:score];
    }
}

#pragma mark - Image

- (UIImage *)imageWithImageName:(NSString *)imageName {
    NSString *bundlePath = [PH_BUNDLE_CLASS pathForResource:@"PHStarRating.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *img_path = [bundle pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:img_path];
}

@end
