//
//  NSString+MD5HexDigest.h
//  CarFriendsCircle
//
//  Created by song_tiger on 13-5-13.
//  Copyright (c) 2013年 broadengate. All rights reserved.
// md5加密

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

@interface NSString (md5)
/*
 md5加密
 */
-(NSString *) md5HexDigest;

@end
