//
//  MyMessageViewController.m
//  JRProperty
//
//  Created by duwen on 14/11/26.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyMessageViewController.h"
#import "JRDefine.h"
#import "MyMessageTableViewCell.h"
#import "MessageDataManager.h"
#import "LoginManager.h"
#import "NoResultView.h"
#import "MyMessageService.h"
#import "SVProgressHUD.h"
@interface MyMessageViewController ()
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NoResultView * noResultView;
@property (nonatomic, strong) MyMessageService * myMessageService;
@end

@implementation MyMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMyMesssageService) name:@"HAVENEWMSGNOTIFICATION" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *userId = [LoginManager shareInstance].loginAccountInfo.uId;
    [[MessageDataManager defaultManager] updateMyMessage:userId cId:CID_FOR_REQUEST];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HAVEWATCHMESSAGE" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_wodexiaoxi"]];

    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    UINib *cellNib = [UINib nibWithNibName:@"MyMessageTableViewCell" bundle:nil];
    [_myMessageTableView registerNib:cellNib forCellReuseIdentifier:@"MyMessageTableViewCellIndentifier"];
    self.prototypeCell  = [_myMessageTableView dequeueReusableCellWithIdentifier:@"MyMessageTableViewCellIndentifier"];
    
    
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
    
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.myMessageService = [[MyMessageService alloc] init];
    if (!self.isNotification) {
        if (_messageRequestSuccess) {
            if ([RETURN_CODE_SUCCESS isEqualToString:_baseModel.retcode]) {
                NSString *userId = [LoginManager shareInstance].loginAccountInfo.uId;
                self.dataSourceArray = [[MessageDataManager defaultManager] queryMyMessage:userId cId:CID_FOR_REQUEST];
                if (self.dataSourceArray.count > 0) {
                    [self.noResultView setHidden:YES];
                    [_myMessageTableView reloadData];
                }else{
                    [self.noResultView setHidden:NO];
                }
            }else{
                [self.noResultView initialWithTipText:_baseModel.retinfo];
                [self.noResultView setHidden:NO];
            }
        }else{
            [self requestMyMesssageService];
        }
    }else{
        [self requestMyMesssageService];
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HAVEWATCHMESSAGE" object:nil];
}

/**
 *  我的消息查询
 */
- (void)requestMyMesssageService{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.myMessageService Bus100701:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[MessageListModel class]]) {
            MessageListModel *messageListModel = (MessageListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:messageListModel.retcode]) {
                NSString *userId = [LoginManager shareInstance].loginAccountInfo.uId;
                [[MessageDataManager defaultManager] insertMessage:messageListModel userId:userId cId:CID_FOR_REQUEST];
                self.dataSourceArray = [[MessageDataManager defaultManager] queryMyMessage:userId cId:CID_FOR_REQUEST];
                if (self.dataSourceArray.count > 0) {
                    [self.noResultView setHidden:YES];
                }else{
                    [self.noResultView setHidden:NO];
                }
                [_myMessageTableView reloadData];
                
            }else{
                [self.noResultView initialWithTipText:messageListModel.retinfo];
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataSourceArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMessageTableViewCellIndentifier"];
    NSDictionary * dic = self.dataSourceArray[indexPath.row];
    if ([@"1" isEqualToString:[dic objectForKey:@"isRead"]]) {
        // 未读
        cell.messageNameLabel.textColor = UIColorFromRGB(0x000000);
        cell.messageLabel.textColor = UIColorFromRGB(0x444444);
        cell.timeLabel.textColor = UIColorFromRGB(0x666666);
    }else{
        // 已读
        cell.messageLabel.textColor = cell.messageNameLabel.textColor = UIColorFromRGB(0x666666);
        cell.timeLabel.textColor = UIColorFromRGB(0x888888);
    }
    
    if (indexPath.row == self.dataSourceArray.count - 1) {
        cell.midLineIV.hidden = YES;
        cell.footLineIV.hidden = NO;
    }else{
        cell.midLineIV.hidden = NO;
        cell.footLineIV.hidden = YES;
    }
    [cell reFrashDataWithMessageModel:[dic objectForKey:@"messageModel"]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageTableViewCell *cell = (MyMessageTableViewCell *)self.prototypeCell;
    NSDictionary * dic = self.dataSourceArray[indexPath.section];
    [cell reFrashDataWithMessageModel:[dic objectForKey:@"messageModel"]];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height > 80 ? 1 + size.height:80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
