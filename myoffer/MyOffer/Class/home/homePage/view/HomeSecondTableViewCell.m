//
//  HomeSecondTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "SecondCollectionViewCell.h"
#import "HomeSecondTableViewCell.h"
@interface HomeSecondTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *CollectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowlayout;

@end

@implementation HomeSecondTableViewCell
+(instancetype)cellInitWithTableView:(UITableView *)tableView
{
    static NSString *Identifier = @"second";
    
    HomeSecondTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        
        cell =[[HomeSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        
    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

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
//    CGFloat width =  0.5*(XScreenWidth  - 30);
//    CGFloat heigh =  XScreenWidth *0.4;
//    flowlayout.itemSize = CGSizeMake(width,heigh);
//    // 设置item行与行之间的间隙
//    flowlayout.minimumLineSpacing = ITEM_MARGIN;
    // 设置item列与列之间的间隙
    flowlayout.minimumInteritemSpacing = 0;
 
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
     self.CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, 2 * XScreenWidth *0.4) collectionViewLayout:flowlayout];
     self.CollectionView.dataSource = self;
     self.CollectionView.delegate = self;
     [self.CollectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:identify];
     self.CollectionView.backgroundColor = XCOLOR_BG;
    
    [self.contentView  addSubview:self.CollectionView];
    
    
}


-(void)setItems:(NSArray *)items
{
    _items = items;
    
    NSInteger column = (NSInteger)(items.count * 0.5 + 0.5);
    
    CGFloat collectionx  = 0;
    CGFloat collectiony  = 0;
    CGFloat collectionw  = XScreenWidth;
    CGFloat collectionh  = column *  XScreenWidth * 0.4;
    self.CollectionView.frame =  CGRectMake(collectionx,collectiony,collectionw,collectionh);
    
    CGFloat width =  0.5 * (XScreenWidth - 3 * ITEM_MARGIN);
    CGFloat heigh =  (collectionh - ( column + 1 )* ITEM_MARGIN )/ column;
    self.flowlayout.itemSize = CGSizeMake(width,heigh);
 
    [self.CollectionView reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

 }


#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
     return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
     return  self.items.count;
}

static NSString *identify = @"two";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SecondCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
  
    cell.itemInfo = self.items[indexPath.row];
     
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    if ([self.delegate respondsToSelector:@selector(HomeSecondTableViewCell:andDictionary:)]) {
        
        [self.delegate HomeSecondTableViewCell:self andDictionary:self.items[indexPath.row]];
        
    }
    
}


@end
