//
//  PraiseDetailViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/11/27.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "PraiseDetailViewController.h"
#import "PraiseDetailTableViewCell.h"
#import "PraisePublishViewController.h"
#import "PraiseListService.h"
#import "PraiseDetailListModel.h"
#import "PraiseSignListModel.h"

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"


@interface PraiseDetailViewController ()

@property(strong,nonatomic) PraiseListService * praiseListService;// 表扬服务类
@property(strong,nonatomic) NSMutableArray * dataSourceArray;// 数据源
@property(strong,nonatomic) NSMutableArray * dataSourceArrayPraiseSign;// 可用标签数据源
@property(strong,nonatomic) PraiseDetailListModel * praiseDetailListModel;// 表扬详情模型
@property(strong,nonatomic) PraiseSignListModel * praiseSignListModel; // 表扬标签列表
@property(strong,nonatomic) NSMutableDictionary * praiseSignDic; // 表扬标签字典
@property(copy,nonatomic) NSString * queryTime; // 查询时间点

@property (assign, nonatomic) NSInteger     cPage;                   // 页数
@property (assign, nonatomic) BOOL          hasMore;                // 更多标示

@property (weak, nonatomic) IBOutlet UIImageView *eImageUrl;
@property (weak, nonatomic) IBOutlet UILabel *eName;
@property (weak, nonatomic) IBOutlet UILabel *eDepName;
@property (weak, nonatomic) IBOutlet UILabel *eNum;
@property (weak, nonatomic) IBOutlet UILabel *top;
@property (weak, nonatomic) IBOutlet UILabel *praiseNum;
@property (weak, nonatomic) IBOutlet UIButton *praisePublishBtn;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;


- (IBAction)publishPraise:(id)sender;

@end

@implementation PraiseDetailViewController

