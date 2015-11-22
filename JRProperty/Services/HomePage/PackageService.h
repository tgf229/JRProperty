//
//  PackageService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface PackageService : BaseService

/**
 * 邮包列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param type   状态类型 1 待领取 2 已领取
 * @param page   当前页
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100601:(NSString *)cId
               uId:(NSString *)uId
              type:(NSString *)type
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


/**
 *  APP用户提醒（用于查询新消息等数量）
 *
 *  @param cId     小区ID
 *  @param uId     用户ID
 *  @param success 成功后调用的block
 *  @param failure 失败后调用的block
 */
- (void) Bus101201:(NSString *)cId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
@end

