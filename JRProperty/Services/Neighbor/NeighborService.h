//
//  NeighborService.h
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

@interface NeighborService : BaseService

/**
 * 3.3.1	邻里—广场查询
 * @param cId    小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300101:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.2	邻里—社区列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param type    类型
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300201:(NSString *)cId
               uId:(NSString *)uId
              type:(NSString *)type
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


/**
 * 3.3.3	邻里—我关注的社区动态列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300301:(NSString *)cId
               uId:(NSString *)uId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.4	社区—社区基本信息查询
 * @param sId    社区ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300401:(NSString *)sId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


/**
 * 3.3.5	社区—社区话题列表查询
 * @param sId    社区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300501:(NSString *)sId
               uId:(NSString *)uId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.6	社区—关注&取消关注
 * @param uId     用户ID
 * @param sId     社区ID
 * @param type    加入退出标志位
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300601:(NSString *)uId
               sId:(NSString *)sId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
@end


