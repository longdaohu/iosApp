//
//  HomeApplicationDestinationCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/11.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeApplicationDestinationCell.h"
#import "HomeSingleImageCell.h"

@interface HomeApplicationDestinationCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIImageView *rankView;


@end

@implementation HomeApplicationDestinationCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    CGFloat item_h = 164;
    CGFloat item_w = 115;
    self.layout.itemSize = CGSizeMake(item_w, item_h);
    
    [self.cView registerClass:[HomeSingleImageCell class] forCellWithReuseIdentifier:@"HomeSingleImageCell"];
    self.cView.dataSource = self;
    self.cView.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.rankView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.rankView addGestureRecognizer:tap];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeSingleImageCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSingleImageCell" forIndexPath:indexPath];
    cell.item =  self.items[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic = self.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(dic);
    }
}

- (void)tap{
    
    if (self.actionBlock) {
        self.actionBlock(@{@"path":@"https://www.myoffer.cn/ad/landing/8.htm"});
    }
}


- (void)setGroup:(myofferGroupModel *)group{
    
    _group = group;
    
    self.items = group.items.firstObject;
 
//    if (self.group.cell_offset_x == 0) {
//         self.group.cell_offset_x = -self.cView.contentInset.left;
//    }
//    [self.cView setContentOffset:CGPointMake(self.group.cell_offset_x, 0) animated:NO];
    
}
/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView == self.cView) {
        self.group.cell_offset_x = scrollView.mj_offsetX;
     }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //防止 非用户用原因 DidDidEndDeceleratingWithScrollView没被调用
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndDecelerating:scrollView];
}

*/

@end
