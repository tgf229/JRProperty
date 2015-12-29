//
//  PraiseListService.m
//  JRProperty
//
//  Created by YMDQ on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "PraiseListService.h"
#import "PraiseListModel.h"
#import "PraiseDetailListModel.h"
#import "PraiseSignListModel.h"

@implementation PraiseListService
{
    NSString * cIdKey;      // 小区ID
    NSString * uIdKey;      // 房屋ID
    NSString * timeKey;     // 时间
    
    NSString * eIdKey;      // 员工id
    NSString * pageKey;     // 当前页
    NSString * numKey;      // 每页条数
    NSString * queryTimekey;// 查询时间
    
    NSString * tagKey;      // 标签id数组，逗号分割
    NSString * contentKey;  // 评价内容
}

- (id)init
{
    if (self = [super init]) {
        cIdKey     = @"cId";
        timeKey     = @"time";
        uIdKey     = @"uId";
        
        eIdKey = @"eId";
        pageKey = @"page";
        numKey = @"num";
        queryTimekey = @"queryTime";
        
        tagKey = @"tag";
        contentKey = @"content";

    }
    return self;
}

/**
 * 表扬－信息列表查询 v2.0
 * @param cId    小区ID
 * @param uId    用户ID
 * @param time    时间
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200501:(NSString *)cId
               uId:(NSString *)uId
              time:(NSString *)time
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptTime = [DES3Util tripleDES:time encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptTime,timeKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200501_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
       PraiseListModel * demoModel = [[PraiseListModel alloc] initWithEncryptData:responseObject error:nil];
        
        
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
 * 表扬－评论列表查询 v2.0
 * @param eId    员工ID
 * @param time   时间
 * @param page   当前页
 * @param num    每页条数
 * @param queryTime  查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200801:(NSString *)eId
              time:(NSString *)time
              page:(NSString *)page
               num:(NSString *)num
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:eId,eIdKey,time,timeKey,page,pageKey,num,numKey,queryTime,queryTimekey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200801_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        PraiseDetailListModel * demoModel = [[PraiseDetailListModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 表扬－标签查询 v2.0
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200701:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    // 组装入参parameters对象
    NSDictionary * params = nil;
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200701_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        PraiseSignListModel * demoModel = [[PraiseSignListModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 表扬－表扬接口 v2.0
 * @param string  cId  小区id
 * @param string  uId  用户id
 * @param string  eId  员工id
 * @param string  tag  标签id数组
 * @param string  content  表扬内容
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200601:(NSString *)cId
               uId:(NSString *)uId
               eId:(NSString *)eId
               tag:(NSString *)tag
           content:(NSString *)content
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptEId = [DES3Util tripleDES:eId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptTag = [DES3Util tripleDES:tag encryptOrDecrypt:kCCEncrypt];
    NSString * encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptEId,eIdKey,encryptTag,tagKey,encryptContent,contentKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200601_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        BaseModel * demoModel = [[BaseModel alloc] initWithEncryptData:responseObject error:nil];
        
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
