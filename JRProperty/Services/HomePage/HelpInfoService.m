//
//  HelpInfoService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HelpInfoService.h"
#import "HelpInfoListModel.h"
#import "NewsListModel.h"

@implementation HelpInfoService
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
 * 便民信息查询
 * @param cId    小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100801:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus100801_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        HelpInfoListModel * demoModel = [[HelpInfoListModel alloc] initWithDictionary:responseObject error:nil];
        
        
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
 * 新鲜事查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100901:(NSString *)cId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (uId && ![@"" isEqualToString:uId]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey,uId,uIdKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey, nil];
    }
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus100901_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        NewsListModel * demoModel = [[NewsListModel alloc] initWithDictionary:responseObject error:nil];
        
        
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
