//
//  HelpInfoForHouseOwnerViewController.m
//  JRProperty
//
//  Created by duwen on 14/11/18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HelpInfoForHouseOwnerViewController.h"
#import "AppDelegate.h"
#import "JRDefine.h"
#import "HelpInfoForHouseOwnerViewTableViewCell.h"
#import "HelpInfoService.h"
#import "HelpInfoListModel.h"
#import "SVProgressHUD.h"
#import "NoResultView.h"
static NSString *cellIndentifier = @"HelpInfoForHouseOwnerViewTableViewCellIndentifier";

@interface HelpInfoForHouseOwnerViewController ()
@property (strong, nonatomic)HelpInfoService *helpInfoService;  // 便民信息服务类
@property (nonatomic, strong) NoResultView * noResultView;      // 哭脸
@end

@implementation HelpInfoForHouseOwnerViewController

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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_bianming"]];

    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    UINib *cellNib = [UINib nibWithNibName:@"HelpInfoForHouseOwnerViewTableViewCell" bundle:nil];
    [self.helpInfoTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    self.prototypeCell  = [self.helpInfoTableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    self.sourceArray = [[NSMutableArray alloc] init];
    self.helpInfoService = [[HelpInfoService alloc] init];
    
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-145, UIScreenWidth, 140);
    }
    else {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-45, UIScreenWidth, 140);
    }
    [self.noResultView setHidden:YES];
    [self.view addSubview:self.noResultView];
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.helpInfoService Bus100801:CID_FOR_REQUEST success:^(id responseObject) {
        if ([responseObject isKindOfClass:[HelpInfoListModel class]]) {
             HelpInfoListModel *helpInfoListModel = (HelpInfoListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:helpInfoListModel.retcode]) {
                [self.sourceArray addObjectsFromArray:helpInfoListModel.doc];
                [self.helpInfoTableView reloadData];
                if(helpInfoListModel.doc.count == 0) {
                    [self.noResultView initialWithTipText:@"暂无便民信息"];
                    [self.noResultView setHidden:NO];
                }
            }else{
                [self.noResultView initialWithTipText:helpInfoListModel.retinfo];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpInfoForHouseOwnerViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.plotPhoneButton.tag = indexPath.row;
    [cell.plotPhoneButton addTarget:self action:@selector(callButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cell refrashDataWithHelpInfoModel:self.sourceArray[indexPath.row]];
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    } else {
        cell.topLine.hidden = YES;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpInfoForHouseOwnerViewTableViewCell * cell = (HelpInfoForHouseOwnerViewTableViewCell *)self.prototypeCell;
    [cell refrashDataWithHelpInfoModel:self.sourceArray[indexPath.row]];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height > 100.0f?size.height + 1:100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)callButtonSelected:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        HelpInfoModel *helpInfoModel = self.sourceArray[btn.tag];
        NSString *telStr = [helpInfoModel.tel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([@"" isEqualToString:telStr]||telStr==nil) {
            [SVProgressHUD showErrorWithStatus:@"暂无号码信息"];
            return;
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
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
