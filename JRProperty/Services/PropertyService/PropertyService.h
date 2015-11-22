//
//  PropertyService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface PropertyService : BaseService

/**
 * 工单提交—报修&投诉&表扬
 * @param cId    小区ID
 * @param uId    用户ID
 * @param hId    房屋ID
 * @param content   描述
 * @param flag    是否包含图片
 * @param file    图片数组
 * @param type    类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200101:(NSString *)cId
               hId:(NSString *)hId
               uId:(NSString *)uId
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray  *)file
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 工单列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200201:(NSString *)cId
               uId:(NSString *)uId
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 工单详情查询
 * @param workOrderId    工单ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200301:(NSString *)workOrderId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 工单评价
 * @param workOrderId      工单ID
 * @param uId    用户ID
 * @param content 评论内容
 * @param level   评价级别
 * @param flag    是否包含图片
 * @param file    图片数组
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200401:(NSString *)workOrderId
               uId:(NSString *)uId
             level:(NSString *)level
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray  *)file
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


@end
