//
//  PraiseDetailTableViewCell.h
//  JRProperty
//
//  Created by YMDQ on 15/11/27.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UILabel *praiseSign;
@property (weak, nonatomic) IBOutlet UILabel *praiseContent;

@end
