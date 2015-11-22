//
//  ArticleService.m
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleService.h"
#import "CommentListModel.h"
#import "ArticleListModel.h"
#import "ReplyResultModel.h"
#import "DES3Util.h"

@implementation ArticleService
{
    NSString * cIdKey;      // 小区ID
    NSString * hIdKey;      // 房屋ID
    NSString * uIdKey;      // 用户ID
    NSString * userIdKey;      // 用户ID
    NSString * sIdKey;      // 社区ID
    NSString * aIdKey;      // 话题ID
    NSString * articleIdKey;      // 话题ID
    NSString * contentKey;  // 描述
    NSString * flagKey;     // 是否包含图片
    NSString * fileKey;     // 图片数组
    NSString * typeKey;     // 类型
    NSString * pageKey;     // 当前页
    NSString * numKey ;     // 每页展示条数
    NSString * phoneTypeKey ;     // 手机类型
    NSString * queryTimeKey;     // 查询时间点
    NSString * modelKey;     // 手机型号
    NSString * replyUIdKey ;     // 被回复的uid
    NSString * replyCommentIdKey;     // 被回复的评论id
}

- (id)init
{
    if (self = [super init]) {
        cIdKey     = @"cId";
        hIdKey     = @"hId";
        uIdKey     = @"uId";
        userIdKey  = @"userId";
        sIdKey     = @"id";
        aIdKey     = @"id";
        articleIdKey=@"articleId";
        contentKey = @"content";
        flagKey    = @"flag";
        fileKey    = @"file";
        typeKey    = @"type";
        pageKey    = @"page";
        numKey     = @"num";
        phoneTypeKey     = @"phoneType";
        queryTimeKey     = @"queryTime";
        modelKey     = @"model";
        replyUIdKey = @"replyUId";
        replyCommentIdKey = @"commentId";
    }
    return self;
}


