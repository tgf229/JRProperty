//
//  MoveArticleService.m
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "MoveArticleService.h"

@implementation MoveArticleService
{
    NSString * fromIdKey; // 话题所属的社区ID
    NSString * toIdKey;     // 要转移到的社区ID
    NSString * articleIdKey; // 话题ID
    NSString * uIdKey ;  // 用户ID
    NSString * cIdKey;  // 小区ID
}

- (id)init
{
    if (self = [super init]) {
        fromIdKey = @"fromId";
        toIdKey = @"toId";
        articleIdKey = @"articleId";
        uIdKey  = @"uId";
        cIdKey = @"cId";
    }
    return self;
}

- (void)Bus101301:(NSString *)fromId
             toId:(NSString *)_toId
        articleId:(NSString *)_articleId
              uId:(NSString *)_uId
          success:(void (^)(id))success
          failure:(void (^)(NSError *))failure{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptFromId = [DES3Util tripleDES:fromId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptToId = [DES3Util tripleDES:_toId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptArticleId = [DES3Util tripleDES:_articleId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:_uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptCId = [DES3Util tripleDES:[[NSUserDefaults standardUserDefaults] valueForKey:@"ucid"] encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptFromId,fromIdKey,encryptToId,toIdKey,encryptArticleId,articleIdKey,encryptUId,uIdKey,encryptCId,cIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus302001_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
