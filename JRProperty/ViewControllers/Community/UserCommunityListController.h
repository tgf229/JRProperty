//
//  CommunityListController.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/1.
//  Copyright © 2015年 YRYZY. All rights reserved.
//


#include "JRViewController.h"
#import "CommunityListCell.h"
#import "PhotosViewController.h"

@interface UserCommunityListController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,PhotosViewDatasource,PhotosViewDelegate>

@end
