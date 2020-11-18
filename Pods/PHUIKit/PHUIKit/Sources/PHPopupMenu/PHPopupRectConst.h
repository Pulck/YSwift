//
//  PHPopupRectConst.h
//  PHUIKit
//
//  Created by 秦平平 on 2020/1/13.
//  Copyright © 2020 云学堂信息科技（江苏）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_STATIC_INLINE CGFloat PHRectWidth(CGRect rect)
{
    return rect.size.width;
}

UIKIT_STATIC_INLINE CGFloat PHRectHeight(CGRect rect)
{
    return rect.size.height;
}

UIKIT_STATIC_INLINE CGFloat PHRectX(CGRect rect)
{
    return rect.origin.x;
}

UIKIT_STATIC_INLINE CGFloat PHRectY(CGRect rect)
{
    return rect.origin.y;
}

UIKIT_STATIC_INLINE CGFloat PHRectTop(CGRect rect)
{
    return rect.origin.y;
}

UIKIT_STATIC_INLINE CGFloat PHRectBottom(CGRect rect)
{
    return rect.origin.y + rect.size.height;
}

UIKIT_STATIC_INLINE CGFloat PHRectLeft(CGRect rect)
{
    return rect.origin.x;
}

UIKIT_STATIC_INLINE CGFloat PHRectRight(CGRect rect)
{
    return rect.origin.x + rect.size.width;
}

NS_ASSUME_NONNULL_END
