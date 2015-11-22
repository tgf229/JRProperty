//
//  ArticleListViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  邻里  话题子视图

#import "JRViewController.h"
#import "PhotosViewController.h"
#import "ArticleTableViewCell.h"
#import "PlotSomethingNewTableViewCell.h"

@interface ArticleListViewController : JRViewController<UITableViewDataSource,UITableViewDelegate,ArticleTableViewViewDelegate,PhotosViewDatasource,PhotosViewDelegate,PlotSonethingNewTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *articleTableView; //tableview

@end
