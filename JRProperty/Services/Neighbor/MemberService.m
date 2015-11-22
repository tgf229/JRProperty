//
//  MemberService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MemberService.h"
#import "CommunityModel.h"
#import "ArticleListModel.h"
#import "ReplyListModel.h"

@implementation MemberService
{
    NSString * cIdKey;      // 小区ID
    NSString * hIdKey;      // 房屋ID
    NSString * uIdKey;      // 用户ID
    NSString * aIdKey;      // 话题ID
    NSString * sIdKey;      // 社区ID
    NSString * contentKey;  // 描述
    NSString * flagKey;     // 是否包含图片
    NSString * fileKey;     // 图片数组
    NSString * typeKey;     // 类型
    NSString * pageKey;     // 当前页
    NSString * numKey ;     // 每页展示条数
    NSString * phoneTypeKey ;     // 手机类型
    NSString * queryTimeKey;     // 查询时间点
    NSString * modelKey;     // 手机型号
    NSString * queryUIdKey;     // 要查询的用户ID
    NSString * nameKey;     // 社区名称
    NSString * descKey;     // 社区公告
    NSString * logoKey;     // 社区logo
    
}

- (id)init
{
    if (self = [super init]) {
        cIdKey     = @"cId";
        hIdKey     = @"hId";
        uIdKey     = @"uId";
        aIdKey     = @"id";
        sIdKey     = @"id";
        contentKey = @"content";
        flagKey    = @"flag";
        fileKey    = @"file";
        typeKey    = @"type";
        pageKey    = @"page";
        numKey     = @"num";
        phoneTypeKey     = @"phoneType";
        queryTimeKey     = @"queryTime";
        modelKey     = @"model";
        queryUIdKey     = @"queryUId";
        nameKey     = @"name";
        descKey     = @"desc";
        logoKey     = @"logo";
    }
    return self;
}

/**
 * 3.3.13	用户—用户基本信息查询
 * @param uId    当前用户ID
 * @param queryUId    要查询的用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301301:(NSString *)uId
          queryUId:(NSString *)queryUId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (uId && ![@"" isEqualToString:uId]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,queryUId,queryUIdKey,CID_FOR_REQUEST,cIdKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:queryUId,queryUIdKey,CID_FOR_REQUEST,cIdKey ,nil];
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301301_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/

        NSLog( @"个人信息查询  %@",responseObject);
        MemberModel * demoModel = [[MemberModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 3.3.14	用户—用户话题列表查询
 * @param queryUId    要查询的用户ID
 * @param uId    用户ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301401:(NSString *)uId
          queryUId:(NSString *)queryUId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params ;
    if (uId && ![@"" isEqualToString:uId]) {
        if (queryTime && ![@"" isEqualToString:queryTime]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:CID_FOR_REQUEST,cIdKey,uId,uIdKey,queryUId,queryUIdKey,queryTime,queryTimeKey,page,pageKey,num,numKey, nil];
        } else {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:CID_FOR_REQUEST,cIdKey,uId,uIdKey,queryUId,queryUIdKey,page,pageKey,num,numKey, nil];
        }
    } else {
        if (queryTime && ![@"" isEqualToString:queryTime]) {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:CID_FOR_REQUEST,cIdKey,queryUId,queryUIdKey,queryTime,queryTimeKey,page,pageKey,num,numKey, nil];
        } else {
            params = [[NSDictionary alloc]initWithObjectsAndKeys:CID_FOR_REQUEST,cIdKey,queryUId,queryUIdKey,page,pageKey,num,numKey, nil];
        }
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301401_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        NSLog(@"个人话题查询 %@",responseObject);
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
 * 3.3.15	用户—创建社区
 * @param uId    用户ID
 * @param cId    小区ID
 * @param name    社区名称
 * @param desc    社区公告
 * @param file    文件
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301501:(NSString *)uId
               cId:(NSString *)cId
              name:(NSString *)name
              desc:(NSString *)desc
              file:(NSString *)file
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptName = [DES3Util tripleDES:name encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params;
    if (desc && ![@"" isEqualToString:desc]) {
        NSString * encryptDesc = [DES3Util tripleDES:desc encryptOrDecrypt:kCCEncrypt];
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptName,nameKey,encryptDesc,descKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptName,nameKey, nil];
    }
    
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301501_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:file] name:fileKey error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

/**
 * 3.3.16	用户—删除社区
 * @param uId    用户ID
 * @param sId    社区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301601:(NSString *)uId
               sId:(NSString *)sId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptSId = [DES3Util tripleDES:sId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptSId,sIdKey,encryptUId,uIdKey,encryptCId,@"cId", nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301601_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

/**
 * 3.3.17	用户—社区基本信息维护
 * @param uId    用户ID
 * @param sId    社区ID
 * @param name    社区名称
 * @param desc    社区公告
 * @param file    文件
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301701:(NSString *)uId
               sId:(NSString *)sId
              name:(NSString *)name
              desc:(NSString *)desc
              logo:(NSString *)logo
              flag:(NSString *)flag
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptSId = [DES3Util tripleDES:sId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptName = [DES3Util tripleDES:name encryptOrDecrypt:kCCEncrypt];
    NSString * encryptDesc = [DES3Util tripleDES:desc encryptOrDecrypt:kCCEncrypt];
    NSString * encryptFlag = [DES3Util tripleDES:flag encryptOrDecrypt:kCCEncrypt];

    // 组装入参parameters对象
    NSDictionary * params;
   
    if (desc && ![@"" isEqualToString:desc]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptSId,sIdKey,encryptUId,uIdKey,encryptName,nameKey,encryptDesc,descKey,encryptFlag,flagKey ,encryptCId,@"cId", nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptSId,sIdKey,encryptUId,uIdKey,encryptFlag,flagKey ,encryptName,nameKey,encryptCId,@"cId", nil];
    }
   
    if ([flag  integerValue]==0) {
        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301701_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
    else {
        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301701_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:logo] name:logoKey error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}


/**
 * 3.3.18	用户—新消息列表查询
 * @param uId    当前用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus302101:(NSString *)uId
               cId:(NSString *)cId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];

    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey, nil];
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus302101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
         NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [[DES3Util tripleDES:string encryptOrDecrypt:kCCDecrypt] dataUsingEncoding:NSUTF8StringEncoding];     /* Now try to deserialize the JSON object into a dictionary */
        
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];NSLog(@"ReplyListModel接口  %@",jsonObject);
        ReplyListModel * demoModel = [[ReplyListModel alloc] initWithEncryptData:responseObject error:nil];
        
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


