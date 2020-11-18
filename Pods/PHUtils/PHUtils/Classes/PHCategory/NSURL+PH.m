//
//  NSURL+PH.m
//  FBSnapshotTestCase
//
//  Created by Hu, Yuping on 2019/11/1.
//

#import "NSURL+PH.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSURL (PH)

+(NSString*)ph_urlValueEncode:(NSString*)str
{
    CFAllocatorRef allocator = kCFAllocatorDefault;
    CFStringRef ori = (__bridge CFStringRef)str;
    CFStringRef cha = NULL;
    CFStringRef leg = CFSTR("!*'();:@&=+$,/?%#[]");
    CFStringEncoding encod = kCFStringEncodingUTF8;
    CFStringRef result = CFURLCreateStringByAddingPercentEscapes(allocator, ori, cha, leg, encod);
    return (NSString *)CFBridgingRelease(result);
}

+(NSString *)ph_urlValueDecode:(NSString*)str{
    NSString *result = [(NSString *)str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


// 获取视频第一帧
+ (UIImage*)ph_getVideoPreViewImageWithURL:(NSURL *)url {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

@end
