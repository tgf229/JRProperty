//
//  NeighborService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "NeighborService.h"
#import "SquareModel.h"
#import "CircleListModel.h"
#import "ArticleListModel.h"
#import "CommunityModel.h"


@implementation NeighborService
{
    NSString * cIdKey;      // 小区ID
    NSString * hIdKey;      // 房屋ID
    NSString * uIdKey;      // 用户ID
    NSString * sIdKey;      // 社区ID
    NSString * contentKey;  // 描述
    NSString * flagKey;     // 是否包含图片
    NSString * fileKey;     // 图片数组
    NSString * typeKey;     // 类型
    NSString * pageKey;     // 当前页
    NSString * numKey ;     // 每页展示条数
    NSString * workOrderIdKey ;     // 工单ID
    NSString * queryTimeKey;     // 查询时间点
    
}

- (id)init
{
    if (self = [super init]) {
        cIdKey     = @"cId";
        hIdKey     = @"hId";
        uIdKey     = @"uId";
        sIdKey     = @"id";
        contentKey = @"content";
        flagKey    = @"flag";
        fileKey    = @"file";
        typeKey    = @"type";
        pageKey    = @"page";
        numKey     = @"num";
        workOrderIdKey     = @"id";
        queryTimeKey     = @"queryTime";
    }
    return self;
}
/**
 * 3.3.1	邻里—广场查询
 * @param cId    小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300101:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        SquareModel * demoModel = [[SquareModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"广场查询 %@",responseObject);
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
 * 3.3.2	邻里—社区列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param type    类型
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300201:(NSString *)cId
               uId:(NSString *)uId
              type:(NSString *)type
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (uId && ![@"" isEqualToString:uId]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey,uId,uIdKey,type,typeKey,page,pageKey,num,numKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey,type,typeKey,page,pageKey,num,numKey, nil];
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        NSLog(@"圈子列表查询 %@",responseObject);
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        CircleListModel * demoModel = [[CircleListModel alloc] initWithDictionary:responseObject error:nil];
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
 * 3.3.3	邻里—我关注的社区动态列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300301:(NSString *)cId
               uId:(NSString *)uId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (queryTime && ![@"" isEqualToString:queryTime]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey,uId,uIdKey,queryTime,queryTimeKey,page,pageKey,num,numKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey,uId,uIdKey,page,pageKey,num,numKey, nil];
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300301_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        NSLog(@"查询我关注的动态 %@",responseObject);
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        ArticleListModel * demoModel = [[ArticleListModel alloc] initWithDictionary:responseObject error:nil];
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
 * 3.3.4	社区—社区基本信息查询
 * @param sId    社区ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300401:(NSString *)sId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (uId && ![@"" isEqualToString:uId]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:sId,sIdKey,uId,uIdKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:sId,sIdKey, nil];
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300401_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        NSLog(@"圈子基本信息 %@",responseObject);
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        CommunityModel * demoModel = [[CommunityModel alloc] initWithDictionary:responseObject error:nil];
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
 * 3.3.5	社区—社区话题列表查询
 * @param sId    社区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300501:(NSString *)sId
               uId:(NSString *)uId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (uId && ![@"" isEqualToString:uId]) {
        if (queryTime && ![@"" isEqualToString:queryTime]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:sId,sIdKey,uId,uIdKey,queryTime,queryTimeKey,page,pageKey,num,numKey, nil];
        } else {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:sId,sIdKey,uId,uIdKey,page,pageKey,num,numKey, nil];
        }
    } else {
        if (queryTime && ![@"" isEqualToString:queryTime]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:sId,sIdKey,queryTime,queryTimeKey,page,pageKey,num,numKey, nil];
        } else {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:sId,sIdKey,page,pageKey,num,numKey, nil];
        }
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300501_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
       // NSLog(@"社区话题列表 %@",responseObject);
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        ArticleListModel * demoModel = [[ArticleListModel alloc] initWithDictionary:responseObject error:nil];
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
 * 3.3.6	社区—关注&取消关注
 * @param uId     用户ID
 * @param sId     社区ID
 * @param type    加入退出标志位
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300601:(NSString *)uId
               sId:(NSString *)sId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptSId = [DES3Util tripleDES:sId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,uIdKey,encryptSId,sIdKey,encryptType,typeKey,encryptCId,@"cId", nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300601_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
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
