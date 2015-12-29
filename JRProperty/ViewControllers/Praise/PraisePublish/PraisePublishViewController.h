//
//  PraisePublishViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/11/26.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"
#import "PraiseListModel.h"
#import "PraiseSignListModel.h"
#import "PraiseDetailListModel.h"

@interface PraisePublishViewController : JRViewControllerWithBackButton<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *depUserName;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property(strong,nonatomic) PraiseModel * praiseModel;
@property(strong,nonatomic) NSArray<PraiseSignModel> * praiseSignArray;// 可用标签数据源
@property(strong,nonatomic) id<PassPraiseDetailModelDelegate> delegate; //


@end
