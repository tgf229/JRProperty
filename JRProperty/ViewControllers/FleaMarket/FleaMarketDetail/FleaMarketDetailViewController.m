//
//  FleaMarketDetailViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/12/16.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "FleaMarketDetailViewController.h"
#import "FleaMarketDetailInfoTableViewCell.h"

#import "FleaMarketService.h"
#import "FleaMarketDetailModel.h"
#import "FleaMarketCommentListModel.h"
#import "LoginManager.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface FleaMarketDetailViewController ()

@property(strong,nonatomic) FleaMarketService * fleaMarketService;
@property(strong,nonatomic) FleaMarketDetailModel * fleaMarketDetailModel;
@property (weak, nonatomic) IBOutlet UITableView *fleaMarketTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;

@property (weak, nonatomic) IBOutlet UILabel *prodInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIImageView *imageUrlView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameView;
@property (weak, nonatomic) IBOutlet UILabel *timeView;
@property (weak, nonatomic) IBOutlet UILabel *cPriceView;
@property (weak, nonatomic) IBOutlet UILabel *oPriceView;
@property (weak, nonatomic) IBOutlet UILabel *commentNumView;
@property (weak, nonatomic) IBOutlet UIView *likeListImagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeListHeightCons;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
- (IBAction)commentAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomCons;
@property (weak, nonatomic) IBOutlet UIImageView *shotSepatorLineView;
@property (weak, nonatomic) IBOutlet UILabel *placeView;
@property (weak, nonatomic) IBOutlet UIButton *favViewBtn;
- (IBAction)favoriteAction:(id)sender;

@property(copy,nonatomic) NSString * queryTime;
@property(assign,nonatomic) int page;
@property(strong,nonatomic) NSMutableArray * dataSourceArray;// 数据源
@property(strong,nonatomic) FleaMarketCommentListModel * fleaMarketCommentListModel;// 跳蚤留言列表模型
@property(copy,nonatomic) NSString * repUid; // 被回复的用户id
@property(copy,nonatomic) NSString * comtId; // 被回复的评论id
@property(copy,nonatomic) NSString * repNickName; // 被回复的nickname




@end

@implementation FleaMarketDetailViewController

-(void)config{
    self.fleaMarketService = [[FleaMarketService alloc] init];
    self.queryTime = @"";
    self.page = 1;
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.repUid = @"";
    self.comtId = @"";
    self.repNickName = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = self.fleaMarketTableView;
    
    [weaktb addFooterWithCallback:^{
        // 调用网络请求
        //        if (self.hasMore) {
        [self requestCommentList:++self.page];
        //        }
    }];
    
    [self config];
    [self requestFleaMarketDetail];
    [self requestCommentList:self.page];
    
}

