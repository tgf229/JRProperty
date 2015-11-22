//
//  BaseService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-7.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService
{
    NSString * key1;  // 当前service请求用到的key统一在头部定义
}

- (id)init
{
    if (self = [super init]) {
        key1 = @"key1";   // 当前service请求用到的key统一在此初始化
    }
    return self;
}

/**
 * service方法示例
 * @param inputString 入参  根据实际业务，可有多个，也可多种类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */

- (void) serviceDemo:(NSString *)inputString
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptValue = [DES3Util tripleDES:inputString encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptValue,key1, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:@"www.baidu.com" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithEncryptData:responseObject error:nil];
        
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
//        BaseModel * demoModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        
        
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
