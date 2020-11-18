//
//  PHSignDialogView.h
//  AFNetworking
//
//  Created by zhuli on 2018/4/27.
//  云豆

#import "PHDialogBaseView.h"

@interface PHSignDialogView : PHDialogBaseView

/**
 初始化云豆view

 @param frame size
 @param yunDouCount 云豆个数
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame yunDouCount:(int)yunDouCount;

@end
