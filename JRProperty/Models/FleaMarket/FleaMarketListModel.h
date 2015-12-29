//
//  FleaMarketListModel.h
//  JRProperty
//
//  Created by YMDQ on 15/12/21.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JSONModel.h"
#import "BaseModel.h"

@protocol FleaMarketModel
@end

@protocol FleaMarketImageModel
@end

@interface FleaMarketImageModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * imageUrlS     ; // 缩略图地址
@property (copy, nonatomic) NSString<Optional> * imageUrlL     ; // 大图地址
@end

@interface FleaMarketModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * uId     ; // 发布此消息的用户ID
@property (copy, nonatomic) NSString<Optional> * nickName   ; // 发布此消息的用户昵称
@property (copy, nonatomic) NSString<Optional> * imageUrl      ; // 用户头像
@property (copy, nonatomic) NSString<Optional> * time    ; // 发布此消息据当前时间
@property (copy, nonatomic) NSString<Optional> * aId     ; // 宝贝id
@property (copy, nonatomic) NSString<Optional> * content; // 宝贝内容
@property (copy, nonatomic) NSString<Optional> * flag   ; // 是否已收藏
@property (copy, nonatomic) NSString<Optional> * praiseNum ; // 收藏数量
@property (copy, nonatomic) NSString<Optional> * commentNum ; // 评论数量
@property (copy, nonatomic) NSString<Optional> * oPrice ; // 原价
@property (copy, nonatomic) NSString<Optional> * cPrice ; // 现价
@property (strong, nonatomic) NSArray<FleaMarketImageModel, Optional> * imageList; // 信息包含图片列表地址
@end

@interface FleaMarketListModel : BaseModel
@property(copy,nonatomic) NSString<Optional> * queryTime       ; //查询时间点
@property (strong, nonatomic) NSArray<FleaMarketModel, Optional> * doc;
@end
