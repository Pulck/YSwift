//
//  PHNavView.h
//  PHUIKit
//
//  Created by 朱力 on 2020/8/19.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PHNavActionType) {
    PHNavHeaderAction,//点击头像
    PHNavNoticeAction,//点击公告
    PHNavSearchAction,//点击搜索
    PHNavMessageAction,//点击消息
    PHNavScanAction//点击扫码
};

typedef void(^navBlock)(PHNavActionType type, NSInteger noticeIndex);

@interface PHNavView : UIView

/// 初始化导航头
/// @param headerStr 头像地址
/// @param noticeArray 公告表
/// @param msgCount 消息数
/// @param rollSpeed 公告播放速度（单位：秒/1000PT）
- (instancetype)initWithInfo:(id)headerStr
                  noticeArray:(NSArray *)noticeArray
                     msgCount:(NSUInteger)msgCount
                     rollSpeed:(CGFloat)rollSpeed;

/// 导航头中的元素点击行为回调，其中noticeIndex仅用于公告表
@property (nonatomic, copy) navBlock navBlock;

- (void)reSetheaderStr:(id)headerStr;

- (void)reSetNoticeArray:(NSArray *)noticeArray;

- (void)reSetMsgCount:(NSInteger)msgCount;

@end

NS_ASSUME_NONNULL_END
