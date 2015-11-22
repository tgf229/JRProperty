//
//  CircularDetailViewController.m
//  JRProperty
//
//  Created by duwen on 14/11/27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "CircularDetailViewController.h"
#import "JRDefine.h"
#import "CircularDataTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AnnounceService.h"
#import "AnnounceDetailModel.h"
#import "MessageDataManager.h"
#import "SVProgressHUD.h"
#import "LoginManager.h"
#import "LoginViewController.h"
#import "NoResultView.h"

#import "PopSocialShareView.h"
#import "ShareToSnsService.h"

#define BOTTOMHEIGHT    44
#define TEXTVIEWHEIGHT  48

static NSString *cellIndentifier = @"CircularDataTableViewCellIdentifier";
@interface CircularDetailViewController ()<PopSocialShareViewDelegate,ShareToSnsServiceDelegate>
{
    int upNum;              // 赞记录
    int downNum;            // 踩记录
    int staus;              // 赞踩标示
    
    int myMsgNum;           // 我的评论消息数
}
@property (nonatomic, assign) CGFloat               contentOffsetY;//下滑控制键盘隐藏
@property (strong, nonatomic) AnnounceService *announceService;     // 通告服务类
@property (nonatomic, strong) NoResultView * noResultView;          // 哭脸

@property (nonatomic,strong) PopSocialShareView      *shareView;    // 分享视图
@property (nonatomic,strong) ShareToSnsService       *shareService; // 分享服务类
@property (nonatomic,strong) NSIndexPath             *sharedIndexPath;  // 分享标示

@end

@implementation CircularDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}
/**
 *  配置信息
 */
- (void)config{
    for (UIButton *btn in _bottomButtonArray) {
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    
    self.commentArray = [[NSMutableArray alloc] init];
    
    // 判断是否赞过
    staus = [[MessageDataManager defaultManager] queryStausWithAnnounceId:_announceModel.id];
    if (staus == 999) {
        // 未赞未踩
        upNum = 0;
        downNum = 0;
    }else if (staus == 1){
        // 赞过
        upNum = 1;
        downNum = 0;
    }else{
        // 踩过
        upNum = 0;
        downNum = 1;
    }
    [(UIButton *)_bottomButtonArray[0] setImage:[UIImage imageNamed:(upNum%2==0?@"linli_detail_footbtn_zan_32x32":@"linli_detail_footbtn_zan_32x32_press")] forState:UIControlStateNormal];
//    [(UIButton *)_bottomButtonArray[1] setImage:[UIImage imageNamed:(downNum%2==0?@"icon_caired":@"icon_caired_pressed")] forState:UIControlStateNormal];
//    _textViewHeightConstraint.constant = 0.0f;
    _keyboardView.hidden = YES;
    
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
    
    _headViewHeightConstraint.constant = UIScreenWidth * 100 / 320;
    _bottomView.hidden = YES;
    _circularDetailTableView.hidden = YES;
    
    
    self.shareService = [[ShareToSnsService alloc] init];
    self.sharedIndexPath = [[NSIndexPath alloc] init];
    
    myMsgNum = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *cellNib = [UINib nibWithNibName:@"CircularDataTableViewCell" bundle:nil];
    [_circularDetailTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    self.prototypeCell  = [_circularDetailTableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (CURRENT_VERSION < 7.0f) {
        _topConstraint.constant = 0.0f;
    }
    
    [self config];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.circularDetailTableView addGestureRecognizer:tapGestureRecognizer];
    
    self.announceService = [[AnnounceService alloc] init];
    [self requestCommentService];
    
    [self initKeyboardView];
}

/**
 *  评论请求服务
 */
- (void)requestCommentService{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.announceService Bus100301:self.announceModel.id success:^(id responseObject) {
        if ([responseObject isKindOfClass:[AnnounceDetailModel class]]) {
            self.announceDetailModel = (AnnounceDetailModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:self.announceDetailModel.retcode]) {
                [self.commentArray addObjectsFromArray:self.announceDetailModel.comment];
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.announceDetailModel.imageUrl] placeholderImage:[UIImage imageNamed:@"home_banner"]];
                _headViewTitleLabel.text = self.announceDetailModel.name;
                _contentLabel.text = self.announceDetailModel.desc;
                _commentBumLabel.text = [NSString stringWithFormat:@"评论 %d",self.announceDetailModel.comment.count];
                [(UIButton *)_bottomButtonArray[0] setTitle:self.announceDetailModel.praiseNum forState:UIControlStateNormal];
                [(UIButton *)_bottomButtonArray[1] setTitle:[NSString stringWithFormat:@"%d",self.announceDetailModel.comment.count] forState:UIControlStateNormal];
                _bottomView.hidden = NO;
                _circularDetailTableView.hidden = NO;
                [_circularDetailTableView reloadData];
                [self showAnimateWhenChangeConstraint];
            }else{
                [self.noResultView initialWithTipText:self.announceDetailModel.retinfo];
                [self.noResultView setHidden:NO];
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
        [self.noResultView setHidden:NO];
    }];
}

