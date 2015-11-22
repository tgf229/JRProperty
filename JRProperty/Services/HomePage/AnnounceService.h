//
//  AnnounceService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface AnnounceService : BaseService

/**
 * 轮播通告—列表查询
 * @param cId     小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100201:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 轮播通告—详情查询
 * @param announceId      通告ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100301:(NSString *)announceId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 轮播通告—赞&踩&分享
 * @param announceId      通告ID
 * @param type    赞和踩&分享标志位	踩:0 赞:1 分享:2
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100401:(NSString *)announceId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 轮播通告—评论
 * @param announceId      通告ID
 * @param uId    用户ID
 * @param content 评论内容
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100501:(NSString *)announceId
               uId:(NSString *)uId
           content:(NSString *)content
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end



