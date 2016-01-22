//
//  PraiseRankingViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/11/25.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "PraiseRankingViewController.h"
#import "PraiseRankingTableViewCell.h"

#import "PraiseListService.h"
#import "PraiseListModel.h"

#import "LoginManager.h"

#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

#import "PraiseListViewController.h"
#import "PraiseDetailViewController.h"

@interface PraiseRankingViewController ()
@property (strong, nonatomic) IBOutlet UIView *tView;
@property (weak, nonatomic) IBOutlet UILabel *lMonth;
@property (weak, nonatomic) IBOutlet UILabel *lYear;
@property(strong,nonatomic) UIButton * cDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftPraiseTimes;
@property (weak, nonatomic) IBOutlet UITableView *rankingTable;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

@property(strong,nonatomic) PraiseListService * praiseListService;// 表扬服务类
@property(strong,nonatomic) NSMutableArray * dataSourceArray;// 数据源
@property(strong,nonatomic) PraiseListModel * praiseListModel;// 表扬列表模型


@property(copy,nonatomic) NSString * year; // 基准年份

@property(copy,nonatomic) NSString * cYear; // 系统年
@property(copy,nonatomic) NSString * cMonth; // 系统月

@property(copy,nonatomic) NSString * sdYear; // 选择年份
@property(copy,nonatomic) NSString * titleMonth; // title月份

@property(copy,nonatomic) NSString * titleYear; // title年份

@end

@implementation PraiseRankingViewController

-(void)config{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.praiseListService = [[PraiseListService alloc] init];
    self.year = @"2015";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tView.frame = CGRectMake(-27.5, 10, 55, 20);
    // Do any additional setup after loading the view.
    self.cDateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,55, 20)];
    //    [self.cDateBtn setImage:[UIImage imageNamed:@"home_icon_arrow_24x14"] forState:UIControlStateNormal];
    [self.tView addSubview:self.cDateBtn];
    
    [self.cDateBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.cDateBtn addTarget:self action:@selector(choseDate:) forControlEvents:UIControlEventTouchDown];
    
    
    //    [self.navigationItem.titleView addSubview:self.cDateBtn];
    
    self.navigationItem.titleView = self.tView;
    
    [self config];
    [self requestPraiseList:self.rankingTime];
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
                 
                 self.leftPraiseTimes.text = self.praiseListModel.praiseTimes;
                 
                     self.lMonth.text = [vTime substringFromIndex:4]; // 选中月
                     self.lYear.text = [vTime substringToIndex:4]; // 选中年
                 
                 self.cYear =[self.praiseListModel.currentTime substringToIndex:4]; // 系统年
                 self.cMonth = [self monthSub0:[self.praiseListModel.currentTime substringFromIndex:4]];  // 系统月
                 
                 
                 
                 self.titleMonth = [vTime substringFromIndex:4];
                 self.titleYear = [vTime substringToIndex:4];
                 
                 self.sdYear = self.titleYear; // 选中年
                 
                 [self.rankingTable reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PraiseRankingTableViewCell *rankingCell = [tableView dequeueReusableCellWithIdentifier:@"praiseRankingCell"];
    
    PraiseModel *praiseModel = (PraiseModel *)self.dataSourceArray[indexPath.row];// 会有问题
    
    
    rankingCell.headImg.layer.masksToBounds = YES;
    rankingCell.headImg.layer.cornerRadius = 30;
    
    [rankingCell.headImg sd_setImageWithURL:[NSURL URLWithString:praiseModel.eImageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    //设置员工姓名
    rankingCell.depUserName.text = praiseModel.eName;
    //设置单月被赞次数
    rankingCell.praiseNum.text = [praiseModel.praise stringByAppendingString:@"人表扬"];
    
    switch (indexPath.row) {
        case 0:
            [rankingCell.crownImg setImage:[UIImage imageNamed:@"praise_list_one"]];
            break;
        case 1:
            [rankingCell.crownImg setImage:[UIImage imageNamed:@"praise_list_two"]];
            break;
        case 2:
            [rankingCell.crownImg setImage:[UIImage imageNamed:@"praise_list_three"]];
            break;
        default:
            [rankingCell.crownImg setImage:nil];
            break;
    }

    
    NSLog(@"%f",rankingCell.headImg.frame.size.width);
    
//    self.portraitImgView.layer.masksToBounds = YES;
//    self.portraitImgView.layer.cornerRadius = 40;
    
    rankingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return rankingCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
            if ([time isEqualToString:[self yearMonth2Time:self.cYear month:self.cMonth]]) {
                // 传参到praiselistvc中
                UIStoryboard *praiseStoryboard = [UIStoryboard storyboardWithName:@"PraiseStoryboard" bundle:nil];
                
                PraiseListViewController *praiseListViewController = [praiseStoryboard instantiateViewControllerWithIdentifier:@"praiseListViewController"];
                
                praiseListViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:praiseListViewController animated:YES];
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
    
    if (self.titleYear != nil) {
        self.sdYear = self.titleYear;
    }
    
    int sdYearint = [self.sdYear intValue];
    int yearint = [self.year intValue];
    int yearrow = sdYearint-yearint;
    
    int monthrow;
    if ([self.sdYear isEqualToString:@"2015"]) {
        monthrow = 0;
    }else {
        monthrow =  [[self monthSub0:self.titleMonth] intValue]-1;
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
