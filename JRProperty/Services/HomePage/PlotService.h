//
//  PlotService.h
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface PlotService : BaseService

/**
 *  小区检索 V1.1
 *
 *  @param uId     用户ID
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) Bus101301:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
