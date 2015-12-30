//
//  CommunityService.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CommunityService.h"
#import "ArticleListModel.h"
#import "CommentListModel.h"
#import "ReplyResultModel.h"
#import "ReplyListModel.h"
#import "DES3Util.h"

@implementation CommunityService
{
    NSString *cIdKey;
    NSString *uIdKey;
    NSString *pageKey;
    NSString *numKey;
    NSString *queryTimeKey;
    NSString *aIdKey;
    NSString *typeKey;
    NSString *contentKey;
    NSString *phoneTypeKey;
    NSString *modelKey;
    NSString *voteListKey;
    NSString *fileKey;
    NSString *voteIdKey;
    NSString *replyUIdKey;
    NSString *commentIdKey;
    NSString *queryUIdKey;
}

-(id)init
{
    if (self = [super init]) {
        cIdKey = @"cId";
        uIdKey = @"uId";
        pageKey = @"page";
        numKey = @"num";
        queryTimeKey = @"queryTime";
        aIdKey = @"aId";
        typeKey = @"type";
        contentKey = @"content";
        phoneTypeKey = @"phoneType";
        modelKey = @"model";
        voteListKey = @"voteList";
        fileKey = @"file";
        voteIdKey = @"voteId";
        replyUIdKey = @"replyUId";
        commentIdKey = @"commentId";
        queryUIdKey = @"queryUId";
    }
    return self;
}

