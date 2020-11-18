//
//  PHWatermarkView.m
//  PHUIKit
//
//  Created by 秦平平 on 2020/2/4.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import "PHWatermarkView.h"
#import <PHUtils/PHUtils.h>

@implementation PHWatermarkView

/**
 设置水印
 
 @param frame 水印大小
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)showWaterMarkWithFrame:(CGRect)frame markText:(NSString *)markText markFont: (CGFloat)markFont
                     markColor: (UIColor *)markColor {
    UIColor *color = markColor ? markColor:[UIColor ph_colorWithHexString:@"#BFBFBF" alpha:0.4f];
    UIFont *font = [UIFont boldSystemFontOfSize:markFont > 0 ? markFont:18];
    NSMutableParagraphStyle   *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{NSFontAttributeName: font,
                           NSForegroundColorAttributeName:color,
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
    NSString *mark = ([NSString ph_isNilOrEmpty:markText]? @"":markText);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
    CGFloat strWidth = attrStr.size.width; // 绘制文本的宽
    CGFloat strHeight = attrStr.size.height;
    CGFloat viewWidth = frame.size.width; //原始image的宽高
    CGFloat viewHeight = frame.size.height;
    UIView *imageView = [[UIView alloc] initWithFrame:frame];
    CGFloat tranformRotation = -M_PI / 5;  // 旋转角度
    if (frame.size.height > frame.size.width) {
        UILabel *label1 = [self waterLabelFrame:CGRectMake(0, 0, strWidth, strHeight) labelCenter:CGPointMake(viewWidth/2,1.0/4.0*viewHeight) tranformRotation:tranformRotation attributedText:attrStr];
        [imageView addSubview:label1]; // 第一条水印
        UILabel *label2 = [self waterLabelFrame:CGRectMake(0, 0, strWidth, strHeight) labelCenter:CGPointMake(viewWidth/2,2.0/4.0*viewHeight) tranformRotation:tranformRotation attributedText:attrStr];
        [imageView addSubview:label2]; // 第二条水印
        UILabel *label3 = [self waterLabelFrame:CGRectMake(0, 0, strWidth, strHeight) labelCenter:CGPointMake(viewWidth/2,3.0/4.0*viewHeight) tranformRotation:tranformRotation attributedText:attrStr];
        [imageView addSubview:label3]; // 第三条水印
    }else{
        UILabel *label1 = [self waterLabelFrame:CGRectMake(0, 0, strWidth, strHeight) labelCenter:CGPointMake(1.0/4.0*viewWidth,viewHeight/2.0) tranformRotation:tranformRotation attributedText:attrStr];
        [imageView addSubview:label1]; // 第一条水印
        UILabel *label2 = [self waterLabelFrame:CGRectMake(0, 0, strWidth, strHeight) labelCenter:CGPointMake(2.0/4.0*viewWidth,viewHeight/2.0) tranformRotation:tranformRotation attributedText:attrStr];
        [imageView addSubview:label2]; // 第二条水印
        UILabel *label3 = [self waterLabelFrame:CGRectMake(0, 0, strWidth, strHeight) labelCenter:CGPointMake(3.0/4.0*viewWidth,viewHeight/2.0) tranformRotation:tranformRotation attributedText:attrStr];
        [imageView addSubview:label3]; // 第三条水印
    }
    self.image = [UIImage getImageFromView:imageView landscapeLeft:NO];
}
/// 创建旋转后的视图
- (UILabel *)waterLabelFrame:(CGRect)frame labelCenter:(CGPoint)lableCenter tranformRotation:(CGFloat)tranformRotation attributedText:(NSMutableAttributedString *)attributedText {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setCenter:lableCenter];
    label.attributedText = attributedText;
    float centerX = label.bounds.size.width/2;
    float centerY = label.bounds.size.height/2;
    float x = label.bounds.size.width/2;
    float y = label.bounds.size.height;
    CGAffineTransform trans = GetCGAffineTransformRotateAroundPoint(centerX,centerY,x ,y ,tranformRotation);
    label.transform = CGAffineTransformIdentity;
    label.transform = trans;
    return label;
}
/// 旋转
CGAffineTransform  GetCGAffineTransformRotateAroundPoint(float centerX, float centerY ,float x ,float y ,float angle)
{
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //1.判断自己能否接收事件
    if(self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) {
        return nil;
    }
    //2.判断当前点在不在当前View.
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    //3.从后往前遍历自己的子控件.让子控件重复前两步操作,(把事件传递给,让子控件调用hitTest)
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
        //取出每一个子控件
        UIView *chileV =  self.subviews[i];
        //把当前的点转换成子控件坐标系上的点.
        CGPoint childP = [self convertPoint:point toView:chileV];
        UIView *fitView = [chileV hitTest:childP withEvent:event];
        //判断有没有找到最适合的View
        if(fitView){
            return fitView;
        }
    }
    
    //4.没有找到比它自己更适合的View.那么它自己就是最适合的View
    return self;
}

//作用:判断当前点在不在它调用View,(谁调用pointInside,这个View就是谁)
//什么时候调用:它是在hitTest方法当中调用的.
//注意:point点必须得要跟它方法调用者在同一个坐标系里面
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    return NO;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
