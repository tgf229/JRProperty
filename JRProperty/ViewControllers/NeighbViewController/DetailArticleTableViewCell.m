//
//  DetailArticleTableViewCell.m
//  JRProperty
//
//  Created by tingting zuo on 14-12-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "DetailArticleTableViewCell.h"
#import "JRDefine.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "UITableViewCell+FindContainer.h"
#import "LoginManager.h"

@implementation DetailArticleTableViewCell

- (void)awakeFromNib {
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 20;
    self.userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    [self.userImageView addGestureRecognizer:singleTap];
    self.nickName.textColor = [UIColor getColor:@"384d78"];
    self.timeLabel.textColor = [UIColor getColor:@"888888"];
    
    [self.topImageView setHidden:YES];
    self.pictureView = [[ArticlePictureView alloc]initWithFrame:CGRectMake(15, 0, UIScreenWidth, 0)];
    [self addSubview:self.pictureView];
    self.voteView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleVoteView" owner:self options:nil]objectAtIndex:0];
    [self.voteView initial];
    self.voteView.delegate = self;
    [self addSubview:self.voteView];
    self.detailBottomView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleBottomView" owner:self options:nil]objectAtIndex:0];
    [self.detailBottomView initial];
    self.detailBottomView.delegate = self;
    [self addSubview:self.detailBottomView];
}

- (void)setData:(ArticleDetailModel *)data createUid:(NSString *)uId{
    _data = data;
    self.nickName.text = data.nickName;
    self.timeLabel.text = data.time;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    self.contentLabel.text = data.content;
    
    if (data.isTop.length !=0) {
        if ([data.isTop integerValue]==1) {
            [self.topImageView setHidden:NO];
        }
        else {
            [self.topImageView setHidden:YES];
        }
    }
    
    if ([data.uId isEqualToString:uId]) {
        [self.userTypeButton setTitle:@"圈主" forState:UIControlStateNormal];
        [self.userTypeButton setBackgroundImage:[UIImage imageNamed:@"quzhu_bg_80x32"] forState:UIControlStateNormal];
    }
    else {
        [self.userTypeButton setTitle:@"用户" forState:UIControlStateNormal];
        [self.userTypeButton setBackgroundImage:[UIImage imageNamed:@"user_bg_80x32"] forState:UIControlStateNormal];
    }
    
    [self.userTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //计算content的高度
    CGSize size = CGSizeMake(UIScreenWidth-30,4000);
    CGFloat contentHeight =0.0;
    if (data.content.length != 0) {
        CGSize labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        contentHeight = labelsize.height;
    }
    
    if (UIScreenWidth >=375) {
        if (contentHeight>100) {
            if (UIScreenWidth>375) {
                self.labelTopContraint.constant = -10;
            }
            else  {
                self.labelTopContraint.constant = 3;
            }
        }
        else if (contentHeight < 100 && contentHeight>30) {
            self.labelTopContraint.constant = 5;
        }
        else {
            self.labelTopContraint.constant = 12;
        }
    }
    CGFloat pictureHight = [ArticlePictureView height:data.imageList.count];
    if (pictureHight !=0) {
        self.pictureView.frame =CGRectMake(0, 82+contentHeight+10, UIScreenWidth, pictureHight);
        self.pictureView.delegate = self;
        [self.pictureView setData:data.imageList];
    }
    
    CGFloat voteHight= 0.0;
    if ([data.type integerValue]== 2) {
        voteHight = 61.0;
        [self.voteView setHidden:NO];
        if (pictureHight ==0) {
            self.voteView.frame = CGRectMake(0, 82+contentHeight+10, UIScreenWidth, 61);
        }
        else {
            self.voteView.frame = CGRectMake(0, 82+contentHeight+10+pictureHight+10, UIScreenWidth, 61);
        }
        [self.voteView setData:data];
    }
    else {
        [self.voteView setHidden:YES];
    }
  
    if (pictureHight ==0) {
        self.detailBottomView.frame =CGRectMake(0, 82+contentHeight+10+voteHight, UIScreenWidth, 40);
    }
    else {
        self.detailBottomView.frame = CGRectMake(0, 82+contentHeight+10+pictureHight+10+voteHight, UIScreenWidth, 40);
    }
    [self.detailBottomView setData:data];
}


+(CGFloat)height:(ArticleDetailModel *)data {
    //计算content的高度
    CGFloat cellHeight;
    CGSize size = CGSizeMake(UIScreenWidth-30,4000);
    CGFloat contentHeight =0.0;
    if (data.content.length != 0) {
        CGSize labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        contentHeight = labelsize.height;
    }
    CGFloat pictureHight = [ArticlePictureView height:data.imageList.count];
    CGFloat voteHight= 0.0;
    if ([data.type integerValue]==2) {
        voteHight = 61.0;
    }
    if (pictureHight ==0) {
        cellHeight = 82+contentHeight+10+voteHight+40;
    }
    else {
        cellHeight = 82+contentHeight+10+pictureHight+10+voteHight+40;
    }
    
    return cellHeight;
}

- (void)voteClick:(ArticleVoteView *)voteView withArticleId:(NSString *)articleId type:(NSString *)type {
    //获取indexPath
    UITableView * tableView;
    
    tableView = [self findContainingTableView];
    
    NSIndexPath * indexPath = [tableView indexPathForCell:self];
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(voteClick:atIndex:withArticleId:type:)]){
        [_delegate voteClick:voteView atIndex:indexPath.row withArticleId:articleId type:type];
    }
}

