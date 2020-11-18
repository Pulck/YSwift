//
//  UIImage+PH.m
//  FBSnapshotTestCase
//
//  Created by Hu, Yuping on 2019/11/1.
//

#import "UIImage+PH.h"
#import "UIColor+PH.h"
#import "NSString+PH.h"
// 获取屏幕 宽度、高度
#define PHPhoto_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define PHPhoto_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define PHPhoto_HORIZONTAL_SPACE 130//水平间距
#define PHPhoto_VERTICAL_SPACE 130//竖直间距
#define PHPhoto_TRANSFORM_ROTATION (-M_PI_2 / 3)//旋转角度(正旋45度 || 反旋45度)

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

@implementation UIImage (PH)

+ (UIImage *)toolKit_imageName:(NSString *)imageName bundlePath:(NSString *)path {
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@.png",path,imageName];
    return [UIImage imageWithContentsOfFile:imgPath];
}

+ (UIImage *)toolKitUI_imageName:(NSString *)imageName {
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSString *localPath = @"YXTUISDK.bundle/yxtsdk_tools_ui.bundle";
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", path, localPath];
    return [self toolKit_imageName:imageName bundlePath:imgPath];
}

+ (UIImage *)toolKitUI_musicImageName:(NSString *)imageName{
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSString *localPath = @"YXTUISDK.bundle/yxtsdk_tools_ui.bundle/musicImage";
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", path, localPath];
    return [self toolKit_imageName:imageName bundlePath:imgPath];
}

+ (UIImage *)ph_createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

// 根据nikeName绘制图片
+ (UIImage *)ph_createNikeNameImageName:(NSString *)name imageSize:(CGSize)size{
    UIImage *image = [UIImage ph_imageColor:[UIColor ph_colorWithHexString:@"#436BFF" alpha:1] size:size cornerRadius:size.width / 2];
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
    // 画名字
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]}];
    [name drawAtPoint : CGPointMake ( (size.width  - nameSize.width) / 2 , (size.height  - nameSize.height) / 2 ) withAttributes : @{ NSFontAttributeName :[ UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName :[ UIColor ph_colorWithHexString:@"ffffff" ] } ];
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}

+ (UIImage *)ph_imageColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(1, 1);
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [colorImage drawInRect:rect];
    colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

+ (id)ph_colorWithHexString:(NSString*)hexColor alpha:(CGFloat)alpha {
    UIColor* retColor = [UIColor ph_colorWithHexString:hexColor alpha:alpha];
    return retColor;
}


+ (UIImage *)ph_addWaterImage:(UIImage *)originalImage title:(NSString *)title markFont: (CGFloat)markFont
                     markColor: (UIColor *)markColor markAlignment: (NSNumber *)markAlignment waterWidth:(CGFloat)waterWidth
                   waterHeight:(CGFloat)waterHeight verticalSpace:(CGFloat)verticalSpace
               horizontalSpace:(CGFloat)horizontalSpace transformRotation:(CGFloat)rotation
{
    NSLog(@"waterheight = %f",waterHeight);
    //原始image的宽高
    CGFloat viewWidth = originalImage.size.width;
    CGFloat viewHeight = originalImage.size.height;
    int ratio = viewWidth / waterWidth;
    if (ratio <= 0) {
        ratio = 1;
    }
    UIColor *color;
    if (markColor) {
        color = markColor;
    }else{
        color = [UIColor ph_colorWithHexString:@"555555" alpha:0.25f];
    }
    CGFloat fontsize = 14;
    if (markFont > 0) {
        fontsize = markFont;
    }
    UIFont *font = [UIFont systemFontOfSize:fontsize * ratio];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (markAlignment) {
        paragraphStyle.alignment = [markAlignment integerValue];
    }else{
        paragraphStyle.alignment = NSTextAlignmentCenter;//文本对齐方式 左右对齐（两边对齐）
    }
    //文字的属性
    NSDictionary *attr = @{
                           // 设置字体大小
                           NSFontAttributeName: font,
                           // 设置文字颜色
                           NSForegroundColorAttributeName:color,
                           // 设置文字对齐方式
                           NSParagraphStyleAttributeName:paragraphStyle
                           };
    
    //为了防止图片失真，绘制区域宽高和原始图片宽高一样
    UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
    //先将原始image绘制上
    [originalImage drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    //sqrtLength：原始image的对角线length。
    //在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
    NSString *mark = title;
    if ([NSString ph_isNilOrEmpty:mark]) {
        mark = @"";
    }
    NSMutableAttributedString *attrStr = nil;
    attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
    //绘制文字的宽高
    CGFloat strWidth = attrStr.size.width;
    CGFloat strHeight = attrStr.size.height;
    //开始旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将绘制原点（0，0）调整到源image的中心
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
    CGFloat tranformRotation = rotation;
    if (rotation <= 0) {
        tranformRotation = PHPhoto_TRANSFORM_ROTATION;
    }
    //以绘制原点为中心旋转
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(tranformRotation));
    //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点
    //(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
    CGFloat hSpace = horizontalSpace;
    if (hSpace <= 0) {
        hSpace = PHPhoto_HORIZONTAL_SPACE;
    }
    
    CGFloat vSpace = verticalSpace;
    if (vSpace <= 0) {
        vSpace = PHPhoto_VERTICAL_SPACE;
    }
    hSpace *= ratio;
    vSpace *= ratio;
    //计算需要绘制的列数和行数
    int horCount = sqrtLength / (strWidth + hSpace) + 1;
    int verCount = sqrtLength / (strHeight + vSpace) + 1;
    
    //此处计算出需要绘制水印文字的起始点，
    //由于水印区域要大于图片区域所以起点在原有基础上移
    //    CGFloat orignX = -(sqrtLength-viewWidth)/2;
    CGFloat orignY = -(sqrtLength-viewHeight)/2;
    
    //在每列绘制时X坐标叠加
    CGFloat tempOrignX = 0;
    //在每行绘制时Y坐标叠加
    CGFloat tempOrignY = orignY;
    
    for (int i = 0; i < verCount; i++) {
        tempOrignY += (strHeight + vSpace);
        if (i % 2 == 0) { // 单行
            tempOrignX = 10;
        }else { // 双行
            tempOrignX = 10 + hSpace;
        }
        tempOrignX += -2*(strWidth+hSpace);
        // 因为要旋转，默认左右两边多画两条
        for (int j = -2; j < horCount + 2; j++) {
            tempOrignX += strWidth + hSpace;
            CGRect rect = CGRectMake(tempOrignX, tempOrignY, strWidth, strHeight);
            [mark drawInRect:rect withAttributes:attr];
        }
    }
    
    //根据上下文制作成图片
    UIImage *waterMarkImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    
    return waterMarkImg;
}

