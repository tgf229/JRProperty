//
//  MyFleaMarketViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/12/29.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "MyFleaMarketViewController.h"

#import "FleaMarketListTableViewCell.h"

#import "FleaMarketDetailViewController.h"

#import "FleaMarketService.h"
#import "FleaMarketListModel.h"

#import "LoginManager.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#define MOREBTN_BASE_TAG  300

@interface MyFleaMarketViewController ()

- (IBAction)sellingItemAction:(id)sender;
- (IBAction)unSellAction:(id)sender;
- (IBAction)moreAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *unSellBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sliderImgView;

@property (weak, nonatomic) IBOutlet UIButton *sellingBtn;

@property (weak, nonatomic) IBOutlet UITableView *fleaMarketListTableView;

@property (strong, nonatomic) IBOutlet UIView *shadowLayoutView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
- (IBAction)cancelShadowViewAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *upBtn;
- (IBAction)upAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
- (IBAction)downAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
- (IBAction)delAction:(id)sender;

@property(strong,nonatomic) FleaMarketService * fleaMarketService;// 跳蚤服务类
@property(strong,nonatomic) NSMutableArray * dataSourceArray;// 数据源
@property(strong,nonatomic) NSMutableArray * dataSourceArray2;// 数据源2
@property(strong,nonatomic) FleaMarketListModel * fleaMarketListModel;// 跳蚤列表模型
@property(copy,nonatomic) NSString * queryTime; // 查询时间点 只要第一次就为空 之后为第一次返回的时间
@property(copy,nonatomic) NSString * queryTime2; // 查询时间点 只要第一次就为空 之后为第一次返回的时间
@property (assign, nonatomic) NSInteger     cPage; // 当前页码
@property (assign, nonatomic) NSInteger     cPage2; // 当前页码

@property(strong,nonatomic)FleaMarketModel * fleaMarketModel; // 跳蚤信息模型

@property(nonatomic,assign) BOOL isFirstSellingReq;
@property(nonatomic,assign) BOOL isFirstUnSellReq;
@property(nonatomic,assign) NSInteger type;

@end

@implementation MyFleaMarketViewController

-(void)config{
    self.fleaMarketService = [[FleaMarketService alloc] init];
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.dataSourceArray2 = [[NSMutableArray alloc] init];
    
    self.isFirstSellingReq = YES;
    self.isFirstUnSellReq = YES;
    self.type = 1; // 0下架 1上架
    
    self.queryTime = @""; // 页码首次加载初始化为空
    self.queryTime2 = @""; // 页码首次加载初始化为空
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *uiimg = [UIImage imageNamed:@"fabudebaobei"];
    UIImageView * uiv = [[UIImageView alloc] initWithImage:uiimg];
    
//    CGSize size = CGSizeMake(320,2000);
//    CGSize labelsize = [self.titleName sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
//    UIView * tView = [[UIView alloc] initWithFrame:CGRectMake((UIScreenWidth - labelsize.width) / 2, 0, labelsize.width, 40)];
//    [tView setBackgroundColor:[UIColor clearColor]];
//    UILabel * tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelsize.width, 40)];
//    [tLabel setBackgroundColor:[UIColor clearColor]];
//    [tLabel setFont:[UIFont systemFontOfSize:20]];
//    tLabel.text = self.titleName;
//    [tView addSubview:tLabel];
    self.navigationItem.titleView = uiv;
    
    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = self.fleaMarketListTableView;
    
    [weaktb addHeaderWithCallback:^{
        switch (self.type) {
            case 1:{
                self.cPage = 1;
                break;
            }
            case 0:{
                self.cPage2 = 1;
                break;
            }
            default:
                break;
        }
        // 调用网络请求
//        self.cPage = 1;
        //        self.hasMore = YES;
        [self requestMyFleaMarketList:self.type == 1?self.cPage:self.cPage2 type:[NSString stringWithFormat:@"%ld",(long)self.type]];
        [self.fleaMarketListTableView footerBeginRefreshing];
    }];
    
    
    [weaktb addFooterWithCallback:^{
        // 调用网络请求
        //        if (self.hasMore) {
        [self requestMyFleaMarketList:self.type == 1?++self.cPage:++self.cPage2 type:[NSString stringWithFormat:@"%ld",(long)self.type]];
        //        }
    }];
    
    
    [self config];
    [self switchRequest:self.type];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void) switchRequest:(NSInteger )type{
    switch (type) {
        case 1:
            if (!self.isFirstSellingReq) {
                [self.fleaMarketListTableView reloadData];
                return;
            }else{
                self.isFirstSellingReq = NO;
            }
            break;
        case 0:
            if (!self.isFirstUnSellReq) {
                [self.fleaMarketListTableView reloadData];
                return;
            }
            else{
                self.isFirstUnSellReq = NO;
            }
            break;
        default:
            return;
            break;
    }
    [self requestMyFleaMarketList:1 type:[NSString stringWithFormat:@"%ld",(long)type]];
}

