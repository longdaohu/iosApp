//
//  IntroViewController.m
//  
//
//  Created by Blankwonder on 6/15/15.
//
//

#import "IntroViewController.h"
#import "KDBannerView.h"

@interface IntroViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *bgView;
@property(nonatomic,strong)UIButton *enterBtn;
@property(nonatomic,strong)UIImageView  *versionView;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,strong)UIView *pageView;
@property(nonatomic,strong)UIView *focusView;
@property(nonatomic,assign)CGRect versionView_Frame_O;
@property(nonatomic,assign)CGRect enterBtn_Frame_O;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self makeUI];
    
}


- (void)makeUI{

    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    bgView.pagingEnabled = YES;
    bgView.alwaysBounceHorizontal = YES;
    bgView.bounces = NO;
    bgView.showsHorizontalScrollIndicator = NO;
    bgView.delegate = self;
    [self.view addSubview:bgView];
    self.bgView = bgView;

    self.images = @[@"into001.jpeg",@"into002.jpeg",@"into003.jpeg",@"into004.jpeg",@"into005.jpeg",@"into006.jpeg"];
   
    for (NSString *imageName in self.images) {
        
        CGFloat item_W = bgView.bounds.size.width;
        CGFloat item_X = bgView.subviews.count * item_W;
        CGFloat item_Y = 0;
        CGFloat item_H = bgView.bounds.size.height;
        UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(item_X, item_Y, item_W, item_H)];
        bannerView.clipsToBounds = YES;
        
        UIImageView *banner = [[UIImageView alloc] initWithFrame:bannerView.bounds];
        [bannerView addSubview:banner];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        banner.image = XImage(imageName);
        
        [bgView addSubview:bannerView];
        
    }
    
    bgView.contentSize = CGSizeMake(bgView.subviews.count * XSCREEN_WIDTH, 0);
    
    
    
    UIView *bannerView = bgView.subviews.lastObject;
    
    
    UIImageView *versionView = [[UIImageView alloc] initWithImage:XImage(@"intro_version")];
    versionView.frame = CGRectMake(0,bannerView.bounds.size.height * 0.1, bannerView.bounds.size.width, versionView.image.size.height);
    [bannerView addSubview:versionView];
    versionView.contentMode = UIViewContentModeScaleAspectFit;
    self.versionView = versionView;
    self.versionView_Frame_O= versionView.frame;
    
    
    CGFloat enter_W = 152;
    CGFloat enter_X = (XSCREEN_WIDTH - enter_W) * 0.5;
    CGFloat enter_Y = XSCREEN_HEIGHT * 0.8;
    CGFloat enter_H = 52;
    UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake(enter_X, enter_Y, enter_W, enter_H)];
    [bannerView addSubview:enterBtn];
    [enterBtn setImage:[UIImage imageNamed:@"enterButton"] forState:UIControlStateNormal];
    enterBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [enterBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    self.enterBtn = enterBtn;
    self.enterBtn_Frame_O = enterBtn.frame;
    
 
    [self makePageControl];
    
}

- (void)makePageControl{
    
    UIView *pageView = [[UIView  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.enterBtn.frame) + 20, XSCREEN_WIDTH, 20)];
    [self.view addSubview:pageView];
    self.pageView = pageView;
    
    
    CGFloat margin = 20;
    CGFloat spod_W = 10;
    CGFloat spod_H = spod_W;
    CGFloat spod_Y = 0;
    CGFloat spod_X = (XSCREEN_WIDTH - self.images.count * spod_W - (self.images.count - 1)* margin) * 0.5;
    
    for (NSInteger index = 0; index < self.images.count; index++) {
        
        CGFloat temp_X  = (spod_W + margin) * index;
        
        UIView *spodView = [[UIView alloc] initWithFrame:CGRectMake(temp_X + spod_X, spod_Y, spod_W, spod_H)];
        spodView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        spodView.layer.cornerRadius = spod_W * 0.5;
        spodView.layer.masksToBounds = YES;
        [pageView addSubview:spodView];
     }
    
    
    UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    focusView.backgroundColor = XCOLOR_WHITE;
    focusView.layer.cornerRadius = spod_W * 0.5;
    focusView.layer.masksToBounds = YES;
    [pageView addSubview:focusView];
    focusView.center = [pageView.subviews.firstObject center];
    self.focusView = focusView;
}


#pragma mark :UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat pageWidth = scrollView.frame.size.width;
    
    self.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    CGFloat  move = scrollView.contentOffset.x /  pageWidth;
    
    CGFloat  alpha = move - (NSInteger)move;
    
    if ((NSInteger)move == (self.images.count - 2)) {
        
        self.enterBtn.alpha = alpha;
        self.versionView.alpha = alpha;
 
        CGRect newVersionRect  = self.versionView_Frame_O;
        newVersionRect.size.height = alpha * self.versionView_Frame_O.size.height;
        self.versionView.frame = newVersionRect;
        self.versionView.center = CGPointMake(XSCREEN_WIDTH * 0.5, self.versionView_Frame_O.size.height * 0.5 +  self.versionView_Frame_O.origin.y);
 
        CGRect newEnterRect  = self.enterBtn_Frame_O;
        newEnterRect.size.height = alpha * self.enterBtn_Frame_O.size.height;
        self.enterBtn.frame = newEnterRect;
        self.enterBtn.center = CGPointMake(XSCREEN_WIDTH * 0.5, self.enterBtn_Frame_O.size.height * 0.5 +  self.enterBtn_Frame_O.origin.y);
 
    }
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.focusView.center = [self.pageView.subviews[self.currentPage] center];
    }];
    
}

- (void)onClick:(UIButton *)sender{

    [self dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page引导页"];
    
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
    
    KDClassLog(@"page引导页 dealloc");
}


@end
