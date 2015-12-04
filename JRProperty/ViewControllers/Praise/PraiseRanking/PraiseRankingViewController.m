//
//  PraiseRankingViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/11/25.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "PraiseRankingViewController.h"
#import "PraiseRankingTableViewCell.h"

@interface PraiseRankingViewController ()

@end

@implementation PraiseRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PraiseRankingTableViewCell *rankingCell = [tableView dequeueReusableCellWithIdentifier:@"praiseRankingCell"];
    
    
    rankingCell.headImg.layer.masksToBounds = YES;
    rankingCell.headImg.layer.cornerRadius = 30;
    
    NSLog(@"%f",rankingCell.headImg.frame.size.width);
    
//    self.portraitImgView.layer.masksToBounds = YES;
//    self.portraitImgView.layer.cornerRadius = 40;
    
    return rankingCell;
//    return nil;
}

@end
