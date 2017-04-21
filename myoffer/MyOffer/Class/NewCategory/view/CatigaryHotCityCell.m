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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellInitWithTableView:(UITableView *)tableView
{
    static NSString *Identifier = @"third";
    
    CatigaryHotCityCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell =[[CatigaryHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
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
    // 设置item行与行之间的间隙
    //    flowlayout.minimumLineSpacing = 0;
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


- (void)setHotCities:(NSArray *)hotCities{

    _hotCities = hotCities;
    
    [self.CollectionView  reloadData];
}


- (void)setLastCell:(BOOL)lastCell{

    _lastCell = lastCell;
    
    self.bottom_line.hidden = lastCell;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentsSize = self.bounds.size;
    
    self.bottom_line.frame = CGRectMake(10, contentsSize.height - 1,contentsSize.width , 1);
    
}


#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.hotCities.count + 1;
}

static NSString *identify = @"cityCell";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CatigaryCityCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (indexPath.row == self.hotCities.count) {

        cell.moreCity  =  YES;
        
    }else{
    
        cell.city = self.hotCities[indexPath.row];

    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (indexPath.row == self.hotCities.count) {
        
        if (self.actionBlock) {
            
            self.actionBlock(@"more");
        }
        
    }else{
    
        CatigaryHotCity *hotCity = self.hotCities[indexPath.row];
        
        if (self.actionBlock) {
            
            self.actionBlock(hotCity.city);
        }
        
    }

    
}


@end
