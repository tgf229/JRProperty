//
//  MemberService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
// 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
// 如果接口返回数据是加密的，responseObject为NSData类型
// 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
// 具体逻辑已在initWithEncryptData方法中实现

#import "BaseService.h"

@interface MemberService : BaseService

/**
 * 3.3.13	用户—用户基本信息查询
 * @param uId    当前用户ID
 * @param queryUId    要查询的用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301301:(NSString *)uId
          queryUId:(NSString *)queryUId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.14	用户—用户话题列表查询
 * @param queryUId    要查询的用户ID
 * @param uId    用户ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301401:(NSString *)uId
          queryUId:(NSString *)queryUId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


/**
 * 3.3.15	用户—创建社区
 * @param uId    用户ID
 * @param cId    小区ID
 * @param name    社区名称
 * @param desc    社区公告
 * @param file    文件
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301501:(NSString *)uId
               cId:(NSString *)cId
              name:(NSString *)name
              desc:(NSString *)desc
              file:(NSString *)file
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.16	用户—删除社区
 * @param uId    用户ID
 * @param sId    社区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301601:(NSString *)uId
               sId:(NSString *)sId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.17	用户—社区基本信息维护
 * @param uId    用户ID
 * @param sId    社区ID
 * @param name    社区名称
 * @param desc    社区公告
 * @param file    文件
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301701:(NSString *)uId
               sId:(NSString *)sId
              name:(NSString *)name
              desc:(NSString *)desc
              logo:(NSString *)logo
              flag:(NSString *)flag
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.18	用户—新消息列表查询
 * @param uId    当前用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus302101:(NSString *)uId
               cId:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
@end
