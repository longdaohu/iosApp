//
//  HomeRoomVerticalCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/2.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomVerticalCell.h"
#import "HomeRoomApartmentItemCell.h"
#import "HomeRoomIndexFlatsObject.h"
#import "HomeRoomIndexFlatFrameObject.h"

@interface HomeRoomVerticalCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *bgView;
@property(nonatomic,strong)UIView *bottom_line;
@property(nonatomic,strong)UICollectionViewFlowLayout *flow;
@end


@implementation HomeRoomVerticalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        self.flow = flow;
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flow];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = XCOLOR_WHITE;
        collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self.contentView addSubview:collectionView];
        self.bgView = collectionView;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[HomeRoomApartmentItemCell class] forCellWithReuseIdentifier:@"HomeRoomApartmentItemCell"];
        collectionView.scrollEnabled = NO;

        
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_RANDOM;
        [self.contentView addSubview:line];
        self.bottom_line = line;
        
    }
    
    return self;
}

- (void)setGroup:(myofferGroupModel *)group{
    
    _group = group;
 
    HomeRoomIndexFrameObject *roomFrameObj = group.items.firstObject;
    self.flow.minimumLineSpacing = roomFrameObj.minimumLineSpacing;
    self.flow.minimumInteritemSpacing = roomFrameObj.minimumInteritemSpacing;
    self.items = roomFrameObj.flatsFrames;
}

- (void)bottomLineHiden:(BOOL)hiden{
    
    self.bottom_line.hidden = hiden;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    [self.bgView reloadData];
}

#pragma mark : <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    HomeRoomApartmentItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeRoomApartmentItemCell" forIndexPath:indexPath];
    cell.flatFrameObject = self.items[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    HomeRoomIndexFlatFrameObject *flatFrameObject = self.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(indexPath.row,flatFrameObject.item);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    HomeRoomIndexFlatFrameObject *FlatFrameObject = self.items[indexPath.row];
    return  CGSizeMake( FlatFrameObject.item_width , FlatFrameObject.item_height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize content_size = self.contentView.bounds.size;
 
    CGRect bg_frame = self.contentView.bounds;
    bg_frame.size.height = self.contentView.bounds.size.height - 10;
    self.bgView.frame = bg_frame;
 
    
    CGFloat line_x = 20;
    CGFloat line_h = 3;
    CGFloat line_y = content_size.height - line_h;
    CGFloat line_w = content_size.width - line_x * 2;
    self.bottom_line.frame = CGRectMake(line_x, line_y, line_w, line_h);
 
}

@end

