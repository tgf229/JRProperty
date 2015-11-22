//
//  UserService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface UserService : BaseService

/**
 * 3.4.1	注册
 * @param phone    注册手机号
 * @param nickName 昵称
 * @param msg      手机短信验证码
 * @param pwd      密码
 * @param version  客户端版本标识
 * @param hId      房屋ID
 * @param type     类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400101:(NSString *)phone
          nickName:(NSString *)nickName
               msg:(NSString *)msg
               pwd:(NSString *)pwd
               hId:(NSString *)hId
              type:(NSString *)type
           version:(NSString *)version
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.2	登录
 * @param username 手机号
 * @param pwd      密码
 * @param version  客户端版本标识
 * @param cId      小区ID
 * @param type     类型
 * @param imei     手机唯一号
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400201:(NSString *)username
              imei:(NSString *)imei
               pwd:(NSString *)pwd
               cId:(NSString *)cId
              type:(NSString *)type
           version:(NSString *)version
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.3	通知服务器发送短信验证码
 * @param phone    注册手机号
 * @param type     类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400301:(NSString *)phone
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.4	个人信息查询
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400401:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.5	头像上传
 * @param uId    用户ID
 * @param file    文件
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400501:(NSString *)uId
              file:(NSString *)file
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.6	个人信息修改
 * @param uId      用户ID
 * @param nickName 用户昵称
 * @param desc     用户签名
 * @param name     姓名
 * @param sex      性别
 * @param birth    生日
 * @param flag     模块标记
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400601:(NSString *)uId
          nickName:(NSString *)nickName
              desc:(NSString *)desc
              name:(NSString *)name
               sex:(NSString *)sex
             birth:(NSString *)birth
              flag:(NSString *)flag
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.7	修改密码
 * @param uId      用户ID
 * @param oldPwd   老密码
 * @param pwd      新密码
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400701:(NSString *)uId
            oldPwd:(NSString *)oldPwd
               pwd:(NSString *)pwd
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.8	忘记密码—验证用户名
 * @param username      用户ID
 * @param msgCode   验证码
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400801:(NSString *)username
           msgCode:(NSString *)msgCode
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.4.9	忘记密码—设置新密码
 * @param username      用户ID
 * @param pwd      新密码
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400901:(NSString *)username
               pwd:(NSString *)pwd
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
