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
#import "PraiseListService.h"
#import "PraiseListModel.h"
#import "PraiseRankingViewController.h"

#import "LoginManager.h"

#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "ButtonTestVC.h"


@interface PraiseListViewController ()
@property (strong, nonatomic) IBOutlet UIView *tView;
@property (weak, nonatomic) IBOutlet UICollectionView *praiseCollection;
//月
@property (weak, nonatomic) IBOutlet UILabel *lMonth;
//年
@property (weak, nonatomic) IBOutlet UILabel *lYear;
// 表扬剩余次数
@property (weak, nonatomic) IBOutlet UILabel *leftTimes;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

@property(strong,nonatomic) UIButton * cDateBtn;

@property(assign,nonatomic) BOOL isIphone5;
@property(assign,nonatomic) BOOL isFirst; // 是否第一次请求网关


@property(strong,nonatomic) PraiseListService * praiseListService;// 表扬服务类
@property(strong,nonatomic) NSMutableArray * dataSourceArray;// 数据源
@property(strong,nonatomic) PraiseListModel * praiseListModel;// 表扬列表模型

@property(copy,nonatomic) NSString * year; // 基准年份

@property(copy,nonatomic) NSString * cYear; // 当前年份
@property(copy,nonatomic) NSString * cMonth; // 当前月份

@property(copy,nonatomic) NSString * sdYear; // 选择年份
@property(copy,nonatomic) NSString * titleMonth; // title月份

@property(copy,nonatomic) NSString * titleYear; // title年份



@end

@implementation PraiseListViewController

-(void)config{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.praiseListService = [[PraiseListService alloc] init];
    self.year = @"2015";
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_guanyu"]];
    
    self.tView.frame = CGRectMake(-27.5, 10, 55, 20);
    
    self.cDateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,55, 20)];
//    [self.cDateBtn setImage:[UIImage imageNamed:@"home_icon_arrow_24x14"] forState:UIControlStateNormal];
    [self.tView addSubview:self.cDateBtn];
    
    [self.cDateBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.cDateBtn addTarget:self action:@selector(choseDate:) forControlEvents:UIControlEventTouchDown];
    



//    [self.navigationItem.titleView addSubview:self.cDateBtn];
    
    self.navigationItem.titleView = self.tView;
    
//    [moneyLab setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Do any additional setup after loading the view.
    CGSize iOSDeviceScreenSize  = [UIScreen mainScreen].bounds.size;
    NSString *s = [NSString stringWithFormat:@"%.0f x %.0f", iOSDeviceScreenSize.width, iOSDeviceScreenSize.height];
    NSLog(@"%@", s);
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (iOSDeviceScreenSize.height > iOSDeviceScreenSize.width) {//竖屏情况
            if (iOSDeviceScreenSize.height == 568) {//iPhone 5/5s/5c（iPod touch 5）设备
                NSLog(@"iPhone 5/5s/5c（iPod touch 5）设备");
                self.isIphone5 = YES;
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
                self.isIphone5 = NO;
            }
        }
        else{
            self.isIphone5 = NO;
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
        self.isIphone5 = NO;
    }
    
    self.isFirst = YES;
    [self config];
    [self requestPraiseList:nil];
}

/**
 * request方法
 * 请求表扬员工列表
 */
