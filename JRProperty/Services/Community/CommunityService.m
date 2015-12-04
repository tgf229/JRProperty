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
    }
    return self;
}

//话题列表查询
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

@end
