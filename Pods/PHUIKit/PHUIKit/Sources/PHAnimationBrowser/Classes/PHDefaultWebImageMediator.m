//
//  PHDefaultWebImageMediator.m
//  AFNetworking
//
//  Created by Hu, Yuping on 2019/12/27.
//

#import "PHDefaultWebImageMediator.h"
#import "YBIBUtilities.h"
#import <SDWebImage/SDWebImageManager.h>
#import "SDWebImageDownloaderOperation.h"
#import "SDImageCache.h"

@implementation PHDefaultWebImageMediator

#pragma mark - <YBIBWebImageMediator>
    
- (id)yb_downloadImageWithURL:(NSURL *)URL requestModifier:(nullable YBIBWebImageRequestModifierBlock)requestModifier progress:(nonnull YBIBWebImageProgressBlock)progress success:(nonnull YBIBWebImageSuccessBlock)success failed:(nonnull YBIBWebImageFailedBlock)failed {
    if (!URL) return nil;

    SDWebImageManager *manger = [SDWebImageManager sharedManager];
    id token = [manger.imageDownloader downloadImageWithURL:URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progress) progress(receivedSize, expectedSize);
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (error) {
            if (failed) failed(error, finished);
        } else {
            if (success) success(data, finished);
        }
    }];
    
    return token;
}
    
- (void)yb_cancelTaskWithDownloadToken:(id)token {
    if (token) {
        SDWebImageDownloaderOperation * operation = (SDWebImageDownloaderOperation *)token;
        [operation cancel];
    }
}
    
- (void)yb_storeToDiskWithImageData:(NSData *)data forKey:(NSURL *)key {
    if (!key) return;
    NSString *cacheKey = [SDWebImageManager.sharedManager cacheKeyForURL:key];
    if (!cacheKey) return;
    
    YBIB_DISPATCH_ASYNC(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[SDImageCache sharedImageCache] storeImageDataToDisk:data forKey:cacheKey];
    })
}
    
- (void)yb_queryCacheOperationForKey:(NSURL *)key completed:(YBIBWebImageCacheQueryCompletedBlock)completed {
#define QUERY_CACHE_FAILED if (completed) {completed(nil, nil); return;}
    if (!key) QUERY_CACHE_FAILED
    NSString *cacheKey = [SDWebImageManager.sharedManager cacheKeyForURL:key];
    if (!cacheKey) QUERY_CACHE_FAILED
#undef QUERY_CACHE_FAILED
    
    // 获取当前的图片的缓存Key
    NSString *img_key = [SDWebImageManager.sharedManager cacheKeyForURL:key];
    // 获取内存中缓存的UIimage对象
    UIImage *memoryImg = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:img_key];
    // 获取本地缓存的文件路径
    NSString *imagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:img_key];
    
    if (memoryImg) { // 内存中获取UIImage对象
        if (completed) {
            completed(memoryImg, [NSData dataWithContentsOfFile:imagePath]);
        }
    } else { // 硬盘上获取UIImage对象
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:img_key done:^(UIImage *image, SDImageCacheType cacheType) {
            if (completed) {
                completed(image, [NSData dataWithContentsOfFile:imagePath]);
            }
        }];
    }
    
}
    
@end
