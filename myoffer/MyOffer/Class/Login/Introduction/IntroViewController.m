//
//  IntroViewController.m
//  
//
//  Created by Blankwonder on 6/15/15.
//
//

#import "IntroViewController.h"
#import "KDBannerView.h"
#import "IntroCell.h"

@interface IntroViewController ()
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)UIView *pageView;
@property(nonatomic,strong)UIView *focusView;
@property (weak, nonatomic) IBOutlet UICollectionView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flow;
@property(nonatomic,strong)NSArray *items;

@end

@implementation IntroViewController

- (NSArray *)items{
    if (!_items) {
        
        
        _items = @[
                          @{
                              @"title":@"海外留学",
                              @"summary":@"一键智能匹配院校&专业\n极速48小时递交申请",
                              @"icon":@"intro_01.jpg"
                              },
                          @{
                              @"title":@"海外租房",
                              @"summary":@"1、000、000+全球房源\n5分钟完成预订",
                              @"icon":@"intro_02.jpg"
                              },
                          @{
                              @"title":@"海外学费支付",
                              @"summary":@"全球1000+所大学\n24小时随时支付",
                              @"icon":@"intro_03.jpg"
                              },
                          
                          @{
                              @"title":@"海外名企训练营",
                              @"summary":@"500强顶级海外企业\n职业培训/实习",
                              @"icon":@"intro_04.jpg"
                              },
                          @{
                              @"title":@"移民签证",
                              @"summary":@"100%签证成功率 30、000+成功案例\n境内+境外权威律师团队",
                              @"icon":@"intro_05.jpg"
                              }
                          ];
    }
    
    
    return _items;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.flow.itemSize = CGSizeMake(XSCREEN_WIDTH, XSCREEN_HEIGHT);
    self.bgView.bounces = NO;
    [self.bgView registerClass:[IntroCell class] forCellWithReuseIdentifier:@"IntroCell"];
    
    [self makeUI];

}

#pragma mark : UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    IntroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntroCell" forIndexPath:indexPath];
    cell.item = self.items[indexPath.row];
    cell.acitonBlock = ^{
        [weakSelf onClick];
    };
    
    return cell;
}

- (void)makePageControl{
    
    CGFloat pageView_y  = IsIphoneMiniScreen ? XSCREEN_HEIGHT * 0.9 :XSCREEN_HEIGHT * 0.88;
    UIView *pageView = [[UIView  alloc] initWithFrame:CGRectMake(0,pageView_y, XSCREEN_WIDTH, 20)];
    [self.view addSubview:pageView];
    self.pageView = pageView;
    
    
    CGFloat margin = 20;
    CGFloat spod_W = 8;
    CGFloat spod_H = spod_W;
    CGFloat spod_Y = 0;
    CGFloat spod_X = (XSCREEN_WIDTH - self.items.count * spod_W - (self.items.count - 1)* margin) * 0.5;
    
    for (NSInteger index = 0; index < self.items.count; index++) {
        
        CGFloat temp_X  = (spod_W + margin) * index;
        
        UIView *spodView = [[UIView alloc] initWithFrame:CGRectMake(temp_X + spod_X, spod_Y, spod_W, spod_H)];
        spodView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        spodView.layer.cornerRadius = spod_W * 0.5;
        spodView.layer.masksToBounds = YES;
        [pageView addSubview:spodView];
    }
 
    UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    focusView.backgroundColor = XCOLOR_LIGHTBLUE;
    focusView.layer.cornerRadius = 7;
    focusView.layer.masksToBounds = YES;
    [pageView addSubview:focusView];
    focusView.center = [pageView.subviews.firstObject center];
    self.focusView = focusView;
}
- (void)makeUI{

    [self makePageControl];
}


#pragma mark :UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    self.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.focusView.center = [self.pageView.subviews[self.currentPage] center];
    }];
    
    CGFloat  margin = (scrollView.contentSize.width -  scrollView.mj_offsetX);
    self.pageView.hidden = (margin < scrollView.mj_w * 1.5);
    
}

- (void)onClick{
    [self dismiss];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page引导页"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page引导页"];
}

- (void)didReceiveMemoryWarning {  
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    KDClassLog(@"page引导页 + IntroViewController +  dealloc");
}


@end
