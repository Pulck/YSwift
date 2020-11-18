//
//  PHDataMediator.h
//  图片浏览Demo
//
//  Created by Hu, Yuping on 2019/12/27.
//  Copyright © 2019 江苏云学堂信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHAnimationImageBrowser.h"

NS_ASSUME_NONNULL_BEGIN

@interface PHDataMediator : NSObject

- (instancetype)initWithBrowser:(PHAnimationImageBrowser *)browser;

@property (nonatomic, assign) NSUInteger dataCacheCountLimit;

- (NSInteger)numberOfCells;

- (id<YBIBDataProtocol>)dataForCellAtIndex:(NSInteger)index;

- (void)clear;

@property (nonatomic, assign) NSUInteger preloadCount;

- (void)preloadWithPage:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
