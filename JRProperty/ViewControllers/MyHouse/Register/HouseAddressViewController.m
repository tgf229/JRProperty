//
//  HouseAddressViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HouseAddressViewController.h"
#import "MyHouseTableViewCell.h"
#import "RegisterCheckHouseViewController.h"
#import "BuildingListModel.h"
#import "HouseService.h"
#import "SVProgressHUD.h"

@interface HouseAddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic)   IBOutlet UITableView *mainTableView;
@property (strong,nonatomic) NSMutableArray *houseDataArray;
@property (strong,nonatomic) HouseService   *houseService;

@end

@implementation HouseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_xiaoquzhuzhi"]];
    self.navigationItem.titleView = iv;
    // Do any additional setup after loading the view.
    
    if(self.houseDataArray == nil)
    {
        self.houseDataArray = [[NSMutableArray alloc] init];
    }

    self.houseService = [[HouseService alloc] init];
    
    switch (self.houseNumberType) {
        case BuildingNumner: // 栋
        {
            self.plotNameLab.text = _plotsName;
            if(self.buildModel == nil)
            {
                self.buildModel = [[BuildingModel alloc] init];
            }
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
            
            [self.houseService Bus401001:self.plotsCid success:^(id responseOjb){
                // 成功
                BuildingListModel *buildingList = (BuildingListModel *)responseOjb;
                if([buildingList.retcode isEqualToString:@"000000"])
                {
                    [SVProgressHUD dismiss];
                    [self.houseDataArray addObjectsFromArray:buildingList.doc];
                    
                    [_mainTableView reloadData];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:buildingList.retinfo];
                }
                
            }failure:^(NSError *error){
                // 失败
                [SVProgressHUD showErrorWithStatus:@"查询失败，请稍后重试"];
            }];
        }
            break;
        case UnitNumber:     // 单元
            if(self.unitModel == nil)
            {
                self.unitModel = [[UnitModel alloc] init];
            }
            // dw add V1.1
            if(self.houseModel == nil)
            {
                self.houseModel = [[HouseModel alloc] init];
            }
            self.headView.hidden = YES;
            self.headViewHeightConstraint.constant = 0.0f;
            // dw end
            break;
        case RoomNumber:     // 单元
            if(self.houseModel == nil)
            {
                self.houseModel = [[HouseModel alloc] init];
            }
            break;
            
        default:
            break;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 数据

- (void)refreshHouseDataWithBuildingModel:(BuildingModel *)buildingModel
{
    if(self.buildModel == nil)
    {
        self.buildModel = [[BuildingModel alloc] init];
    }
    if(self.houseDataArray == nil)
    {
        self.houseDataArray = [[NSMutableArray alloc] init];
    }
    
    self.buildModel = buildingModel;
    [self.houseDataArray addObjectsFromArray:buildingModel.bList];
}

- (void)refreshHouseDataWithUnitModel:(BuildingModel *)buildingModel andUnitModel:(UnitModel *)unitModel
{
    if(self.buildModel == nil)
    {
        self.buildModel = [[BuildingModel alloc] init];
    }
    if(self.unitModel == nil)
    {
        self.unitModel = [[UnitModel alloc] init];
    }
    if(self.houseDataArray == nil)
    {
        self.houseDataArray = [[NSMutableArray alloc] init];
    }
    
    self.buildModel = buildingModel;
    self.unitModel = unitModel;
    [self.houseDataArray addObjectsFromArray:unitModel.dList];
}

#pragma mark - UITableViewDataSource

// dw add V1.1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.houseNumberType == UnitNumber) {
        return [_houseDataArray count];
    }
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (self.houseNumberType == UnitNumber) {
//        UnitModel * unitModel = (UnitModel *)[_houseDataArray objectAtIndex:section];
//        return unitModel.dName;
//    }
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.houseNumberType == UnitNumber) {
        return 36.0f;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 36)];
//    UIImageView * bgIV = [[UIImageView alloc] initWithFrame:view.frame];
//    UIImage * image = [[UIImage imageNamed:@"select_bg_blue_40x40"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
//    [bgIV setImage:image];
//    [view addSubview:bgIV];
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 14, 16)];
    [icon setImage:[UIImage imageNamed:@"myhome_house_select_ico_location"]];
    [view addSubview:icon];
    
    UnitModel * unitModel = (UnitModel *)[_houseDataArray objectAtIndex:section];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20 + 16 + 7, 0, 100, 36)];
    [lab setText:unitModel.dName];
    [lab setTextColor:[UIColor getColor:@"bb474d"]];
    [lab setBackgroundColor:[UIColor clearColor]];
