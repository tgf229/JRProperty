//
//  MyWorkOrderDetailViewController.m
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyWorkOrderDetailViewController.h"
#import "MyWorkOrderDetailTableViewCell.h"
#import "JRDefine.h"
#import "MyWorkOrderCommentViewController.h"
#import "UIImageView+WebCache.h"
#import "PropertyService.h"
#import "WorkOrderDetailModel.h"
#import "PhotosViewController.h"
#import "NoResultView.h"
#import "SVProgressHUD.h"
#define IMAGEVIEWHEIGHT (UIScreenWidth - 44)/3

static NSString *cellIndentifier = @"MyWorkOrderDetailTableViewCellIndentifier";
@interface MyWorkOrderDetailViewController ()<MyWorkOrderDetailTableViewCellDelegate,PhotosViewDelegate,PhotosViewDatasource>

@property (strong, nonatomic) NSMutableArray *dataSourceArray;      // 数据源
@property (strong, nonatomic) NSMutableArray *imageViewArray;       // 图片数组
@property (strong, nonatomic) PropertyService * propertyService;    // 物业服务类
@property (strong, nonatomic) WorkOrderDetailModel *workOrderDetailModel;   // 工单详情Model
@property (nonatomic, strong) NoResultView * noResultView;          // 哭脸
@end

@implementation MyWorkOrderDetailViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

/**
 *  标题栏右侧按钮
 */
- (void)createPostButton {
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [postButton setFrame:CGRectMake(0, 0, 64+ 22, 24)];
    }
    else{
        [postButton setFrame:CGRectMake(0, 0,64, 20)];
    }
    
//    [postButton setTitle:@"评价服务"  forState:UIControlStateNormal];
//    [postButton setTitle:@"评价服务"  forState:UIControlStateHighlighted];
    [postButton setImage:[UIImage imageNamed:@"red_pingjiafuwu"] forState:UIControlStateNormal];
    [postButton setImage:[UIImage imageNamed:@"red_pingjiafuwu"] forState:UIControlStateHighlighted];
//    [postButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateNormal];
//    [postButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateHighlighted];
//    postButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [postButton addTarget:self action:@selector(gotoPostPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  配置信息
 */
