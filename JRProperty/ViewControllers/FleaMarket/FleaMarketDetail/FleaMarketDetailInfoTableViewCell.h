//
//  FleaMarketDetailInfoTableViewCell.h
//  JRProperty
//
//  Created by YMDQ on 15/12/18.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FleaMarketDetailInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;

@end
