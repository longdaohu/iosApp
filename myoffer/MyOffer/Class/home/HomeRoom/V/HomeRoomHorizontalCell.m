//
//  HomeRoomHorizontalCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/25.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomHorizontalCell.h"

#import "HomeRoomPraiseItemCell.h"
#import "HomeRoomApartmentItemCell.h"
#import "HomeSingleImageCell.h"

@interface HomeRoomHorizontalCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *bgView;
@property(nonatomic,strong)UIView *bottom_line;
@property(nonatomic,strong)UICollectionViewFlowLayout *flow;
@end


@implementation HomeRoomHorizontalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flow = flow;
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flow];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = XCOLOR_WHITE;
        collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self.contentView addSubview:collectionView];
        self.bgView = collectionView;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        collectionView.showsHorizontalScrollIndicator = NO;
        
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_RANDOM;
        [self.contentView addSubview:line];
        self.bottom_line = line;
        
    }
    
    return self;
}

- (void)bottomLineHiden:(BOOL)hiden{
    
    self.bottom_line.hidden = hiden;
}

- (void)setSectionType:(SectionGroupType)sectionType{
    _sectionType = sectionType;
    

    if (sectionType == SectionGroupTypeRoomHotCity) {
        
         self.flow.itemSize = CGSizeMake(115, 165);
         [self.bgView registerClass:[HomeSingleImageCell class] forCellWithReuseIdentifier:@"HomeSingleImageCell"];
    }

    if (sectionType == SectionGroupTypeRoomCustomerPraise) {
        
         self.flow.itemSize = CGSizeMake(255, 228);
         [self.bgView registerClass:[HomeRoomPraiseItemCell class] forCellWithReuseIdentifier:@"HomeRoomPraiseItemCell"];
    }

    if (sectionType == SectionGroupTypeRoomApartmentRecommendation) {
        self.flow.itemSize = CGSizeMake(235, 220);
        [self.bgView registerClass:[HomeRoomApartmentItemCell class] forCellWithReuseIdentifier:@"HomeRoomApartmentItemCell"];
    }
    
    if (sectionType == SectionGroupTypeRoomHomestay) {
        
        self.bgView.scrollEnabled = NO;
        self.flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat item_w =  (XSCREEN_WIDTH - 50) * 0.5;
        CGFloat item_h =  item_w  + 80;
        self.flow.itemSize = CGSizeMake( item_w , item_h);
        [self.bgView registerClass:[HomeRoomApartmentItemCell class] forCellWithReuseIdentifier:@"RoomHomestayCell"];
     }
    
    if (sectionType == SectionGroupTypeBannerTheme) {
        
        CGFloat item_h =  185 * XSCREEN_WIDTH / 375.0;
        CGFloat item_w = item_h * 258.2/185;
        self.flow.itemSize = CGSizeMake(item_w, item_h);
        self.flow.minimumInteritemSpacing = 15.8;
        [self.bgView registerClass:[HomeSingleImageCell class] forCellWithReuseIdentifier:@"HomeSingleImageCell"];
    }
 

}

#pragma mark : <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.sectionType == SectionGroupTypeRoomHotCity) {
 
        HomeSingleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSingleImageCell" forIndexPath:indexPath];
 
        return cell;
    }
    
    if (self.sectionType == SectionGroupTypeBannerTheme) {
        
        HomeSingleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSingleImageCell" forIndexPath:indexPath];
        NSDictionary *item =  self.items[indexPath.row];
        NSDictionary *images = item[@"images"];
        NSDictionary *app = images[@"app"];
        cell.path = app[@"url"];
        
        return cell;
    }
 
    if (self.sectionType == SectionGroupTypeRoomCustomerPraise) {
 
        HomeRoomPraiseItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeRoomPraiseItemCell" forIndexPath:indexPath];
 
        return cell;
    }

    if (self.sectionType == SectionGroupTypeRoomApartmentRecommendation) {
        HomeRoomApartmentItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeRoomApartmentItemCell" forIndexPath:indexPath];
 
        return cell;
    }
    
    if (self.sectionType == SectionGroupTypeRoomHomestay) {
        HomeRoomApartmentItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomHomestayCell" forIndexPath:indexPath];
        cell.isHomestay = YES;
 
        return cell;
    }

    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.contentView.backgroundColor = XCOLOR_RANDOM;
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item =  self.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(indexPath.row,item);
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize content_size = self.contentView.bounds.size;
    
    if (self.sectionType == SectionGroupTypeRoomHomestay) {
 
        CGRect bg_frame = self.contentView.bounds;
        bg_frame.size.height = self.contentView.bounds.size.height - 10;
        self.bgView.frame = bg_frame;
        
    }else{
        
        CGRect bg_frame = self.contentView.bounds;
        bg_frame.size.height = self.flow.itemSize.height;
        self.bgView.frame = bg_frame;
    }
 
    CGFloat line_x = 20;
    CGFloat line_h = 3;
    CGFloat line_y = content_size.height - line_h;
    CGFloat line_w = content_size.width - line_x * 2;
    self.bottom_line.frame = CGRectMake(line_x, line_y, line_w, line_h);
}


@end