#pragma mark -图片旋转相关

/** 纠正图片的方向 */
- (UIImage *)ph_fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

/** 按给定的方向旋转图片 */
- (UIImage*)ph_rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

/** 垂直翻转 */
- (UIImage *)ph_flipVertical
{
    return [self ph_rotate:UIImageOrientationDownMirrored];
}

/** 水平翻转 */
- (UIImage *)ph_flipHorizontal
{
    return [self ph_rotate:UIImageOrientationUpMirrored];
}

/** 将图片旋转弧度radians */
- (UIImage *)ph_imageRotatedByRadians:(CGFloat)radians
{
    // calculate the size of the rotated view's containing box for our drawing space
    CGRect rotateRect = CGRectMake(0,0,self.size.width, self.size.height);
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:rotateRect];
    CGAffineTransform rad_t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = rad_t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGFloat drawX = -self.size.width / 2;
    CGFloat drawY = -self.size.height / 2;
    CGRect drawRect = CGRectMake( drawX, drawY, self.size.width, self.size.height);
    CGContextDrawImage(bitmap, drawRect, [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 将图片旋转角度degrees */
- (UIImage *)ph_imageRotatedByDegrees:(CGFloat)degrees
{
    return [self ph_imageRotatedByRadians:kDegreesToRadian(degrees)];
}

/** 交换宽和高 */
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat swap = rect.size.width;
    
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

/**
 将UIView转成UIImage并返回图片路径
 
 @param view 要转换成image的View
 @return 图片路径
 */
+ (NSString *)ph_getViewImagePath:(UIView *)view landscapeLeft:(BOOL)landscapeLeft {
    return [self saveImage:[self getImageFromView:view landscapeLeft:landscapeLeft]];
}

+ (NSString *)saveImage:(UIImage *)image {
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = arr.firstObject;
    NSString *path = [cacheDir stringByAppendingPathComponent:@"draw"];
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDir && existed)) {
        NSFileManager *fm1 = [NSFileManager defaultManager];
        [fm1 createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *str = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000];
    NSString *subPath = [NSString stringWithFormat:@"%@sign.JPG",str];
    NSString *savedImagePath=[path stringByAppendingPathComponent:subPath];
    BOOL success = [imagedata writeToFile:savedImagePath atomically:YES];
    if (success) {
        return savedImagePath;
    }
    return @"";
}

+ (UIImage *)getImageFromView:(UIView *)theView landscapeLeft:(BOOL)landscapeLeft {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, scale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (landscapeLeft) {
        return [image ph_rotate:UIImageOrientationLeft];
    }
    return image;
}

//二维码生成
+ (UIImage *)ph_qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //通过kvo方式给一个字符串，生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    CIImage *img = [filter outputImage];//拿到二维码图片
    CGFloat size = Imagesize;
    CGFloat size2 = waterImagesize;
    UIImage *qrImg = nil;
    qrImg=[self ph_createNonInterpolatedUIImageFormCIImage:img withSize:size waterImageSize:size2];
    return qrImg;
}

