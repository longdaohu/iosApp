//
//  HomeThirdTableViewCell.m
//  myOffer
//
//  Created by sara on 16/3/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HomeThirdTableViewCell.h"
#import "UniCollectionViewCell.h"
#import "HotUniversityFrame.h"

@interface HomeThirdTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *CollectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowlayout;

@end

@implementation HomeThirdTableViewCell

+(instancetype)cellInitWithTableView:(UITableView *)tableView
{
    static NSString *Identifier = @"third";
    
    HomeThirdTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell =[[HomeThirdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = XCOLOR_BG;
        [self makeCollectView];
        
     }
    return self;
}


-(void)makeCollectView
{
    
     UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowlayout = flowlayout;
    // 设置每一个cell的宽高 (cell在CollectionView中称之为item)
    CGFloat width = XScreenWidth * 0.6;
    CGFloat heigh = width * 1.3 + 20;
    
    flowlayout.itemSize = CGSizeMake(width,heigh);
    // 设置item行与行之间的间隙
//    flowlayout.minimumLineSpacing = 0;
    // 设置item列与列之间的间隙
//    flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
     flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, 0);//sectionInset的设置与item的宽高不一致会出现警报信息
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, heigh) collectionViewLayout:flowlayout];

    self.CollectionView                           = collectionView;
    collectionView.showsVerticalScrollIndicator   = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource                     = self;
    collectionView.delegate                       = self;
    collectionView.backgroundColor                = XCOLOR_BG;
    [self.CollectionView registerClass:[UniCollectionViewCell class] forCellWithReuseIdentifier:identify];
    [self.contentView  addSubview:self.CollectionView];
    
}


-(void)setUniFrames:(NSArray *)uniFrames
{
    _uniFrames = uniFrames;
    
    [self.CollectionView reloadData];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.uniFrames.count;
}

static NSString *identify = @"three";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     UniCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
     cell.uniFrame = self.uniFrames[indexPath.row];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(HomeThirdTableViewCell: andDictionary:)]) {
        
        HotUniversityFrame *uniFrame =  self.uniFrames[indexPath.row];
        
        [self.delegate HomeThirdTableViewCell:self andDictionary:uniFrame.universityDic];
     }
    
}


@end
