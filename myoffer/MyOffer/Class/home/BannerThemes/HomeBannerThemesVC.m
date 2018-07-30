//
//  HomeBannerThemesVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/26.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeBannerThemesVC.h"
#import "HomeImageCell.h"

@interface HomeBannerThemesVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *bgView;
@end

@implementation HomeBannerThemesVC


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page专题攻略"];
    NavigationBarHidden(NO);
}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page专题攻略"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专题攻略";
    self.view.backgroundColor = XCOLOR_WHITE;
    [self makeUI];

}

- (void)makeUI{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = 30;
    CGFloat item_w = XSCREEN_WIDTH - 40;
    CGFloat item_h =  item_w * 239/335.0;
    flow.itemSize = CGSizeMake(item_w, item_h);
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flow];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = XCOLOR_WHITE;
    collectionView.contentInset = UIEdgeInsetsMake(20, 20, XNAV_HEIGHT + 30, 20);
    [self.view addSubview:collectionView];
    self.bgView = collectionView;
    [collectionView registerClass:[HomeImageCell class] forCellWithReuseIdentifier:@"HomeImageCell"];
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}


#pragma mark : <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeImageCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeImageCell" forIndexPath:indexPath];
    cell.shadowEnable = true;
 
    NSDictionary *item =  self.items[indexPath.row];
    NSDictionary *images = item[@"images"];
    NSDictionary *app = images[@"app"];
    cell.path = app[@"url"];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    NSDictionary *item =  self.items[indexPath.row];
    NSDictionary *images = item[@"images"];
    NSDictionary *app = images[@"app"];
    NSString *path = [app valueForKeyPath:@"target"];
    
    WebViewController *vc = [[WebViewController alloc] initWithPath:path];
    PushToViewController(vc);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"HomeBannerThemesVC + 专题推荐 + dealloc");
}


@end
