//
//  PropertyService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PropertyService.h"
#import "WorkOrderListModel.h"
#import "WorkOrderDetailModel.h"

@implementation PropertyService
{
    NSString * cIdKey;      // 小区ID
    NSString * hIdKey;      // 房屋ID
    NSString * uIdKey;      // 用户ID
    NSString * contentKey;  // 描述
    NSString * flagKey;     // 是否包含图片
    NSString * fileKey;     // 图片数组
    NSString * typeKey;     // 类型
    NSString * pageKey;     // 当前页
    NSString * numKey ;     // 每页展示条数
    NSString * workOrderIdKey ;     // 工单ID
    NSString * levelKey ;     // 评价级别

}

- (id)init
{
    if (self = [super init]) {
        cIdKey     = @"cId";
        hIdKey     = @"hId";
        uIdKey     = @"uId";
        contentKey = @"content";
        flagKey    = @"flag";
        fileKey    = @"file";
        typeKey    = @"type";
        pageKey    = @"page";
        numKey     = @"num";
        workOrderIdKey     = @"id";
        levelKey     = @"level";
    }
    return self;
}

/**
 * 工单提交—报修&投诉&表扬
 * @param cId    小区ID
 * @param uId    用户ID
 * @param hId    房屋ID
 * @param content   描述
 * @param flag    是否包含图片
 * @param file    图片数组
 * @param type    类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200101:(NSString *)cId
               hId:(NSString *)hId
               uId:(NSString *)uId
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray  *)file
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    NSString * encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    NSString * encryptHId = [DES3Util tripleDES:hId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptFlag = [DES3Util tripleDES:flag encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptType,typeKey,encryptHId,hIdKey,encryptFlag,flagKey,encryptContent,contentKey, nil];
    
    // 判断是否有文件
    if ([@"0" isEqualToString:flag]) {
        // 发送POST请求
        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

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
    } else if ([@"1" isEqualToString:flag]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"multipart/form-data"];
        [manager POST:HTTP_Bus200101_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0; i < file.count; i++) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[file objectAtIndex:i]] name:fileKey error:nil];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

/**
 * 工单列表查询
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page   当前页
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200201:(NSString *)cId
               uId:(NSString *)uId
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptPage = [DES3Util tripleDES:page encryptOrDecrypt:kCCEncrypt];
    NSString * encryptNum = [DES3Util tripleDES:num encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptPage,pageKey,encryptNum,numKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        WorkOrderListModel * demoModel = [[WorkOrderListModel alloc] initWithEncryptData:responseObject error:nil];
        
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
 * 工单详情查询
 * @param workOrderId    工单ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200301:(NSString *)workOrderId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    NSString * encryptWorkOrderId = [DES3Util tripleDES:workOrderId encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptWorkOrderId,workOrderIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200301_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        WorkOrderDetailModel * demoModel = [[WorkOrderDetailModel alloc] initWithEncryptData:responseObject error:nil];
        
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
 * 工单评价
 * @param workOrderId      工单ID
 * @param uId    用户ID
 * @param content 评论内容
 * @param level   评价级别
 * @param flag    是否包含图片
 * @param file    图片数组
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200401:(NSString *)workOrderId
               uId:(NSString *)uId
             level:(NSString *)level
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray  *)file
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptWorkOrderId = [DES3Util tripleDES:workOrderId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptLevel = [DES3Util tripleDES:level encryptOrDecrypt:kCCEncrypt];
    NSString * encryptFlag = [DES3Util tripleDES:flag encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params;
    
    if (content && ![@"" isEqualToString:content]) {
        NSString * encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptWorkOrderId,workOrderIdKey,encryptUId,uIdKey,encryptLevel,levelKey,encryptContent,contentKey,encryptFlag,flagKey,encryptCId,@"cId", nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptWorkOrderId,workOrderIdKey,encryptUId,uIdKey,encryptLevel,levelKey,encryptFlag,flagKey,encryptCId,@"cId", nil];
    }
    // 判断是否有文件
    if ([@"0" isEqualToString:flag]) {
        // 发送POST请求
        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus200401_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

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
    } else if ([@"1" isEqualToString:flag]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"multipart/form-data"];
        [manager POST:HTTP_Bus200401_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0; i < file.count; i++) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[file objectAtIndex:i]] name:fileKey error:nil];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

@end