- (void)praiseClick:(NSString *)articleId {
    //获取indexPath
    UITableView * tableView;
    
    tableView = [self findContainingTableView];
    
    NSIndexPath * indexPath = [tableView indexPathForCell:self];
    //调用代理
    if (_delegate && [_delegate respondsToSelector:@selector(praise:forIndexPath:)]) {
        [_delegate praise:articleId forIndexPath:indexPath];
    }
}

- (void)cancelPraiseClick:(NSString *)articleId {
    //获取indexPath
    UITableView * tableView = [self findContainingTableView];
    NSIndexPath* indexPath = [tableView indexPathForCell:self];
    
    //调用代理
    if (_delegate && [_delegate respondsToSelector:@selector(cancelPraise:forIndexPath:)]) {
        [_delegate cancelPraise:articleId forIndexPath:indexPath];
    }
}


- (void)commentClick:(ArticleDetailModel *)data {
    if (_delegate && [_delegate respondsToSelector:@selector(commentClick:)]) {
        [_delegate commentClick:data];
    }
}

- (void)setArticle:(NSString *)articleId {
    //获取indexPath
    UITableView * tableView = [self findContainingTableView];
    NSIndexPath* indexPath = [tableView indexPathForCell:self];
    if (_delegate && [_delegate respondsToSelector:@selector(setArticle:forIndexPath:)]) {
        [_delegate setArticle:articleId forIndexPath:indexPath];
    }
}


- (void)imageClick:(ArticlePictureView *)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *)info {
    if (_delegate && [_delegate respondsToSelector:@selector(imageClick:atIndex:withInfo:)]) {
        [_delegate imageClick:pictureView atIndex:index withInfo:info];
    }
}

-(void)shareArticle:(NSString *)articleId {
    //获取indexPath
    UITableView * tableView = [self findContainingTableView];
    NSIndexPath* indexPath = [tableView indexPathForCell:self];
    if (_delegate && [_delegate respondsToSelector:@selector(shareArticle:forIndexPath:)]) {
        [_delegate shareArticle:articleId forIndexPath:indexPath];
    }
}

#pragma mark - 头像点击事件
-(void) headClick:(UIImageView *)sender{
    
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(userHeadClick:)]){
        [_delegate userHeadClick:_data.uId];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
