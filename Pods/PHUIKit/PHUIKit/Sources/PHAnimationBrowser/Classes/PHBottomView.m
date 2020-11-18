//
//  PHBottomView.m
//  AFNetworking
//
//  Created by Hu, Yuping on 2020/1/4.
//

#import "PHBottomView.h"
#import "YBIBIconManager.h"
#import "YBIBUtilities.h"


@implementation PHBottomView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pageLabel];
        //[self addSubview:self.operationButton];
        //[self setOperationType:PHBottomViewOperationTypeMore];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height, width = self.bounds.size.width;
    
    self.pageLabel.frame = CGRectMake(0, 0, width, height);
    //CGFloat buttonWidth = 54;
    //self.operationButton.frame = CGRectMake(width - buttonWidth, 0, buttonWidth, height);
}

// 获取window顶部安全区高度
- (CGFloat)getWindowSafeAreaTop{
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;//44
    }
    return 0.0;
}

// 获取window底部安全区高度
- (CGFloat)getWindowSafeAreaBottom{
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;//34
    }
    return 0.0;
}

#pragma mark - public

+ (CGFloat)defaultHeight {
    return 40;
}

- (void)setPage:(NSInteger)page totalPage:(NSInteger)totalPage {
    if (totalPage <= 1) {
        self.pageLabel.hidden = YES;
    } else {
        self.pageLabel.hidden  = NO;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", page + (NSInteger)1, totalPage];
    }
}

#pragma mark - event

//- (void)clickOperationButton:(UIButton *)button {
//    if (self.clickOperation) self.clickOperation(self.operationType);
//}

#pragma mark - getters & setters

//- (void)setOperationType:(PHBottomViewOperationType)operationType {
//    _operationType = operationType;
//
//    UIImage *image = nil;
//    switch (operationType) {
//            case PHBottomViewOperationTypeSave:
//            image = [YBIBIconManager sharedManager].toolSaveImage();
//            break;
//            case PHBottomViewOperationTypeMore:
//            image = [YBIBIconManager sharedManager].toolMoreImage();
//            break;
//    }
//
//    [self.operationButton setImage:image forState:UIControlStateNormal];
//}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [UILabel new];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont boldSystemFontOfSize:16];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}

//- (UIButton *)operationButton {
//    if (!_operationButton) {
//        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _operationButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        _operationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_operationButton addTarget:self action:@selector(clickOperationButton:) forControlEvents:UIControlEventTouchUpInside];
//        _operationButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
//        _operationButton.layer.shadowOffset = CGSizeMake(0, 1);
//        _operationButton.layer.shadowOpacity = 1;
//        _operationButton.layer.shadowRadius = 4;
//    }
//    return _operationButton;
//}
@end
