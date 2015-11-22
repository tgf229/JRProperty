//
//  BaseModel.m
//  JRProperty
//
//  Created by wangzheng on 14-11-7.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"
#import "DES3Util.h"

@implementation BaseModel

-(instancetype)initWithEncryptData:(NSData *)data error:(NSError *__autoreleasing *)err
{
    //turn nsdata to an nsstring
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!string) return nil;
    
    //create an instance
    JSONModelError* initError = nil;
    NSString * decodeString = [DES3Util tripleDES:string encryptOrDecrypt:kCCDecrypt];
    id objModel = [self initWithString:decodeString usingEncoding:NSUTF8StringEncoding error:&initError];
    if (initError && err) *err = initError;
    return objModel;
}

@end
