//
//  HouseService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HouseService.h"
#import "BuildingListModel.h"
#import "MyHouseListModel.h"
#import "UserInfoModel.h"

@implementation HouseService
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
    NSString * idCardKey;     // 身份证后6位
    NSString * optUIdKey;     // 操作的账号
    
}

- (id)init
{
    if (self = [super init]) {
        phoneKey = @"phone";
        nickNameKey = @"nickName";
        msgKey = @"msg";
        pwdKey = @"pwd";
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
        idCardKey = @"idCard";
        optUIdKey = @"optUId";
    }
    return self;
}

/**
 * 3.4.10	房屋—通过小区检索房屋信息
 * @param cId      小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401001:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus401001_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        BuildingListModel * demoModel = [[BuildingListModel alloc] initWithDictionary:responseObject error:nil];
        
        
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
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (uId && ![@"" isEqualToString:uIdKey]) {
        if ([@"1" isEqualToString:type]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,hId,hIdKey,type,typeKey,idCard,idCardKey,phone,phoneKey,msgCode,msgCodeKey, nil];
        } else if ([@"2" isEqualToString:type]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,hId,hIdKey,type,typeKey,idCard,idCardKey, nil];
        }
    } else {
        if ([@"1" isEqualToString:type]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:hId,hIdKey,type,typeKey,idCard,idCardKey,phone,phoneKey,msgCode,msgCodeKey, nil];
        } else if ([@"2" isEqualToString:type]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:hId,hIdKey,type,typeKey,idCard,idCardKey, nil];
        }
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus401101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
 * 3.4.12	房屋—账号绑定的房屋列表查询
 * @param uId     用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401201:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus401201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        MyHouseListModel * demoModel = [[MyHouseListModel alloc] initWithEncryptData:responseObject error:nil];
        
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
 * 3.4.13	房屋—房下账号查询
 * @param uId     用户ID
 * @param hId     房屋ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401301:(NSString *)uId
               hId:(NSString *)hId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptHId = [DES3Util tripleDES:hId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey,encryptHId,hIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus401301_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        UserInfoListModel * demoModel = [[UserInfoListModel alloc] initWithEncryptData:responseObject error:nil];
        
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
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptHId = [DES3Util tripleDES:hId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptOptUId = [DES3Util tripleDES:optUId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey,encryptHId,hIdKey,encryptOptUId,optUIdKey,encryptType,typeKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus401401_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
 * 3.4.15	房屋—用户解绑房屋
 * @param uId     用户ID
 * @param hId     房屋ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus401501:(NSString *)uId
               hId:(NSString *)hId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptHId = [DES3Util tripleDES:hId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey,encryptHId,hIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus401501_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

@end
