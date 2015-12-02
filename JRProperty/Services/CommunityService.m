//
//  CommunityService.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CommunityService.h"
#import "ArticleListModel.h"

@implementation CommunityService
{
    NSString *cIdKey;
    NSString *uIdKey;
    NSString *pageKey;
    NSString *numKey;
    NSString *queryTimeKey;
}

-(id)init
{
    if (self = [super init]) {
        cIdKey = @"cId";
        uIdKey = @"uId";
        pageKey = @"page";
        numKey = @"num";
        queryTimeKey = @"queryTime";
    }
    return self;
}

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

@end
