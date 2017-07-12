//
//  MessageTopicHeaderViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageTopicHeaderViewController.h"
#import "MyofferSectionView.h"
#import "MessageHotTopicMedel.h"
#import "CatigaryCityCollectionCell.h"
#import "MessageTopicViewController.h"


@interface MessageTopicHeaderViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)MyofferSectionView *sectionView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;

@end

static NSString * const reuseIdentifier = @"cityCell";

@implementation MessageTopicHeaderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];

}

- (void)makeUI{
    
    self.view.backgroundColor =  XCOLOR_BG;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.layout = layout;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CatigaryCityCollectionCell class] ) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    collectionView.backgroundColor =  XCOLOR_BG;
    collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    
    //分区View;
    MyofferSectionView *sectionView = [[MyofferSectionView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH , 50)];
    sectionView.title = @"热门专题";
    self.sectionView = sectionView;
    [self.view addSubview: sectionView];
    [self.sectionView bottomLineShow:NO];
    
    self.collectionView.mj_y =  self.sectionView.mj_h;
    
    
}

- (void)setHeader_Height:(CGFloat)header_Height{

    _header_Height = header_Height;
    
    self.layout.itemSize = CGSizeMake(XSCREEN_WIDTH * 0.5, header_Height - 60);
    
    self.collectionView.mj_h = header_Height - self.collectionView.mj_y - 10;
 
 }

- (void)setTopices:(NSArray *)topices{

    _topices = topices;
    
    [self.collectionView reloadData];
    
}


#pragma mark : UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.topices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CatigaryCityCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.topic = self.topices[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   MessageHotTopicMedel *topic = self.topices[indexPath.row];
    
    MessageTopicViewController *tp = [[MessageTopicViewController alloc] init];
    
    tp.topic_id = topic.topic_id;
    
    [self.navigationController pushViewController:tp animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end