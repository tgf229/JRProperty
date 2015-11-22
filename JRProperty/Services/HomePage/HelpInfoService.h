//
//  HelpInfoService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface HelpInfoService : BaseService

/**
 * 便民信息查询
 * @param cId    小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100801:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 新鲜事查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100901:(NSString *)cId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
