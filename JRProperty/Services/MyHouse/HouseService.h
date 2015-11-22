//
//  HouseService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface HouseService : BaseService

/**
 * 3.4.10	房屋—通过小区检索房屋信息
 * @param cId      小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401001:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.11	房屋—绑定房屋
 * @param uId     用户ID
 * @param hId     房屋ID
 * @param type    类型
 * @param idCard  业主身份证号码后6位
 * @param phone   业主手机号
 * @param msgCode 短信验证码
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401101:(NSString *)uId
               hId:(NSString *)hId
              type:(NSString *)type
            idCard:(NSString *)idCard
             phone:(NSString *)phone
           msgCode:(NSString *)msgCode
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.12	房屋—账号绑定的房屋列表查询
 * @param uId     用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401201:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.13	房屋—房下账号查询
 * @param uId     用户ID
 * @param hId     房屋ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401301:(NSString *)uId
               hId:(NSString *)hId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.14	房屋—业主冻结&恢复房下账号
 * @param uId     用户ID
 * @param hId     房屋ID
 * @param optUId     操作的账号
 * @param type     类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401401:(NSString *)uId
               hId:(NSString *)hId
            optUId:(NSString *)optUId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.15	房屋—用户解绑房屋
 * @param uId     用户ID
 * @param hId     房屋ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401501:(NSString *)uId
               hId:(NSString *)hId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
