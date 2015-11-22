//
//  NbSquareViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  邻里广场页面

#import "JRViewController.h"
#import "SquareTableViewCell.h"


@interface NbSquareViewController : JRViewController<UITableViewDataSource,UITableViewDelegate,SquareCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *squareTableView; //tableview

@end
