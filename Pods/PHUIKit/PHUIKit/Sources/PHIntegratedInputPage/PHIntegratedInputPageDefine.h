//
//  PHIntegratedInputPageDefine.h
//  Pods
//
//  Created by 梁琛 on 2019/11/8.
//

#ifndef PHIntegratedInputPageDefine_h
#define PHIntegratedInputPageDefine_h

@import Foundation;

#ifdef __cplusplus
#define PHInput_EXTERN        extern "C" __attribute__((visibility ("default")))
#else
#define PHInput_EXTERN            extern __attribute__((visibility ("default")))
#endif

typedef NS_ENUM(NSUInteger, PHIntegrateSeparatorStyle) {
    PHIntegrateSeparatorStyleNone,
    PHIntegrateSeparatorStyleSingle,
    PHIntegrateSeparatorStyleGroup
};


#endif /* PHIntegratedInputPageDefine_h */
