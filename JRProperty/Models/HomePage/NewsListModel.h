//
//  NewsListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol PlotImageModel
@end

@protocol NewsModel
@end

@interface PlotImageModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * imageUrlS; // 缩略图地址
@property (copy, nonatomic) NSString<Optional> * imageUrlL; // 大图地址
@end

@interface NewsModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * uId      ; // 用户ID
@property (copy, nonatomic) NSString<Optional> * nickName ; // 用户昵称
@property (copy, nonatomic) NSString<Optional> * imageUrl ; // 用户头像地址
@property (copy, nonatomic) NSString<Optional> * time     ; // 话题发布时间距离当前时间
@property (copy, nonatomic) NSString<Optional> * level    ; // 话题级别
@property (copy, nonatomic) NSString<Optional> * id       ; // 话题所属的社区ID
@property (copy, nonatomic) NSString<Optional> * name     ; // 话题所属的社区名称
@property (copy, nonatomic) NSString<Optional> * articleId; // 话题ID
@property (copy, nonatomic) NSString<Optional> * content  ; // 话题内容
@property (copy, nonatomic) NSString<Optional> * flag     ; // 是否已赞
@property (copy, nonatomic) NSString<Optional> * praiseNum; // 赞数量
@property (copy, nonatomic) NSString<Optional> * shareNum ; // 分享数量
@property (copy, nonatomic) NSString<Optional> * comment  ; // 评论数量
@property (copy, nonatomic) NSString<Optional> * type     ; // 话题类型
@property (copy, nonatomic) NSString<Optional> * yes      ; // 支持数量
@property (copy, nonatomic) NSString<Optional> * no       ; // 反对数量
@property (copy, nonatomic) NSString<Optional> * voteFlag ; // 是否投票
@property (strong, nonatomic) NSArray<PlotImageModel, Optional> * imageList;
// dw add V1.1
@property (copy, nonatomic) NSString<Optional> * userLevel; //  用户等级 0：普通用户 1：大V 2:超级管理员
@end

@interface NewsListModel : BaseModel
@property (strong, nonatomic) NSArray<NewsModel, Optional> * doc;
@end
