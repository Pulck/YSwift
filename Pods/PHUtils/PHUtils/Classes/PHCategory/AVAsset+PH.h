//
//  AVAsset+PH.h
//  AliyunVideo
//
//  Created by 朱力 on 2020/6/28.
//  Copyright © 2020 YXT. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (PH)

- (CGSize)avAssetNaturalSize;

- (CGFloat)avAssetVideoTrackDuration;

- (CGFloat)avAssetAudioTrackDuration;

- (float)frameRate;

- (NSString *)artist;

- (NSString *)title;
@end

