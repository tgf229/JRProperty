//
//  CommunityListCell.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/1.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CommunityListCell.h"
#import "JRDefine.h"

@implementation CommunityListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        pictureHight = 90;
    }
    else if (data.imageList.count >3){
//        pictureHight = imageHight*2+9;
        pictureHight = 90 + 3 + 90;
    }
    cellHeight = 69+contentHeight + 10 + pictureHight;
    return cellHeight;
}

@end
