//
//  ArticleListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol ImageModel
@end

@protocol ArticleDetailModel
@end

@interface ImageModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * imageUrlS; // 缩略图地址
@property (copy, nonatomic) NSString<Optional> * imageUrlL; // 大图地址
@end

@interface ArticleDetailModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * uId      ; // 用户ID
@property (copy, nonatomic) NSString<Optional> * nickName ; // 用户昵称
@property (copy, nonatomic) NSString<Optional> * userLevel ; // 用户等级 1 大V
@property (copy, nonatomic) NSString<Optional> * imageUrl ; // 用户头像地址
@property (copy, nonatomic) NSString<Optional> * time     ; // 话题发布时间距离当前时间
@property (copy, nonatomic) NSString<Optional> * level    ; // 话题级别
@property (copy, nonatomic) NSString<Optional> * id       ; // 话题所属的社区ID
@property (copy, nonatomic) NSString<Optional> * name     ; // 话题所属的社区名称
@property (copy, nonatomic) NSString<Optional> * articleId; // 话题ID
@property (copy, nonatomic) NSString<Optional> * content  ; // 话题内容
@property (copy, nonatomic) NSString<Optional> * isTop    ; // 话题是否置顶 0 否 1 是
@property (copy, nonatomic) NSString<Optional> * flag     ; // 是否已赞 未赞：0 已赞：1
@property (copy, nonatomic) NSString<Optional> * praiseNum; // 赞数量
@property (copy, nonatomic) NSString<Optional> * shareNum ; // 分享数量
@property (copy, nonatomic) NSString<Optional> * comment  ; // 评论数量
@property (copy, nonatomic) NSString<Optional> * type     ; // 话题类型 1 普通话题  2 投票话题
@property (copy, nonatomic) NSString<Optional> * yes      ; // 支持数量
@property (copy, nonatomic) NSString<Optional> * no       ; // 反对数量
@property (copy, nonatomic) NSString<Optional> * voteFlag ; // 是否投票 未投：0 已投赞成：1  已投反对：2
@property (strong, nonatomic) NSMutableArray<ImageModel, Optional> *imageList;
@end

@interface ArticleListModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * queryTime; // 查询时间点
@property (strong, nonatomic) NSMutableArray<ArticleDetailModel, Optional> *doc;
@end
