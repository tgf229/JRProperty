//
//  PraisePublishViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/11/26.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface PraisePublishViewController : JRViewControllerWithBackButton<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *depUserName;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end
