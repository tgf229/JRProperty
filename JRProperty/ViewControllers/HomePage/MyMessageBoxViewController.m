//
//  MyMessageBoxViewController.m
//  JRProperty
//
//  Created by YMDQ on 16/1/4.
//  Copyright © 2016年 YRYZY. All rights reserved.
//

#import "MyMessageBoxViewController.h"
#import "MessageDataManager.h"
#import "LoginManager.h"
#import "MyMessageBoxService.h"

#import "MyMessageBoxTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "FleaMarketDetailViewController.h"

@interface MyMessageBoxViewController ()
@property(strong,nonatomic) NSMutableArray * dataSourceArray; // 数据源
@property (weak, nonatomic) IBOutlet UITableView *myMessageBoxTableView;

@property(strong,nonatomic) MyMessageBoxService * myMessageBoxService;

@end

@implementation MyMessageBoxViewController

-(void)config{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.myMessageBoxService = [[MyMessageBoxService alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *uiimg = [UIImage imageNamed:@"title_wodexiaoxi"];
    UIImageView * uiv = [[UIImageView alloc] initWithImage:uiimg];
    
    self.navigationItem.titleView = uiv;

    
    [self config];
    [self setRightBarButtonItem];
//    [self requestMyMessageBoxFromDatabase];
    [self requestMyMesssageBox];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)requestMyMessageBoxFromDatabase{
                       
    NSMutableArray * unReadMessages = [[MessageDataManager defaultManager] queryMyMessageBox:[LoginManager shareInstance].loginAccountInfo.uId isRead:@"0" type:@"1,2"];
    NSMutableArray * readMessages = [[MessageDataManager defaultManager] queryMyMessageBox:[LoginManager shareInstance].loginAccountInfo.uId isRead:@"1" type:@"1,2"];
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:unReadMessages];
    [self.dataSourceArray addObjectsFromArray:readMessages];
    [self.myMessageBoxTableView reloadData];
}

/**
 *  我的消息查询 v2.0
 */
- (void)requestMyMesssageBox{
    [self.myMessageBoxService Bus100702:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[MyMessageBoxListModel class]]) {
            MyMessageBoxListModel *myMessageBoxListModel = (MyMessageBoxListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:myMessageBoxListModel.retcode]) {
                NSString *userId = [LoginManager shareInstance].loginAccountInfo.uId;
                [[MessageDataManager defaultManager] insertMessageBox:myMessageBoxListModel userId:userId];
                int num = [[MessageDataManager defaultManager] queryMyUnReadMessageBox:userId];
                NSString *numStr = [NSString stringWithFormat:@"%d",num];
                [self requestMyMessageBoxFromDatabase];
                //之后的视图操作 大兔兔 继续
//                _headViewMyMessageNumLabel.text = numStr;
//                if (num != 0) {
//                    _headViewMyMessageButtonView.hidden = NO;
//                }else{
//                    _headViewMyMessageButtonView.hidden = YES;
//                }
            }
//            if (!_baseModel) {
//                _baseModel = [[BaseModel alloc] init];
//            }
//            _baseModel.retcode = myMessageBoxListModel.retcode;
//            _baseModel.retinfo = myMessageBoxListModel.retinfo;
        }
