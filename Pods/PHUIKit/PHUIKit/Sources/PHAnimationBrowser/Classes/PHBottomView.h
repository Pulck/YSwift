//
//  PHBottomView.h
//  AFNetworking
//
//  Created by Hu, Yuping on 2020/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PHBottomViewOperationType) {
    PHBottomViewOperationTypeSave,   //保存
    PHBottomViewOperationTypeMore    //更多
};

@interface PHBottomView : UIView

/// 页码标签
@property (nonatomic, strong) UILabel *pageLabel;

/// 操作按钮（自定义：直接修改图片或文字，然后添加点击事件）
//@property (nonatomic, strong) UIButton *operationButton;

/// 按钮类型
//@property (nonatomic, assign) PHBottomViewOperationType operationType;

/**
 设置页码
 
 @param page 当前页码
 @param totalPage 总页码数
 */
- (void)setPage:(NSInteger)page totalPage:(NSInteger)totalPage;

/// 点击操作按钮的回调
//@property (nonatomic, copy) void(^clickOperation)(PHBottomViewOperationType type);

+ (CGFloat)defaultHeight;

@end

NS_ASSUME_NONNULL_END
