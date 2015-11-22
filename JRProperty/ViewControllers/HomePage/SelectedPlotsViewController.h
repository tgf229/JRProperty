//
//  SelectedPlotsViewController.h
//  JRProperty
//
//  Created by dw on 15/3/23.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface SelectedPlotsViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)void (^buttonBlock)(NSString*  titleStr,NSString * cid,NSString * city);
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, assign) BOOL isHomePass;
@property (nonatomic, strong) NSString * cidStr;
@end
