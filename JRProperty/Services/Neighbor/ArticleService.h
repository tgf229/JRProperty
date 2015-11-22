//
//  ArticleService.h
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

@interface ArticleService : BaseService

/**
 * 3.3.7	话题—发表话题
 * @param uId     用户ID
 * @param sId     社区ID
 * @param content     内容
 * @param flag     是否有图片
 * @param file     文件
 * @param phoneType     手机类型
 * @param model     手机型号
 * @param type    话题类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300701:(NSString *)uId
               sId:(NSString *)sId
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray  *)file
         phoneType:(NSString *)phoneType
             model:(NSString *)model
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.8	话题—话题点赞&取消赞
 * @param uId     用户ID
 * @param aId     话题ID
 * @param type    赞和取消赞标志位
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300801:(NSString *)uId
               aId:(NSString *)aId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.9	话题—话题分享
 * @param aId     话题ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300901:(NSString *)aId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.10	话题—话题投票
 * @param uId     用户ID
 * @param aId     话题ID
 * @param type    投票赞成or反对
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301001:(NSString *)uId
               aId:(NSString *)aId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.11	话题—话题评论
 * @param uId     用户ID
 * @param aId     话题ID
 * @param content 评论内容
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301101:(NSString *)uId
               aId:(NSString *)aId
          replyUId:(NSString *)replyUId
         commentId:(NSString *)commentId
           content:(NSString *)content
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.12	话题—话题评论列表查询
 * @param aId    话题ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301201:(NSString *)aId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
/**
 * 3.3.18	用户—话题置顶&取消置顶&删除
 * @param uId    用户ID
 * @param sId    社区ID
 * @param aId    话题ID
 * @param type   类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301801:(NSString *)uId
               sId:(NSString *)sId
               aId:(NSString *)aId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.19	话题-话题详情查询
 * @param aId    话题ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301901:(NSString *)aId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.3.20	话题-话题举报
 * @param aId    话题ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus302201:(NSString *)aId
               uId:(NSString *)uId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
