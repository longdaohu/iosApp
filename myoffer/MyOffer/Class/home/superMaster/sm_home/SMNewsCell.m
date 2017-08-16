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
@property(nonatomic,strong)CAShapeLayer *shaper;
@property(nonatomic,strong)UIView *bgView;

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
    
    UIView *bgView = [UIView new];
    self.bgView = bgView;
    self.cView.backgroundView = bgView;
    
   
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"释放查看全部";
    titleLab.numberOfLines = 0;
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = XCOLOR_SUBTITLE;
    self.titleLab = titleLab;
    [bgView  addSubview:titleLab];
    
}

- (CAShapeLayer *)shaper{

    if (!_shaper) {
        
        _shaper =[CAShapeLayer layer];
        [self.bgView.layer addSublayer:_shaper];
        _shaper.fillColor = [UIColor colorWithWhite:0 alpha:0.06].CGColor;
        
    }
    return _shaper;
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
    
    NSString *message_id = nil;
    NSString *message_url = nil;
    if (newsFrame.news.messageType == SMMessageTypeOffLine){
        message_url = newsFrame.news.offline_url;
    }else{
        message_id = newsFrame.news.message_id;
    }
    
    if (self.actionBlock)  self.actionBlock(message_id,message_url,NO);

    
 }


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.titleLab.hidden) return;
   
    CGFloat over_distance = self.cView.contentSize.width  - scrollView.contentOffset.x - scrollView.bounds.size.width;
    
    CGFloat right_x = 0;
    CGFloat right_max_w = 35;
    
    if (over_distance < 0) {
        
        CGFloat disctance = self.bgView.bounds.size.width + over_distance;
  
        if ( disctance < scrollView.bounds.size.width - right_max_w) {
            right_x = self.title_X - right_max_w;
            self.show_push = YES;
        }else{
            right_x = self.title_X + over_distance;
            self.show_push = NO;
        }
        
         self.titleLab.mj_x = right_x;
        
        
        CGFloat path_x =  fabs(over_distance)  > right_max_w ? self.bgView.bounds.size.width - right_max_w * 2 : self.bgView.bounds.size.width + over_distance * 2;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.bgView.mj_w, 0)];
        [path  addQuadCurveToPoint:CGPointMake(self.bgView.mj_w, self.bgView.mj_h) controlPoint:CGPointMake(path_x,self.bgView.mj_h *0.5)];
        self.shaper.path = path.CGPath;
        
        
    }else{
    
        self.show_push = NO;
        self.titleLab.mj_x = self.title_X;
        self.shaper.path = nil;
     }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  
     if (self.titleLab.hidden || !self.show_push) return;
    
    if ( self.actionBlock) {
        
        self.actionBlock(nil,nil,YES);
    }
    
}



- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;

    self.cView.frame = CGRectMake(0, 0,contentSize.width,self.cv_Height);
    
    CGFloat bg_w = contentSize.width;
    CGFloat bg_h = contentSize.height;
    CGFloat bg_x = 0;
    CGFloat bg_y = 0;
    self.bgView.frame = CGRectMake(bg_x, bg_y, bg_w, bg_h);
    
    
    CGFloat r_h = contentSize.height;
    CGFloat r_x = contentSize.width + 15;
    self.titleLab.frame = CGRectMake(r_x , 0, 20, r_h);
    self.title_X = r_x;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
