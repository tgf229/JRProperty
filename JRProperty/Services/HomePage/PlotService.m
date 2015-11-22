//
//  PlotService.m
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "PlotService.h"
#import "PlotListModel.h"
@implementation PlotService
{
    NSString * uIdKey ;  // 用户ID
}

- (id)init
{
    if (self = [super init]) {
        uIdKey  = @"uId";
    }
    return self;
}

- (void)Bus101301:(NSString *)uId
          success:(void (^)(id))success
          failure:(void (^)(NSError *))failure{
    // 组装入参parameters对象
    NSDictionary * params = nil;
    if (uId) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey, nil];
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus101301_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        NSError *error = [[NSError alloc] init];
        PlotListModel * demoModel = [[PlotListModel alloc] initWithData:responseObject error:&error];
        
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
