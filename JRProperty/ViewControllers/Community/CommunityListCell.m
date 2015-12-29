//
//  CommunityListCell.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/1.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CommunityListCell.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h" //图片请求缓存
#import "LoginManager.h"
#import "ReportViewController.h"

@implementation CommunityListCell

- (void)awakeFromNib {
    //基本属性设置
    //头像圆形
    [self.headImageView.layer setCornerRadius:15.0];
    [self.headImageView.layer setMasksToBounds:YES];
    [self.headImageView setClipsToBounds:YES];
    //tableview 点击不变色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //字体颜色
    [self.nameLabel setTextColor:UIColorFromRGB(0x4093c6)];
    [self.timeLabel setTextColor:UIColorFromRGB(0x999999)];
    [self.contentLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.praiseButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    [self.commentButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
    //按钮与文字的间距
    [self.praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
    [self.commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
    
    self.detailModel = [[ArticleDetailModel alloc]init];
    self.communityService =[[CommunityService alloc]init];
    self.shareService = [[ShareToSnsService alloc]init];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCell:(ArticleDetailModel *)detailModel{
    _detailModel = detailModel;
    self.nameLabel.text = detailModel.nickName;
    self.timeLabel.text = detailModel.time;
    self.contentLabel.text = detailModel.content;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.imageUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    
    for (int i = [detailModel.imageList count]; i<6; i++) {
        UIImageView *imageview = self.imagesImageView[i];
        [imageview setImage:nil];
    }
    
    for (int j=0; j<[detailModel.imageList count]; j++) {
        ImageModel *model = detailModel.imageList[j];
        UIImageView *imageView = self.imagesImageView[j];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrlS] placeholderImage:[UIImage imageNamed:@"community_default"]];
        
//        UIButton *button = self.imagesButton[j];
//        button.tag = j;
//        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([@"1" isEqualToString: detailModel.isHot]) {
        [self.hotImageView setHidden:NO];
    }else {
        [self.hotImageView setHidden:YES];
    }
    
    if ([@"2" isEqualToString:detailModel.type] || [@"3" isEqualToString:detailModel.type]) {
        [self.voteImageView setHidden: NO];
    }else{
        [self.voteImageView setHidden:YES];
    }
    
    [self setData:detailModel];
}

-(void)setData:(ArticleDetailModel *)detailModel{
    if ([@"1" isEqualToString:detailModel.flag]) {
        [self.praiseButton setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateNormal];
        [self.praiseButton setImage:[UIImage imageNamed:@"like_36x36"] forState:UIControlStateHighlighted];
        [self.praiseButton removeTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [self.praiseButton addTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.praiseButton setImage:[UIImage imageNamed:@"like_36x36"] forState:UIControlStateNormal];
        [self.praiseButton setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateHighlighted];
        [self.praiseButton removeTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
        [self.praiseButton addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.praiseButton setTitle:detailModel.praiseNum forState:UIControlStateNormal];
    [self.commentButton setTitle:detailModel.commentNum forState:UIControlStateNormal];
}

- (void)praise {
    [UIView animateWithDuration:0.2 animations:^{
        _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _praiseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _praiseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];
    
    _detailModel.flag = @"1";
    int number = [_detailModel.praiseNum intValue]+1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    _detailModel.praiseNum =numberStr;
    [self setData:_detailModel];
    
    //调接口服务 赞
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.communityService Bus300802:CID_FOR_REQUEST aId:_detailModel.aId uId:uid     type:@"1" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)cancelPraise{
    [UIView animateWithDuration:0.2 animations:^{
        _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _praiseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _praiseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];
    
    _detailModel.flag = @"0";
    int number = [_detailModel.praiseNum intValue]-1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    _detailModel.praiseNum =numberStr;
    [self setData:_detailModel];
    
    //调接口服务 赞
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.communityService Bus300802:CID_FOR_REQUEST aId:_detailModel.aId uId:uid     type:@"0" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)moreClick:(id)sender
{
    BOOL is_super;
    if ([IS_SUPER_REQUEST intValue] == 2) {
        is_super = YES;
    }
    else {
        is_super = NO;
    }
    self.shareView = [[ShareView alloc]initViewIsAdmin:is_super isCreator:NO isTop:NO];
    self.shareView.delegate = self;
    [self.shareView show];
}

//举报 移动
- (void)didSelectOperationButton:(ArticleOperationType)operationType {
    [self.shareView dismissPage];
    //举报话题
    if (operationType == ArticleReport) {
        ReportViewController *controller = [[ReportViewController alloc]init];
        controller.articleId = _detailModel.aId;
        UIViewController *communityListController = [self getSuper];
        [communityListController.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType {
    [self.shareView dismissPage];
    
    self.shareService.actID = _detailModel.articleId;
    NSData *imageData = nil;
    NSData *bigImageData=nil;
    if (_detailModel.imageList.count>0) {
        ImageModel *image = [_detailModel.imageList objectAtIndex:0];
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlS]];
        bigImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlL]];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTP_SHARED_ARTICLE_URL,_detailModel.aId];
    
    NSString *fullMessage = [NSString stringWithFormat:@"%@\n%@%@",_detailModel.name,_detailModel.content,urlStr];
    
    [self.shareService showSocialPlatformIn:self
                                 shareTitle:_detailModel.name
                                  shareText:_detailModel.content
                                   shareUrl:urlStr
                            shareSmallImage:imageData
                              shareBigImage:bigImageData
                           shareFullMessage:fullMessage
                             shareToSnsType:platformType];
}

-(UIViewController *)getSuper{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//-(void) click:(UIButton*) sender{
//    //调用代理
//    if(_delegate && [_delegate respondsToSelector:@selector(imageClick:withInfo:)]){
//        [_delegate imageClick:sender.tag withInfo:self.detailModel.imageList];
//    }
//}

+(CGFloat)height:(ArticleDetailModel *)data {
    //如果类型为官方话题
    if ([@"4" isEqualToString:data.type] || [@"5" isEqualToString:data.type]) {
        return 180;
    }else{
        //计算content的高度
        CGFloat cellHeight;
        CGSize size = CGSizeMake(UIScreenWidth-65,4000);
        CGFloat contentHeight =0.0;
        if (data.content.length != 0) {
            CGSize labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            contentHeight = labelsize.height;
        }
        CGFloat pictureHight=0.0 ;
        CGFloat imageHight =( UIScreenWidth-50-20-3)/3;
        if (data.imageList.count > 0 && data.imageList.count<=3) {
                    pictureHight = imageHight+10;
//            pictureHight = 10 + 90;
        }
        else if (data.imageList.count >3){
                    pictureHight = imageHight*2+10+3;
//            pictureHight = 10 + 90 + 3 + 90;
        }
        cellHeight = 69+ (contentHeight>30?30:contentHeight) + pictureHight + 18+20+18;
        return cellHeight;
    }
}

@end
