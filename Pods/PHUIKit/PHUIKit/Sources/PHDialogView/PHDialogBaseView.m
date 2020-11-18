//
//  PHDialogBaseView.m
//
//  Created by zhuli on 2018/4/27.
//

#import "PHDialogBaseView.h"
#import "UIView+PH.h"

@interface PHDialogBaseView ()

/**
 contentView 子类需要显示动画，需要命名与contentView一样
 */
@property (nonatomic,strong)UIView * contentView;

@end

@implementation PHDialogBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)apearWithAnimationCompletion:(void (^ __nullable)(BOOL finished))completion {
    self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    } completion:completion];
}

- (void)dissApearWithAnimationCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)apearWithBottomAnimationCompletion:(void (^ __nullable)(BOOL finished))completion {
    [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.ph_height)];
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, 0, self.ph_width, self.ph_height)];
    } completion:completion];
}

- (void)dissApearWithBottomAnimationCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.ph_height)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
    }];
}

@end