/**
 *  底部按钮点击
 *
 *  @param sender
 */
- (IBAction)bottomButtonSelected:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch ([btn tag]) {
        case 0:
        {
            // 点赞
            if (staus == 999) {
                if (downNum+upNum==0) {
                    upNum++;
                    [btn setImage:[UIImage imageNamed:(upNum%2==0?@"linli_detail_footbtn_zan_32x32":@"linli_detail_footbtn_zan_32x32_press")] forState:UIControlStateNormal];
                    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    k.values = @[@(0.1),@(1.0),@(1.5)];
                    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
                    k.calculationMode = kCAAnimationLinear;
                    [btn.imageView.layer addAnimation:k forKey:@"SHOW"];
                    NSString *numStr = [NSString stringWithFormat:@"%d",[btn.titleLabel.text intValue] + 1];
                    [btn setTitle:numStr forState:UIControlStateNormal];
                }
                [self.announceService Bus100401:_announceModel.id type:@"1" success:^(id responseObject) {
                    if ([responseObject isKindOfClass:[BaseModel class]]) {
                        BaseModel *baseModel = (BaseModel *)responseObject;
                        if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
                            if ([[MessageDataManager defaultManager] insertAnnounceWithId:_announceModel.id staus:@"1"]) {
                                staus = 1;
                            }
                        }
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }
            break;
        case 1:
        {
            // 踩
            if (staus == 999) {
                if (downNum+upNum==0) {
                    downNum++;
                    [btn setImage:[UIImage imageNamed:(downNum%2==0?@"icon_caired":@"icon_caired_pressed")] forState:UIControlStateNormal];
                    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    k.values = @[@(0.1),@(1.0),@(1.5)];
                    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
                    k.calculationMode = kCAAnimationLinear;
                    [btn.imageView.layer addAnimation:k forKey:@"SHOW"];
                    NSString *numStr = [NSString stringWithFormat:@"%d",[btn.titleLabel.text intValue] + 1];
                    [btn setTitle:numStr forState:UIControlStateNormal];

                }
                [self.announceService Bus100401:_announceModel.id type:@"0" success:^(id responseObject) {
                    if ([responseObject isKindOfClass:[BaseModel class]]) {
                        BaseModel *baseModel = (BaseModel *)responseObject;
                        if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
                            if ([[MessageDataManager defaultManager] insertAnnounceWithId:_announceModel.id staus:@"0"]) {
                                staus = 0;
                            }
                        }
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }
            break;
        case 2:
        {
            // 评论
//            _bottomHeightConstraint.constant = 1.0f;
//            _textViewHeightConstraint.constant = TEXTVIEWHEIGHT;
            _keyboardView.hidden = NO;
            _bottomView.hidden = YES;
            _bottomConstraint.constant = _textViewHeightConstraint.constant + _textViewBottomConstraint.constant;
//            [_CommenInputView resignFirstResponder];
            [self showAnimateWhenChangeConstraint];
        }
            break;
        case 3:
        {
            // 分享
            PopSocialShareView *tempShareView = [[PopSocialShareView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            tempShareView.delegate = self;
            self.shareView = tempShareView;
//            self.sharedIndexPath = indexPath;
            [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
        }
            break;
        default:
            break;
    }
    
    
    
}

- (IBAction)commentBtnClick:(id)sender
{
    // 评论
    //            _bottomHeightConstraint.constant = 1.0f;
    //            _textViewHeightConstraint.constant = TEXTVIEWHEIGHT;
    _keyboardView.hidden = NO;
    _bottomView.hidden = YES;
    _bottomConstraint.constant = _textViewHeightConstraint.constant + _textViewBottomConstraint.constant;
    //            [_CommenInputView resignFirstResponder];
    [self showAnimateWhenChangeConstraint];
}

//评论输入区域属性
- (void)initKeyboardView {
    [self.keyboardView setBackgroundColor:[UIColor getColor:@"F2F2F2"]];
    self.CommenInputView.isScrollable = NO;
    self.CommenInputView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.CommenInputView.animateHeightChange = YES;
    self.CommenInputView.minNumberOfLines = 1;
    self.CommenInputView.maxNumberOfLines = 4;
    self.CommenInputView.returnKeyType = UIKeyboardTypeDefault;
    self.CommenInputView.font = [UIFont systemFontOfSize:15.0f];
    self.CommenInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.CommenInputView.delegate = self;
    self.CommenInputView.placeholder = @"说点什么吧...";
    [self.CommenInputView setBackgroundColor:[UIColor getColor:@"FDFDFD"]];
    CALayer *layer1 = [self.CommenInputView layer];
    layer1.borderColor = [UIColor grayColor].CGColor;
    layer1.borderWidth = 0.5f;
    [self.CommenInputView.layer setCornerRadius:5.0];
    [self.CommenInputView.layer setMasksToBounds:YES];
    [self.CommenInputView setClipsToBounds:YES];
    
    [self.sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
}

//发请求发表评论
/**
 *  发送评论
 */
- (void) sendComment {
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"很抱歉，游客无法操作此功能，请进行注册或登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    else {
        NSString * str = [self.CommenInputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([@"" isEqualToString:str]||str==nil) {
            // 请输入内容
            [SVProgressHUD showErrorWithStatus:@"评论内容不能为空！"];
            self.CommenInputView.text = @"";
            [self.CommenInputView resignFirstResponder];
            return;
        }else {
            [self.CommenInputView resignFirstResponder];
            [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
            [self.announceService Bus100501:self.announceModel.id uId:[LoginManager shareInstance].loginAccountInfo.uId content:str success:^(id responseObject) {
                if ([responseObject isKindOfClass:[BaseModel class]]) {
                    BaseModel * baseModel = (BaseModel *)responseObject;
                    if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
                        //成功
                        [SVProgressHUD dismiss];
                        AnnounceCommentModel * acModel = [[AnnounceCommentModel alloc] init];
                        acModel.name = [LoginManager shareInstance].loginAccountInfo.nickName;
                        acModel.image = [LoginManager shareInstance].loginAccountInfo.image;
                        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"yyyyMMddHHmmss"];
                        NSString *pubTime = [formatter stringFromDate:[NSDate date]];
                        acModel.time = pubTime;
                        acModel.desc = [self.CommenInputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        [self.commentArray insertObject:acModel atIndex:0];
                        myMsgNum++;
                        [_circularDetailTableView beginUpdates];
                        NSArray *arrInsertRows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
                        [_circularDetailTableView insertRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationTop];
                        [_circularDetailTableView endUpdates];
                        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                        self.CommenInputView.text = @"";
                        [_circularDetailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        
                        UIButton * commentBtn = (UIButton *)_bottomButtonArray[1];
                        int commentNum = [commentBtn.titleLabel.text intValue] + 1;
                        [(UIButton *)_bottomButtonArray[1] setTitle:[NSString stringWithFormat:@"%d",commentNum] forState:UIControlStateNormal];
                        _commentBumLabel.text = [NSString stringWithFormat:@"评论 %d",commentNum];
                    }else{
                        [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
                    }
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
            }];
        }
    }
}


/**
 *  展示约束动画
 */
- (void)showAnimateWhenChangeConstraint{
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.35f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircularDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (indexPath.row < myMsgNum) {
        cell.isMyComment = YES;
    }else{
        cell.isMyComment = NO;
    }
    [cell refreshDataWithAnnounceCommentModel:(AnnounceCommentModel *)self.commentArray[indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [_contentLabel setTextColor:UIColorFromRGB(0x666666)];
    _contentLabel.text = self.announceDetailModel.desc;
    return _circularDetailHeadView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircularDataTableViewCell *cell = (CircularDataTableViewCell *)self.prototypeCell;
    [cell refreshDataWithAnnounceCommentModel:(AnnounceCommentModel *)self.commentArray[indexPath.row]];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height > 65.0f? size.height + 1 : 65.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    _contentLabel.text = self.announceDetailModel.desc;
    _headViewHeightConstraint.constant = UIScreenWidth * 8 / 15;
    [_circularDetailHeadView updateConstraintsIfNeeded];
    _contentLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - 70;
    CGSize size = [_circularDetailHeadView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


#pragma mark - HGTextViewDelegate Method
/**
 *  改变textview的高度
 *
 *  @param growingTextView textview
 *  @param height          改变的高度
 */
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.keyboardView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
//    self.keyboardView.frame = r;
    _textViewHeightConstraint.constant = r.size.height;
    _bottomConstraint.constant = _textViewHeightConstraint.constant + _textViewBottomConstraint.constant;
    [self.view layoutIfNeeded];
    
}
/**
 *  当键盘出现或改变时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    CGRect oldFrame = self.keyboardView.frame;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
//    self.keyboardView.frame = CGRectMake(0, UIScreenHeight-height-oldFrame.size.height, self.view.frame.size.width, oldFrame.size.height);
    _textViewHeightConstraint.constant = oldFrame.size.height;
    _textViewBottomConstraint.constant = height;
    _bottomConstraint.constant = _textViewBottomConstraint.constant + _textViewHeightConstraint.constant;
    if (self.commentArray.count > 0) {
        [_circularDetailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

/**
 *  当键盘退出时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGRect oldFrame = self.keyboardView.frame;
//    self.keyboardView.frame =CGRectMake(0, UIScreenHeight-oldFrame.size.height, self.view.frame.size.width, oldFrame.size.height);
    _textViewHeightConstraint.constant = oldFrame.size.height;
    _textViewBottomConstraint.constant = 0.0f;
    _bottomConstraint.constant = _textViewBottomConstraint.constant + _textViewHeightConstraint.constant;
}

#pragma mark - Scroll  控制下滑表格则 键盘下降
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ((self.circularDetailTableView.contentOffset.y - _contentOffsetY) < 20)
    {
        [self.circularDetailTableView resignFirstResponder];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _contentOffsetY = scrollView.contentOffset.y;
}


/**
 *  控制textview输入长度
 *
 *  @param textView textview
 *  @param range    range
 *  @param text     text
 *
 *  @return  是否可输入
 */
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([self.CommenInputView.text length] > 200) {
        self.CommenInputView.text = [self.CommenInputView.text substringToIndex:199];
        return NO;
    }else if ([self.CommenInputView.text length] == 200){
        self.CommenInputView.text = [self.CommenInputView.text substringToIndex:199];
        return YES;
    }
    
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //跳转到登陆页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //登录返回前需要请求圈子用户信息
        JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
        loginViewController.loginButtonBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

/**
 *  给tableview加的手势触发事件  点击空白处 隐藏键盘
 *
 *  @param tap 点击手势
 */
-(void)keyboardHide:(UITapGestureRecognizer *)tap {
    [self.CommenInputView resignFirstResponder];
//    _bottomHeightConstraint.constant = BOTTOMHEIGHT;
//    _textViewHeightConstraint.constant = 0;
//    _textViewBottomConstraint.constant = 0;
    _keyboardView.hidden = YES;
    _bottomView.hidden = NO;
    _bottomConstraint.constant = BOTTOMHEIGHT;
    [self showAnimateWhenChangeConstraint];
}


#pragma  mark - 分享 PopSocialShareViewDelegate
- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType
{
    [self.shareView removeShareSubView];
    self.shareService.delegate = self;
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.announceDetailModel.imageUrl]];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTP_SHARED_AD_URL,self.announceDetailModel.id];
    NSString *fullMessage = [NSString stringWithFormat:@"%@\n%@%@",self.announceDetailModel.name,self.announceDetailModel.desc,urlStr];


    [self.shareService showSocialPlatformIn:self
                                 shareTitle:self.announceDetailModel.name
                                  shareText:self.announceDetailModel.desc
                                   shareUrl:urlStr
                            shareSmallImage:imageData
                              shareBigImage:imageData
                           shareFullMessage:fullMessage
                             shareToSnsType:platformType];
}

#pragma  mark - 分享成功 ShareToSnsServiceDelegate

/**
 *  分享成功
 */
- (void)shareToSnsPlatformSuccessed
{
    [self.announceService Bus100401:self.announceDetailModel.id type:@"2" success:^(id responseObject) {
        if ([responseObject isKindOfClass:[BaseModel class]]) {
            BaseModel *resultModel = (BaseModel *)responseObject;
            if ([resultModel.retcode isEqualToString:@"000000"]) {
                // 分享次数+1 self.sharedindexPath
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//                UIButton * shareBtn = (UIButton *)_bottomButtonArray[2];
//                int shareNum = [shareBtn.titleLabel.text intValue] + 1;
//                [(UIButton *)_bottomButtonArray[3] setTitle:[NSString stringWithFormat:@"%d",shareNum] forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error) {
        
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

@end
