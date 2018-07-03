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
@property (weak, nonatomic) IBOutlet UICollectionView *uvicAdvantView;
@property(nonatomic,strong)NSArray *UVICAdvantes;
@property(nonatomic,strong)NSArray *UVICImmigrationes;
@property (weak, nonatomic) IBOutlet UICollectionView *UVICImmigrationView;

@end

@implementation HomeUVICCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
    self.uvicAdvantView.clipsToBounds = NO;
    self.uvicAdvantView.dataSource = self;
    [self.uvicAdvantView registerNib:[UINib nibWithNibName:@"HomeUVICserviceAdvantageCell" bundle:nil] forCellWithReuseIdentifier:@"HomeUVICserviceAdvantageCell"];
    
    self.UVICImmigrationView.clipsToBounds = NO;
    self.UVICImmigrationView.dataSource = self;
    [self.UVICImmigrationView registerNib:[UINib nibWithNibName:@"HomeUVICImmigrationProjectCell" bundle:nil] forCellWithReuseIdentifier:@"HomeUVICImmigrationProjectCell"];
    
}

- (NSArray *)UVICAdvantes{
    if (!_UVICAdvantes) {
        
        _UVICAdvantes = @[
                          @{
                              @"title":@"最权威的留学机构",
                              @"summary":@"UVIC 是英国一百多所大学的官方合作机构，是目前英国规模最大最具权威的教育机构。\n UVIC 是英国第一家被 UCAS、OISC、ILPA、IOL 四大政府机构同时颁发运营牌照的专业机构。\n UVIC 是唯一的一家外资背景获得中国教育部留学服务牌照的公司。",
                              @"icon":@"home_uvic_ukVisa_c.jpg"
                              },
                          @{
                              @"title":@"最大规模的大学展",
                              @"summary":@"UVIC 英国教育签证中心举办的 UniFair 环球大学展是全球规模和影响力最大的大学展之一，与包括牛津大学等 90 所英、美、澳大学直接交流，每届展会都会吸引来自全球近百所知名大学以及数千位来自超过 100 个不同国籍的留学生参加，成为留学生面对面接触大学招生主管老师的重要渠道。",
                              @"icon":@"home_uvic_ukVisa_d.jpg"
                              },
                          @{
                              @"title":@"最专业的留学导师",
                              @"summary":@"UVIC 精英团队有着数十年的教育咨询经验，海量成功案例。UVIC 是英国文化协会 British Council、澳大利亚 QEAC 授权的全球官方教育推广机构，由各国高校招生主管定期培训，保证留学团队随时掌握高校最新招生资讯，确保学生可以选择到最适合且最理想的学校。",
                              @"icon":@"home_uvic_ukVisa_a.jpg"
                              },
                          @{
                              @"title":@"最完善的留学生服务",
                              @"summary":@"UVIC 也在积极提供在境外的各类后续服务，从签证申请、留学公寓、学费汇款、超级导师 ®、境外生活服务，到留学生实习 / 职业 / 创业培训，为国际学生尽早融入海外社会和跨境文化提供最全面的支持。",
                              @"icon":@"home_uvic_ukVisa_e.jpg"
                              },
                          @{
                              @"title":@"广泛的影响力",
                              @"summary":@"UVIC 在帮助跨境人士的同时，也为大量留学中介机构、境外大学和学院提供专业的英国教育支持，协助合作机构的学生申请英国大学，提供完善的留学后续服务。",
                              @"icon":@"home_uvic_ukVisa_b.jpg"
                              }
                          ];
    }
    
    return _UVICAdvantes;
}


- (NSArray *)UVICImmigrationes{
    if (!_UVICImmigrationes) {
        
        _UVICImmigrationes = @[
                          @{
                              @"title":@"项目优势",
                              @"items":@[
                                            @{
                                                 @"key":@"国家福利",
                                                 @"value":@"享受免费医疗、子女教育"
                                                 },
                                            @{
                                                @"key":@"资金安全",
                                                @"value":@"英国国债是世界上评级前列的国债"
                                                },
                                            @{
                                                @"key":@"条件宽松",
                                                @"value":@"无管理经验，无语言、学历、背景等要求"
                                                },
                                            @{
                                                @"key":@"离境宽松",
                                                @"value":@"自由进出英国，家属没有离境时间限制（无移民监）"
                                                },
                                            @{
                                                @"key":@"办理周期短",
                                                @"value":@"从递交申请到获批首次签证平均 3-6 个月"
                                                }
                                      ]
                              },
                          
                          @{
                              @"title":@"申请条件",
                              @"items":@[
                                      @{
                                          @"key":@"条件一",
                                          @"value":@"申请人年满 18 周岁，无犯罪记录"
                                          },
                                      @{
                                          @"key":@"条件二",
                                          @"value":@"可携带配偶及 18 周岁以下的子女 "
                                          },
                                      @{
                                          @"key":@"条件三",
                                          @"value":@"200 万英镑投资于英国政府指定的金融机构并购买国债、企业债、股票等金融产品，5 年后本息返还，转为永久居民"
                                          }
                                      ]
                              }
                          ];
    }
    
    return _UVICImmigrationes;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark : UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.uvicAdvantView) {
        
        return self.UVICAdvantes.count;
    }
    
    return self.UVICImmigrationes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.uvicAdvantView) {
        
        HomeUVICserviceAdvantageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeUVICserviceAdvantageCell" forIndexPath:indexPath];
        cell.item  = self.UVICAdvantes[indexPath.row];
        return cell;
    }
    
    HomeUVICImmigrationProjectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeUVICImmigrationProjectCell" forIndexPath:indexPath];
    cell.item  = self.UVICImmigrationes[indexPath.row];
    
    return cell;
}


@end

