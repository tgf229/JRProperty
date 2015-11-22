//
//  SettingService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "SettingService.h"
#import "VersionModel.h"

@implementation SettingService
{
    NSString * uIdKey;  // 用户ID
    NSString * versionKey;  // 版本号
    NSString * typeKey;  // 手机类型
    NSString * modelKey;  // 手机型号
    NSString * imeiKey;  // 设备唯一号
    NSString * contactKey;  // 用户联系方式
    NSString * remarkKey;  // 用户反馈意见信息
}

- (id)init
{
    if (self = [super init]) {
        uIdKey = @"uId";
        versionKey = @"version";
        typeKey = @"type";
        modelKey = @"model";
        imeiKey = @"imei";
        contactKey = @"contact";
        remarkKey = @"remark";

    }
    return self;
}


/**
 * 3.5.1	意见反馈
 * @param uId     用户ID
 * @param version 版本号
 * @param type    手机类型
 * @param model   手机型号
 * @param imei    设备唯一号
 * @param contact 用户联系方式
 * @param remark  用户反馈意见信息
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus500101:(NSString *)uId
           version:(NSString *)version
              type:(NSString *)type
             model:(NSString *)model
              imei:(NSString *)imei
           contact:(NSString *)contact
            remark:(NSString *)remark
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
//    // 如果请求需要加密，此处对入参进行加密预处理
//    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
//    NSString * encryptVersion = [DES3Util tripleDES:version encryptOrDecrypt:kCCEncrypt];
//    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
//    NSString * encryptModel = [DES3Util tripleDES:model encryptOrDecrypt:kCCEncrypt];
//    NSString * encryptImei = [DES3Util tripleDES:imei encryptOrDecrypt:kCCEncrypt];
//    NSString * encryptContact = [DES3Util tripleDES:contact encryptOrDecrypt:kCCEncrypt];
//    NSString * encryptRemark = [DES3Util tripleDES:remark encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params;
    if (contact && ![@"" isEqualToString:contact]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:version,versionKey,type,typeKey,model,modelKey,imei,imeiKey,contact,contactKey,remark,remarkKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:version,versionKey,type,typeKey,model,modelKey,imei,imeiKey,remark,remarkKey, nil];
    }
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus500101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

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
 * 3.5.2	版本更新检查
 * @param version 版本号
 * @param type    手机类型
 * @param imei    设备唯一号
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus500201:(NSString *)version
              type:(NSString *)type
              imei:(NSString *)imei
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:version,versionKey,imei,imeiKey,type,typeKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus500201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        VersionModel * demoModel = [[VersionModel alloc] initWithDictionary:responseObject error:nil];
        
        
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