-(void)config{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.dataSourceArrayPraiseSign = [[NSMutableArray alloc] init];
    self.praiseListService = [[PraiseListService alloc] init];
    self.praiseSignDic = [NSMutableDictionary dictionary];
    
    self.cPage = 1;
    self.hasMore = YES;
    self.queryTime = @"";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.eName.text = self.praiseModel.eName; // 员工姓名
    self.eDepName.text = self.praiseModel.eDepName; // 部门
    self.eNum.text = self.praiseModel.eNum; // 工号
    self.top.text = self.praiseModel.top; // 员工获得冠军数
    self.praiseNum.text = self.praiseModel.praise; // 员工被表扬次数
    //设置头像
    [self.eImageUrl sd_setImageWithURL:[NSURL URLWithString:self.praiseModel.eImageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    self.eImageUrl.layer.masksToBounds = YES;
    self.eImageUrl.layer.cornerRadius = 40;
    
    //设置按钮背景view
    UIImage *biaoyang_greybg = [[UIImage imageNamed:@"praise_wordbg_30x60"]  resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    
    UIImageView *backgroundimg = [[UIImageView alloc] initWithImage:biaoyang_greybg];
    [backgroundimg setFrame:CGRectMake(0.0, 0.0, UIScreenWidth, 50)];
    [self.btnBgView addSubview:backgroundimg];
    [self.btnBgView sendSubviewToBack:backgroundimg];
    
    // 设置按钮背景图片
    [self.praisePublishBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_20x20"]  resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];

    
    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = self.praiseDetailTableView;
    
    [weaktb addHeaderWithCallback:^{
        // 调用网络请求
        self.cPage = 1;
        self.hasMore = YES;
        [self requestPraiseList:self.cPage];
        [self.praiseDetailTableView footerBeginRefreshing];
    }];

    
    [weaktb addFooterWithCallback:^{
        // 调用网络请求
        if (self.hasMore) {
            [self requestPraiseList:++self.cPage];
        }
    }];
    
    [self config];
    [self requestPraiseSignList];
}


/**
 * request方法
 * 请求表扬详情列表
 */
-(void)requestPraiseList:(NSInteger) page{
    NSString *eId = self.praiseModel.eId;
    NSString *time = self.cTime;
    NSString *qTime;
    if (page == 1) {
        qTime = @"";
    }
    else{
        qTime = self.queryTime;
    }
//    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.praiseListService Bus200801:eId time:time page:[NSString stringWithFormat:@"%d",page] num:NUMBER_FOR_REQUEST queryTime:qTime success:^(id responseObject)
     {
         if ([responseObject isKindOfClass:[PraiseDetailListModel class]]) {
             self.praiseDetailListModel = (PraiseDetailListModel *)responseObject;
             if ([RETURN_CODE_SUCCESS isEqualToString:self.praiseDetailListModel.retcode]) {
                 
                 if (page == 1) { // 第一页请求清空数据源
                     [self.dataSourceArray removeAllObjects];
                     [self.praiseDetailTableView headerEndRefreshing];
                     self.queryTime = self.praiseDetailListModel.queryTime;
                 }
                 
                 [self.praiseDetailTableView footerEndRefreshing]; // 停止底部刷新
                 
                 if (self.praiseDetailListModel.doc.count < 10) {  // 一页数据小于10隐藏底部
                     self.hasMore = YES;
                     [self.praiseDetailTableView setFooterHidden:NO];
                 }
                 
                 [self.dataSourceArray addObjectsFromArray:self.praiseDetailListModel.doc];
                 [self.praiseDetailTableView reloadData];
             }else{
                 NSLog(@"请求网关返回失败");
             }
         }
//         [SVProgressHUD dismiss];
     } failure:^(NSError *error) {
         NSLog(@"请求失败");
     }];
    
}

/**
 * request方法
 * 请求表扬标签列表
 */
-(void)requestPraiseSignList{
    [self.praiseListService Bus200701:^(id responseObject)
     {
         if ([responseObject isKindOfClass:[PraiseSignListModel class]]) {
             self.praiseSignListModel = (PraiseSignListModel *)responseObject;
             if ([RETURN_CODE_SUCCESS isEqualToString:self.praiseSignListModel.retcode]) {
                 NSMutableArray * signList = [[NSMutableArray alloc] init];
                 [signList removeAllObjects];
                 [signList addObjectsFromArray:self.praiseSignListModel.doc];
                 
                 for (PraiseSignModel *praiseSign in signList) {
                     [self.praiseSignDic setObject:praiseSign forKey:praiseSign.tId];
                     if ([praiseSign.tStatus isEqualToString:@"1"]) {
                         [self.dataSourceArrayPraiseSign addObject:praiseSign];
                     }
                 }
                 [self requestPraiseList:self.cPage]; // 请求表扬详情列表
                 
             }else{
                 NSLog(@"请求网关返回失败");
             }
         }
     } failure:^(NSError *error) {
         NSLog(@"请求失败");
     }];
    
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
    PraiseDetailTableViewCell * praiseDetailTableCell = [tableView dequeueReusableCellWithIdentifier:@"praiseDetailCell"];
    
    //获取展示数据
    PraiseDetailModel * praiseDetailModel = (PraiseDetailModel*)self.dataSourceArray[indexPath.row];
    
    //设置头像
    [praiseDetailTableCell.headImg sd_setImageWithURL:[NSURL URLWithString:praiseDetailModel.imageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    praiseDetailTableCell.headImg.layer.masksToBounds = YES;
    praiseDetailTableCell.headImg.layer.cornerRadius = 15;
    
    praiseDetailTableCell.userName.text = praiseDetailModel.nickName;
    praiseDetailTableCell.publishTime.text = praiseDetailModel.time;
    praiseDetailTableCell.praiseSign.text = [self tagId2name:praiseDetailModel.tag];

    praiseDetailTableCell.praiseContent.text = praiseDetailModel.content;
    
    return praiseDetailTableCell;
    //    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取展示数据
    PraiseDetailModel * praiseDetailModel = (PraiseDetailModel*)self.dataSourceArray[indexPath.row];
    
    CGFloat tagWith = UIScreenWidth-30.0;
    UIFont *tagFont = [UIFont systemFontOfSize:15.0];
    NSString * tagContent = [self tagId2name:praiseDetailModel.tag];
    CGSize tagSize = [tagContent sizeWithFont:tagFont constrainedToSize:CGSizeMake(tagWith, 4000) lineBreakMode:NSLineBreakByWordWrapping];
   
    
    // 列寬
    CGFloat contentWidth = UIScreenWidth-30.0;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:15];
    // 該行要顯示的內容
    NSString *content = praiseDetailModel.content;
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 4000) lineBreakMode:NSLineBreakByWordWrapping];
    // 這裏返回需要的高度
    return size.height+84  + tagSize.height + 5 + 16;
//    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (IBAction)publishPraise:(id)sender {
    UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"PraiseStoryboard" bundle:nil];
    
    PraisePublishViewController *praisePublishViewController = [storboard instantiateViewControllerWithIdentifier:@"praisePublishViewController"];
    //将点击的员工信息传至下个vc中
    praisePublishViewController.praiseModel = self.praiseModel;
    praisePublishViewController.praiseSignArray = (NSArray<PraiseSignModel>*)self.dataSourceArrayPraiseSign;
    praisePublishViewController.title = @"表扬";
    praisePublishViewController.delegate = self;
    
    praisePublishViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:praisePublishViewController animated:YES];
}

-(NSString*)tagId2name:(NSString *)tag{
    // 分割tag字符串
    NSArray *array = [tag componentsSeparatedByString:@","];
    //获取tag实际name
    PraiseSignModel * ps;
    NSString * tagNames = @"";
    for (NSString *s in array) {
        tagNames = [tagNames stringByAppendingString:@"·"];
        ps = (PraiseSignModel*)[self.praiseSignDic objectForKey:s];
        tagNames = [tagNames stringByAppendingString:ps.tName];
    }
    if ([@"" isEqualToString:tagNames]) {
        return @"";
    }
    tagNames = [tagNames substringFromIndex:1];
    return tagNames;
}

-(void)passPraiseDetailModel2Show:(PraiseDetailModel *)model{
    [self.dataSourceArray insertObject:model atIndex:0];
    [self.praiseDetailTableView reloadData];
    NSInteger t = [self.praiseNum.text integerValue];
    t++;
    
    self.praiseNum.text = [NSString stringWithFormat:@"%ld",t];
}
@end
