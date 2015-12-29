//
//  FleaMarketService.m
//  JRProperty
//
//  Created by YMDQ on 15/12/21.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "FleaMarketService.h"
#import "FleaMarketListModel.h"
#import "FleaMarketDetailModel.h"
#import "FleaMarketCommentListModel.h"

@implementation FleaMarketService

{
    NSString * cIdKey;      // 小区ID
    NSString * uIdKey;      // 房屋ID
    NSString * aIdKey;      // 宝贝id
    NSString * timeKey;     // 时间
    
    NSString * pageKey;     // 当前页
    NSString * numKey;      // 每页条数
    NSString * queryTimekey;// 查询时间
    
    NSString * typeKey; // 类型 0售卖宝贝 1 求购宝贝
    NSString * contentKey;  // 评价内容
    
    NSString * replyUidKey; // 被回复的用户id
    NSString * commentIdKey; // 被回复的评论id
    
    NSString * flagKey; // 是否包含图片
    NSString * fileKey; // 图片数组
    
    NSString * phoneTypeKey; // 手机类型 1安卓 2苹果
    NSString * modelKey; // 手机型号
    
    NSString * oPriceKey; // 原价
    NSString * cPrkceKey; // 现价
    
    NSString * showPhoneKey; // 联系方式
    NSString * queryUIdKey; // 要查询的用户id
    
    
}

- (id)init
{
    if (self = [super init]) {
        cIdKey = @"cId";
        uIdKey = @"uId";
        timeKey = @"time";
        pageKey = @"page";
        numKey = @"num";
        typeKey = @"type";
        queryTimekey = @"queryTime";
        aIdKey = @"aId";
        contentKey = @"content";
        replyUidKey = @"replyUId";
        commentIdKey = @"commentId";
        flagKey = @"flag";
        fileKey = @"file";
        phoneTypeKey = @"phoneType";
        modelKey = @"model";
        oPriceKey = @"oPrice";
        cPrkceKey = @"cPrice";
        showPhoneKey = @"showPhone";
        queryUIdKey = @"queryUId";
    }
    return self;
}

/**
 * 跳蚤市场－列表查询 v2.0
 * @param cId    小区ID
 * @param uId    用户ID
 * @param page    当前页
 * @param num    每页展示条数
 * @param type    类型0售卖宝贝1求购宝贝
 * @param queryTime    查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600101:(NSString *)uId
               cId:(NSString *)cId
              page:(NSString *)page
               num:(NSString *)num
              type:(NSString *)type
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,CID_FOR_REQUEST,cIdKey,page,pageKey,num,numKey,type,typeKey,queryTime,queryTimekey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        FleaMarketListModel * demoModel = [[FleaMarketListModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 跳蚤市场－详情查询 v2.0
 * @param uId    小区ID
 * @param aId    宝贝id
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600201:(NSString *)uId
               aId:(NSString *)aId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,aId,aIdKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        FleaMarketDetailModel * demoModel = [[FleaMarketDetailModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 跳蚤市场－评论列表查询 v2.0
 * @param aId    宝贝ID
 * @param page    当前页
 * @param num    每页展示条数
 * @param queryTime    查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600301:(NSString *)aId
              page:(NSString *)page
               num:(NSString *)num
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey,page,pageKey,num,numKey,queryTime,queryTimekey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600301_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        FleaMarketCommentListModel * demoModel = [[FleaMarketCommentListModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 跳蚤市场－评论&回复 v2.0
 * @param cId    小区ID
 * @param aId    宝贝ID
 * @param uId    用户id
 * @param replyUid    被回复对用户id
 * @param commentId    被回复的评论id
 * @param content    评论内容
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600401:(NSString *)cId
               aId:(NSString *)aId
               uId:(NSString *)uId
          replyUid:(NSString *)replyUid
         commentId:(NSString *)commentid
           content:(NSString *)content
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptAid = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptReplyUid = [DES3Util tripleDES:replyUid encryptOrDecrypt:kCCEncrypt];
    NSString * encryptCommentid = [DES3Util tripleDES:commentid encryptOrDecrypt:kCCEncrypt];
    NSString * encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptAid,aIdKey,encryptReplyUid,replyUidKey,encryptCommentid,commentIdKey,encryptContent,contentKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600401_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
        FleaMarketCommentModel * demoModel = [[FleaMarketCommentModel alloc] initWithEncryptData:responseObject error:nil];
        
        
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
 * 跳蚤市场－发布宝贝信息 v2.0
 * @param cId    小区ID
 * @param uId    用户id
 * @param content    话题内容
 * @param flag    是否包含图片
 * @param file    图片数组
 * @param phoneType    手机类型 1安卓2苹果
 * @param model    手机型号
 * @param type    信息类型 0售卖1求购
 * @param oPrice    原价
 * @param cPrice    现价
 * @param showPhone    联系方式
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600501:(NSString *)cId
               uId:(NSString *)uId
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray *)file
         phoneType:(NSString *)phoneType
             model:(NSString *)model
              type:(NSString *)type
            oPrice:(NSString *)oPrice
            cPrice:(NSString *)cPrice
         showPhone:(NSString *)showPhone
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    NSString * encryptFlag = [DES3Util tripleDES:flag encryptOrDecrypt:kCCEncrypt];
    NSString * encryptPhoneType = [DES3Util tripleDES:phoneType encryptOrDecrypt:kCCEncrypt];
    NSString * encryptModel = [DES3Util tripleDES:model encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    NSString * encryptOPrice = [DES3Util tripleDES:oPrice encryptOrDecrypt:kCCEncrypt];
    NSString * encryptCPrice = [DES3Util tripleDES:cPrice encryptOrDecrypt:kCCEncrypt];
    NSString * encryptShowPhone = [DES3Util tripleDES:showPhone encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptFlag,flagKey,encryptPhoneType,phoneTypeKey,encryptModel,modelKey,encryptContent,contentKey,encryptType,typeKey,encryptOPrice,oPriceKey,encryptCPrice,cPrkceKey,encryptShowPhone,showPhoneKey, nil];
    
    NSLog(@"%@",params);
    
//    // 判断是否有文件
//    if ([@"0" isEqualToString:flag]) {
//        // 发送POST请求
//        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600501_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            /*******成功返回处理逻辑**********/
//            
//            // 如果接口返回数据是加密的，responseObject为NSData类型
//            // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
//            // 具体逻辑已在initWithEncryptData方法中实现，此处调用此方法即可反射出实体类
//            BaseModel * demoModel = [[BaseModel alloc] initWithEncryptData:responseObject error:nil];
//            // 调用success块
//            if (success) {
//                success(demoModel);
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            /*******失败返回处理逻辑**********/
//            
//            if (failure) {
//                failure(error);
//            }
//        }];
//    } else if ([@"1" isEqualToString:flag]) {
    
        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600501_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0; i < file.count; i++) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[file objectAtIndex:i]] name:fileKey error:nil];
            }
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
//    }

    
}

