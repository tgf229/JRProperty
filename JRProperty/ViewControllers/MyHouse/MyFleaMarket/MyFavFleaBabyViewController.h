//
//  MyFavFleaBabyViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/12/31.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface MyFavFleaBabyViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>
@property(copy,nonatomic) NSString *titleName;
@end
