//
//  HomeFeeVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeFeeVC.h"
#import "HomeFeeCell.h"
#import "HomeRentCell.h"
#import "HomeYESGlobalCell.h"
#import "HomeUVICCell.h"
#import "MeiqiaServiceCall.h"


@interface HomeFeeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIScrollView *bgView;
@property (assign, nonatomic)CGFloat isTableOnMoving;
@property (assign, nonatomic)BOOL isloaded;
@property(nonatomic,strong)UIButton *meiqiaBtn;
@property(nonatomic,assign)BOOL isMeiqiaPush;
@property(nonatomic,strong)UIButton *upBtn;

@end

@implementation HomeFeeVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMeiqiaPush) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.isMeiqiaPush = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
}


- (void)toLoadView{
    
    if (self.upBtn)  [self upButtonAnimate:self.upBtn];

    if (self.isloaded) return;
    self.isloaded = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self makeUI];
    });
}

- (void)toSetTabBarhidden{
    
    if (self.meiqiaBtn) {
        self.tabBarController.tabBar.hidden = (self.meiqiaBtn.alpha > 0 ? NO : YES);
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
}


- (void)makeUI{
    
    self.bgView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.bgView.contentSize = CGSizeMake(XSCREEN_WIDTH, XSCREEN_HEIGHT+1);
    self.bgView.delegate = self;
    [self.view addSubview:self.bgView];
    if (@available(iOS 11.0, *)) {
        self.bgView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGFloat up_w = 80;
    CGFloat up_h =  up_w;
    CGFloat up_y =  XSCREEN_HEIGHT * 0.77;
    CGFloat up_x =  (XSCREEN_WIDTH - up_w) * 0.5;
    UIButton *upBtn = [[UIButton alloc] initWithFrame: CGRectMake(up_x, up_y, up_w, up_h)];
    [upBtn setImage:XImage(@"home_page_directive") forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(caseToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];
    [self upButtonAnimate:upBtn];
     self.upBtn = upBtn;
    
    [self makeTableView];
    [self.view  addSubview:self.meiqiaBtn];

}

- (void)upButtonAnimate:(UIButton *)sender{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:sender.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(sender.center.x, sender.center.y - 60)];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1;
    group.repeatCount = 6;
    group.removedOnCompletion = YES;
    group.animations = @[opacityAnim,animation];
    [sender.layer addAnimation:group forKey:@"ani"];
}

- (UIButton *)meiqiaBtn{
    
    if (!_meiqiaBtn) {
        
        CGFloat width = 60;
        CGFloat height = width;
        CGFloat x = XSCREEN_WIDTH - width - 20;
        CGFloat y = XSCREEN_HEIGHT - XTabBarHeight - height - 40;
        _meiqiaBtn = [[UIButton alloc] initWithFrame:CGRectMake( x, y, width, height)];
        _meiqiaBtn.layer.cornerRadius = width * 0.5;
        [_meiqiaBtn setBackgroundImage:XImage(@"meiqia_call_logo") forState:UIControlStateNormal];
        [_meiqiaBtn addTarget:self action:@selector(meiqiaClick) forControlEvents:UIControlEventTouchUpInside];
        _meiqiaBtn.alpha = 0;
        
    }
    
    return _meiqiaBtn;
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT,XSCREEN_WIDTH, XSCREEN_HEIGHT - HOME_MENU_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 150;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XTabBarHeight, 0);
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.layer.cornerRadius = 10;
    self.tableView.userInteractionEnabled = NO;
    
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *class_name;
    switch (self.type) {
        case HomeLandingTypeMoney:
            class_name = @"HomeFeeCell";
            break;
        case HomeLandingTypeRoom:
            class_name = @"HomeRentCell";
            break;
        case HomeLandingTypeYesGlobal:
            class_name = @"HomeYESGlobalCell";
            break;
        default:
            class_name = @"HomeUVICCell";
            break;
    }
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:class_name];
    if (!cell) {
        cell = Bundle(class_name);
    }

    if ([class_name isEqualToString:@"HomeFeeCell"]) {
        HomeFeeCell *cell_fee = (HomeFeeCell *)cell;
        cell_fee.actionBlock = ^(NSString *path) {
            [self web:path];
        };
    }
    
    if ([class_name isEqualToString:@"HomeRentCell"]) {
        HomeRentCell *cell_fee = (HomeRentCell *)cell;
        cell_fee.actionBlock = ^(NSString *path) {
            [self web:path];
        };
    }
    
    if ([class_name isEqualToString:@"HomeYESGlobalCell"]) {
        HomeYESGlobalCell *cell_fee = (HomeYESGlobalCell *)cell;
        cell_fee.actionBlock = ^(NSString *path) {
            [self web:path];
        };
    }
    
    if ([class_name isEqualToString:@"HomeUVICCell"]) {
        HomeUVICCell *cell_fee = (HomeUVICCell *)cell;
        cell_fee.actionBlock = ^(NSString *path) {
            [self web:path];
        };
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewAutomaticDimension;
}


#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgView) {
        if (self.isTableOnMoving) return;
            self.tableView.mj_y =  (XSCREEN_HEIGHT - 1.5 * scrollView.mj_offsetY);
     }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.bgView == scrollView ) {
        
        self.isTableOnMoving = (scrollView.mj_offsetY >= XSCREEN_WIDTH * 0.3);
        if (!self.isTableOnMoving) return;
        if (scrollView.mj_offsetY >= XSCREEN_WIDTH * 0.3) {
            [self caseToTop];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.tableView == scrollView) {
        if (-scrollView.mj_offsetY >= XSCREEN_WIDTH * 0.2) {
            [self caseToBottom];
        }
    }
}

- (void)caseToTop{
    self.isTableOnMoving = YES;
    self.bgView.userInteractionEnabled = NO;
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.tableView.mj_y =  HOME_MENU_HEIGHT;
        self.meiqiaBtn.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self.bgView setContentOffset:CGPointZero animated:NO];
        self.tableView.userInteractionEnabled = YES;
        self.isTableOnMoving = NO;
        
    }];
}

- (void)caseToBottom{
    
    self.isTableOnMoving = YES;
    self.tableView.userInteractionEnabled = NO;
    self.tabBarController.tabBar.hidden = YES;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.tableView.mj_y = XSCREEN_HEIGHT + 50;
        self.meiqiaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.bgView.userInteractionEnabled = YES;
        self.isTableOnMoving = NO;
        
    }];
}

- (void)meiqiaClick{
    
    self.isMeiqiaPush = YES;
    [MeiqiaServiceCall callWithController:self];
}

- (void)web:(NSString *)path{
    WebViewController *vc  = [[WebViewController alloc] initWithPath:path];
    PushToViewController(vc);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