-(void)requestFleaMarketDetail{
    [self.fleaMarketService Bus600201:[LoginManager shareInstance].loginAccountInfo.uId aId:self.aid success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[FleaMarketDetailModel class]]) {
            self.fleaMarketDetailModel = (FleaMarketDetailModel*)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:self.fleaMarketDetailModel.retcode]) {
                //                [SVProgressHUD showSuccessWithStatus:@“”]; 请求成功返回
                //设置头像
                [self.imageUrlView sd_setImageWithURL:[NSURL URLWithString:self.fleaMarketDetailModel.imageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
                self.imageUrlView.layer.masksToBounds = YES;
                self.imageUrlView.layer.cornerRadius = 17;
        
                self.nickNameView.text = self.fleaMarketDetailModel.nickName;
                self.timeView.text = self.fleaMarketDetailModel.time;
        
                //缺少价格字段
                self.cPriceView.text = self.fleaMarketDetailModel.cPrice;
                self.oPriceView.text = self.fleaMarketDetailModel.oPrice;
        
                self.prodInfoLabel.text = self.fleaMarketDetailModel.content;
        
                // 设置图片
                // 图片宽高
                CGFloat imgSize = (UIScreenWidth-30.0-6.0)/3.0;
        
                if ([self.fleaMarketDetailModel.imageList count] > 0) {
                    CGFloat lineHeight = 3.0; // 行间距
                    CGFloat trueHeight = 0.0; // 实际行间距
                    UIImageView * uiv;
                    for (int i = 0; i<[self.fleaMarketDetailModel.imageList count]; i++) {
                        FleaMarketImageModel * fmim ;
                        fmim = self.fleaMarketDetailModel.imageList[i];
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
                        [self.imagesView addSubview:uiv];
                        trueHeight = trueHeight + imgSize +lineHeight;
                    }
        
                }
        
                if ([self.fleaMarketDetailModel.likeList count] > 0) {
        // 设置喜欢的用户头像
                    CGFloat likeheadspace = 5.0;
                    CGFloat likeheadleftspace = 15.0;
                    CGFloat likehead_x = 0;
                    for (int i = 0; i < [self.fleaMarketDetailModel.likeList count]; i++) {
                        likehead_x = likeheadleftspace+30.0*i+likeheadspace*i; // 头像x坐标
                        
                        if ((likehead_x+30.0+5.0+30.0) > UIScreenWidth-15.0) { // 最后一个头像
                            UIImageView * likeHeadUiv = [[UIImageView alloc] initWithFrame:CGRectMake(likehead_x, 5.0, 30.0, 30.0)];
                            [likeHeadUiv setImage:[UIImage imageNamed:@"used_detail_more"]];
                            [self.likeListImagesView addSubview:likeHeadUiv];
                            break;
                        }
                        UIImageView * likeHeadUiv = [[UIImageView alloc] initWithFrame:CGRectMake(likehead_x, 5.0, 30.0, 30.0)];
                        FleaMarketLikeModel * fmlm =(FleaMarketLikeModel *)self.fleaMarketDetailModel.likeList[i];
                        [likeHeadUiv sd_setImageWithURL:[NSURL URLWithString:fmlm.imageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
                        likeHeadUiv.layer.masksToBounds = YES;
                        likeHeadUiv.layer.cornerRadius = 15;
                        [self.likeListImagesView addSubview:likeHeadUiv];
                    }
                }else{
                    self.likeListHeightCons.constant = 0.0;
                    self.shotSepatorLineView.hidden = YES;
                }
                
                //设置收藏的数量
                [self.favViewBtn setTitle:self.fleaMarketDetailModel.praiseNum forState:UIControlStateNormal];
                if ([@"1" isEqualToString:self.fleaMarketDetailModel.flag]) { // 设置收藏button背景
                    [self.favViewBtn setBackgroundImage:[UIImage imageNamed:@"use_detail_btn_collect_press"] forState:UIControlStateNormal];
                }
                
                self.commentNumView.text = self.fleaMarketDetailModel.commentNum;
        
                self.tableHeadView.frame = CGRectMake(0.0, 0.0, UIScreenWidth, [self detailHeaderHeight]);
                self.fleaMarketTableView.tableHeaderView = self.tableHeadView;
                
                //                [self.fleaMarketTableView reloadData];
            }
            else{
                NSLog(@"请求网关失败");
                [SVProgressHUD showErrorWithStatus:self.fleaMarketDetailModel.retinfo];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据异常"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取详情宝贝详情失败，请稍后重试"];
    }];
}

-(CGFloat)detailHeaderHeight{
    CGFloat upStaticHeight = 20.0+35.0+15.0; // 上部固定高度 到文字部分的固定高度
    CGFloat footStaticHeight = 30.0; // 底部固定高度
    
    // 文字高度
    CGSize size = CGSizeMake(UIScreenWidth-50.0-20.0-16.0,4000.0);
    CGSize prodInfosize = [self.fleaMarketDetailModel.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //    if (prodInfosize.height != 0) {
    prodInfosize.height = prodInfosize.height+15; // 间距约束
    //    }
    // 图片高度
    CGFloat imagesViewHeight;
    if ([self.fleaMarketDetailModel.imageList count] == 0) {
        imagesViewHeight = 0.0+15.0; // 间距约束
    }else{
        if ([self.fleaMarketDetailModel.imageList count] <= 3) {
            imagesViewHeight = (UIScreenWidth-30.0-6.0)/3.0;
        }else{
            imagesViewHeight = ((UIScreenWidth-30.0-6.0)/3.0)*2+3;
        }
        imagesViewHeight = imagesViewHeight + 15;
    }
    // 其他控件固定高度
    CGFloat otherHeight = 50.0+11.0;
    // 喜欢列表高度
    CGFloat likeListHeight = 0.0;
    if ([self.fleaMarketDetailModel.likeList count] > 0) {
        likeListHeight = 40.0;
    }
    return upStaticHeight+footStaticHeight+prodInfosize.height+imagesViewHeight+otherHeight+likeListHeight;
}

-(void)requestCommentList:(int) page{
    [self.fleaMarketService Bus600301:self.aid page:[NSString stringWithFormat:@"%d",page] num:NUMBER_FOR_REQUEST queryTime:self.queryTime success:^(id responseObject) {
        if ([responseObject isKindOfClass:[FleaMarketCommentListModel class]]) {
            self.fleaMarketCommentListModel = (FleaMarketCommentListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:self.fleaMarketCommentListModel.retcode]) {
                if (page == 1) {
                    [self.dataSourceArray removeAllObjects];
                    self.queryTime = self.fleaMarketCommentListModel.queryTime;
                }
                
                [self.fleaMarketTableView footerEndRefreshing];
                
                [self.dataSourceArray addObjectsFromArray:self.fleaMarketCommentListModel.doc];
                [self.fleaMarketTableView reloadData];
            }
            else{
                [SVProgressHUD showErrorWithStatus:self.fleaMarketCommentListModel.retinfo];
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取宝贝评论失败，请稍后重试"];
    }];
}

-(void) viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    
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
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (indexPath.section == 0) {
    FleaMarketDetailInfoTableViewCell * fleaMarketDetailInfoCell = [tableView dequeueReusableCellWithIdentifier:@"fleaMarketDetailInfoCell"];
    
    FleaMarketCommentModel * fmc = (FleaMarketCommentModel *)self.dataSourceArray[indexPath.row];
    
    //设置头像
    [fleaMarketDetailInfoCell.headImgView sd_setImageWithURL:[NSURL URLWithString:fmc.imageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    fleaMarketDetailInfoCell.headImgView.layer.masksToBounds = YES;
    fleaMarketDetailInfoCell.headImgView.layer.cornerRadius = 17;
    
    fleaMarketDetailInfoCell.nickNameView.text = fmc.nickName;
    fleaMarketDetailInfoCell.timeView.text = fmc.time;
    if (fmc.replyNickName.length > 0) {
        NSString * nn = fmc.nickName;
        NSString * rnn = fmc.replyNickName;
        NSString * c = [[nn stringByAppendingString:@"回复"] stringByAppendingString:rnn];
        fleaMarketDetailInfoCell.commentView.text = c;
    }
    else{
        fleaMarketDetailInfoCell.commentView.text = fmc.content;
    }
    
    return  fleaMarketDetailInfoCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat upHeitht = 20.0+35.0+15.0;
    CGFloat footHeight = 20.0;

    // 文字高度
    CGSize size = CGSizeMake(UIScreenWidth-50-20-16,4000.0);
    FleaMarketCommentModel * fmc = (FleaMarketCommentModel *)self.dataSourceArray[indexPath.row];
    NSString * c = @"";
    if(fmc.replyNickName.length > 0){
        NSString * nn = fmc.nickName;
        NSString * rnn = fmc.replyNickName;
         c = [[nn stringByAppendingString:@"回复"] stringByAppendingString:rnn];
    }
    else{
        c = fmc.content;
    }
    
    
    CGSize prodInfosize = [c sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return upHeitht+footHeight+prodInfosize.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FleaMarketCommentModel * fmc = (FleaMarketCommentModel *)self.dataSourceArray[indexPath.row];
    self.placeView.text = [@"回复" stringByAppendingString:fmc.nickName];
    [self.commentTextView becomeFirstResponder];
    self.repUid = fmc.uId;
    self.comtId = fmc.commentId;
}

/**
 *  当键盘出现或改变时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    //
    self.textViewBottomCons.constant = keyboardHeight;
    //
    UITapGestureRecognizer *keyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboardTaped:)];
    [self.view addGestureRecognizer:keyboardTap];
    
}
/**
 *  当键盘退出时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    //还原消息发布栏位置
    self.textViewBottomCons.constant = 0.0;
}

- (void)hiddenKeyboardTaped:(id)sender
{
    [self.commentTextView resignFirstResponder];
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self.view removeGestureRecognizer:tap];
    
    NSString * content = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0) { // 键盘退出时如果评论无知恢复默认状态
        [self clearVal];
        [self resetVal];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeView.hidden = NO;
    }else{
        self.placeView.hidden = YES;
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


- (IBAction)commentAction:(id)sender {
    NSString * cont = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (cont.length == 0) {
        [self addAlertViewWithInfo:@"请填写评论消息"];
        return;
    }
    [self.fleaMarketService Bus600401:nil aId:self.aid uId:[LoginManager shareInstance].loginAccountInfo.uId replyUid:self.repUid commentId:self.comtId content:cont success:^(id responseObject) {
        if ([responseObject isKindOfClass:[FleaMarketCommentModel class]]) {
            FleaMarketCommentModel * baseModel = (FleaMarketCommentModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
                //发布成功刷新当前评论tableview
                FleaMarketCommentModel * fmc = [[FleaMarketCommentModel alloc] init];
                fmc.commentId = baseModel.commentId;
                fmc.uId = [LoginManager shareInstance].loginAccountInfo.uId;
                fmc.imageUrl = [LoginManager shareInstance].loginAccountInfo.image;
                fmc.time = @"刚刚";
                fmc.nickName = [LoginManager shareInstance].loginAccountInfo.nickName;
                fmc.replyUId = self.repUid;
                fmc.replyNickName = self.repNickName;
                fmc.content = cont;
                
                int comnum = [self.commentNumView.text intValue] + 1;
                self.commentNumView.text = [NSString stringWithFormat:@"%d",comnum];
                
                
                [self.dataSourceArray insertObject:fmc atIndex:0];
                [self.fleaMarketTableView reloadData];
                [self clearVal];
                [self resetVal];
            }
            else{
                [self clearVal];
                [self resetVal];
                [SVProgressHUD showErrorWithStatus:self.fleaMarketCommentListModel.retinfo];
            }
        }else{
            [self clearVal];
            [self resetVal];
        }
    } failure:^(NSError *error) {
        [self clearVal];
        [self resetVal];
        [SVProgressHUD showErrorWithStatus:@"发布评论失败，请稍后重试"];
    }];
}


-(void)clearVal{
    self.repUid = @"";
    self.comtId = @"";
    self.repNickName = @"";
}

-(void)resetVal{
    self.placeView.text = @"+ 添加你的评论";
    self.placeView.hidden = NO;
    self.commentTextView.text = @"";
}

/**
 *  alert消息提示框
 *
 *  @param str 提示内容
 */
- (void)addAlertViewWithInfo:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}
- (IBAction)favoriteAction:(id)sender {
    
    if ([@"0" isEqualToString:self.fleaMarketDetailModel.flag]) { // 未收藏
        [self.fleaMarketService Bus600601:nil aId:self.aid uId:[LoginManager shareInstance].loginAccountInfo.uId type:@"1" success:^(id responseObject) {
            if ([responseObject isKindOfClass:[BaseModel class]]) {
                BaseModel * b = (BaseModel *)responseObject;
                if ([RETURN_CODE_SUCCESS isEqualToString:b.retcode]) {
                    [self.favViewBtn setBackgroundImage:[UIImage imageNamed:@"use_detail_btn_collect_press"] forState:UIControlStateNormal];
                    int pnum = [self.fleaMarketDetailModel.praiseNum intValue];
                    pnum++;
                    [self.favViewBtn setTitle:[NSString stringWithFormat:@"%d",pnum] forState:UIControlStateNormal];
                    self.fleaMarketDetailModel.praiseNum = [NSString stringWithFormat:@"%d",pnum];
                    self.fleaMarketDetailModel.flag = @"1";
                }else{
                    [SVProgressHUD showErrorWithStatus:b.retinfo];
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"收藏该宝贝失败，请稍后重试"];
        }];

    }
    if ([@"1" isEqualToString:self.fleaMarketDetailModel.flag]) { // 已收藏
        [self.fleaMarketService Bus600601:nil aId:self.aid uId:[LoginManager shareInstance].loginAccountInfo.uId type:@"0" success:^(id responseObject) {
            if ([responseObject isKindOfClass:[BaseModel class]]) {
                BaseModel * b = (BaseModel *)responseObject;
                if ([RETURN_CODE_SUCCESS isEqualToString:b.retcode]) {
                    [self.favViewBtn setBackgroundImage:[UIImage imageNamed:@"use_detail_btn_collect"] forState:UIControlStateNormal];
                    int pnum = [self.fleaMarketDetailModel.praiseNum intValue];
                    pnum--;
                    [self.favViewBtn setTitle:[NSString stringWithFormat:@"%d",pnum] forState:UIControlStateNormal];
                    self.fleaMarketDetailModel.praiseNum = [NSString stringWithFormat:@"%d",pnum];
                    self.fleaMarketDetailModel.flag = @"0";
                }else{
                    [SVProgressHUD showErrorWithStatus:b.retinfo];
                }
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"取消收藏宝贝失败，请稍后重试"];
        }];

    }

}
@end