- (void) requestPraiseList:(NSString *) vTime{
    
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.praiseListService Bus200501:nil uId:uid time:vTime success:^(id responseObject)
    {
        if ([responseObject isKindOfClass:[PraiseListModel class]]) {
            self.praiseListModel = (PraiseListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:self.praiseListModel.retcode]) {
                [self.dataSourceArray removeAllObjects];
                [self.dataSourceArray addObjectsFromArray:self.praiseListModel.doc];
                
                self.leftTimes.text = self.praiseListModel.praiseTimes;
                
                if (self.isFirst) {
                    self.lMonth.text = [self.praiseListModel.currentTime substringFromIndex:4];
                    self.lYear.text = [self.praiseListModel.currentTime substringToIndex:4];
                    
                    self.cYear =[self.praiseListModel.currentTime substringToIndex:4];
                    self.cMonth = [self monthSub0:[self.praiseListModel.currentTime substringFromIndex:4]];
                    self.sdYear = self.cYear;
                    self.titleMonth = self.cMonth;
                    self.titleYear = self.cYear;
                    
                    self.isFirst = NO;
                }
                
                [self.praiseCollection reloadData];
            }else{
                NSLog(@"请求网关返回失败");
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];

}

-(NSString *) monthSub0:(NSString*)month{
    if ([@"0" isEqualToString:[month substringToIndex:1]]) {
        return [month substringFromIndex:1];
    }
    return month;
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
    [cell layoutIfNeeded];
    if (self.dataSourceArray.count > (indexPath.section*3+indexPath.item)) {
    //cell 背景图片设置
    UIImage *biaoyang = [UIImage imageNamed:@"biaoyang"];
    UIImageView *bgimg = [[UIImageView alloc] initWithImage:biaoyang];
    if (self.isIphone5) {
        bgimg.frame = CGRectMake(0,0,112/1.17,163/1.17);
    }
    [cell addSubview:bgimg];
    [cell sendSubviewToBack:bgimg];
    
    //表扬人数背景图片设置
    UIImage *biaoyang_greybg = [UIImage imageNamed:@"biaoyang_greybg"];
    UIImageView *backgroundimg = [[UIImageView alloc] initWithImage:biaoyang_greybg];
    [cell.backGroung addSubview:backgroundimg];
    [cell.backGroung sendSubviewToBack:backgroundimg];
    
    PraiseModel *praiseModel = (PraiseModel *)self.dataSourceArray[indexPath.section*3+indexPath.item];// 会有问题

    //设置头像
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:praiseModel.eImageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    //设置部门名称
    cell.depName.text = praiseModel.eDepName;
    //设置员工工号
    cell.depNum.text = praiseModel.eNum;
    //设置员工姓名
    cell.depUserName.text = praiseModel.eName;
    //设置单月被赞次数
    cell.praiseNum.text = praiseModel.praise;
        
        switch (indexPath.section*3+indexPath.item) {
            case 0:
                [cell.tipsImg setImage:[UIImage imageNamed:@"tips_one"]];
                break;
            case 1:
                [cell.tipsImg setImage:[UIImage imageNamed:@"tips_two"]];
                break;
            case 2:
                [cell.tipsImg setImage:[UIImage imageNamed:@"tips_three"]];
                break;
            default:
                [cell.tipsImg setImage:nil];
                break;
        }
    
    cell.hidden = NO;
    
    }else{
        cell.hidden = YES;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return ceil(self.dataSourceArray.count/3.0); // 向上取整
//    return 10;
}

/**
 *  点击每个cell触发操作
 *
 *  @param collectionView 集合视图 indexPath 被点击的cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //test 要删除=============
    UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"PraiseStoryboard" bundle:nil];
    //获取表扬详情vc
    PraiseDetailViewController *praiseDetailViewController = [storboard instantiateViewControllerWithIdentifier:@"praiseDetailViewController"];
    praiseDetailViewController.title = @"表扬";
    //将点击的员工信息传至下个vc中
    praiseDetailViewController.praiseModel =(PraiseModel *)self.dataSourceArray[indexPath.section*3+indexPath.item];
    praiseDetailViewController.cTime = [self.lYear.text stringByAppendingString:self.lMonth.text];
    
    
    praiseDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:praiseDetailViewController animated:YES];
    
//    ButtonTestVC * buttonTestVC = [storboard instantiateViewControllerWithIdentifier:@"buttonTestVC"];
//    buttonTestVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:buttonTestVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        // Do any additional setup after loading the view.
    if (self.isIphone5) {
        return CGSizeMake(112/1.17,163/1.17);
    }
    else{
        return CGSizeMake(112, 163);
    }

}

-(void)choseDate:(id)sender{
    
    UIAlertController * alertVc = [[UIAlertController alloc] init];
    alertVc.title = @"\n\n\n\n\n\n\n\n\n\n";
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"取消");
    }];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        
        NSInteger row0 = [self.myPickerView selectedRowInComponent:0];
        NSInteger row1 = [self.myPickerView selectedRowInComponent:1];
        
        NSInteger sdyearint = [self.year integerValue]+row0;
        self.sdYear = [NSString stringWithFormat:@"%ld",sdyearint];
        
        NSString *chMonth;
        if ([self.sdYear isEqualToString:@"2015"]) {
            chMonth = @"12";
        }else{
            chMonth = [NSString stringWithFormat:@"%ld",row1+1];
        }
        
        NSString * time = [self yearMonth2Time:self.sdYear month:chMonth];
        if (![time isEqualToString:[self yearMonth2Time:self.titleYear month:self.titleMonth]]) { // 不是当前title展示的年月
            //传参到下一个vc中
            if ([time isEqualToString:@"系统当前年月"]) {
                // 传参到praiselistvc中
            }else{
                UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"PraiseStoryboard" bundle:nil];
                PraiseRankingViewController *praiseRankingViewController = [storboard instantiateViewControllerWithIdentifier:@"praiseRankingViewController"];
                praiseRankingViewController.rankingTime = time;
                    praiseRankingViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:praiseRankingViewController animated:YES];
            }
        }
        
        NSLog(@"确定");
    }];
    //    UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
    
    if (self.cYear != nil) {
        self.sdYear = self.cYear;
    }
    
    int sdYearint = [self.sdYear intValue];
    int yearint = [self.year intValue];
    int yearrow = sdYearint-yearint;
    
    int monthrow;
    if ([self.sdYear isEqualToString:@"2015"]) {
        monthrow = 0;
    }else {
        monthrow =  [self.cMonth intValue]-1;
    }
    [self.myPickerView selectRow:yearrow inComponent:0 animated:NO];
    [self.myPickerView selectRow:monthrow inComponent:1 animated:NO];
    
    [self.myPickerView setFrame:CGRectMake(15.0, 0.0, self.myPickerView.frame.size.width, self.myPickerView.frame.size.height)];
    
    [alertVc.view addSubview:self.myPickerView];
    [alertVc addAction:cancelAction];
    [alertVc addAction:okAction];
    [self presentViewController:alertVc animated:true completion:nil];
}

-(NSString*)yearMonth2Time:(NSString*)vyear month:(NSString*)vmonth{
    if (vmonth.length<2) {
        vmonth = [@"0" stringByAppendingString:vmonth];
    }
    return [vyear stringByAppendingString:vmonth];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        int intYear = [self.year intValue];
        int intCyear = [self.cYear intValue];
        return intCyear-intYear+1;
    }else{
        if ([self.sdYear isEqualToString:@"2015"]) {
            return 1;
        }else if ([self.sdYear isEqualToString:self.cYear]){
            return [self.cMonth integerValue];
        }else{
            return 12;
        }
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) { // year
        long syear = [self.year intValue]+row;
        return [[NSString stringWithFormat:@"%ld",syear] stringByAppendingString:@"年"];
    }else{
        if ([self.sdYear isEqualToString:@"2015"]) {
            return [@"12" stringByAppendingString:@"月"];
        }else{
            long m = row+1;
            return [[NSString stringWithFormat:@"%ld",m] stringByAppendingString:@"月"];
        }
        
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSInteger row = [self.myPickerView selectedRowInComponent:0];
        long syear = [self.year intValue]+row;
        self.sdYear = [NSString stringWithFormat:@"%ld",syear];
        [self.myPickerView reloadComponent:1];
        
        if (![self.cYear isEqualToString:@"2015"]) {
            if ([self.sdYear isEqualToString:self.cYear]) {
                int monthrow;
                monthrow =  [self.cMonth intValue]-1;
                [self.myPickerView selectRow:monthrow inComponent:1 animated:NO];
            }
        }
        
    }
}





@end
