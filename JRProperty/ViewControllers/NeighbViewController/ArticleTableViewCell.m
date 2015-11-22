//
//  ArticleTableViewCell.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#import "JRDefine.h"
#import "ArticleTableViewCell.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "UITableViewCell+FindContainer.h"
#import "LoginManager.h"
@implementation ArticleTableViewCell


- (void)awakeFromNib {

    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 20;
    self.userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    [self.userImageView addGestureRecognizer:singleTap];
    self.nickName.textColor = [UIColor getColor:@"384d78"];
    self.timeLabel.textColor = [UIColor getColor:@"888888"];
    self.comeLabel.textColor = [UIColor getColor:@"888888"];
    self.circleNameLabel.textColor = [UIColor getColor:@"576b96"];
    [self.topIcon setHidden:YES];
    [self.userType setHidden:YES];
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 78, UIScreenWidth-30, 0)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.userInteractionEnabled = YES;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines =0;
    [self addSubview:self.contentLabel];
    self.pictureView = [[ArticlePictureView alloc]initWithFrame:CGRectMake(15, 0, UIScreenWidth, 0)];
    [self addSubview:self.pictureView];
    self.voteView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleVoteView" owner:self options:nil]objectAtIndex:0];
    [self.voteView initial];
    self.voteView.delegate = self;
    [self addSubview:self.voteView];
   
    self.bottomView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleBottom" owner:self options:nil]objectAtIndex:0];
    [self.bottomView initial];
    self.bottomView.delegate =self;
    [self addSubview:self.bottomView];
}

- (void)isDetailPage:(BOOL)isDetail{
    self.isDetailPage = isDetail;
}
- (void)setData:(ArticleDetailModel *)data createUid:(NSString *)uId{
    _data = data;
    self.nickName.text = data.nickName;
    self.timeLabel.text = data.time;
    self.circleNameLabel.text = data.name;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    //判断是否含有URL
    NSString *content = data.content;
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    NSString* substringForMatch;
    NSString *frontString;
    NSString *behindString;
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        substringForMatch = [content substringWithRange:match.range];
        if (substringForMatch.length !=0) {
            self.url = [NSURL URLWithString:substringForMatch];
        }
        frontString = [content substringToIndex:match.range.location];
        
        behindString = [content substringWithRange:NSMakeRange(match.range.location+match.range.length,content.length-frontString.length-substringForMatch.length)];
    }
    UITapGestureRecognizer *singleTap;
    UIColor  *color2 = [UIColor getColor:@"4a5f8b"];
    //计算文本高度
    CGSize size = CGSizeMake(UIScreenWidth-30,4000);
    CGFloat contentHeight =0.0;
    CGSize labelsize ;
//    if (data.content.length != 0) {
//        
//    }
    labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    contentHeight = labelsize.height;
    self.contentLabel.frame =CGRectMake(15, 78, UIScreenWidth-30, contentHeight);

    if (substringForMatch.length ==0) {
        
        self.contentLabel.text = data.content;
        [self.contentLabel removeGestureRecognizer:singleTap];
        self.contentLabel.userInteractionEnabled =NO;
    }
    else {
        NSString *contentStr = [NSString stringWithFormat:@"%@网页链接%@",frontString,behindString];
        NSMutableAttributedString  *tempMutableStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        if (frontString.length>0) {
            [tempMutableStr addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(frontString.length, 4)];
        }
        else {
            [tempMutableStr addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0, 4)];
        }
        
        self.contentLabel.attributedText = tempMutableStr;
        self.contentLabel.userInteractionEnabled =YES;

        singleTap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linkClick:)];
        [self.contentLabel addGestureRecognizer:singleTap];
        
    }
    

    if ([data.userLevel isEqualToString:@"1"]) {
        [self.vip setHidden:NO];
    }
    else {
        [self.vip setHidden:YES];
    }
 
    CGFloat pictureHight = [ArticlePictureView height:data.imageList.count];
        self.pictureView.frame =CGRectMake(0, 78+contentHeight+10, UIScreenWidth, pictureHight);
        self.pictureView.delegate = self;
        [self.pictureView setData:data.imageList];
    
    CGFloat voteHight= 0.0;
    if ([data.type integerValue]== 2) {
        voteHight = 61.0;
         [self.voteView setHidden:NO];
        if (pictureHight ==0) {
            self.voteView.frame = CGRectMake(0, 78+contentHeight+10, UIScreenWidth, 61);
        }
        else {
            self.voteView.frame = CGRectMake(0, 78+contentHeight+10+pictureHight+10, UIScreenWidth, 61);
        }
        [self.voteView setData:data];
    }
    else {
        [self.voteView setHidden:YES];
    }
    if (self.isDetailPage) {
        [self.circleNameLabel setHidden:YES];
        [self.comeLabel setHidden:YES];
        if (data.isTop.length !=0) {
            if ([data.isTop integerValue]==1) {
                [self.topIcon setHidden:NO];
            }
            else {
                [self.topIcon setHidden:YES];
            }
        }
        else {
             [self.topIcon setHidden:YES];
        }
        [self.userType setHidden:NO];
        if ([data.uId isEqualToString:uId]) {
            [self.userType setTitle:@"圈主" forState:UIControlStateNormal];
            [self.userType setBackgroundImage:[UIImage imageNamed:@"quzhu_bg_80x32"] forState:UIControlStateNormal];
        }
        else {
            [self.userType setTitle:@"用户" forState:UIControlStateNormal];
            [self.userType setBackgroundImage:[UIImage imageNamed:@"user_bg_80x32"] forState:UIControlStateNormal];
        }

        [self.userType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (pictureHight ==0) {
        self.bottomView.frame =CGRectMake(0, 78+contentHeight+10+voteHight, UIScreenWidth, 30);
    }
    else {
        self.bottomView.frame = CGRectMake(0, 78+contentHeight+10+pictureHight+10+voteHight, UIScreenWidth, 30);
    }
    [self.bottomView setData:data];
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
        cellHeight = 78+contentHeight+10+voteHight+30;
    }
    else {
        cellHeight = 78+contentHeight+10+pictureHight+10+voteHight+30;
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

//- (void)setArticle:(NSString *)articleId {
//    //获取indexPath
//    UITableView * tableView = [self findContainingTableView];
//    NSIndexPath* indexPath = [tableView indexPathForCell:self];
//    if (_delegate && [_delegate respondsToSelector:@selector(setArticle:forIndexPath:)]) {
//        [_delegate setArticle:articleId forIndexPath:indexPath];
//    }
//}


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


-(void) linkClick:(UIImageView *)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(selectUrl:)]){
        [_delegate selectUrl:self.url];
    }
}
@end
