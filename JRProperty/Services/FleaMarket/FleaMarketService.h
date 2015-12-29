//
//  FleaMarketService.h
//  JRProperty
//
//  Created by YMDQ on 15/12/21.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface FleaMarketService : BaseService

/**
 * 跳蚤市场－列表查询 v2.0
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page    当前页
 * @param num    每页展示条数
 * @param type    类型0售卖宝贝1求购宝贝
 * @param queryTime    查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600101:(NSString *)uId
               cId:(NSString *)cId
              page:(NSString *)page
               num:(NSString *)num
              type:(NSString *)type
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 跳蚤市场－详情查询 v2.0
 * @param uId    小区ID
 * @param aId    宝贝id
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600201:(NSString *)uId
               aId:(NSString *)aId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 跳蚤市场－评论列表查询 v2.0
 * @param aId    宝贝ID
 * @param page    当前页
 * @param num    每页展示条数
 * @param queryTime    查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600301:(NSString *)aId
              page:(NSString *)page
               num:(NSString *)num
               queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 跳蚤市场－评论&回复 v2.0
 * @param cId    小区ID
 * @param aId    宝贝ID
 * @param uId    用户id
 * @param replyUid    被回复对用户id
 * @param commentId    被回复的评论id
 * @param content    评论内容
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600401:(NSString *)cId
              aId:(NSString *)aId
               uId:(NSString *)uId
         replyUid:(NSString *)replyUid
         commentId:(NSString *)commentid
           content:(NSString *)content
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 跳蚤市场－发布宝贝信息 v2.0
 * @param cId    小区ID
 * @param uId    用户id
 * @param content    话题内容
 * @param flag    是否包含图片
 * @param file    图片数组
 * @param phoneType    手机类型 1安卓2苹果
 * @param model    手机型号
 * @param type    信息类型 0售卖1求购
 * @param oPrice    原价
 * @param cPrice    现价
 * @param showPhone    联系方式
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600501:(NSString *)cId
               uId:(NSString *)uId
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray *)file
         phoneType:(NSString *)phoneType
             model:(NSString *)model
              type:(NSString *)type
            oPrice:(NSString *)oPrice
            cPrice:(NSString *)cPrice
         showPhone:(NSString *)showPhone
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 跳蚤市场－宝贝操作接口 v2.0
 * @param cId    小区ID
 * @param aId    宝贝ID
 * @param uId    用户id
 * @param type   类型 取消收藏0 收藏1 上架2 下架3 删除4
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600601:(NSString *)cId
               aId:(NSString *)aId
               uId:(NSString *)uId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 跳蚤市场－发布宝贝列表查询 v2.0
 * @param uId    当前用户ID
 * @param cId    小区ID
 * @param queryUid    要查询的用户id
 * @param page    当前页
 * @param num   每页展示条数
 * @param type   类型 0下架的宝贝 1上架的宝贝
 * @param queryTime   查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600701:(NSString *)uId
               cId:(NSString *)cId
          queryUid:(NSString *)queryUid
              page:(NSString *)page
               num:(NSString *)num
              type:(NSString *)type
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 跳蚤市场－发布宝贝列表查询 v2.0
 * @param uId    当前用户ID
 * @param cId    小区ID
 * @param queryUid    要查询的用户id
 * @param page    当前页
 * @param num   每页展示条数
 * @param queryTime   查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600801:(NSString *)uId
               cId:(NSString *)cId
          queryUid:(NSString *)queryUid
              page:(NSString *)page
               num:(NSString *)num
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
