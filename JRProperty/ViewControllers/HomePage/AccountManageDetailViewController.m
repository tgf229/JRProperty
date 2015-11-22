//
//  AccountManageDetailViewController.m
//  JRProperty
//
//  Created by duwen on 14/11/26.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "AccountManageDetailViewController.h"
#import "JRDefine.h"
#import "AccountManageDetailTableViewCell.h"
#import "NoResultView.h"
static NSString *cellIndentifier = @"AccountManageDetailTableViewCellIndentifier";


@interface AccountManageDetailViewController ()
{
    BOOL showAllBill;           // 是否显示所有账单标示
}
@property (nonatomic, strong) NoResultView * noResultView;  // 哭脸
@end

@implementation AccountManageDetailViewController

-(void)test
{
    MoneyModel * moneyModel = [[MoneyModel alloc] init];
    moneyModel.time = @"20151010121212";
    moneyModel.money = @"1900";
    NSArray * moneyList = [NSArray arrayWithObjects:moneyModel,moneyModel, nil];
    FeeModel * feeModel = [[FeeModel alloc] init];
    feeModel.name = @"按时接电话";
    feeModel.totalMoney = @"3300";
    feeModel.money = @"1200";
    feeModel.moneyList = moneyList;
    [self.dataSourceArray addObject:feeModel];
    [self.dataSourceArray addObject:feeModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_feiyong"]];

    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    UINib *cellNib = [UINib nibWithNibName:@"AccountManageDetailTableViewCell" bundle:nil];
    [_accountManageDetailTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    self.prototypeCell  = [_accountManageDetailTableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    self.dataSourceArray = [[NSMutableArray alloc] init];
    for (FeeModel * feeModel in _billModel.hList) {
        if ([_typeStr isEqualToString:feeModel.type]) {
            [self.dataSourceArray addObject:feeModel];
        }
    }
//    [self test];
    
    
    
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:@"很抱歉，暂无数据！"];
    if (CURRENT_VERSION<7) {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-145, UIScreenWidth, 140);
    }
    else {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-45, UIScreenWidth, 140);
    }
    [self.noResultView setHidden:YES];
    [self.view addSubview:self.noResultView];
    
    [_tableViewHeadView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [_headTitleLabel setTextColor:UIColorFromRGB(0x575757)];

    _checkButton.selected = NO;
    showAllBill = YES;
    self.noPayDataArray = [[NSMutableArray alloc] init];
    for (FeeModel *feeModel in self.dataSourceArray) {
        if ([feeModel.status intValue] < 3) {
            [self.noPayDataArray addObject:feeModel];
        }
    }
    
    [self isShowNoResultView];
}
/**
 *  显示按钮点击
 *
 *  @param sender
 */
- (IBAction)checkButtonSelected:(id)sender {
    if (_checkButton.selected) {
        // 选中
        _checkButton.selected = NO;
        // 做未选中操作 显示全部账单
        showAllBill = YES;
    }else{
        // 未选中
        _checkButton.selected = YES;
        // 做选中操作 显示未缴账单
        showAllBill = NO;
    }
    [self isShowNoResultView];
    [_accountManageDetailTableView reloadData];
}

/**
 *  展示哭脸
 */
- (void)isShowNoResultView{
    if (showAllBill) {
        if ([self.dataSourceArray count] > 0) {
            [self.noResultView setHidden:YES];
        }else{
            [self.noResultView setHidden:NO];
        }
    }else{
        if ([self.noPayDataArray count] > 0) {
            [self.noResultView setHidden:YES];
        }else{
            [self.noResultView setHidden:NO];
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return showAllBill?[self.dataSourceArray count]:[self.noPayDataArray count];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        [_tableViewHeadView setBackgroundColor:UIColorFromRGB(0xeeeeee)];
//        return _tableViewHeadView;
//    }else{
//        return nil;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountManageDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell refrashAccountManageDetailDataWithFeeModel:(FeeModel *)(showAllBill?self.dataSourceArray[indexPath.row]:self.noPayDataArray[indexPath.row])];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountManageDetailTableViewCell *cell = (AccountManageDetailTableViewCell *)self.prototypeCell;
    [cell refrashAccountManageDetailDataWithFeeModel:(FeeModel *)(showAllBill?self.dataSourceArray[indexPath.row]:self.noPayDataArray[indexPath.row])];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height > 134 ? 1 + size.height:135;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
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
