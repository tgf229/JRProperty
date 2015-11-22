//
//  ReplyMessageViewController.h
//  JRProperty
//
//  Created by tingting zuo on 15-3-31.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"

@interface ReplyMessageViewController :JRViewControllerWithBackButton <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end
