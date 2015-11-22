//
//  PackageService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PackageService.h"
#import "PackageListModel.h"
#import "NewPackageNumModel.h"
@implementation PackageService
{
    NSString * cIdKey ;  // 小区ID
    NSString * uIdKey ;  // 用户ID
    NSString * typeKey;  // 状态类型
    NSString * pageKey;  // 当前页
    NSString * numKey ;  // 每页展示条数
}

- (id)init
{
    if (self = [super init]) {
        cIdKey  = @"cId";
        uIdKey  = @"uId";
        typeKey = @"type";
        pageKey = @"page";
        numKey  = @"num";
    }
    return self;
}

/**
 * 邮包列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param type   状态类型 1 待领取 2 已领取
 * @param page   当前页
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100601:(NSString *)cId
               uId:(NSString *)uId
              type:(NSString *)type
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    NSString * encryptPage = [DES3Util tripleDES:page encryptOrDecrypt:kCCEncrypt];
    NSString * encryptNum = [DES3Util tripleDES:num encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptType,typeKey,encryptPage,pageKey,encryptNum,numKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus100601_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        PackageListModel * demoModel = [[PackageListModel alloc] initWithEncryptData:responseObject error:nil];
        
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
 *  APP用户提醒（用于查询新消息等数量）
 *
 *  @param cId     小区ID
 *  @param uId     用户ID
 *  @param success 成功后调用的block
 *  @param failure 失败后调用的block
 */
- (void)Bus101201:(NSString *)cId
              uId:(NSString *)uId
          success:(void (^)(id))success
          failure:(void (^)(NSError *))failure{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus101201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NewPackageNumModel *demoModel = [[NewPackageNumModel alloc] init];
        NSData *jsonData = [[DES3Util tripleDES:string encryptOrDecrypt:kCCDecrypt] dataUsingEncoding:NSUTF8StringEncoding];     /* Now try to deserialize the JSON object into a dictionary */
        
        NSError *error = nil;
        if (jsonData) {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"消息数目接口  %@",jsonObject);
            if (jsonObject != nil && error == nil){
                if ([jsonObject isKindOfClass:[NSDictionary class]]){
                    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                    demoModel.retinfo = [deserializedDictionary objectForKey:@"retinfo"];
                    demoModel.retcode = [deserializedDictionary objectForKey:@"retcode"];
                    demoModel.theNewPost = [deserializedDictionary objectForKey:@"newPost"];
                    demoModel.theNewReply = [deserializedDictionary objectForKey:@"newReply"];
                    
                } else if ([jsonObject isKindOfClass:[NSArray class]]){
                } else {
                }
            }
        }
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
//        NewPackageNumModel * demoModel = [[NewPackageNumModel alloc] initWithEncryptData:responseObject error:nil];
        
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
