//
//  PaymentSlipViewController.m
//  JRProperty
//
//  Created by dw on 14/11/22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PaymentSlipViewController.h"
#import "JRDefine.h"
#import "FeeService.h"
#import "ChargeListModel.h"
#import "LoginManager.h"
#import "SVProgressHUD.h"
#import "NoResultView.h"
#import "PaymentSlipTableViewCell.h"
#define cellIndentifier @"PaymentSlipTableViewCellIdentifier"

@interface PaymentSlipViewController ()
@property(strong, nonatomic)FeeService *feeService;
@property (nonatomic, strong) NoResultView * noResultView;
@end

@implementation PaymentSlipViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    
    UINib *cellNib = [UINib nibWithNibName:@"PaymentSlipTableViewCell" bundle:nil];
    [_paymentSlipTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    self.prototypeCell  = [_paymentSlipTableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    self.sourceArray = [[NSMutableArray alloc] init];
    
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
//    if (CURRENT_VERSION<7) {
//        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-145, UIScreenWidth, 140);
//    }
//    else {
        self.noResultView.frame = CGRectMake(0,100, UIScreenWidth, 140);
//    }
    [self.noResultView setHidden:YES];
    [self.view addSubview:self.noResultView];
    
    self.feeService = [[FeeService alloc] init];
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.feeService Bus101101:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[ChargeListModel class]]) {
            ChargeListModel *chargeListModel = (ChargeListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:chargeListModel.retcode]) {
                [self.sourceArray addObjectsFromArray:chargeListModel.doc];
                [self.paymentSlipTableView reloadData];
                if(chargeListModel.doc.count == 0) {
                    [self.noResultView initialWithTipText:@"很抱歉，暂无数据！"];
                    [self.noResultView setHidden:NO];
                }
            }else{
                [self.noResultView initialWithTipText:chargeListModel.retinfo];
                [self.noResultView setHidden:NO];
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
        [self.noResultView setHidden:NO];
        [SVProgressHUD dismiss];
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentSlipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell refrashDataWithChargeModel:(ChargeModel *)self.sourceArray[indexPath.row]];
    if (self.sourceArray.count == indexPath.row + 1) {
        cell.maxLine.hidden = NO;
        cell.minLine.hidden = YES;
    }else{
        cell.maxLine.hidden = YES;
        cell.minLine.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

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
