//
//  MemberListViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MemberListViewController.h"
#import "MemberTableViewCell.h"
#import "UserPageViewController.h"
#import "NoResultView.h"

#import "CommunityModel.h"
#import "UIColor+extend.h"

#import "JRDefine.h"

@interface MemberListViewController ()

@property (strong,nonatomic)  NoResultView  *noResultView; //哭脸视图

@end

@implementation MemberListViewController

- (void)viewDidLoad {
    self.title = @"圈子成员";
    [super viewDidLoad];
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_quanzichengyuan"]];
    self.navigationItem.titleView = iv;
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-45, UIScreenWidth, 140);
    if (self.memberList.count == 0) {
        [self.noResultView setHidden:NO];
    }
    else {
        [self.noResultView setHidden:YES];
    }
    
    [self.view addSubview:self.noResultView];
    
    self.memberTableView.delegate = self;
    self.memberTableView.dataSource =self;
    self.memberTableView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.memberTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.memberTableView.showsVerticalScrollIndicator = YES;

}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12.0f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"MemberTableViewCell";
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor getColor:@"fcfcfc"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //获取数据
    MemberModel * info = [self.memberList objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.memberList.count -1) {
        [cell isLastRow:YES];
    }else {
        [cell isLastRow:NO];
    }

    [cell setData:info];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //转到个人中心页面
    MemberModel * model = [self.memberList objectAtIndex:indexPath.row];
    UserPageViewController *controller = [[UserPageViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.queryUid = model.uId;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
