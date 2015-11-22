
//
//  UserService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "UserService.h"
#import "LoginModel.h"
#import "UserInfoModel.h"

@implementation UserService
{
    NSString * phoneKey;  // 注册手机号
    NSString * nickNameKey;  // 昵称
    NSString * msgKey;  // 手机短信验证码
    NSString * pwdKey;  // 密码
    NSString * oldPwdKey;  // 密码
    NSString * versionKey;  // 客户端版本标识
    NSString * hIdKey;  // 房屋ID
    NSString * typeKey;  // 类型
    NSString * usernameKey;  // 手机号
    NSString * imeiKey;  // 手机设备唯一码
    NSString * cIdKey;  // 小区ID
    NSString * uIdKey;  // 用户ID
    NSString * fileKey;     // 图片数组
    NSString * sexKey;     // 性别
    NSString * birthKey;     // 出生日期
    NSString * descKey;     // 用户签名
    NSString * nameKey;     // 用户姓名
    NSString * msgCodeKey;     // 验证码
    NSString * flagKey;     // 验证码
}

- (id)init
{
    if (self = [super init]) {
        phoneKey = @"phone";
        nickNameKey = @"nickName";
        msgKey = @"msg";
        pwdKey = @"pwd";
        oldPwdKey = @"oldPwd";  // 密码
        versionKey = @"version";
        hIdKey = @"hId";
        typeKey = @"type";
        usernameKey = @"username";
        imeiKey = @"imei";
        cIdKey = @"cId";
        uIdKey = @"uId";
        fileKey = @"file";
        sexKey = @"sex";
        birthKey = @"birth";
        descKey = @"desc";
        nameKey = @"name";
        msgCodeKey = @"msgCode";
        flagKey = @"flag";
    }
    return self;
}

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
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (msg && ![@"" isEqualToString:msg]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:phone,phoneKey,nickName,nickNameKey,msg,msgKey,pwd,pwdKey,hId,hIdKey,type,typeKey,version,versionKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:phone,phoneKey,nickName,nickNameKey,pwd,pwdKey,hId,hIdKey,type,typeKey,version,versionKey, nil];
    }
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}


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
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:username,usernameKey,imei,imeiKey,pwd,pwdKey,type,typeKey,version,versionKey,cId,cIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        LoginModel * demoModel = [[LoginModel alloc] initWithDictionary:responseObject error:nil];
        
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 解密sessionkey
        if (demoModel && demoModel.baseKey && ![@"" isEqualToString:demoModel.baseKey]) {
            [DES3Util tripleDESWithAppkey:demoModel.baseKey];
            
        }
        // dw add
        if ([RETURN_CODE_SUCCESS isEqualToString:demoModel.retcode]) {
            // 登录成功保存超级管理员标示和用户所选小区标示
//            if ([@"2" isEqualToString:demoModel.userLevel]) {
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSuper"];
//            }else{
//                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSuper"];
//            }
            [[NSUserDefaults standardUserDefaults] setValue:demoModel.userLevel forKey:@"isSuper"];
            [[NSUserDefaults standardUserDefaults] setValue:demoModel.cId forKey:@"ucid"];
            [[NSUserDefaults standardUserDefaults] setValue:demoModel.cId forKey:@"cid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ucid"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isSuper"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        // dw end
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        // dw add
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ucid"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSuper"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // dw end
        if (failure) {
            failure(error);
        }
    }];
}

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
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:phone,phoneKey,type,typeKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400301_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}

/**
 * 3.4.4	个人信息查询
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400401:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400401_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        UserInfoModel * demoModel = [[UserInfoModel alloc] initWithEncryptData:responseObject error:nil];
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}

/**
 * 3.4.5	头像上传
 * @param uId    用户ID
 * @param file    文件路径
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus400501:(NSString *)uId
              file:(NSString *)file
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey, nil];
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400501_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:file] name:fileKey error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}

/**
 * 3.4.6	个人信息修改
 * @param uId      用户ID
 * @param nickName 用户昵称
 * @param desc     用户签名
 * @param name     姓名
 * @param sex      性别
 * @param birth    生日
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
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:6];
    [params setObject:[DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt] forKey:uIdKey];
    [params setObject:[DES3Util tripleDES:nickName encryptOrDecrypt:kCCEncrypt] forKey:nickNameKey];
    [params setObject:[DES3Util tripleDES:flag encryptOrDecrypt:kCCEncrypt] forKey:flagKey];
    if (desc && ![@"" isEqualToString:desc]) {
        [params setObject:[DES3Util tripleDES:desc encryptOrDecrypt:kCCEncrypt] forKey:descKey];
    }
    if (name && ![@"" isEqualToString:name]) {
        [params setObject:[DES3Util tripleDES:name encryptOrDecrypt:kCCEncrypt] forKey:nameKey];
    }
    if (sex && ![@"" isEqualToString:sex]) {
        [params setObject:[DES3Util tripleDES:sex encryptOrDecrypt:kCCEncrypt] forKey:sexKey];
    }
    if (birth && ![@"" isEqualToString:birth]) {
        [params setObject:[DES3Util tripleDES:birth encryptOrDecrypt:kCCEncrypt] forKey:birthKey];
    }
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400601_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithEncryptData:responseObject error:nil];
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}

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
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptOldPwd = [DES3Util tripleDES:oldPwd encryptOrDecrypt:kCCEncrypt];
    NSString * encryptPwd = [DES3Util tripleDES:pwd encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey,encryptOldPwd,oldPwdKey,encryptPwd,pwdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400701_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithEncryptData:responseObject error:nil];
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}

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
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:username,usernameKey,msgCode,msgCodeKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400801_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}

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
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:username,usernameKey,pwd,pwdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus400901_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        
        
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        // 如果有需要，此处添加其他业务逻辑，注意进行线程处理，不要影响UI主线程
        
        
        // 调用success块
        if (success) {
            success(demoModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        /*******失败返回处理逻辑**********/
        
        if (failure) {
            failure(error);
        }
    }];
}

@end
