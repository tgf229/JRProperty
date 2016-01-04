//
//  MyMessageBoxService.m
//  JRProperty
//
//  Created by YMDQ on 16/1/4.
//  Copyright © 2016年 YRYZY. All rights reserved.
//

#import "MyMessageBoxService.h"
#import "MyMessageBoxListModel.h"

@implementation MyMessageBoxService
{
    NSString * cIdKey    ;         // 小区ID
    NSString * uIdKey     ;        // 用户ID
   }

- (id)init
{
    if (self = [super init]) {
        cIdKey            = @"cId";
        uIdKey            = @"uId";
    }
    return self;
}

/**
 *  我的消息查询 V2.0
 *
 *  @param cId     小区ID
 *  @param uId       用户ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void) Bus100702:(NSString *)cId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey,encryptCId,cIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus100702_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        MyMessageBoxListModel * demoModel = [[MyMessageBoxListModel alloc] initWithEncryptData:responseObject error:nil];
        
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
