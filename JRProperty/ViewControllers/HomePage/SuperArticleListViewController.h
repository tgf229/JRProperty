//
//  SuperArticleListViewController.h
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface SuperArticleListViewController : JRViewControllerWithBackButton
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSString * formID; // 话题所属的社区ID
@property (nonatomic, strong) NSString * articleID; // 话题ID
@property (strong,nonatomic) dispatch_block_t callBackBlock;
@end
