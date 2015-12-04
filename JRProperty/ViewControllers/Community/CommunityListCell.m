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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCell:(ArticleDetailModel *)detailModel{
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
    }

}

+(CGFloat)height:(ArticleDetailModel *)data {
    //计算content的高度
    CGFloat cellHeight;
    CGSize size = CGSizeMake(UIScreenWidth-65,4000);
    CGFloat contentHeight =0.0;
    if (data.content.length != 0) {
        CGSize labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        contentHeight = labelsize.height;
    }
    CGFloat pictureHight=0.0 ;
    CGFloat imageHight =( UIScreenWidth-68-8)/3;
    if (data.imageList.count > 0 && data.imageList.count<=3) {
//        pictureHight = imageHight+9;
        pictureHight = 10 + 90;
    }
    else if (data.imageList.count >3){
//        pictureHight = imageHight*2+9;
        pictureHight = 10 + 90 + 3 + 90;
    }
    cellHeight = 69+ (contentHeight>30?30:contentHeight) + pictureHight + 18+20+18;
    return cellHeight;
}

@end
