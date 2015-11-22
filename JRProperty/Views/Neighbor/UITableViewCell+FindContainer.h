//
//  UITableViewCell+FindContainer.h
//  GoldenManager
//
//  Created by MickeySha on 14-7-15.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface UITableViewCell (FindContainer)

/**
 *  查找cell所属的tableView
 *
 *  @return cell所属的tableView
 */
- (UITableView *)findContainingTableView;


/**
 *  查看自身的NSIndexPath对象
 *
 *  @return 自身的NSIndexPath对象
 */
- (NSIndexPath*) findSelfIndexPath;

@end