//小区话题列表查询
-(void) Bus302301:  (NSString *)uId
              cId:  (NSString *)cId
             page:  (NSString *)page
              num:  (NSString *)num
        queryTime:  (NSString *)queryTime
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    if (queryTime && ![@"" isEqualToString:queryTime]) {
        param = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,cId,cIdKey,page,pageKey,num,numKey,queryTime,queryTimeKey, nil];
    }else{
        param = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,cId,cIdKey,page,pageKey,num,numKey, nil];
    }

    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus302301_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ArticleListModel * res = [[ArticleListModel alloc]initWithDictionary:responseObject error:nil];
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//用户话题列表查询
-(void) Bus301402:  (NSString *)cId
              uId:  (NSString *)uId
         queryUId:  (NSString *)queryUId
             page:  (NSString *)page
              num:  (NSString *)num
        queryTime:  (NSString *)queryTime
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure{
    NSDictionary *param;
    if (queryTime && ![@"" isEqualToString:queryTime]) {
        param = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey,uId,uIdKey,queryUId,queryUIdKey,page,pageKey,num,numKey,queryTime,queryTimeKey, nil];
    }else{
        param = [[NSDictionary alloc]initWithObjectsAndKeys:cId,cIdKey,uId,uIdKey,queryUId,queryUIdKey,page,pageKey,num,numKey, nil];
    }
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus301402_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ArticleListModel * res = [[ArticleListModel alloc]initWithDictionary:responseObject error:nil];
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//话题详情查询
-(void) Bus301902:  (NSString *)uId
              aId:  (NSString *)aId
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    param = [[NSDictionary alloc]initWithObjectsAndKeys:uId,uIdKey,aId,aIdKey, nil];
    
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus301902_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ArticleDetailModel * res = [[ArticleDetailModel alloc]initWithDictionary:responseObject error:nil];
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//评论列表查询
-(void) Bus301202:  (NSString *)aId
             page:  (NSString *)page
              num:  (NSString *)num
        queryTime:  (NSString *)queryTime
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    if (queryTime && ![@"" isEqualToString:queryTime]) {
        param = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey,page,pageKey,num,numKey,queryTime,queryTimeKey, nil];
    }else{
        param = [[NSDictionary alloc]initWithObjectsAndKeys:aId,aIdKey,page,pageKey,num,numKey, nil];
    }
    
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus301202_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CommentListModel *res = [[CommentListModel alloc]initWithDictionary:responseObject error:nil];
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//点赞&取消赞
-(void) Bus300802:  (NSString *)cId
              aId:  (NSString *)aId
              uId:  (NSString *)uId
             type:  (NSString *)type
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    
    NSString *encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    
    param = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptAId,aIdKey,encryptUId,uIdKey,encryptType,typeKey, nil];
    
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus300802_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BaseModel *res = [[BaseModel alloc]initWithEncryptData:responseObject error:nil];
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//发表话题
-(void) Bus300702:  (NSString *)cId
              uId:  (NSString *)uId
          content:  (NSString *)content
             flag:  (NSString *)flag
             file:  (NSArray *)file
        phoneType:  (NSString *)phoneType
            model:  (NSString *)model
             type:  (NSString *)type
         voteList:  (NSArray *)voteList
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    NSString *encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    NSString *encryptPhoneType = [DES3Util tripleDES:phoneType encryptOrDecrypt:kCCEncrypt];
    NSString *encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    
    if (!model) {
        model = @"";
    }
    NSString *encryptModel = [DES3Util tripleDES:model encryptOrDecrypt:kCCEncrypt];
    
    param = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey,encryptContent,contentKey,encryptPhoneType,phoneTypeKey,encryptModel,modelKey,encryptType,typeKey, nil];

        [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus300702_URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i=0; i< [file count]; i++) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:[file objectAtIndex:i]] name:fileKey error:nil];
            }
            for (NSString *str in voteList) {
                NSString *encryptStr = [DES3Util tripleDES:str encryptOrDecrypt:kCCEncrypt];
                NSData* data = [encryptStr dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:data name:voteListKey];
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BaseModel *res = [[BaseModel alloc]initWithEncryptData:responseObject error:nil];
            if (success) {
                success(res);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

//话题投票
-(void) Bus301002:  (NSString *)cId
              aId:  (NSString *)aId
              uId:  (NSString *)uId
           voteId:  (NSString *)voteId
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    NSString *encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptVoteId = [DES3Util tripleDES:voteId encryptOrDecrypt:kCCEncrypt];
    param = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptAId,aIdKey,encryptUId,uIdKey,encryptVoteId,voteIdKey, nil];
    
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus301002_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BaseModel *res = [[BaseModel alloc]initWithEncryptData:responseObject error:nil];
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//话题评论&回复
-(void) Bus301102:  (NSString *)cId
              aId:  (NSString *)aId
              uId:  (NSString *)uId
         replyUId:  (NSString *)replyUId
        commentId:  (NSString *)commentId
          content:  (NSString *)content
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    NSString *encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptContent = [DES3Util tripleDES:content encryptOrDecrypt:kCCEncrypt];
    if (replyUId.length != 0) {
        NSString *encryptReplyUId = [DES3Util tripleDES:replyUId encryptOrDecrypt:kCCEncrypt];
        NSString *encryptCommentId = [DES3Util tripleDES:commentId encryptOrDecrypt:kCCEncrypt];
        param = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptAId,aIdKey,encryptUId,uIdKey,encryptReplyUId,replyUIdKey,encryptCommentId,commentIdKey,encryptContent,contentKey, nil];
    }else{
        param = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptAId,aIdKey,encryptUId,uIdKey,encryptContent,contentKey, nil];
    }
    
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus301102_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ReplyResultModel *res = [[ReplyResultModel alloc]initWithEncryptData:responseObject error:nil];
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//新回复消息列表
-(void) Bus302102:  (NSString *)cId
              uId:  (NSString *)uId
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    NSString *encryptCId = [DES3Util tripleDES:cId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    param = [[NSDictionary alloc]initWithObjectsAndKeys:encryptCId,cIdKey,encryptUId,uIdKey, nil];
    
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus302102_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ReplyListModel * res = [[ReplyListModel alloc] initWithEncryptData:responseObject error:nil];

        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//举报
-(void) Bus302202:  (NSString *)aId
              uId:  (NSString *)uId
             type:  (NSString *)type
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure
{
    NSDictionary *param;
    NSString *encryptAId = [DES3Util tripleDES:aId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptUId = [DES3Util tripleDES:uId encryptOrDecrypt:kCCEncrypt];
    NSString *encryptType = [DES3Util tripleDES:type encryptOrDecrypt:kCCEncrypt];
    param = [[NSDictionary alloc]initWithObjectsAndKeys:encryptAId,aIdKey,encryptUId,uIdKey,encryptType,typeKey, nil];
    
    [[AFHTTPRequestOperationManager manager]POST:HTTP_Bus302202_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BaseModel * res = [[BaseModel alloc] initWithEncryptData:responseObject error:nil];
        
        if (success) {
            success(res);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
