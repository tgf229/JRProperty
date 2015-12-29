//
//  PraisePublishViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/11/26.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "PraisePublishViewController.h"
#import "PraisePublishSignCell.h"
#import "PraiseListService.h"
#import "PraiseDetailListModel.h"

#import "LoginManager.h"

#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "PraiseDetailViewController.h"

@interface PraisePublishViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeLable;

- (IBAction)choseSign:(id)sender;
@property(strong,nonatomic) PraiseListService * praiseListService;// 表扬服务类
@property(strong,nonatomic) NSMutableDictionary * signDic; // 表扬标签字典
@property(strong,nonatomic) NSMutableDictionary * cSignDic; // 选中的表扬标签字典


@end

@implementation PraisePublishViewController

-(void)config{

    self.praiseListService = [[PraiseListService alloc] init];
    self.signDic = [NSMutableDictionary dictionary];
    self.cSignDic = [NSMutableDictionary dictionary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 40;
    //设置头像
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.praiseModel.eImageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    //设置员工姓名
    self.depUserName.text = self.praiseModel.eName;
    
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.text =@"您好" ;
//    label.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
//    label.layer.borderWidth = 1;
//    [self.infoView addSubview:label];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.infoView addGestureRecognizer:tapGestureRecognizer];
    
    [self config];
    [self setRightBarButtonItem];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PraisePublishSignCell *signCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"signCell" forIndexPath:indexPath];
    if (self.praiseSignArray.count > (indexPath.section*4+indexPath.item)) {
        PraiseSignModel *signModel = (PraiseSignModel*)self.praiseSignArray[indexPath.section*4+indexPath.item];
        [self.signDic setObject:signModel forKey:signModel.tName];// 设置标签字典
        
        [signCell.signButton setTitle:signModel.tName forState:UIControlStateNormal];//设置按钮文字
        //设置初始按钮背景
        [signCell.signButton setBackgroundImage:[[UIImage imageNamed:@"praise_release_btn_grey"]  resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
        signCell.hidden = NO;
    }else{
        signCell.hidden = YES;
    }
    
    
    return signCell;

}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeLable.hidden = NO;
    }else{
        self.placeLable.hidden = YES;
    }
    
//    [self.textNumberLabel setText:[NSString stringWithFormat:@"%u/100",textView.text.length > 100 ? 100:textView.text.length]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([toBeString length] > 200) {
        textView.text = [toBeString substringToIndex:200];
        return NO;
    }
    
    return YES;
}

- (IBAction)choseSign:(id)sender {
    UIButton * btn = (UIButton*)sender;
    if ([self.cSignDic objectForKey:btn.titleLabel.text] == nil) { // 选中
        PraiseSignModel *signModel = (PraiseSignModel*)[self.signDic objectForKey:btn.titleLabel.text]; // 取出选中对象
        [self.cSignDic setObject:signModel forKey:btn.titleLabel.text]; // 保存选中对象
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_red_20x20"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal]; // 切换背景
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }else{ // 未选中
        [self.cSignDic removeObjectForKey:btn.titleLabel.text]; // 移除选中
        [btn setBackgroundImage:[[UIImage imageNamed:@"praise_release_btn_grey"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal]; // 切换背景
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    NSLog(@"选择标签！！！%@",btn.titleLabel.text);
}

/**
 *  给tableview加的手势触发事件  点击空白处 隐藏键盘
 *
 *  @param tap 点击手势
 */
-(void)keyboardHide:(UITapGestureRecognizer *)tap {
    [self.contentTextView resignFirstResponder];
}

/**
 *  设置导航栏右键
 */
- (void)setRightBarButtonItem
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [editButton setFrame:CGRectMake(0, 0, 32 + 22, 20)];
    } else {
        [editButton setFrame:CGRectMake(0, 0, 32, 20)];
    }
    //[editButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 20, 0, 0)];
    //    [editButton setTitle:@"提交" forState:UIControlStateNormal];
    //    [editButton setTitle:@"提交" forState:UIControlStateHighlighted];
    [editButton setImage:[UIImage imageNamed:@"title_red_tijiao"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"title_red_tijiao"] forState:UIControlStateHighlighted];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    //    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [editButton addTarget:self action:@selector(submitPraiseToService) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 10000;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)submitPraiseToService{
    NSLog(@"提交表扬信息！！！！！！！");
    //获取标签
    NSEnumerator * enumeratorValue = [self.cSignDic objectEnumerator];
    NSString * signString = @"";
    for (PraiseSignModel * sm in enumeratorValue) {
        signString = [signString stringByAppendingString:@","];
        signString = [signString stringByAppendingString:sm.tId];
    }
    //获取content内容
    NSString * content = self.contentTextView.text;
    
    //判断标签和内容是否选择或填写
    if ([@"" isEqualToString:signString] && (content==nil || [@"" isEqualToString:content])) {
        // 请输入内容
        [SVProgressHUD showErrorWithStatus:@"请为该员工选择标签或者填写表扬内容"];
        return;
    }
    signString = [signString substringFromIndex:1]; // 去掉第一个字符“,”
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.praiseListService Bus200601:nil uId:uid eId:self.praiseModel.eId tag:signString content:content success:^(id responseObject) {
        if ([responseObject isKindOfClass:[BaseModel class]]) {
            BaseModel * baseModel = (BaseModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
                
                PraiseDetailModel * addDetailModel = [[PraiseDetailModel alloc] init];
                
                addDetailModel.nickName = [LoginManager shareInstance].loginAccountInfo.nickName;
                addDetailModel.tag = signString;
                addDetailModel.content = content;
                addDetailModel.time = @"刚刚";
                addDetailModel.imageUrl = [LoginManager shareInstance].loginAccountInfo.image;
                
                
                [self.delegate passPraiseDetailModel2Show:addDetailModel];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
                NSLog(@"请求网关返回失败");
            }
        }

    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}

@end
