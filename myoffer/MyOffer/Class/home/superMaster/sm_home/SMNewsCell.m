//
//  SMNewsCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMNewsCell.h"
#import "SMNewsFrame.h"
#import "SMNewsColViewCell.h"


@interface SMNewsCell () <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *cView;
@property(nonatomic,assign)CGFloat cv_Height;

@end

@implementation SMNewsCell

static NSString *identify = @"sm_news";
static NSString *cv_identify = @"sm_cv_news";

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    SMNewsCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[SMNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self makeUI];
        
        self.contentView.backgroundColor = XCOLOR_BG;

    }
    
    return self;
}


- (void)makeUI{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);//sectionInset的设置与item的宽高不一致会出现警报信息
    flowlayout.minimumLineSpacing = 10;
    flowlayout.minimumInteritemSpacing = 0;
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    
    UICollectionView *cView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowlayout];
    self.cView = cView;
    cView.delegate = self;
    cView.dataSource = self;
    [self.contentView addSubview:cView];
    cView.showsVerticalScrollIndicator = NO;
    cView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:cView];
    cView.backgroundColor = XCOLOR_BG;
    
    [cView registerClass:[SMNewsColViewCell class] forCellWithReuseIdentifier:cv_identify];

    
}


- (void)setNewsGroup:(NSArray *)newsGroup{
    
    _newsGroup = newsGroup;
    
    NSArray *newsArr = self.newsGroup.firstObject;
    
    SMNewsFrame *newFrame = newsArr.firstObject;
    
    UICollectionViewFlowLayout *flowlayout = (UICollectionViewFlowLayout *)self.cView.collectionViewLayout;
    flowlayout.itemSize = newFrame.cell_size;
    
    self.cv_Height = newFrame.cell_size.height;
    
    [self.cView reloadData];
}


#pragma mark : UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.newsGroup.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSArray *newsArr = self.newsGroup[section];

    return  newsArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SMNewsColViewCell *content_cell = [collectionView dequeueReusableCellWithReuseIdentifier:cv_identify forIndexPath:indexPath];
    
    NSArray *newsArr = self.newsGroup[indexPath.section];
    
    content_cell.newsFrame = newsArr[indexPath.row];
    
    return content_cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *newsArr = self.newsGroup[indexPath.section];
    
    SMNewsFrame *newsFrame = newsArr[indexPath.row];
    
    NSLog(@">>>>>>>>>>>>>>>> %@",newsFrame.news.guest_university);
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.cView.frame = CGRectMake(0, 0,self.bounds.size.width,self.cv_Height);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
