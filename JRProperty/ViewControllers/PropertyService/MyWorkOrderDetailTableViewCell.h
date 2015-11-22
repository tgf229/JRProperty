//
//  MyWorkOrderDetailTableViewCell.h
//  JRProperty
//
//  Created by duwen on 14/11/27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderDetailModel.h"
@protocol MyWorkOrderDetailTableViewCellDelegate <NSObject>

@optional

- (void)imageViewSelectedWithIndexPath:(NSIndexPath *)indexPath selectedIndex:(int)_selectedIndex;

@end

@interface MyWorkOrderDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) id <MyWorkOrderDetailTableViewCellDelegate>delegate;
//@property (copy, nonatomic) NSString *uName;                        //
@property (strong,nonatomic)NSIndexPath *indexPath;                 // 行标示
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;    // 客服头像
@property (weak, nonatomic) IBOutlet UIImageView *stepBgImageView;  // 楼层背景图
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;            // 楼层数

@property (weak, nonatomic) IBOutlet UILabel *helpNameLabel;        // 客服名称
@property (weak, nonatomic) IBOutlet UILabel *workNameLabel;        // 客服工种
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;           // 回复内容
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLabel;       // 回复时间

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *helpImageViewArray;  // 客服回复图片数组

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpImageViewHeightConstraint;     // 图片视图高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewHeightConstraint;        // 中心线距底部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivConstraint;

/**
 *  初始化数据
 *
 *  @param pathModel 工单回复Model
 */
- (void)reFrashDataWithPathModel:(WorkPathModel *)pathModel;



@end
