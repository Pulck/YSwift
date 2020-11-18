//
//  PHMaxLinesTextView.m
//  PHUIKit
//
//  Created by dingw on 2019/12/23.
//  Copyright © 2019 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHMaxLinesTextView.h"

@interface PHMaxLinesTextView ()

// 记录当前textView总高，高度未变化时，输入文字不做高度计算
@property (nonatomic, assign) CGFloat totalHeight;
// 是否允许滚动
@property (nonatomic, assign) BOOL isEnableScroll;

@end

@implementation PHMaxLinesTextView

- (void)dealloc {
    NSLog(@"//////// PHMaxLinesTextView dealloc");
    // 移除KVO
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加contentOffset监听
        [self addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 添加contentOffset监听
        [self addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return self;
}

// 文字改变
- (void)textDidChange {
    [super textDidChange];
    
    if (self.minHeight <= 0 && self.maxLines <= 0) {
        // 未设置高度限制，不做处理
        return;
    }
    
    // 获取总高
    CGFloat height = ceil([self sizeThatFits:self.frame.size].height);
    if (_totalHeight == height) {
        // 高度未改变，不做处理
        return;
    }
    
    // 记录总高
    _totalHeight = height;
    
    if (self.minHeight > 0 && self.minHeight >= height) {
        // 限制最小高度
        self.isEnableScroll = NO;
        if (self.heightChangedBlock) {
            self.heightChangedBlock(self.minHeight, self);
        }
        return;
    }
    
    if (self.maxLines > 0 && self.maxLines < [self getLines]) {
        // 限制最大行数
        CGFloat maxLinesHeight = self.maxLines * self.font.lineHeight + self.textContainerInset.top + self.textContainerInset.bottom + self.layer.borderWidth * 2;
        if (self.minHeight > 0 && self.minHeight > maxLinesHeight) {
            // 同时限制了最小高度，最小高度优先级高，返回最小高度
            self.isEnableScroll = NO;
            if (self.heightChangedBlock) {
                self.heightChangedBlock(self.minHeight, self);
            }
        }else{
            self.isEnableScroll = YES;
            if (self.heightChangedBlock) {
                self.heightChangedBlock(maxLinesHeight, self);
            }
        }
        return;
    }
    
    self.isEnableScroll = NO;
    if (self.heightChangedBlock) {
        self.heightChangedBlock(height, self);
    }
}

// 获取当前文字行数
- (NSInteger)getLines {
    UIEdgeInsets inset = self.textContainerInset;
    CGFloat height = [self.text boundingRectWithSize:(CGSizeMake((self.frame.size.width - inset.left - inset.right - self.textContainer.lineFragmentPadding * 2), CGFLOAT_MAX)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size.height;
    NSInteger lines = (NSInteger)ceil(height / self.font.lineHeight);
    return lines;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && !self.isEnableScroll) {
        // 解决高度变化且不允许滑动时，textView里面文字上移问题
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (!CGPointEqualToPoint(self.contentOffset, CGPointZero) && !CGPointEqualToPoint(contentOffset, CGPointZero)) {
            self.contentOffset = CGPointZero;
        }
    }
}

@end
