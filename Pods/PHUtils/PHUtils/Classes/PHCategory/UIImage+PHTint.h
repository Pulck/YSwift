//
//  UIImage+PHTint.h
//  FBSnapshotTestCase
//  图片换肤
//  Created by hanjun on 2020/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PHTint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

/**
    图片换肤使用这个方法，效果好一些
 */
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
