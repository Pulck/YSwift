//
//  PHToolViewHandler.m
//  AFNetworking
//
//  Created by Hu, Yuping on 2020/1/4.
//

#import "PHToolViewHandler.h"
#import "YBIBSheetView.h"
#import "YBIBDataProtocol.h"
#import "YBIBOrientationReceiveProtocol.h"
#import "YBIBOperateBrowserProtocol.h"
#import "YBIBCopywriter.h"
#import "YBIBUtilities.h"
#import "PHBottomView.h"

@interface PHToolViewHandler ()

@property (nonatomic, strong) YBIBSheetAction *saveAction;

@end

@implementation PHToolViewHandler

#pragma mark - <YBIBToolViewHandler>

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentPage = _yb_currentPage;
@synthesize yb_totalPage = _yb_totalPage;
@synthesize yb_currentOrientation = _yb_currentOrientation;
@synthesize yb_currentData = _yb_currentData;

- (void)yb_containerViewIsReadied {
    [self.yb_containerView addSubview:self.bottomView];
    [self layoutWithExpectOrientation:self.yb_currentOrientation()];
}

- (void)yb_pageChanged {
    [self.bottomView setPage:self.yb_currentPage() totalPage:self.yb_totalPage()];
}

- (void)yb_respondsToLongPress {
    [self showSheetView];
}

- (void)yb_hide:(BOOL)hide {
    self.bottomView.hidden = hide;
    [self.sheetView hideWithAnimation:NO];
}

- (void)yb_orientationWillChangeWithExpectOrientation:(UIDeviceOrientation)orientation {
    [self.sheetView hideWithAnimation:NO];
}

- (void)yb_orientationChangeAnimationWithExpectOrientation:(UIDeviceOrientation)orientation {
    [self layoutWithExpectOrientation:orientation];
}

#pragma mark - private

- (BOOL)currentDataShouldHideSaveButton {
    id<YBIBDataProtocol> data = self.yb_currentData();
    BOOL allow = [data respondsToSelector:@selector(yb_allowSaveToPhotoAlbum)] && [data yb_allowSaveToPhotoAlbum];
    BOOL can = [data respondsToSelector:@selector(yb_saveToPhotoAlbum)];
    return !(allow && can);
}

- (void)layoutWithExpectOrientation:(UIDeviceOrientation)orientation {
    CGSize containerSize = self.yb_containerSize(orientation);
    UIEdgeInsets padding = YBIBPaddingByBrowserOrientation(orientation);
    
    CGFloat viewY = [UIScreen mainScreen].bounds.size.height - padding.bottom - [PHBottomView defaultHeight];
    self.bottomView.frame = CGRectMake(padding.left, viewY, containerSize.width - padding.left - padding.right, [PHBottomView defaultHeight]);
}

- (void)showSheetView {
    if ([self currentDataShouldHideSaveButton]) {
        [self.sheetView.actions removeObject:self.saveAction];
    } else {
        if (![self.sheetView.actions containsObject:self.saveAction]) {
            [self.sheetView.actions addObject:self.saveAction];
        }
    }
    [self.sheetView showToView:self.yb_containerView orientation:self.yb_currentOrientation()];
}

#pragma mark - getters

- (YBIBSheetView *)sheetView {
    if (!_sheetView) {
        _sheetView = [YBIBSheetView new];
        __weak typeof(self) wSelf = self;
        [_sheetView setCurrentdata:^id<YBIBDataProtocol>{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return nil;
            return self.yb_currentData();
        }];
    }
    return _sheetView;
}

- (YBIBSheetAction *)saveAction {
    if (!_saveAction) {
        __weak typeof(self) wSelf = self;
        _saveAction = [YBIBSheetAction actionWithName:[YBIBCopywriter sharedCopywriter].saveToPhotoAlbum action:^(id<YBIBDataProtocol> data) {
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            if ([data respondsToSelector:@selector(yb_saveToPhotoAlbum)]) {
                [data yb_saveToPhotoAlbum];
            }
            [self.sheetView hideWithAnimation:YES];
        }];
    }
    return _saveAction;
}

- (PHBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [PHBottomView new];
    }
    return _bottomView;
}

@end
