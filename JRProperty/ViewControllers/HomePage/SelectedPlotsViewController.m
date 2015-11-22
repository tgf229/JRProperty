//
//  SelectedPlotsViewController.m
//  JRProperty
//
//  Created by dw on 15/3/23.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "SelectedPlotsViewController.h"
#import "JRDefine.h"
#import "LoginManager.h"
#import "PlotService.h"
#import "PlotListModel.h"
#import "SelectedPlotsTableViewCell.h"
#import "SVProgressHUD.h"
static NSString *cellIndentifier = @"SelectedPlotsTableViewCellIdentifier";

@interface SelectedPlotsViewController ()
@property (nonatomic, strong) PlotService * plotService;
@property (nonatomic, strong) NSMutableArray * dataSourceArray;
@end

@implementation SelectedPlotsViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_xuanzexiaoqu"]];

    UINib *cellNib = [UINib nibWithNibName:@"SelectedPlotsTableViewCell" bundle:nil];
    [self.mainTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    [self.view setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    
    self.plotService = [[PlotService alloc] init];
    NSString * uidStr = [LoginManager shareInstance].loginAccountInfo.uId;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.plotService Bus101301:self.isHomePass?uidStr:nil success:^(id responseObject) {
        PlotListModel * demoModel = (PlotListModel *)responseObject;
        if ([RETURN_CODE_SUCCESS isEqualToString:demoModel.retcode]) {
            [SVProgressHUD dismiss];
            self.dataSourceArray = [[NSMutableArray alloc] initWithArray:demoModel.doc];
            for (PlotModel * tempModel in self.dataSourceArray) {
                if ([self.isHomePass?CID_FOR_REQUEST:self.cidStr isEqualToString:tempModel.cId]) {
                    [self.dataSourceArray exchangeObjectAtIndex:0 withObjectAtIndex:[self.dataSourceArray indexOfObject:tempModel]];
                    break;
                }
            }
            [self.mainTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:demoModel.retinfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
//    PlotModel * model1 = [[PlotModel alloc] init];
//    model1.cId = @"1";
//    model1.cName = @"星雨华府";
//    model1.city = @"南京";
//    
//    PlotModel * model2 = [[PlotModel alloc] init];
//    model2.cId = @"2";
//    model2.cName = @"月安花园";
//    model2.city = @"南京";
//    
//    PlotModel * model3 = [[PlotModel alloc] init];
//    model3.cId = @"3";
//    model3.cName = @"秀水华庭";
//    model3.city = @"南京";
//    
//    PlotModel * model4 = [[PlotModel alloc] init];
//    model4.cId = @"4";
//    model4.cName = @"御墅天珠别墅";
//    model4.city = @"上海";
//    
//    PlotModel * model5 = [[PlotModel alloc] init];
//    model5.cId = @"5";
//    model5.cName = @"雨润.黄金海岸";
//    model5.city = @"常州";
//    
//    self.dataSourceArray = [[NSMutableArray alloc] initWithObjects:model1,model2,model3,model4,model5, nil];
//    
//    for (PlotModel * tempModel in self.dataSourceArray) {
//        if ([CID_FOR_REQUEST isEqualToString:tempModel.cId]) {
//            [self.dataSourceArray exchangeObjectAtIndex:0 withObjectAtIndex:[self.dataSourceArray indexOfObject:tempModel]];
//            break;
//        }
//    }
}


#pragma mark - UITableViewDataSource And UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.cidStr && ![@"" isEqualToString:self.cidStr]) {
        if (section == 0) {
            return 1;
        }
        return self.dataSourceArray.count - 1;
    } else {
        if (section == 0) {
            return 0;
        }
        return self.dataSourceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectedPlotsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PlotModel * demoModel = nil;
    if (self.cidStr && ![@"" isEqualToString:self.cidStr]) {
        if (indexPath.section == 0) {
            demoModel = (PlotModel *)[self.dataSourceArray objectAtIndex:indexPath.row];
            cell.cityNameLab.textColor =  UIColorFromRGB(0x666666);
            cell.houseNameLab.textColor = UIColorFromRGB(0x333333);
            cell.iconImageView.hidden = YES;
            cell.cityNameLab.font = cell.houseNameLab.font = [UIFont systemFontOfSize:15.0f];
            cell.line.hidden = YES;
        }else{
            demoModel = (PlotModel *)[self.dataSourceArray objectAtIndex:indexPath.row + 1];
            cell.cityNameLab.textColor = UIColorFromRGB(0x666666);
            cell.houseNameLab.textColor = UIColorFromRGB(0x333333);
            cell.iconImageView.hidden = YES;
            cell.cityNameLab.font = cell.houseNameLab.font = [UIFont systemFontOfSize:15.0f];
            
        }
    } else {
        if (indexPath.section == 0) {
//            demoModel = (PlotModel *)[self.dataSourceArray objectAtIndex:indexPath.row];
//            cell.cityNameLab.textColor =  UIColorFromRGB(0x666666);
//            cell.houseNameLab.textColor = UIColorFromRGB(0x333333);
//            cell.iconImageView.hidden = YES;
//            cell.cityNameLab.font = cell.houseNameLab.font = [UIFont systemFontOfSize:15.0f];
//            cell.line.hidden = YES;
        }else{
            demoModel = (PlotModel *)[self.dataSourceArray objectAtIndex:indexPath.row];
            cell.cityNameLab.textColor = UIColorFromRGB(0x666666);
            cell.houseNameLab.textColor = UIColorFromRGB(0x333333);
            cell.iconImageView.hidden = YES;
            cell.cityNameLab.font = cell.houseNameLab.font = [UIFont systemFontOfSize:15.0f];
            
        }
    }
    
    
    cell.cityNameLab.text = demoModel.city;
    cell.houseNameLab.text = demoModel.cName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 36)];
    
    UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_grey_top_40x1"]];
    [line setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    [view addSubview:line];
    
    UIImageView * line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_grey_foot_40x1"]];
    [line2 setFrame:CGRectMake(0, 35, self.view.bounds.size.width, 1)];
    [view addSubview:line2];

    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 17, 21)];
    [view addSubview:icon];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, tableView.frame.size.width - 100, 36)];
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    
    [titleLab setBackgroundColor:[UIColor clearColor]];
    [view addSubview:titleLab];
    
    if (section == 0) {
        [icon setImage:[UIImage imageNamed:@"icon_location"]];
        [view setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        titleLab.text = @"当前选择的小区";
        titleLab.textColor = [UIColor getColor:@"bb474d"];
    }else{
        [icon setImage:[UIImage imageNamed:@"icon_xiaoqu"]];
        [view setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        titleLab.text = @"其他小区";
        titleLab.textColor = [UIColor getColor:@"333333"];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (self.cidStr && ![@"" isEqualToString:self.cidStr]) {
            [self.dataSourceArray exchangeObjectAtIndex:0 withObjectAtIndex:indexPath.row + 1];
        } else {
            [self.dataSourceArray exchangeObjectAtIndex:0 withObjectAtIndex:indexPath.row];
        }
        [self.mainTableView reloadData];
        
        PlotModel * plotModel = (PlotModel *)[self.dataSourceArray objectAtIndex:0];
        
        if (_isHomePass) {
            if ([LoginManager shareInstance].loginAccountInfo.isLogin) {
                [[NSUserDefaults standardUserDefaults] setValue:plotModel.cId forKey:@"ucid"];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:plotModel.cId forKey:@"cid"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (self.buttonBlock)
        {
            self.buttonBlock(plotModel.cName,plotModel.cId,plotModel.city);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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

@end
