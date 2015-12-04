//
//  PraiseListViewCell.h
//  JRProperty
//
//  Created by YMDQ on 15/11/24.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *depName;
@property (weak, nonatomic) IBOutlet UILabel *depUserName;
@property (weak, nonatomic) IBOutlet UILabel *depNum;
@property (weak, nonatomic) IBOutlet UIView *backGroung;
@property (weak, nonatomic) IBOutlet UILabel *praiseNum;

@end
