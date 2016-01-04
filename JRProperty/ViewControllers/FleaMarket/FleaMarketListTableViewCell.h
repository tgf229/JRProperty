//
//  FleaMarketListTableViewCell.h
//  JRProperty
//
//  Created by YMDQ on 15/12/16.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FleaMarketListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *prodInfo;
@property (weak, nonatomic) IBOutlet UIButton *favNum;
@property (weak, nonatomic) IBOutlet UIButton *msgNum;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end
