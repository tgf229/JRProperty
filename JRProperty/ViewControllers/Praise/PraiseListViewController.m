//
//  PraiseListViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/11/23.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "PraiseListViewController.h"
#import "PraiseListViewCell.h"
#import "JRDefine.h"
#import "PraiseDetailViewController.h"


@interface PraiseListViewController ()
@property (strong, nonatomic) IBOutlet UIView *tView;
@property(assign,nonatomic) BOOL isIpone5;

@end

@implementation PraiseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_guanyu"]];
    UILabel *month = [[UILabel alloc] init];
    UILabel *year = [[UILabel alloc] init];
    UILabel *yue = [[UILabel alloc] init];
    
    [month setBackgroundColor:[UIColor clearColor]];
    [month setTextColor:UIColorFromRGB(0xd96e5d)];
    [month setFont:[UIFont boldSystemFontOfSize:23.0f]];

    [month setTextAlignment:NSTextAlignmentLeft];
    month.text = @"11";
    
    

    
    CGSize titleSize = [month.text sizeWithAttributes:@{NSFontAttributeName : month.font}];
    
    [month setFrame:CGRectMake(0, 0, titleSize.width,titleSize.height)];
    
    NSLog(@"%f",titleSize.height);
    
    NSLog(@"%f",titleSize.width);
    
    self.tView.frame = CGRectMake(-27.5, 10, 55, 20);

    
//    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.navigationItem.titleView.frame.size.height-titleSize.height)/2, titleSize.width, titleSize.height)];
//    
//    [tView addSubview:month];
    
    float h = self.navigationItem.titleView.frame.size.height;
    NSLog(@"%f",h);
    [self.navigationItem.titleView addSubview:self.tView];
    
//    [moneyLab setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Do any additional setup after loading the view.
    CGSize iOSDeviceScreenSize  = [UIScreen mainScreen].bounds.size;
    
    NSString *s = [NSString stringWithFormat:@"%.0f x %.0f", iOSDeviceScreenSize.width, iOSDeviceScreenSize.height];
    NSLog(@"%@", s);
    
    //    self.label.text = s;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (iOSDeviceScreenSize.height > iOSDeviceScreenSize.width) {//竖屏情况
            if (iOSDeviceScreenSize.height == 568) {//iPhone 5/5s/5c（iPod touch 5）设备
                NSLog(@"iPhone 5/5s/5c（iPod touch 5）设备");
                self.isIpone5 = YES;
            }
//            else if (iOSDeviceScreenSize.height == 667) {//iPhone 6
//                NSLog(@"iPhone 6 设备");
//                self.isIpone5 = NO;
//            } else if (iOSDeviceScreenSize.height == 736) {//iPhone 6 plus
//                NSLog(@"iPhone 6 plus 设备");
//                self.isIpone5 = NO;
//            }
            else {//iPhone4s等其它设备
                NSLog(@"iPhone4s等其它设备");
                self.isIpone5 = NO;
            }
        }
        else{
            self.isIpone5 = NO;
        }
//        if (iOSDeviceScreenSize.width > iOSDeviceScreenSize.height) {//横屏情况
//            if (iOSDeviceScreenSize.width == 568) {//iPhone 5/5s/5c（iPod touch 5）设备
//                NSLog(@"iPhone 5/5s/5c（iPod touch 5）设备");
//            } else if (iOSDeviceScreenSize.width == 667) {//iPhone 6
//                NSLog(@"iPhone 6 设备");
//            } else if (iOSDeviceScreenSize.width == 736) {//iPhone 6 plus
//                NSLog(@"iPhone 6 plus 设备");
//            } else {//iPhone4s等其它设备
//                NSLog(@"iPhone4s等其它设备");
//            }
//        }
    }else{
        self.isIpone5 = NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PraiseListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"praiseCell" forIndexPath:indexPath];
    
    //cell 背景图片设置
    UIImage *biaoyang = [UIImage imageNamed:@"biaoyang"];
    UIImageView *bgimg = [[UIImageView alloc] initWithImage:biaoyang];
    if (self.isIpone5) {
        bgimg.frame = CGRectMake(0,0,112/1.17,163/1.17);
    }
    [cell addSubview:bgimg];
    [cell sendSubviewToBack:bgimg];
    
    //表扬人数背景图片设置
    UIImage *biaoyang_greybg = [UIImage imageNamed:@"biaoyang_greybg"];
    UIImageView *backgroundimg = [[UIImageView alloc] initWithImage:biaoyang_greybg];
    [cell.backGroung addSubview:backgroundimg];
    [cell.backGroung sendSubviewToBack:backgroundimg];
    
    cell.depName.text = @"保洁部";
    cell.depNum.text = @"888888";
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}

/**
 *  点击每个cell触发操作
 *
 *  @param collectionView 集合视图 indexPath 被点击的cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //test 要删除=============
    UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"PraiseStoryboard" bundle:nil];
    
    PraiseDetailViewController *praiseDetailViewController = [storboard instantiateViewControllerWithIdentifier:@"praiseDetailViewController"];
    
//    MyWorkOrderDetailViewController *myWorkOrderDetailVC = [[MyWorkOrderDetailViewController alloc] init];
//    myWorkOrderDetailVC.title = @"我的工单";
//    myWorkOrderDetailVC.workOrderModel = (WorkOrderModel *)self.dataSourceArray[indexPath.section];
    praiseDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:praiseDetailViewController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        // Do any additional setup after loading the view.
    if (self.isIpone5) {
        return CGSizeMake(112/1.17,163/1.17);
    }
    else{
        return CGSizeMake(112, 163);
    }

}






@end
