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
    flowlayout.itemSize = CGSizeMake(FLOWLAYOUT_CityW,FLOWLAYOUT_CityW);
    flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);//sectionInset的设置与item的宽高不一致会出现警报信息
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, FLOWLAYOUT_CityW) collectionViewLayout:flowlayout];
    self.CollectionView   = collectionView;
    collectionView.showsVerticalScrollIndicator  = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource  = self;
    collectionView.delegate  = self;
    collectionView.backgroundColor  = XCOLOR_WHITE;
    [self.contentView  addSubview:self.CollectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CatigaryCityCollectionCell class] ) bundle:nil] forCellWithReuseIdentifier:identify];
    
}

- (void)bottomLineShow:(BOOL)show{

    self.bottom_line.hidden = !show;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentsSize = self.bounds.size;
    
    CGFloat b_x =  ITEM_MARGIN;
    CGFloat b_w =  contentsSize.width;
    CGFloat b_h =  LINE_HEIGHT;
    CGFloat b_y =  contentsSize.height - b_h;
    self.bottom_line.frame = CGRectMake(b_x, b_y ,b_w, b_h);
    
}


#pragma mark: UICollectionViewDataSource UICollectionViewDelegate

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
