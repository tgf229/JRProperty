//
//  ServiceListModel.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/22.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol ServiceItemModel
@end

@interface ServiceItemModel : JSONModel
@property (weak,nonatomic) NSString<Optional> *sId;
@property (weak,nonatomic) NSString<Optional> *sName;
@property (weak,nonatomic) NSString<Optional> *sImage;
@property (weak,nonatomic) NSString<Optional> *sUrl;
@end

@interface ServiceListModel : BaseModel
@property (strong, nonatomic) NSArray<ServiceItemModel, Optional> * doc;
@end