/**
 * 跳蚤市场－宝贝操作接口 v2.0
 * @param cId    小区ID
 * @param aId    宝贝ID
 * @param uId    用户id
 * @param type   类型 取消收藏0 收藏1 上架2 下架3 删除4
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600601:(NSString *)cId
               aId:(NSString *)aId
               uId:(NSString *)uId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptAId,aIdKey,encryptType,typeKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600601_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

/**
 * 跳蚤市场－发布宝贝列表查询 v2.0
 * @param uId    当前用户ID
 * @param cId    小区ID
 * @param queryUid    要查询的用户id
 * @param page    当前页
 * @param num   每页展示条数
 * @param type   类型 0下架的宝贝 1上架的宝贝
 * @param queryTime   查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600701:(NSString *)uId
               cId:(NSString *)cId
          queryUid:(NSString *)queryUid//
              page:(NSString *)page
               num:(NSString *)num
              type:(NSString *)type
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,CID_FOR_REQUEST,cIdKey,page,pageKey,num,numKey,type,typeKey,queryTime,queryTimekey,queryUid,queryUIdKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600701_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        FleaMarketListModel * demoModel = [[FleaMarketListModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 跳蚤市场－收藏宝贝列表查询 v2.0
 * @param uId    当前用户ID
 * @param cId    小区ID
 * @param queryUid    要查询的用户id
 * @param page    当前页
 * @param num   每页展示条数
 * @param queryTime   查询时间点
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus600801:(NSString *)uId
               cId:(NSString *)cId
          queryUid:(NSString *)queryUid
              page:(NSString *)page
               num:(NSString *)num
         queryTime:(NSString *)queryTime
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,CID_FOR_REQUEST,cIdKey,page,pageKey,num,numKey,queryTime,queryTimekey,queryUid,queryUIdKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus600801_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        
        // 如果接口返回数据是加密的，responseObject为NSData类型
        // 需要先转换成NSString，然后进行解密处理，最后通过JSONModel方法反射出实体类
        // 如果接口返回数据不加密，responseObject为NSDictionary类型，直接通过JSONModel方法反射出实体类
        FleaMarketListModel * demoModel = [[FleaMarketListModel alloc] initWithDictionary:responseObject error:nil];
        
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
