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
#import "HomeBannerObject.h"
#import "HomeRoomIndexCityObject.h"

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
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
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

- (void)setGroup:(myofferGroupModel *)group{
    
    _group = group;
    
    self.sectionType = group.type;
    
    if (group.type == SectionGroupTypeRoomCustomerPraise) {
      
        HomeRoomIndexFrameObject *roomFrameObj = group.items.firstObject;
        self.flow.minimumLineSpacing = roomFrameObj.minimumLineSpacing;
        self.flow.minimumInteritemSpacing = roomFrameObj.minimumInteritemSpacing;
        self.flow.itemSize = roomFrameObj.comment_item_size;
        
        self.items = roomFrameObj.item.comments;
        
    }else   if (group.type == SectionGroupTypeRoomHotCity) {
        
        HomeRoomIndexFrameObject *roomFrameObj = group.items.firstObject;
        self.flow.minimumLineSpacing = roomFrameObj.minimumLineSpacing;
        self.flow.minimumInteritemSpacing = roomFrameObj.minimumInteritemSpacing;
        self.flow.itemSize = roomFrameObj.hot_city_item_size;
        self.items = roomFrameObj.item.hot_city;
        
     } else if (group.type == SectionGroupTypeRoomApartmentRecommendation) {
        
        HomeRoomIndexFrameObject *roomFrameObj = group.items.firstObject;
        self.flow.minimumLineSpacing = roomFrameObj.minimumLineSpacing;
        self.flow.minimumInteritemSpacing = roomFrameObj.minimumInteritemSpacing;
        
        if (roomFrameObj.accommodationsFrames.count > 0) {
            
            HomeRoomIndexFlatFrameObject *flatFrameObj =  roomFrameObj.accommodationsFrames.firstObject;
            self.flow.itemSize = CGSizeMake(flatFrameObj.item_width, flatFrameObj.item_height);
            self.items = roomFrameObj.accommodationsFrames;
        }
 
    }else{
        
        self.items = group.items.firstObject;
    }
 
}


- (void)setSectionType:(SectionGroupType)sectionType{
    _sectionType = sectionType;

    NSString *cell = @"HomeSingleImageCell";
    if (sectionType == SectionGroupTypeRoomHotCity) {
         cell = @"HomeSingleImageCell";
    }
    if (sectionType == SectionGroupTypeRoomCustomerPraise) {
        cell = @"HomeRoomPraiseItemCell";
     }
    if (sectionType == SectionGroupTypeRoomApartmentRecommendation) {
        cell = @"HomeRoomApartmentItemCell";
     }
    if (sectionType == SectionGroupTypeBannerTheme) {
        CGFloat item_h =  185 * XSCREEN_WIDTH / 375.0;
        CGFloat item_w = item_h * 258.2/185;
        self.flow.itemSize = CGSizeMake(item_w, item_h);
        self.flow.minimumInteritemSpacing = 15.8;
        self.flow.minimumLineSpacing = 15.8;
         cell = @"HomeSingleImageCell";
    }
    [self.bgView registerClass:NSClassFromString(cell) forCellWithReuseIdentifier:cell];
}

- (void)setItems:(NSArray *)items{
    _items = items;
 
     [self.bgView reloadData];
}

#pragma mark : <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
     return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.sectionType == SectionGroupTypeRoomHotCity) {
        HomeSingleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSingleImageCell" forIndexPath:indexPath];
        cell.city = self.items[indexPath.row];
      
        return cell;
    }
 
    if (self.sectionType == SectionGroupTypeRoomCustomerPraise) {
        HomeRoomPraiseItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeRoomPraiseItemCell" forIndexPath:indexPath];
        cell.item =  self.items[indexPath.row];
        
        return cell;
    }

    if (self.sectionType == SectionGroupTypeRoomApartmentRecommendation) {
        HomeRoomApartmentItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeRoomApartmentItemCell" forIndexPath:indexPath];
        cell.flatFrameObject = self.items[indexPath.row];
 
        return cell;
    }
    
    if (self.sectionType == SectionGroupTypeBannerTheme) {
        HomeSingleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSingleImageCell" forIndexPath:indexPath];
        HomeBannerObject *item =  self.items[indexPath.row];
        cell.path = item.image;
        
        return cell;
    }
 
    UICollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.contentView.backgroundColor = XCOLOR_RANDOM;
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sectionType == SectionGroupTypeRoomCustomerPraise) return;
    
    id item = self.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(indexPath.row,item);
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgView) {
        self.group.cell_offset_x = scrollView.mj_offsetX;
    }
}

static  NSInteger  CollectionView_Current_Page = 0;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
 
    // 获取collectionView的宽度
    CGFloat collectionW = scrollView.bounds.size.width;
    CGFloat item_w = self.flow.itemSize.width;
    CGFloat item_margin = self.flow.minimumLineSpacing;
    // 获取当前的内容偏移量
    CGPoint target = CGPointMake(targetContentOffset -> x, targetContentOffset -> y);
    
    NSInteger index = (NSInteger)(0.5 + target.x/(item_w + item_margin));

    if (fabs(target.x) > fabs(scrollView.mj_offsetX)) {
        index = CollectionView_Current_Page + 1;
    }else{
        
        if (target.x > scrollView.mj_offsetX) {
//            NSLog(@"到左边了");
        }else   if ((scrollView.mj_offsetX+scrollView.mj_w) > scrollView.contentSize.width) {
//            NSLog(@"到右边了");
        }else{
            
            index = CollectionView_Current_Page - 1;
        }

    }

    CGFloat to_x  = index * (item_w + item_margin) - (collectionW - item_w) * 0.5;
    CollectionView_Current_Page  = index;

    targetContentOffset->x  = to_x;
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
 
    if (self.group.cell_offset_x == 0) {
        self.group.cell_offset_x = -self.bgView.contentInset.left;
    }
    [self.bgView setContentOffset:CGPointMake(self.group.cell_offset_x, 0) animated:NO];
}


@end