//    [lab setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [view addSubview:lab];
    
    return view;
}
// dw end

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.houseNumberType == UnitNumber) {
        UnitModel * unitModel = (UnitModel *)[_houseDataArray objectAtIndex:section];
        return [unitModel.dList count];
    }
    return [_houseDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyHouseTableViewCellIdentifier = @"MyHouseTableViewCellIdentifier";
    MyHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHouseTableViewCellIdentifier forIndexPath:indexPath];
    if(self.houseNumberType == UnitNumber){
        cell.editButton.hidden = YES;
    }
    switch (self.houseNumberType) {
        case BuildingNumner: // 栋
        {
            BuildingModel *building = (BuildingModel *)[_houseDataArray objectAtIndex:[indexPath row]];
            cell.houseLabel.text =  building.bName;
            
            if ([indexPath row] + 1 == [_houseDataArray count]) {
                [cell updateSperatorLineLeadingConstraint:0];
            }
        }
            break;
        case UnitNumber:     // 单元
        {
//            UnitModel *unit = (UnitModel *)[_houseDataArray objectAtIndex:[indexPath row]];
//            cell.houseLabel.text =  unit.dName;
            // dw add V1.1
            UnitModel *unit = (UnitModel *)[_houseDataArray objectAtIndex:[indexPath section]];
            HouseModel *house = (HouseModel *)[unit.dList objectAtIndex:[indexPath row]];
            cell.houseLabel.text =  house.hName;
            
            // dw end
        }
            break;
        case RoomNumber:     // 房号
        {
            HouseModel *house = (HouseModel *)[_houseDataArray objectAtIndex:[indexPath row]];
            cell.houseLabel.text =  house.hName;
        }
            break;
        default:
            break;
    }
    [cell updateSperatorLineLeadingConstraint:15];
//    if ([indexPath row] + 1 == [_houseDataArray count]) {
//        [cell updateSperatorLineLeadingConstraint:0];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中效果
    [self.mainTableView deselectRowAtIndexPath:[self.mainTableView indexPathForSelectedRow] animated:YES];
    
    
    if (self.houseNumberType == UnitNumber) {
        
        // 室一级，不再向下选择，返回选择情况
//        self.houseModel = [_houseDataArray objectAtIndex:[indexPath row]];
        
        UnitModel *unit = (UnitModel *)[_houseDataArray objectAtIndex:[indexPath section]];
        HouseModel *house = (HouseModel *)[unit.dList objectAtIndex:[indexPath row]];
        
        
        if([self.navigationController.viewControllers count] > 2)
        {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:1];
            if ([viewController isKindOfClass:[RegisterCheckHouseViewController class]]) {
                RegisterCheckHouseViewController *checkHouseController = (RegisterCheckHouseViewController *)viewController;
                checkHouseController.houseNumberLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.buildModel.bName,unit.dName,house.hName];
                checkHouseController.houseModel = house;
                [self.navigationController popToViewController:checkHouseController animated:YES];
            }
        }
        
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
    HouseAddressViewController *selectHouseController = [storyboard instantiateViewControllerWithIdentifier:@"HouseAddressViewController"];
    switch (self.houseNumberType) {
        case BuildingNumner: // 栋，下一步选单元
            self.buildModel = [_houseDataArray objectAtIndex:[indexPath row]];
            selectHouseController.title = self.buildModel.bName;
            selectHouseController.houseNumberType = UnitNumber;
            [selectHouseController refreshHouseDataWithBuildingModel:self.buildModel];// 单元列表
            break;
        case UnitNumber:     // 单元，下一步选室
            self.unitModel = [_houseDataArray objectAtIndex:[indexPath row]];
            selectHouseController.title = self.unitModel.dName;
            selectHouseController.houseNumberType = RoomNumber;
            [selectHouseController refreshHouseDataWithUnitModel:self.buildModel andUnitModel:self.unitModel];// 单元列表
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:selectHouseController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
