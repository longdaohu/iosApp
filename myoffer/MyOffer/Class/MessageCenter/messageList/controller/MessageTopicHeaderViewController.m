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
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@end

static NSString * const reuseIdentifier = @"cityCell";

@implementation MessageTopicHeaderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];

}

- (void)makeUI{
    
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    self.flowLayout = flow;
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 0;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.sectionInset = UIEdgeInsetsZero;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
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
    sectionView.backgroundColor = XCOLOR_BG;
    [self.view addSubview: sectionView];
    [self.sectionView bottomLineShow:NO];
    
    self.collectionView.mj_y =  self.sectionView.mj_h;
    
    
}

- (void)setHeader_Height:(CGFloat)header_Height{

    _header_Height = header_Height;
    
    self.flowLayout.itemSize = CGSizeMake(XSCREEN_WIDTH * 0.5, header_Height - 60);
    
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



#pragma mark UIScrollViewDelegate

//当将要拖拽scrollView时触发,手指结束scrollView并且将要滑动时触发
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if ([_contain_View isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)_contain_View;
        
        self.containView_scroll_enable = tableView.scrollEnabled;
        
        if (tableView.scrollEnabled) {
            
            tableView.scrollEnabled = NO;
            
        }
        
    }
}

//当结束拖拽时触发(手指将要离开屏幕)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ([_contain_View isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)_contain_View;
        
        if (!tableView.scrollEnabled) {
            
            tableView.scrollEnabled = self.containView_scroll_enable;
            
        }
        
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
