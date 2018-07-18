//
//  HomeUVICCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeUVICCell.h"
#import "HomeUVICserviceAdvantageCell.h"
#import "HomeUVICImmigrationProjectCell.h"

@interface HomeUVICCell ()<UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *serviceView;
@property(nonatomic,strong)NSArray *UVICServices;
@property(nonatomic,strong)NSArray *UVICImmigrationes;
@property (weak, nonatomic) IBOutlet UICollectionView *UVICImmigrationView;
@property (weak, nonatomic) IBOutlet UILabel *contactLab;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *service_flow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceView_constraint;



@end

@implementation HomeUVICCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.serviceView.scrollEnabled = NO;
    self.serviceView.clipsToBounds = NO;
    self.serviceView.dataSource = self;
    [self.serviceView registerNib:[UINib nibWithNibName:@"HomeUVICserviceAdvantageCell" bundle:nil] forCellWithReuseIdentifier:@"HomeUVICserviceAdvantageCell"];
 
    CGFloat margin = 15;
    CGFloat service_w =  (XSCREEN_WIDTH - 2 - 20 * 2);
    self.service_flow.minimumLineSpacing = margin;
    self.service_flow.minimumInteritemSpacing = margin;
    CGFloat service_item_w =  (service_w - margin * 2) /3;
    CGFloat service_item_h =  service_item_w;
    self.service_flow.itemSize = CGSizeMake(service_item_w, service_item_h);
    CGFloat service_h =   margin +  service_item_h * 2;
    self.serviceView_constraint.constant = service_h;
    
 
     self.UVICImmigrationView.dataSource = self;
    [self.UVICImmigrationView registerNib:[UINib nibWithNibName:@"HomeUVICImmigrationProjectCell" bundle:nil] forCellWithReuseIdentifier:@"HomeUVICImmigrationProjectCell"];
    
    NSString *web = @"www.uvic.com.cn访问官网查看更多";
    NSDictionary *attribtDic = @{ NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.contactLab.attributedText];
    [attribtStr addAttributes:attribtDic range:NSMakeRange(5, web.length)];
    self.contactLab.attributedText = attribtStr;
}

- (NSArray *)UVICImmigrationes{
    if (!_UVICImmigrationes) {
        
        _UVICImmigrationes = @[
                          @{
                              @"tag":@"项目一",
                              @"title":@"5万镑毕业生企业家移民",
                              @"summary":@"英国毕业生最便捷的留英之路",
                              @"icon":@"home_uvic_hot_01.jpg"
                              },
                          @{
                              @"tag":@"项目二",
                              @"title":@"企业家移民最低仅需10万镑",
                              @"summary":@"英企合伙人+高薪就业 事业身份双丰收",
                              @"icon":@"home_uvic_hot_02.jpg"
                              },
                          @{
                              @"tag":@"项目三",
                              @"title":@"英国投资移民仅40万镑",
                              @"summary":@"40万镑抵200万镑 移民买房两不误",
                              @"icon":@"home_uvic_hot_03.jpg"
                              }
                          ];
    }
    
    return _UVICImmigrationes;
}


- (NSArray *)UVICServices{
    if (!_UVICServices) {
        
        _UVICServices = @[
                          @{
                              @"title":@"访问签证",
                              @"icon":@"home_uvic_service_01.jpg",
                              },
                          @{
                              @"title":@"学生签证",
                              @"icon":@"home_uvic_service_02.jpg",
                              },
                          @{
                              @"title":@"家庭签证",
                              @"icon":@"home_uvic_service_03.jpg",
                              },
                          @{
                              @"title":@"工作签证",
                              @"icon":@"home_uvic_service_04.jpg",
                              },
                          @{
                              @"title":@"移民签证",
                              @"icon":@"home_uvic_service_05.jpg",
                              },
                          @{
                              @"title":@"永居签证",
                              @"icon":@"home_uvic_service_06.jpg",
                              },
                          ];
    }
    
    return _UVICServices;
}


#pragma mark : UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.serviceView) {
        
        return self.UVICServices.count;
    }
    
    return self.UVICImmigrationes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.serviceView) {
        
        HomeUVICserviceAdvantageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeUVICserviceAdvantageCell" forIndexPath:indexPath];
        cell.item  = self.UVICServices[indexPath.row];
        return cell;
    }
    
    HomeUVICImmigrationProjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeUVICImmigrationProjectCell" forIndexPath:indexPath];
    cell.item  = self.UVICImmigrationes[indexPath.row];

    return cell;
}
- (IBAction)webOnClicked:(id)sender {
    
    if (self.actionBlock) {
        self.actionBlock(@"http://uvic.com.cn/");
    }
    
}



@end

