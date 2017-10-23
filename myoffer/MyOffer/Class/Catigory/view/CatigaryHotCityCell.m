//
//  CatigaryHotCityCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "CatigaryHotCityCell.h"
#import "CatigaryCityCollectionCell.h"
#import "CatigaryHotCity.h"


@interface CatigaryHotCityCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *CollectionView;
@property(nonatomic,strong)CALayer *bottom_line;

@end
@implementation CatigaryHotCityCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

static NSString *cityIdentify = @"hotCity";

+ (instancetype)cellInitWithTableView:(UITableView *)tableView
{
    
    CatigaryHotCityCell *cell =[tableView dequeueReusableCellWithIdentifier:cityIdentify];
    
    if (!cell) {
        
        cell =[[CatigaryHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityIdentify];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self makeCollectView];
        
        CALayer *line = [CALayer layer];
        self.bottom_line = line;
        line.backgroundColor = XCOLOR_line.CGColor;
        [self.contentView.layer addSublayer:line];
        
    }
    return self;
}


-(void)makeCollectView
{
   
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每一个cell的宽高 (cell在CollectionView中称之为item)
    flowlayout.itemSize = CGSizeMake(FLOWLAYOUT_CityW,FLOWLAYOUT_CityW);
    // 设置item列与列之间的间隙
    flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);//sectionInset的设置与item的宽高不一致会出现警报信息
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, FLOWLAYOUT_CityW) collectionViewLayout:flowlayout];
    
    self.CollectionView                           = collectionView;
    collectionView.showsVerticalScrollIndicator   = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource                     = self;
    collectionView.delegate                       = self;
    collectionView.backgroundColor                = XCOLOR_WHITE;
     [self.contentView  addSubview:self.CollectionView];
     [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CatigaryCityCollectionCell class] ) bundle:nil] forCellWithReuseIdentifier:identify];

    
}
-(void)setHot_cities:(NSArray *)hot_cities{

    _hot_cities = hot_cities;
    
//  [self.CollectionView  reloadData];
}

- (void)bottomLineShow:(BOOL)show{

    self.bottom_line.hidden = !show;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentsSize = self.bounds.size;
    
    self.bottom_line.frame = CGRectMake(10, contentsSize.height - 0.5 ,contentsSize.width , 0.5);
    
}


#pragma mark : UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.hot_cities.count;
}

static NSString *identify = @"cityCell";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CatigaryCityCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.city = self.hot_cities[indexPath.row];
 
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    CatigaryHotCity *hotCity = self.hot_cities[indexPath.row];
        
    if (self.actionBlock) self.actionBlock(hotCity.city);
    
}


@end
