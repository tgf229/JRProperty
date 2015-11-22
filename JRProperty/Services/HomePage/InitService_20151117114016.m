//
//  InitService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "InitService.h"
#import "InitModel.h"

@implementation InitService
{
    NSString * versionKey;  // 版本号
    NSString * typeKey   ;  // 手机类型  1安卓 2苹果
    NSString * modelKey  ;  // 手机型号  如:HTCxx
    NSString * imeiKey   ;  // 手机设备唯一号
    NSString * cIdKey    ;  // 小区ID
}

- (id)init
{
    if (self = [super init]) {
        versionKey = @"version";
        typeKey    = @"type";
        modelKey   = @"model";
        imeiKey    = @"imei";
        cIdKey     = @"cId";
    }
    return self;
}

/**
 * 初始化接口
 * @param version 版本号
 * @param type    手机类型  1安卓 2苹果
 * @param model   手机型号  如:HTCxx
 * @param imei    手机设备唯一号
 * @param cId     小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100101:(NSString *)version
              type:(NSString *)type
             model:(NSString *)model
              imei:(NSString *)imei
               cid:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:version,versionKey,type,typeKey,model,modelKey,imei,imeiKey,cId,cIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus100101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        InitModel * demoModel = [[InitModel alloc] initWithDictionary:responseObject error:nil];
        
        
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