-(void)requestMyFleaMarketList:(NSInteger)page type:(NSString*)t{
    if (page == 1) {
        switch (self.type) {
            case 1:{
                self.queryTime = @"";
                break;
            }
            case 0:{
                self.queryTime2 = @"";
                break;
            }
            default:
                break;
        }
    }
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.fleaMarketService Bus600701:uid cId:nil queryUid:uid page:[NSString stringWithFormat:@"%ld",page] num:NUMBER_FOR_REQUEST type:t queryTime:self.type == 1?self.queryTime:self.queryTime2 success:^(id responseObject) {
        if ([responseObject isKindOfClass:[FleaMarketListModel class]]) {
            self.fleaMarketListModel = (FleaMarketListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:self.fleaMarketListModel.retcode]) {
                
                if (page == 1) { // 第一页请求清空数据源
                    switch ([t integerValue]) {
                        case 1:
                            [self.dataSourceArray removeAllObjects];
                            break;
                        case 0:
                            [self.dataSourceArray2 removeAllObjects];
                            break;
                        default:
                            break;
                    }
                    [self.fleaMarketListTableView headerEndRefreshing];
                    switch (self.type) {
                        case 1:{
                            self.queryTime = self.fleaMarketListModel.queryTime;
                            break;
                        }
                        case 0:{
                            self.queryTime2 = self.fleaMarketListModel.queryTime;
                            break;
                        }
                        default:
                            break;
                    }
                }
                
                [self.fleaMarketListTableView footerEndRefreshing]; // 停止底部刷新
                
                if (self.fleaMarketListModel.doc.count < 10) {  // 一页数据小于10隐藏底部
                    //                    self.hasMore = YES;
                    [self.fleaMarketListTableView setFooterHidden:YES];
                }
                
                switch ([t integerValue]) {
                    case 1:
                        [self.dataSourceArray addObjectsFromArray:self.fleaMarketListModel.doc];
                        break;
                    case 0:
                        [self.dataSourceArray2 addObjectsFromArray:self.fleaMarketListModel.doc];
                        break;
                    default:
                        break;
                }
                //                [self.dataSourceArray addObjectsFromArray:self.fleaMarketListModel.doc];
                [self.fleaMarketListTableView reloadData];
            }else{
                NSLog(@"请求网关返回失败");
            }
        }
        //         [SVProgressHUD dismiss];
        
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
    return self.type==1?[self.dataSourceArray count]:[self.dataSourceArray2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FleaMarketListTableViewCell * fleaMarketListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"fleaMarketListTableViewCell"];
    //返回cell之前 先清理干净重用的控件 删除所有子视图
    [fleaMarketListTableViewCell.imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    FleaMarketModel * fmm = self.type==1?(FleaMarketModel*)self.dataSourceArray[indexPath.row]:(FleaMarketModel*)self.dataSourceArray2[indexPath.row];
    
    //设置头像
    [fleaMarketListTableViewCell.headImage sd_setImageWithURL:[NSURL URLWithString:fmm.imageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    fleaMarketListTableViewCell.headImage.layer.masksToBounds = YES;
    fleaMarketListTableViewCell.headImage.layer.cornerRadius = 15;
    // 设置昵称
    fleaMarketListTableViewCell.nickName.text = fmm.nickName;
    fleaMarketListTableViewCell.publishTime.text = fmm.time;
    // 设置内容
    
    fleaMarketListTableViewCell.prodInfo.text = fmm.content;
    
    
    
    // 设置图片
    // 图片宽高
    CGFloat imgSize = (UIScreenWidth-100.0-6.0)/3.0;
    
    if ([fmm.imageList count] > 0) {
        CGFloat lineHeight = 3.0; // 行间距
        CGFloat trueHeight = 0.0; // 实际行间距
        UIImageView * uiv;
        for (int i = 0; i<[fmm.imageList count]; i++) {
            FleaMarketImageModel * fmim ;
            fmim = fmm.imageList[i];
            if (i < 3) {
                uiv = [[UIImageView alloc] initWithFrame:CGRectMake(trueHeight, 0.0, imgSize, imgSize)];
            }
            if (i == 3) {
                trueHeight = 0.0;
            }
            if (i >= 3) {
                uiv = [[UIImageView alloc] initWithFrame:CGRectMake(trueHeight, imgSize+lineHeight, imgSize, imgSize)];
            }
            [uiv sd_setImageWithURL:[NSURL URLWithString:fmim.imageUrlS] placeholderImage:[UIImage imageNamed:@"community_default"]];
            [fleaMarketListTableViewCell.imagesView addSubview:uiv];
            trueHeight = trueHeight + imgSize +lineHeight;
        }
        
    }
    // 设置其他数据
    if ([@"1" isEqualToString:fmm.flag]) { // 该宝贝已收藏
        [fleaMarketListTableViewCell.favNum setImage:[UIImage imageNamed:@"uesd_btn_collect_press"] forState:UIControlStateNormal];
    }else{
        [fleaMarketListTableViewCell.favNum setImage:[UIImage imageNamed:@"uesd_btn_collect"] forState:UIControlStateNormal];
    }
    [fleaMarketListTableViewCell.favNum setTitle:fmm.praiseNum forState:UIControlStateNormal];// titleLabel.text = fmm.praiseNum;
    [fleaMarketListTableViewCell.msgNum setTitle:fmm.commentNum forState:UIControlStateNormal];//.titleLabel.text = fmm.commentNum;
    
    if (fmm.cPrice == nil) {
        fleaMarketListTableViewCell.nowPrice.text = @"不要钱";
        fleaMarketListTableViewCell.oldPrice.text = @"";
    }else{
        
        fleaMarketListTableViewCell.nowPrice.text = [@"¥" stringByAppendingString:fmm.cPrice];
        if (fmm.oPrice != nil && fmm.oPrice.length > 0) {
            fleaMarketListTableViewCell.oldPrice.text = [@"¥" stringByAppendingString:fmm.oPrice];
        }
    }
    fleaMarketListTableViewCell.moreBtn.tag = MOREBTN_BASE_TAG+indexPath.row;
    
    fleaMarketListTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return fleaMarketListTableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    CGFloat upStaticHeight = 21.0+12.0+8.0+11.0; // 上部固定高度 到文字部分的固定高度
    CGFloat footStaticHeight = 15.0; // 底部固定高度
    
    //    FleaMarketModel * fmm = (FleaMarketModel*)self.dataSourceArray[indexPath.row];
    FleaMarketModel * fmm = self.type==1?(FleaMarketModel*)self.dataSourceArray[indexPath.row]:(FleaMarketModel*)self.dataSourceArray2[indexPath.row];
    // 文字高度
    CGSize size = CGSizeMake(UIScreenWidth-50-20-16,30+16);
    CGSize prodInfosize = [fmm.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //    if (prodInfosize.height != 0) {
    prodInfosize.height = prodInfosize.height+15; // 间距约束
    //    }
    // 图片高度
    CGFloat imagesViewHeight;
    if ([fmm.imageList count] == 0) {
        imagesViewHeight = 0.0+10.0; // 间距约束
    }else{
        if ([fmm.imageList count] <= 3) {
            imagesViewHeight = (UIScreenWidth-100.0-6.0)/3.0;
        }else{
            imagesViewHeight = ((UIScreenWidth-100.0-6.0)/3.0)*2+3;
        }
        imagesViewHeight = imagesViewHeight + 10;
    }
    // 其他控件固定高度
    CGFloat otherHeight = 15.0+20.0;
    return upStaticHeight+footStaticHeight+prodInfosize.height+imagesViewHeight+otherHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FleaMarketModel * fmm = self.type==1?(FleaMarketModel*)self.dataSourceArray[indexPath.row]:(FleaMarketModel*)self.dataSourceArray2[indexPath.row];
    
    //test 要删除=============
    UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"FleaMarketStoryboard" bundle:nil];
    //获取跳蚤详情vc
    FleaMarketDetailViewController *fleaMarketDetailViewController = [storboard instantiateViewControllerWithIdentifier:@"fleaMarketDetailViewController"];
    fleaMarketDetailViewController.title = @"详情";
    fleaMarketDetailViewController.aid = fmm.aId;
    fleaMarketDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fleaMarketDetailViewController animated:YES];
}




- (IBAction)sellingItemAction:(id)sender {
    self.type = 1;
    [self.sellingBtn setTitleColor:UIColorFromRGB(0xd96e5d) forState:UIControlStateNormal];
    [self.unSellBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.35f animations:^{
        //        self.saleingBtn.center;
        CGPoint point = self.sliderImgView.center;
        point.x = self.sellingBtn.center.x;
        [self.sliderImgView setCenter:point];
    }];
    
    
    [self switchRequest:self.type];
}

- (IBAction)unSellAction:(id)sender {
    [self.unSellBtn setTitleColor:UIColorFromRGB(0xd96e5d) forState:UIControlStateNormal];
    [self.sellingBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.35f animations:^{
        //        self.saleingBtn.center;
        CGPoint point = self.sliderImgView.center;
        point.x = self.unSellBtn.center.x;
        [self.sliderImgView setCenter:point];
    }];
    
    self.type = 0;
    [self switchRequest:self.type];
}


- (IBAction)moreAction:(id)sender {
    UIButton *mbn = (UIButton *)sender;
    NSInteger tg = mbn.tag;
    [self creatMoreActionView:tg]; // cell索引标志tg
}
-(void)creatMoreActionView:(NSInteger) tag{
    self.shadowLayoutView.frame = CGRectMake(0.0, 0.0, UIScreenWidth, 0);
    [UIView animateWithDuration:0.3f animations:^{
        self.shadowLayoutView.frame = CGRectMake(0.0, 0.0, UIScreenWidth, UIScreenHeight);
        [self.view addSubview:self.shadowLayoutView];
    }];
    self.shadowLayoutView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];// 设置透明
        // 设置点击事件
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShadowViewAction:)];
    [self.shadowLayoutView addGestureRecognizer:tapGesture];
    //设置按钮tag标志
    self.upBtn.tag = tag;
    self.downBtn.tag = tag;
    self.cancelBtn.tag = tag;
    self.delBtn.tag = tag;
    
    //设置按钮背景图片
    FleaMarketModel * fmm = self.type==1?(FleaMarketModel*)self.dataSourceArray[tag-MOREBTN_BASE_TAG]:(FleaMarketModel*)self.dataSourceArray2[tag-MOREBTN_BASE_TAG];
    if (self.type == 1) {
        [self.upBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn_shangjia_disable"] forState:UIControlStateNormal];
        [self.downBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn_xiajia"] forState:UIControlStateNormal];
    }
    else{
        [self.upBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn_shangjia"] forState:UIControlStateNormal];
        [self.downBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn_shangjia_disable"] forState:UIControlStateNormal];
    }
    if ([fmm.flag isEqualToString:@"1"]) {
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"pop_btn_canclecollect"] forState:UIControlStateNormal];
    }
}
- (IBAction)cancelShadowViewAction:(id)sender {
    [UIView animateWithDuration:0.35f animations:^{
        [self.shadowLayoutView removeFromSuperview];
    }];
    for (UIGestureRecognizer * g in [self.shadowLayoutView gestureRecognizers]) {
        [self.shadowLayoutView removeGestureRecognizer:g];
    }
    
}


- (IBAction)upAction:(id)sender {
    FleaMarketModel * fmm = [self returnFleaMarketModelFromButtonTag:sender];
    [self requestOperFleaBaby:fmm.aId type:@"2"];
}
- (IBAction)downAction:(id)sender {
    FleaMarketModel * fmm = [self returnFleaMarketModelFromButtonTag:sender];
    [self requestOperFleaBaby:fmm.aId type:@"3"];
}
- (IBAction)cancelAction:(id)sender {
    FleaMarketModel * fmm = [self returnFleaMarketModelFromButtonTag:sender];
    [self requestOperFleaBaby:fmm.aId type:@"0"];
}
- (IBAction)delAction:(id)sender {
    FleaMarketModel * fmm = [self returnFleaMarketModelFromButtonTag:sender];
    [self requestOperFleaBaby:fmm.aId type:@"4"];
}
-(FleaMarketModel*)returnFleaMarketModelFromButtonTag:(id)btn{
    UIButton *mbn = (UIButton *)btn;
    NSInteger tg = mbn.tag;
    FleaMarketModel * fmm = self.type==1?(FleaMarketModel*)self.dataSourceArray[tg-MOREBTN_BASE_TAG]:(FleaMarketModel*)self.dataSourceArray2[tg-MOREBTN_BASE_TAG];
    return fmm;
}
-(void)requestOperFleaBaby:(NSString*) aid type:(NSString*)type{
    [self.fleaMarketService Bus600601:nil aId:aid uId:[LoginManager shareInstance].loginAccountInfo.uId type:type success:^(id responseObject) {
        if ([responseObject isKindOfClass:[BaseModel class]]) {
            BaseModel * baseModel = (BaseModel*)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
                [self addAlertViewWithInfo:@"宝贝操作成功，您可以刷新列表查看"];
                [self cancelShadowViewAction:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"宝贝操作失败，请稍后重试"];
    }];
}

/**
 *  alert提示
 *
 *  @param str 提示内容
 */
- (void)addAlertViewWithInfo:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}
@end