+ (UIImage *)ph_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width,
    //size_t height, size_t bitsPerComponent, size_t bytesPerRow,
    //CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    uint32_t bitInfo = (CGBitmapInfo)kCGImageAlphaNone;
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, bitInfo);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //logo图
    UIImage *waterimage = [UIImage imageNamed:@"icon_imgApp"];
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    CGFloat rectX = (size-waterImagesize)/2.0;
    CGFloat rectY = (size-waterImagesize)/2.0;
    CGRect rect = CGRectMake( rectX, rectY, waterImagesize, waterImagesize);
    [waterimage drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

#pragma mark - 图片压缩
/// 压缩图片
+ (NSData *)compressImage:(UIImage *)image maxSize:(NSInteger)maxSize {
    return [self compressImage:image maxSize:maxSize maxWidth:512];
}

/// 压缩图片
/// @param image 需要压缩的图片
/// @param maxSize 压缩最大值，单位：kb
/// @param maxWidth 最大宽度，预先压缩一次，避免图片太大，压缩次数过多
/// @return 压缩后返回的图片数据，可能为 nil
+ (NSData *)compressImage:(UIImage *)image maxSize:(NSInteger)maxSize maxWidth:(CGFloat)maxWidth {
    if (![image isKindOfClass:[UIImage class]] || maxSize <= 0) {
        // 图片为空、没限制压缩大小时，返回nil
        return nil;
    }
    // 先判断当前质量是否满足要求，不满足再进行压缩
    NSData *finallImageData = UIImageJPEGRepresentation(image,1.0);
    NSUInteger sizeOriginKB = finallImageData.length / 1024;
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    // 先调整一次分辨率
    CGFloat sourceImageAspectRatio = image.size.width / image.size.height;
    UIImage *newImage = image;
    CGSize defaultSize = image.size;
    if (maxWidth > 0) {
        defaultSize = CGSizeMake(maxWidth, maxWidth / sourceImageAspectRatio);
        newImage = [self newSizeImage:defaultSize image:image];
        if (newImage) {
            finallImageData = UIImageJPEGRepresentation(newImage,1.0);
            NSUInteger dataLengthKB = finallImageData.length / 1024;
            if (dataLengthKB <= maxSize) {
                return finallImageData;
            }
        }
    }
    
    //保存压缩系数
    NSMutableArray *compQuaArr = [NSMutableArray array];
    CGFloat avg = 1.0 / 250.0;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compQuaArr addObject:@(value)];
    }
    // 调整大小说明：压缩系数数组compressionQualityArr是从大到小存储。
    // 思路：使用二分法获取压缩比例进行压缩
    finallImageData = [self compImage:newImage compQuaArr:compQuaArr maxSize:maxSize];
    // 如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        // 每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        CGFloat scale = [[compQuaArr lastObject] floatValue];
        UIImage *img = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, scale)];
        UIImage *tempImage = [self newSizeImage:defaultSize image:img];
        finallImageData = [self compImage:tempImage compQuaArr:compQuaArr maxSize:maxSize];
    }
    return finallImageData;
}

/// 调整图片分辨率/尺寸（等比例缩放）
+ (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        CGFloat width = sourceImage.size.width / tempWidth;
        CGFloat height = sourceImage.size.height / tempWidth;
        newSize = CGSizeMake( width, height);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        CGFloat width = sourceImage.size.width / tempHeight;
        CGFloat height = sourceImage.size.height / tempHeight;
        newSize = CGSizeMake( width, height);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// 二分法，压缩图片
+ (NSData *)compImage:(UIImage *)img compQuaArr:(NSArray *)compQuaArr maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = compQuaArr.count - 1;
    NSUInteger index = 0;
    
    NSData *imageData = [NSData data];
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        imageData = UIImageJPEGRepresentation(img, [compQuaArr[index] floatValue]);
        
        NSUInteger sizeOrigin = imageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSString *formatStr = @"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf";
        CGFloat comScale = [compQuaArr[index] floatValue];
        NSLog(formatStr, (unsigned long)start, (unsigned long)end, (unsigned long)index, comScale);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        }else if (sizeOriginKB < maxSize) {
            if (maxSize - sizeOriginKB < difference) {
                difference = maxSize - sizeOriginKB;
                tempData = imageData;
            }
            if (index <= 0) {
                break;
            }
            end = index - 1;
        }else {
            break;
        }
    }
    return tempData;
}


+ (UIImage*)ph_originImage:(UIImage *)image scaleToSize:(CGSize)size {
    // 下面方法，第一个参数表示区域大小。
    // 第二个参数表示是否是非透明的。
    // 如果需要显示半透明效果，需要传NO，否则传YES。
    // 第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