- (void)config{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.propertyService = [[PropertyService alloc] init];
    self.imageViewArray = [[NSMutableArray alloc] init];
    _bottomView.hidden = YES;
    _footViewHeightConstraint.constant = 0.0f;
    _myWorkOrderDetailTableView.hidden = YES;
    
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
    
    _nameLabel.text = @"";
    _timeLabel.text = @"";
    _contentLabel.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_gongdanxiangqing"]];

    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    UINib *cellNib = [UINib nibWithNibName:@"MyWorkOrderDetailTableViewCell" bundle:nil];
    [_myWorkOrderDetailTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    self.prototypeCell  = [_myWorkOrderDetailTableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (CURRENT_VERSION < 7.0f) {
        _topConstraint.constant = 0.0f;
    }
    [self config];
    [self requestPropertyService];
    
}

/**
 *  工单详情请求
 */
- (void)requestPropertyService{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.propertyService Bus200301:_workOrderModel.id success:^(id responseObject) {
        if ([responseObject isKindOfClass:[WorkOrderDetailModel class]]) {
            _workOrderDetailModel = (WorkOrderDetailModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:_workOrderDetailModel.retcode]) {
                [self.dataSourceArray removeAllObjects];
                [self.dataSourceArray addObjectsFromArray:_workOrderDetailModel.path];
                if ([@"3" isEqualToString:_workOrderDetailModel.status]) {
                    [self createPostButton];
                    _bottomView.hidden = YES;
                    _footViewHeightConstraint.constant = 48.0f;
                }else{
                    _bottomView.hidden = YES;
                    _footViewHeightConstraint.constant = 0.0f;
                }
                _myWorkOrderDetailTableView.hidden = NO;
                [_myWorkOrderDetailTableView reloadData];
            }else{
                [self.noResultView initialWithTipText:_workOrderDetailModel.retinfo];
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

/**
 *  头部图片点击看大图
 *
 *  @param sender
 */
- (IBAction)myUploadImageViewSelected:(id)sender {
    [_imageViewArray removeAllObjects];
    [_imageViewArray addObjectsFromArray:_workOrderDetailModel.imageList];
    UIButton * btn = (UIButton *)sender;
    if (btn.tag > _imageViewArray.count - 1) {
        return;
    }
    PhotosViewController      *photosController = [[PhotosViewController alloc] init];
    photosController.datasource = self;
    photosController.currentPage = (int)btn.tag;
    photosController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photosController animated:YES];
}

/**
 *  评论按钮点击事件
 *
 *  @param sender
 */
- (IBAction)commentButtonSelected:(id)sender {
    MyWorkOrderCommentViewController *vc = [[MyWorkOrderCommentViewController alloc] init];
    vc.title = @"评价";
    vc.hidesBottomBarWhenPushed = YES;
    vc.workID = _workOrderModel.id;
    vc.workOrderCommentSuccessBlock = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"评价成功" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        [self requestPropertyService];
        _bottomView.hidden = YES;
        _footViewHeightConstraint.constant = 0.0f;
        self.navigationItem.rightBarButtonItem = nil;
        [self showAnimateWhenChangeConstraint];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoPostPage
{
    [self commentButtonSelected:self];
}

/**
 *  约束调整动画
 */
- (void)showAnimateWhenChangeConstraint{
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.35f animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  刷新头部数据
 */
- (void)refrashTableViewHeadViewData{
    _contentLabel.text = [NSString stringWithFormat:@"%@",_workOrderDetailModel.content];
    if (_workOrderDetailModel.imageList.count > 0) {
        if (_workOrderDetailModel.imageList.count > 3) {
            _headViewHeightConstraint.constant = IMAGEVIEWHEIGHT * 2 + 7;
            _centerViewHeightContraint.constant = IMAGEVIEWHEIGHT;
        }else{
            _headViewHeightConstraint.constant = IMAGEVIEWHEIGHT;
            _centerViewHeightContraint.constant = 0;
        }
    }else{
        _headViewHeightConstraint.constant = 0;
        _centerViewHeightContraint.constant = 0;
    }
    
    for (int i = 0; i < _workOrderDetailModel.imageList.count; i++) {
        UIImageView *imageView = (UIImageView *)_myUploadImageViewArray[i];
        WorkImageModel *imageModel = (WorkImageModel *)_workOrderDetailModel.imageList[i];
//        imageView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
//        imageView.layer.borderWidth = 1.0;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrlS] placeholderImage:[UIImage imageNamed:@"community_default"]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWorkOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.stepLabel.text = [NSString stringWithFormat:@"STEP%d",[self.dataSourceArray count]-indexPath.row];
    [cell reFrashDataWithPathModel:(WorkPathModel *)self.dataSourceArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [_headView setBackgroundColor:UIColorFromRGB(0xF8F8F8)];
    [_nameLabel setTextColor:UIColorFromRGB(0x007daf)];
    [_timeLabel setTextColor:UIColorFromRGB(0x888888)];
    [_contentLabel setTextColor:UIColorFromRGB(0x333333)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 15;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_workOrderDetailModel.image] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    _nameLabel.text = _workOrderDetailModel.uName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:_workOrderDetailModel.time];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    _timeLabel.text = strDate;
//    _contentLabel.text = _workOrderDetailModel.content;
    if ([@"1" isEqualToString:_workOrderDetailModel.type]) {
        // 保修
        _typeImageView.image = [UIImage imageNamed:@"service_icon_angle_repair"];
    }else if ([@"2" isEqualToString:_workOrderDetailModel.type]){
        // 投诉
        _typeImageView.image = [UIImage imageNamed:@"service_icon_angle_complaint"];
    }else if ([@"3" isEqualToString:_workOrderDetailModel.type]){
        // 表扬
        _typeImageView.image = [UIImage imageNamed:@"service_icon_angle_thank"];
    }else if ([@"4" isEqualToString:_workOrderDetailModel.type]){
        // 求助
        _typeImageView.image = [UIImage imageNamed:@"service_icon_angle_help"];
    }else{
        //建议
        _typeImageView.image = [UIImage imageNamed:@"service_icon_angle_suggest"];
    }
    
    
    [self refrashTableViewHeadViewData];
    if (self.dataSourceArray.count == 0) {
        _timeLineImageView.hidden = YES;
    }else{
        _timeLineImageView.hidden = NO;
    }
    
    return _headView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWorkOrderDetailTableViewCell *cell = (MyWorkOrderDetailTableViewCell *)self.prototypeCell;
    [cell reFrashDataWithPathModel:(WorkPathModel *)self.dataSourceArray[indexPath.row]];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    [self refrashTableViewHeadViewData];
    [_headView updateConstraintsIfNeeded];
    CGSize size = [_headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - MyWorkOrderDetailTableViewCellDelegate

- (void)imageViewSelectedWithIndexPath:(NSIndexPath *)indexPath selectedIndex:(int)_selectedIndex{
    WorkPathModel * workPathModel = (WorkPathModel *)self.dataSourceArray[indexPath.row];
    [_imageViewArray removeAllObjects];
    [_imageViewArray addObjectsFromArray:workPathModel.imageList];
    if (_selectedIndex > _imageViewArray.count - 1) {
        return;
    }
    PhotosViewController      *photosController = [[PhotosViewController alloc] init];
    photosController.datasource = self;
    photosController.currentPage = _selectedIndex;
    photosController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photosController animated:YES];
}

#pragma mark - PhotosViewDatasource

- (NSInteger)photosViewNumberOfCount
{
    return [_imageViewArray count];
}

- (NSString *)photosViewUrlAtIndex:(NSInteger)index
{
    WorkImageModel * workImageModel = (WorkImageModel *)[_imageViewArray objectAtIndex:index];
    return workImageModel.imageUrlL;
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