/**
 * 3.3.7	话题—发表话题
 * @param uId     用户ID
 * @param sId     社区ID
 * @param content     内容
 * @param flag     是否有图片
 * @param file     文件
 * @param phoneType     手机类型
 * @param model     手机型号
 * @param type    话题类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300701:(NSString *)uId
               sId:(NSString *)sId
           content:(NSString *)content
              flag:(NSString *)flag
              file:(NSArray  *)file
         phoneType:(NSString *)phoneType
             model:(NSString *)model
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptSId = [DES3Util tripleDES:sId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptPhoneType = [DES3Util tripleDES:phoneType encryptOrDecrypt:kCCEncrypt];
    NSString * encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    NSString * encryptFlag = [DES3Util tripleDES:flag encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    NSDictionary * params;
    if (model && ![@"" isEqualToString:model]) {
        NSString * encryptModel = [DES3Util tripleDES:model encryptOrDecrypt:kCCEncrypt];
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptSId,sIdKey,encryptUId,uIdKey,encryptPhoneType,phoneTypeKey,encryptContent,contentKey,encryptModel,modelKey,encryptType,typeKey,encryptFlag,flagKey,encryptCId,@"cId",nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptSId,sIdKey,encryptUId,uIdKey,encryptPhoneType,phoneTypeKey,encryptContent,contentKey,encryptType,typeKey,encryptFlag,flagKey,encryptCId,@"cId", nil];
    }
    
    // 判断是否有文件
    if ([@"0" isEqualToString:flag]) {
        // 发送POST请求
        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300701_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
    } else if ([@"1" isEqualToString:flag]) {
        
        [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300701_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
    }
}

/**
 * 3.3.8	话题—话题点赞&取消赞
 * @param uId     用户ID
 * @param aId     话题ID
 * @param type    标志位
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300801:(NSString *)uId
               aId:(NSString *)aId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptAId,aIdKey,encryptUId,uIdKey,encryptType,typeKey,encryptCId,@"cId", nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300801_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
 * 3.3.9	话题—话题分享
 * @param aId     话题ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus300901:(NSString *)aId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey, nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus300901_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        BaseModel * demoModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
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
 * 3.3.10	话题—话题投票
 * @param uId     用户ID
 * @param aId     话题ID
 * @param type    投票赞成or反对   反对： 0    赞成： 1
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301001:(NSString *)uId
               aId:(NSString *)aId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    // 组装入参parameters对象
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptAId,aIdKey,encryptUId,uIdKey,encryptType,typeKey,encryptCId,@"cId", nil];
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301001_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
 * 3.3.11	话题—话题评论
 * @param uId     用户ID
 * @param aId     话题ID
 * @param content 评论内容
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301101:(NSString *)uId
               aId:(NSString *)aId
          replyUId:(NSString *)replyUId
         commentId:(NSString *)commentId
           content:(NSString *)content
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    NSDictionary * params ;
    if (replyUId.length !=0) {
        NSString * encryptRUId = [DES3Util tripleDES:replyUId encryptOrDecrypt:kCCEncrypt];
        NSString * encryptCommentID = [DES3Util tripleDES:commentId encryptOrDecrypt:kCCEncrypt];
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptAId,aIdKey,encryptUId,uIdKey,encryptContent,contentKey,encryptRUId,replyUIdKey,encryptCommentID,replyCommentIdKey,encryptCId,@"cId", nil];
    }
    else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptAId,aIdKey,encryptUId,uIdKey,encryptContent,contentKey,encryptCId,@"cId", nil];
    }
    // 组装入参parameters对象
   
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301101_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //回复
        ReplyResultModel *demoModel = [[ReplyResultModel alloc]initWithEncryptData:responseObject error:nil];
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
 * 3.3.12	话题—话题评论列表查询
 * @param aId    话题ID
 * @param page   当前页
 * @param queryTime    查询时间点
 * @param num    每页展示条数
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301201:(NSString *)aId
         queryTime:(NSString *)queryTime
              page:(NSString *)page
               num:(NSString *)num
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 组装入参parameters对象
    NSDictionary * params;
    if (queryTime && ![@"" isEqualToString:queryTime]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey,queryTime,queryTimeKey,page,pageKey,num,numKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey,page,pageKey,num,numKey, nil];
    }
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"话题评论列表平  %@",responseObject);
        /*******成功返回处理逻辑**********/
        CommentListModel * demoModel = [[CommentListModel alloc] initWithDictionary:responseObject error:nil];
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
 * 3.3.18	用户—话题置顶&取消置顶&删除
 * @param uId    用户ID
 * @param sId    社区ID
 * @param aId    话题ID
 * @param type   类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301801:(NSString *)uId
               sId:(NSString *)sId
               aId:(NSString *)aId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    // 如果请求需要加密，此处对入参进行加密预处理
    // dw add V1.1 add CID
    NSString * encryptCId = [DES3Util tripleDES:CID_FOR_REQUEST encryptOrDecrypt:kCCEncrypt];
    // dw end
    NSString * encryptSId = [DES3Util tripleDES:sId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    
    // 组装入参parameters对象
    // 此处比较特殊，sId对应接口文档的key为cId，所以encryptSId对应cIdKey
    NSDictionary * params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptSId,cIdKey,encryptUId,uIdKey,encryptAId,aIdKey,encryptType,typeKey,encryptCId,@"corpId", nil];
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301801_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
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
 * 3.3.19	话题-话题详情查询
 * @param aId    话题ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus301901:(NSString *)aId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    // 组装入参parameters对象
    NSDictionary * params;
    if (uId && ![@"" isEqualToString:uId]) {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey,uId,uIdKey, nil];
    } else {
        params = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey, nil];
    }
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus301901_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /*******成功返回处理逻辑**********/
        NSLog(@"话题详情 %@",responseObject);
        ArticleDetailModel *demoModel = [[ArticleDetailModel alloc] initWithDictionary:responseObject error:nil];
        
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
 * 3.3.20	话题-话题举报
 * @param aId    话题ID
 * @param uId    用户ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus302201:(NSString *)aId
               uId:(NSString *)uId
              type:(NSString *)type
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    NSString * encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString * encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    NSDictionary * params;
    params = [[NSDictionary alloc]initWithObjectsAndKeys:encryptUId,userIdKey,encryptAId,articleIdKey,encryptType,typeKey, nil];
    
    // 发送POST请求
    [[AFHTTPRequestOperationManager manager] POST:HTTP_Bus302201_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