//        _isHomeMessageRequestSuccess = YES;
    } failure:^(NSError *error) {
//        _isHomeMessageRequestSuccess = YES;
//        if (!_baseModel) {
//            _baseModel = [[BaseModel alloc] init];
//        }
//        _baseModel.retcode = @"000001";
//        _baseModel.retinfo = OTHER_ERROR_MESSAGE;
    }];
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
    MyMessageBoxTableViewCell * myMessageBoxTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"myMessageBoxTableViewCell"];
    //初始化表格cell控件元素
    myMessageBoxTableViewCell.messageFromLabel.text = @"";
    [myMessageBoxTableViewCell.fleaImage setImage:nil];
    myMessageBoxTableViewCell.messageContentTrailingCons.constant = 77.0;
    
    MyMessageBoxModel * myMessageBoxModel = (MyMessageBoxModel *)self.dataSourceArray[indexPath.row];
    // 设置图标
    UIImage * image;
    switch ([myMessageBoxModel.type integerValue]) {
        case 1:{ // 物业消息
            image = [UIImage imageNamed:@"message_ico_wuye"];
            myMessageBoxTableViewCell.messageContentLabel.numberOfLines = 0;
            myMessageBoxTableViewCell.messageContentLabel.text = myMessageBoxModel.content;
            myMessageBoxTableViewCell.messageContentTrailingCons.constant = 10.0;
            myMessageBoxTableViewCell.messageFromLabel.text = [@"来自" stringByAppendingString:myMessageBoxModel.cName];
            break;
        }
        case 2:{ // 跳蚤消息
            image = [UIImage imageNamed:@"message_ico_market"];
            if ((nil != myMessageBoxModel.imageUrl) && ![@"" isEqualToString:myMessageBoxModel.imageUrl]) {
                [myMessageBoxTableViewCell.fleaImage sd_setImageWithURL:[NSURL URLWithString:myMessageBoxModel.imageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
            }
            myMessageBoxTableViewCell.messageContentLabel.numberOfLines = 2;
            myMessageBoxTableViewCell.messageContentLabel.text = myMessageBoxModel.replyContent;
            break;
        }
        default:
            break;
    }
    [myMessageBoxTableViewCell.messageHeadImage setImage:image];
    // 设置时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:myMessageBoxModel.time];
    [dateFormatter setDateFormat:@"yy.MM.dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    myMessageBoxTableViewCell.messageTimeLabel.text = strDate;
    // 设置消息未读状态标示
    if ([@"0" isEqualToString:myMessageBoxModel.isRead]) {
        [myMessageBoxTableViewCell.messageTipImage setImage:[UIImage imageNamed:@"message_point_red"]];
    }else{
        [myMessageBoxTableViewCell.messageTipImage setImage:nil];
    }
    
    return myMessageBoxTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat upHeight = 19.0;
    CGFloat downHeight = 19.0;
    // 图片高度
    CGFloat imageHeight = 0.0;
    // 文字高度
    CGFloat contentHeight = 0.0;
    MyMessageBoxModel * myMessageBoxModel = (MyMessageBoxModel *)self.dataSourceArray[indexPath.row];
    
    if (nil != myMessageBoxModel.imageUrl && [@"" isEqualToString:myMessageBoxModel.imageUrl]) {
        imageHeight = 60.0;
    }
    else{
        // 文字高度
        CGSize size;
        switch ([myMessageBoxModel.type integerValue]) {
            case 2:{ // 跳蚤信息
                if (UIScreenWidth >= 414) {
                    size = CGSizeMake(UIScreenWidth-15-10-57-16,28.0+16.0);  // 两行
                }else{
                    size = CGSizeMake(UIScreenWidth-15-10-38-16,28.0+16.0);
                }
            }
            case 1:{ // 物业信息
                if (UIScreenWidth >= 414) {
                    size = CGSizeMake(UIScreenWidth-15-10-57-16,4000.0); // 不限
                }else{
                    size = CGSizeMake(UIScreenWidth-15-10-38-16,4000.0);
                }
            }
            default:
                break;
        }
        CGSize prodInfosize = [myMessageBoxModel.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        contentHeight = prodInfosize.height+10.0+12.0;
    }
    return upHeight+downHeight+imageHeight+contentHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageBoxModel * myMessageBoxModel = (MyMessageBoxModel *)self.dataSourceArray[indexPath.row];
    
    [[MessageDataManager defaultManager] updateMyMessageBox:[LoginManager shareInstance].loginAccountInfo.uId rowId:myMessageBoxModel.rowId];
    //更改被点击之后的文字样式
    
    
    switch ([myMessageBoxModel.type integerValue]) {
        case 1:{
        }
        case 2:{
            //test 要删除=============
            UIStoryboard *storboard = [UIStoryboard storyboardWithName:@"FleaMarketStoryboard" bundle:nil];
            //获取跳蚤详情vc
            FleaMarketDetailViewController *fleaMarketDetailViewController = [storboard instantiateViewControllerWithIdentifier:@"fleaMarketDetailViewController"];
            fleaMarketDetailViewController.title = @"详情";
            fleaMarketDetailViewController.aid = myMessageBoxModel.aId;
            fleaMarketDetailViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fleaMarketDetailViewController animated:YES];
        }
        default:
            break;
    }
    
    
}

/**
 *  设置导航栏右键
 */
- (void)setRightBarButtonItem
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [editButton setFrame:CGRectMake(0, 0, 32 + 22, 15)];
    } else {
        [editButton setFrame:CGRectMake(0, 0, 32, 15)];
    }
    //[editButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 20, 0, 0)];
    //    [editButton setTitle:@"提交" forState:UIControlStateNormal];
    //    [editButton setTitle:@"提交" forState:UIControlStateHighlighted];
    [editButton setImage:[UIImage imageNamed:@"word_yidu"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"word_yidu"] forState:UIControlStateHighlighted];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    //    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [editButton addTarget:self action:@selector(readMessages) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 10000;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)readMessages{
    [[MessageDataManager defaultManager] updateMyMessageBoxAll:[LoginManager shareInstance].loginAccountInfo.uId];
    [self requestMyMessageBoxFromDatabase];
}

@end
