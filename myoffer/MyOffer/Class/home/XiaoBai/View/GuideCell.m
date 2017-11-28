//
//  GuideCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/11/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "GuideCell.h"
#import "GuideItemCell.h"

@interface GuideCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UILabel *indexLab;


@end

@implementation GuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tagLab.layer.cornerRadius = 10;
    self.tagLab.layer.masksToBounds = true;
    
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    [self.collectView registerNib:[UINib nibWithNibName:NSStringFromClass([GuideItemCell class] ) bundle:nil] forCellWithReuseIdentifier: NSStringFromClass([GuideItemCell class] )];
    self.collectView.contentInset = UIEdgeInsetsMake(0, 0, 0, 14);
    
}

- (void)setProcess:(GuideProcess *)process{
    
    _process = process;

    self.tagLab.text = [NSString stringWithFormat:@"%ld",process.row];
    
    self.titleLab.text = process.title;
    
    self.descLab.text = process.desc;
    
    self.line_left.hidden = process.line_hiden;

    self.countLab.text = [NSString stringWithFormat:@"/ %ld",process.items.count];
    
    [self.collectView reloadData];
    
    self.indexLab.text = [NSString stringWithFormat:@"%ld", process.current_index];
    
    [self.collectView setContentOffset:CGPointMake(process.item_offset_x, 0) animated:NO];
 
}


#pragma mark : UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.process.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GuideItemCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GuideItemCell class])  forIndexPath:indexPath];
    cell.item = self.process.items[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GuideItem *item = self.process.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(item.url);
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    CGFloat  padding  = 14.0;
    CGFloat offset_x = scrollView.contentOffset.x;
    CGFloat offset_w = scrollView.contentSize.width + padding;
    CGFloat bounds_w = scrollView.bounds.size.width;
    CGFloat  item_size_w  = 192.0;
    CGFloat  item_space_w  = padding + item_size_w;
    
    NSInteger index = 0;
 
    if (offset_x<=0) {
        
        index = 1;
        
    }else if (offset_x + bounds_w >= offset_w) {
        
        index = self.process.items.count;
        
        if (!(self.process.item_offset_x  - offset_x)) {
            
            index  = 1 + (offset_x + bounds_w * 0.5) / item_space_w ;
         }
        
    }else{
 
        index  = 1 + (offset_x + bounds_w * 0.5) / item_space_w ;

    }

    self.process.item_offset_x  =  offset_x;
    self.indexLab.text = [NSString stringWithFormat:@"%ld", self.process.current_index];
    self.process.current_index = index;
 
}






@end
