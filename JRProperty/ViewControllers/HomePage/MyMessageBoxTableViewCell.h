//
//  MyMessageBoxTableViewCell.h
//  JRProperty
//
//  Created by YMDQ on 16/1/4.
//  Copyright © 2016年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageBoxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *messageHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fleaImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageContentTrailingCons;
@property (weak, nonatomic) IBOutlet UILabel *messageFromLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageTipImage;


@end
