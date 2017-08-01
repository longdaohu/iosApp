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
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,assign)CGFloat cv_Height;
@property(nonatomic,assign)CGFloat title_X;
@property(nonatomic,assign)BOOL show_push;

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

    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"释放查看全部";
    titleLab.numberOfLines = 0;
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textColor = XCOLOR_TITLE;
    self.titleLab = titleLab;
    [self.contentView addSubview:titleLab];
    
}


- (void)setNewsGroup:(NSArray *)newsGroup{
    
    _newsGroup = newsGroup;
    
    if (newsGroup.count > 0) {
        
        NSArray *newsArr = self.newsGroup.firstObject;
        if (newsArr.count < 2) self.titleLab.hidden = YES;
        
    }
      
    
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
    
    if (self.actionBlock)  self.actionBlock(newsFrame.news.message_id,NO);
     
 }


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.titleLab.hidden) return;
    
    
    CGFloat over_distance = self.cView.contentSize.width  - scrollView.contentOffset.x - scrollView.bounds.size.width;

    if (over_distance < -10) {
    
        self.titleLab.mj_x  =  self.title_X + over_distance;
        
    }else{
    
        self.titleLab.mj_x =  self.title_X;

    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  
     if (self.titleLab.hidden) return;

     if (scrollView.contentOffset.x + scrollView.bounds.size.width > self.cView.contentSize.width) {
     
        self.show_push = YES;

     }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 
    if (self.titleLab.hidden) return;

    if (self.show_push && self.actionBlock) {
        
        self.actionBlock(nil,YES);
    
        self.show_push = NO;
    }
    
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.cView.frame = CGRectMake(0, 0,self.bounds.size.width,self.cv_Height);
    
    if (CGRectContainsRect(CGRectZero, self.titleLab.frame)) {
        
        self.title_X = self.bounds.size.width + 30;
        
        self.titleLab.frame = CGRectMake(self.title_X, 0, 20, self.bounds.size.height);
        
     }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
