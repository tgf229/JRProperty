//
//  UITableViewCell+FindContainer.m
//  GoldenManager
//
//  Created by MickeySha on 14-7-15.
//  Copyright (c) 2014年 Mickey. All rights reserved.
//

#import "UITableViewCell+FindContainer.h"

@implementation UITableViewCell (FindContainer)

#pragma mark 查找cell所属的tableView
- (UITableView *)findContainingTableView
{
	UIView *tableView = self.superview;
	
	while (tableView){
        
		if ([tableView isKindOfClass:[UITableView class]]){
            
			return (UITableView *)tableView;
        }
		
		tableView = tableView.superview;
    }
	
	return nil;
}

#pragma mark 查看自身的NSIndexPath对象
- (NSIndexPath*) findSelfIndexPath{

    UITableView * tableView = [self findContainingTableView];
    return [tableView indexPathForCell:self];
}

@end
