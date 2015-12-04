//
//  PraisePublishViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/11/26.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "PraisePublishViewController.h"
#import "PraisePublishSignCell.h"

@interface PraisePublishViewController ()

@end

@implementation PraisePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 40;
    
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.text =@"您好" ;
//    label.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
//    label.layer.borderWidth = 1;
//    [self.infoView addSubview:label];
    
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
    
    
    return signCell;

}

@end
