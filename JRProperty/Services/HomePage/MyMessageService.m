//
//  MyInfoService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyMessageService.h"
#import "MessageListModel.h"

@implementation MyMessageService
{
    NSString * cIdKey ;  // 小区ID
    NSString * uIdKey ;  // 用户ID
}

- (id)init
{
    if (self = [super init]) {
        cIdKey  = @"cId";
        uIdKey  = @"uId";
    }
    return self;
}

/**
 * 我的消息查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100701:(NSString *)cId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus100701_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        MessageListModel * demoModel = [[MessageListModel alloc] initWithEncryptData:responseObject error:nil];
        
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
