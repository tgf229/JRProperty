//
//  ArticleDetailHeadView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleDetailHeadView.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "JRDefine.h"
@implementation ArticleDetailHeadView

-(void)initial {
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    [self.headImageView addGestureRecognizer:singleTap];
    self.nicknameLabel.textColor = [UIColor getColor:@"4093c6"];
    self.timeLabel.textColor = [UIColor getColor:@"999999"];
//    self.comeLabel.textColor = [UIColor getColor:@"888888"];
//    self.circleNameLabel.textColor = [UIColor getColor:@"4a5f8b"];
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, UIScreenWidth-30, 0)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor getColor:@"333333"];
    self.contentLabel.userInteractionEnabled = YES;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines =0;
    [self addSubview:self.contentLabel];
    self.pictureView = [[ArticlePictureView alloc]initWithFrame:CGRectMake(15, 0, UIScreenWidth, 0)];
    self.pictureView.delegate = self;
    [self addSubview:self.pictureView];
    self.voteView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleVoteView" owner:self options:nil]objectAtIndex:0];
    [self.voteView initial];
    self.voteView.delegate = self;
    [self addSubview:self.voteView];
    
    self.voteCustomView = [[VoteListView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0)];
    [self addSubview:self.voteCustomView];
}

- (void)setData:(ArticleDetailModel *)data {
    _data = data;
    self.nicknameLabel.text = data.nickName;
    _commentBumLabel.text = [NSString stringWithFormat:@"评论 %@",self.data.commentNum];
    self.timeLabel.text = data.time;
    if ([@"1" isEqualToString: data.isHot]) {
        [self.hotImageView setHidden:NO];
    }else {
        [self.hotImageView setHidden:YES];
    }
    
    if ([@"2" isEqualToString:data.type] || [@"3" isEqualToString:data.type]) {
        [self.voteImageView setHidden: NO];
    }else{
        [self.voteImageView setHidden:YES];
    }
    
//    self.circleNameLabel.text = data.name;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
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
        else {
            self.url = nil;
        }
        frontString = [content substringToIndex:match.range.location];
        
        behindString = [content substringWithRange:NSMakeRange(match.range.location+match.range.length,content.length-frontString.length-substringForMatch.length)];
    }
    
    UIColor  *color1 = [UIColor getColor:@"4a5f8b"];
    UITapGestureRecognizer *singleTap;
    CGSize size = CGSizeMake(UIScreenWidth-30,4000);
    CGFloat contentHeight =0.0;
    if (data.content.length != 0) {
        CGSize labelsize;
        labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        contentHeight = labelsize.height;
    }
    self.contentLabel.frame =CGRectMake(15, 65, UIScreenWidth-30, contentHeight);

    if (substringForMatch.length ==0) {
        self.contentLabel.text = data.content;
        [self.contentLabel removeGestureRecognizer:singleTap];
        self.contentLabel.userInteractionEnabled = NO;
    }
    else {
        self.contentLabel.userInteractionEnabled = YES;
        NSString *contentStr = [NSString stringWithFormat:@"%@网页链接%@",frontString,behindString];
        NSMutableAttributedString  *tempMutableStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        if (frontString.length>0) {
            [tempMutableStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(frontString.length, 4)];
        }
        else {
            [tempMutableStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 4)];
        }
        self.contentLabel.userInteractionEnabled = YES;

        self.contentLabel.attributedText = tempMutableStr;
       singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(linkClick:)];
        [self.contentLabel addGestureRecognizer:singleTap];
        
    } 

    if ([data.userLevel isEqualToString:@"1"]) {
        [self.daVip setHidden:NO];
    }
    else {
        [self.daVip setHidden:YES];
    }
    
    CGFloat pictureHight = [ArticlePictureView height:data.imageList.count];
       self.pictureView.frame =CGRectMake(0, 65+contentHeight+10, UIScreenWidth, pictureHight);
    [self.pictureView setData:data.imageList];
    CGFloat voteHight= 0.0;
    if ([data.type integerValue]== 2) {
        voteHight = 90;
        [self.voteView setHidden:NO];
        if (pictureHight ==0) {
            self.voteView.frame = CGRectMake(0, 65+contentHeight+10, UIScreenWidth, 90);
        }
        else {
            self.voteView.frame = CGRectMake(0, 65+contentHeight+10+pictureHight+10, UIScreenWidth, 90);
        }
        [self.voteView setData:data];
    }
    else {
        [self.voteView setHidden:YES];
    }
    if ([data.type integerValue]== 3) {
        if ([data.voteList count] == 0) {
            [self.voteCustomView setHidden:YES];
        }else{
            voteHight = 72 * data.voteList.count;
//            CGFloat voteWidth = UIScreenWidth -130;
            
            [self.voteCustomView setHidden:NO];
            if (pictureHight ==0) {
                self.voteCustomView.frame = CGRectMake(0, 65+contentHeight+10, UIScreenWidth, voteHight);
            }
            else {
                self.voteCustomView.frame = CGRectMake(0, 65+contentHeight+10+pictureHight+10, UIScreenWidth, voteHight);
            }
//            self.voteCustomView initWithFrame:<#(CGRect)#>
            [self.voteCustomView initial:data];
        }
    }else{
        [self.voteCustomView setHidden:NO];
    }
}


+(CGFloat) height:(ArticleDetailModel *)data {
    //计算content的高度
    CGFloat height;
    CGSize size = CGSizeMake(UIScreenWidth-30,4000);
    CGFloat contentHeight =0.0;
    if (data.content.length != 0) {
        CGSize labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        contentHeight = labelsize.height;
    }
    CGFloat pictureHight = [ArticlePictureView height:data.imageList.count];
    CGFloat voteHight= 0.0;
    if ([data.type integerValue]==2) {
        voteHight = 90;
    }
    else if([data.type integerValue] == 3){
        voteHight = 72*data.voteList.count+20;
    }
    if (pictureHight ==0) {
        if (voteHight>0) {
            height = 95+contentHeight+10+voteHight+1;
        }
        else {
            height = 95+contentHeight+10;
        }
    }
    else {
        if (voteHight >0) {
            height = 95+contentHeight+10+pictureHight+10+voteHight+1;
        }
        else {
            height = 95+contentHeight+10+pictureHight+20;
        }
    }
    return height;
}


#pragma mark - 头像点击事件
-(void) headClick:(UIImageView *)sender{
    
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(userHeadClick:)]){
        [_delegate userHeadClick:_data.uId];
    }
}

-(void) linkClick:(UIImageView *)sender{
    
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(selectUrl:)]){
        [_delegate selectUrl:self.url];
    }
}
- (void)voteClick:(ArticleVoteView *)voteView withArticleId:(NSString *)articleId type:(NSString *)type voteId:(NSString *)voteId {
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(voteClick:type:voteId:)]){
        [_delegate voteClick:voteView type:type voteId:voteId];
    }
}

- (void)imageClick:(ArticlePictureView *)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *)info {
    if(_delegate && [_delegate respondsToSelector:@selector(imageClick:atIndex:withInfo:)]){
        [_delegate imageClick:pictureView atIndex:index withInfo:info];
    }
}


@end
