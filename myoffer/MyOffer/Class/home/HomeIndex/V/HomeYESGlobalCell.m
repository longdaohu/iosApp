//
//  HomeYESGlobalCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYESGlobalCell.h"
#import "HomeYESUserCell.h"
#import "HomeSingleImageCell.h"

@interface HomeYESGlobalCell ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *fixView;
@property (weak, nonatomic) IBOutlet UICollectionView *advantageView;
@property(nonatomic,strong) NSArray *YESUsers;
@property(nonatomic,strong) NSArray *advantes;
@property (weak, nonatomic) IBOutlet UIView *projectView1;
@property (weak, nonatomic) IBOutlet UIView *projectView2;
@property (weak, nonatomic) IBOutlet UIView *projectView3;
@property (weak, nonatomic) IBOutlet UIView *Whatget012;
@property (weak, nonatomic) IBOutlet UIView *Whatget014;
@property (weak, nonatomic) IBOutlet UIView *Whatget013;
@property (weak, nonatomic) IBOutlet UIView *Whatget011;
@property (weak, nonatomic) IBOutlet UIView *Whatget01;
@property (weak, nonatomic) IBOutlet UIView *Whatget02;
@property (weak, nonatomic) IBOutlet UIView *Whatget03;
@property (weak, nonatomic) IBOutlet UIView *Whatget04;
@property (weak, nonatomic) IBOutlet UIView *Whatget05;
@property (weak, nonatomic) IBOutlet UIView *Whatget06;
@property (weak, nonatomic) IBOutlet UIView *Whatget08;
@property (weak, nonatomic) IBOutlet UIView *Whatget07;
@property (weak, nonatomic) IBOutlet UIView *Whatget09;
@property (weak, nonatomic) IBOutlet UIView *Whatget010;

@property(nonatomic,strong)NSArray *projectViews;
@property(nonatomic,strong)CAShapeLayer *shadowLayer;

@end


@implementation HomeYESGlobalCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.fixView.dataSource = self;
    self.advantageView.dataSource = self;
    [self.fixView registerClass:[HomeYESUserCell class] forCellWithReuseIdentifier:@"HomeYESUserCell"];
    [self.advantageView registerClass:[HomeSingleImageCell class] forCellWithReuseIdentifier:@"HomeSingleImageCell2"];
 
    self.projectViews = @[self.Whatget01,self.Whatget02,self.Whatget03,self.Whatget04,self.Whatget05,self.Whatget06,self.Whatget07,self.Whatget08,self.Whatget09,self.Whatget010,self.Whatget011,self.Whatget012,self.Whatget013,self.Whatget014,self.projectView1,self.projectView2,self.projectView3];
    
 
}


- (NSArray *)YESUsers{
    if (!_YESUsers) {
        
        _YESUsers = @[
                          @{
                              @"title":@"正在进行留学规划",
                              @"icon":@"home_global_user_01.jpg"
                              },
                          @{
                              @"title":@"申请名校背景不足",
                              @"icon":@"home_global_user_02.jpg"
                              },
                          @{
                              @"title":@"欠缺专业社会实践经验",
                              @"icon":@"home_global_user_03.jpg"
                              },
                          @{
                              @"title":@"在英求职受到签证困扰",
                              @"icon":@"home_global_user_04.jpg"
                              },
                          @{
                              @"title":@"渴望归国寻找就业机会",
                              @"icon":@"home_global_user_05.jpg"
                              },
                          @{
                              @"title":@"尚欠缺国内求职经验",
                              @"icon":@"home_global_user_06.jpg"
                              },
                          @{
                              @"title":@"尚无职业规划",
                              @"icon":@"home_global_user_07.jpg"
                              },
                          @{
                              @"title":@"寻求专业评估指导",
                              @"icon":@"home_global_user_08.jpg"
                              },
                          @{
                              @"title":@"渴望进入名企实习",
                              @"icon":@"home_global_user_09.jpg"
                              },
                          @{
                              @"title":@"或全职工作的在校学生及在职人员",
                              @"icon":@"home_global_user_010.jpg"
                              }
                          
                          ];
    }
    
    return _YESUsers;
}


- (NSArray *)advantes{
    if (!_advantes) {
        
        _advantes = @[
                      @{
                          @"name":@"",
                          @"icon":@"home_global_ad_01.jpg"
                          },
                      @{
                          @"name":@"",
                          @"icon":@"home_global_ad_02.jpg"
                          },
                      @{
                          @"name":@"",
                          @"icon":@"home_global_ad_03.jpg"
                          }
                      
                      ];
    }
    
    return _advantes;
}

#pragma mark : UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.advantageView) {
        return self.advantes.count;
    }

    return self.YESUsers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.advantageView) {
        
        HomeSingleImageCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSingleImageCell2" forIndexPath:indexPath];
        cell.item = self.advantes[indexPath.row];
        
        return cell;

    }
    
    HomeYESUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeYESUserCell" forIndexPath:indexPath];
    cell.item  = self.YESUsers[indexPath.row];
    
    return cell;
}

- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor = XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 0);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.05;
        _shadowLayer = shaper;

        [self.contentView.layer insertSublayer:shaper below:self.projectView1.layer];
    }
    
    return _shadowLayer;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
 
    UIBezierPath *path;
    for (NSInteger index = 0; index < self.projectViews.count; index++) {
        UIView *item =  self.projectViews[index];
        if (index == 0) {
            path = [UIBezierPath bezierPathWithRect:item.frame];
        }else{
            [path appendPath: [UIBezierPath bezierPathWithRect:item.frame]];
        }
    }
    self.shadowLayer.shadowPath = path.CGPath;
 
 
}


@end



