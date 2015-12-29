//
//  PraiseListService.h
//  JRProperty
//
//  Created by YMDQ on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface PraiseListService : BaseService

/**
 * 表扬－信息列表查询 v2.0
 * @param cId    小区ID
 * @param uId    用户ID
 * @param time    时间
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200501:(NSString *)cId
               uId:(NSString *)uId
               time:(NSString *)time
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 表扬－评论列表查询 v2.0
 * @param eId    员工ID
 * @param time   时间
 * @param page   当前页
 * @param num    每页条数
 * @param queryTime  查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200801:(NSString *)eId
              time:(NSString *)time
              page:(NSString *)page
               num:(NSString *)num
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 表扬－标签查询 v2.0
 * @param string  nil
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200701:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 表扬－表扬接口 v2.0
 * @param string  cId  小区id
 * @param string  uId  用户id
 * @param string  eId  员工id
 * @param string  tag  标签id数组
 * @param string  content  表扬内容
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200601:(NSString *)cId
               uId:(NSString *)uId
               eId:(NSString *)eId
               tag:(NSString *)tag
           content:(NSString *)content
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
