//
//  AccountManageViewController.m
//  JRProperty
//
//  Created by dw on 14/11/22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "AccountManageViewController.h"
#import "JRDefine.h"
#import <objc/runtime.h>
#import "AccountManageDetailViewController.h"
#import "FeeService.h"
#import "BillListModel.h"
#import "LoginManager.h"
#import "NoResultView.h"
#import "SVProgressHUD.h"
@interface AccountManageViewController ()
@property (strong, nonatomic) FeeService * feeService;
@property (strong, nonatomic) NSMutableArray * houseArray;
@property (strong, nonatomic) NSMutableArray * feeDetailArray;
@property (nonatomic, strong) NoResultView * noResultView;
@end

@implementation AccountManageViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

-(void)test
{
    NSMutableArray *typeArray = [[NSMutableArray alloc] init];
    for (int i = 0;i<3;i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"物业费用",@"typeName",@"1",@"type", nil];
        [typeArray addObject:dic];
    }
    //                    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
    //                    [typeArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"hId",@"金地自在城",@"hName",typeArray,@"tList", nil];
    if ([typeArray count]!=0) {
        [self.houseArray addObject:dic];
        [self.houseArray addObject:dic];
    }
}

/**
 *  配置信息
 */
- (void)config{
    self.feeService = [[FeeService alloc] init];
    self.houseArray = [[NSMutableArray alloc] init];
    self.feeDetailArray = [[NSMutableArray alloc] init];
//    [self test];
    
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];

    [self config];
    [self requestFromService];
}

/**
 *  服务器请求
 */
- (void)requestFromService{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.feeService Bus101001:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[BillListModel class]]) {
            BillListModel *billListModel = (BillListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:billListModel.retcode]) {
                [self.feeDetailArray addObjectsFromArray:billListModel.doc];
                for (BillModel *billModel in billListModel.doc) {
                    NSMutableArray *setTypeName = [[NSMutableArray alloc]init];
                    NSMutableArray *setType = [[NSMutableArray alloc] init];
                    for (FeeModel *feeModel in billModel.hList) {
                        if (![setType containsObject:feeModel.type]) {
                            [setTypeName addObject:feeModel.typeName];
                            [setType addObject:feeModel.type];
                        }
                    }
                    NSMutableArray *typeArray = [[NSMutableArray alloc] init];
                    for (int i = 0;i<setType.count;i++) {
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:setTypeName[i],@"typeName",setType[i],@"type", nil];
                        [typeArray addObject:dic];
                    }
//                    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
//                    [typeArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:billModel.hId,@"hId",billModel.hName,@"hName",typeArray,@"tList", nil];
                    if ([typeArray count]!=0) {
                        [self.houseArray addObject:dic];
                    }
                }
                [self.accountManageTableView reloadData];
                if(billListModel.doc.count == 0) {
                    [self.noResultView initialWithTipText:@"很抱歉，暂无数据！"];
                    [self.noResultView setHidden:NO];
                }
            }else{
                [self.noResultView initialWithTipText:billListModel.retinfo];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.houseArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.houseArray[section];
    return [dic[@"tList"] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _accountManageTableView.frame.size.width, 40)];
    [view setBackgroundColor:UIColorFromRGB(0xf8f8f8)];

    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
    [view addSubview:customView];
    [customView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    customView.translatesAutoresizingMaskIntoConstraints = NO;

    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView(view)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(customView,view)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[customView(==40)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(customView)]];
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:customView.frame];
//    [bgImageView setImage:[UIImage imageNamed:@"mybill_zhanghao_titbg_grey"]];
//    [customView addSubview:bgImageView];
//    bgImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgImageView)]];
//    [customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgImageView)]];
    
    NSDictionary *dic = self.houseArray[section];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLab.textColor = UIColorFromRGB(0x333333);
    titleLab.text = dic[@"hName"];
    [customView addSubview:titleLab];
    titleLab.translatesAutoresizingMaskIntoConstraints = NO;
    [customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLab)]];
    [customView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLab)]];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"accountManageTableViewIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        [cell setBackgroundView:[[UIView alloc] init]];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [accessoryButton setTag:999];
        [accessoryButton setImage:[UIImage imageNamed:@"mybill_btn_arrow"] forState:UIControlStateNormal];
        [accessoryButton setImage:[UIImage imageNamed:@"mybill_btn_arrow_press"] forState:UIControlStateHighlighted];
        [accessoryButton setImageEdgeInsets:UIEdgeInsetsMake(0, UIScreenWidth - 15 - 9, 0, 15)];
        [accessoryButton addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:accessoryButton];
        [cell.contentView bringSubviewToFront:accessoryButton];
        accessoryButton.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[accessoryButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(accessoryButton)]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[accessoryButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(accessoryButton)]];
        
        if (CURRENT_VERSION < 7.0f) {
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_grey_foot_40x1"]];
            [cell.contentView addSubview:line];
            line.translatesAutoresizingMaskIntoConstraints =  NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[line]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(==1)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
        }
        
    }
    id object = [cell.contentView viewWithTag:999];
    if ([object isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)object;
        objc_setAssociatedObject(btn, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSDictionary *dic = self.houseArray[indexPath.section];
    NSMutableArray *arr = dic[@"tList"];
    cell.textLabel.text = [(NSDictionary *)[arr objectAtIndex:indexPath.row] objectForKey:@"typeName"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12.0f;
}


- (void)cellSelected:(UIButton *)sender{
    id object = objc_getAssociatedObject(sender, "indexPath");
    if ([object isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath *indexPath = (NSIndexPath *)object;
        NSDictionary * dic = self.houseArray[indexPath.section];
        AccountManageDetailViewController *accountManageDetailVC = [[AccountManageDetailViewController alloc] init];
        NSMutableArray *arr = dic[@"tList"];
        NSDictionary * tDic = (NSDictionary *)[arr objectAtIndex:indexPath.row];
        accountManageDetailVC.title = [tDic objectForKey:@"typeName"];
        accountManageDetailVC.typeStr = [tDic objectForKey:@"type"];
        accountManageDetailVC.hidesBottomBarWhenPushed = YES;
        for (BillModel * billModel in self.feeDetailArray) {
            if ([dic[@"hId"] isEqualToString:billModel.hId]) {
                accountManageDetailVC.billModel = billModel;
                break;
            }
        }
        [self.navigationController pushViewController:accountManageDetailVC animated:YES];
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
