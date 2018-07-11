//
//  HomeApplicationVC.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/7.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeApplicationVC.h"
#import "HomeSecView.h"
#import "HomeApplycationArtCell.h"
#import "HomeApplyUniCell.h"
#import "HomeApplicationTopView.h"
#import "HomeApplicationDestinationCell.h"
#import "HomeApplySubjecttCell.h"
#import "MessageDetaillViewController.h"

#import "SearchViewController.h"
#import "PipeiEditViewController.h"
#import "GuideOverseaViewController.h"
#import "WYLXViewController.h"
#import "CatigoryViewController.h"
#import "SearchUniversityCenterViewController.h"
#import "IntelligentResultViewController.h"
#import "MeiqiaServiceCall.h"

#define  MENU_HEIGHT  XNAV_HEIGHT + 16


@interface HomeApplicationVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)UIView *header;
@property(nonatomic,strong)UIScrollView *bgView;
@property (assign, nonatomic)CGFloat isTableOnMoving;
@property (assign, nonatomic)BOOL isloaded;
@property (assign, nonatomic)NSInteger recommendationsCount;
@property(nonatomic,strong)UIButton *meiqiaBtn;
@property(nonatomic,strong)UIButton *upBtn;
@property(nonatomic,assign)BOOL isMeiqiaPush;

@end

@implementation HomeApplicationVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkZhiNengPiPei];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat height = (XSCREEN_HEIGHT >=812) ? XSCREEN_HEIGHT : (XSCREEN_WIDTH * 625.0/375);
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, height)];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"home_application_bg.jpg" ofType:nil];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [bgImageView setImage:image];
    
    UIImage *icon = XImage(@"home_application_bg_word");
    UIImageView *word_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MENU_HEIGHT + 40, XSCREEN_WIDTH, XSCREEN_WIDTH * icon.size.height/icon.size.width)];
    word_iconView.image = icon;
    [self.view addSubview:word_iconView];
    
    self.view.clipsToBounds = YES;
}

- (void)toLoadView{
 
    if (self.upBtn)  [self upButtonAnimate:self.upBtn];
 
    if (self.isloaded) return;
    self.isloaded = YES;
    //    if (!delayed) {
    //        [self makeUI];
    //        return;
    //    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self makeUI];
        [self makedData];
    });

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
        [self.view insertSubview:_meiqiaBtn aboveSubview:self.tableView];
        _meiqiaBtn.alpha = 0;
        
    }
    
    return _meiqiaBtn;
}


- (NSArray *)groups{
    
    if (!_groups) {
        
        myofferGroupModel *uni  = [myofferGroupModel groupWithItems:nil header:@"院校宝典"];
        uni.accesory_title= @"查看更多";
        uni.type = SectionGroupTypeApplyUniversity;
        NSArray *cities = @[
                            @{@"country":@"英国",@"city":@"伦敦",@"name":@"伦敦\nLondon", @"icon":@"city_ld.jpg",},
                            @{@"country":@"英国",@"city":@"曼彻斯特",@"name":@"曼彻斯特\nManchester", @"icon":@"city_mcst.jpg",},
                            @{@"country":@"英国",@"city":@"伯明翰",@"name":@"伯明翰\nBirmingham", @"icon":@"city_bmh.jpg",},
                            @{@"country":@"澳大利亚",@"city":@"悉尼",@"name":@"悉尼\nSydney", @"icon":@"city_xn.jpg",},
                            @{@"country":@"澳大利亚",@"city":@"墨尔本",@"name":@"墨尔本\nMelbourne", @"icon":@"city_mrb.jpg",},
                            @{@"country":@"新西兰",@"city":@"奥克兰",@"name":@"奥克兰\nAuckland", @"icon":@"city_akl.jpg"}
                            ];
        myofferGroupModel *destination  = [myofferGroupModel groupWithItems:@[cities] header:@"目的地"];
        destination.type = SectionGroupTypeApplyDestination;
        destination.accesory_title= @"留学生梦想的6座城";
        destination.section_header_height  = 60;
        
        NSArray *areas = @[@"placeHolder"];
        myofferGroupModel *subject  = [myofferGroupModel groupWithItems:@[areas] header:@"热门专业"];
        subject.type = SectionGroupTypeApplySubject;

        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *items = [ud valueForKey:@"HotArticle"];
        myofferGroupModel *article  = [myofferGroupModel groupWithItems:items header:@"热门阅读"];
        article.type = SectionGroupTypeArticleColumn;
        article.accesory_title= @"查看更多";
        
        _groups = @[uni,destination,subject,article];
    }
    
    return _groups;
}


- (void)makedData{
    [self makeHotUni];
}

/*-----------热门学校----------*/
- (void)makeHotUni{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@svc/app/hotUniversity",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makHotUniWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                           }];
}

- (void)makHotUniWithResponse:(id)response{
    if (!ResponseIsOK) return;
    [self reloadWithItems:@[response[@"result"]] type:SectionGroupTypeApplyUniversity];
    
}
/*-----------热门学校----------*/
- (void)reloadWithItems:(NSArray *)items type:(SectionGroupType)type{
    NSInteger index = 0;
    for (myofferGroupModel *group in self.groups) {
        if (group.type == type) {
            index = [self.groups indexOfObject:group];
            group.items = items;
            break;
        }
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)makeUI{
    
    self.view.clipsToBounds = YES;
    
    self.bgView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.bgView.contentSize = CGSizeMake(XSCREEN_WIDTH, XSCREEN_HEIGHT + 10);
    self.bgView.delegate = self;
    [self.view addSubview:self.bgView];
    if (@available(iOS 11.0, *)) {
        self.bgView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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

-(void)makeTableView
{
    
    CGFloat header_h = 170;
    CGFloat header_w = XSCREEN_WIDTH;
    UIView *header = [UIView new];
    self.header = header;
    header.frame = CGRectMake(0, 0, header_w, header_h);
    header.clipsToBounds = YES;
    
    self.tableView =[[MyOfferTableView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT, header_w, XSCREEN_HEIGHT - MENU_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = header;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 150;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XTabBarHeight + 30, 0);
    self.tableView.backgroundColor = XCOLOR(0, 0, 0, 0);
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = XCOLOR_WHITE;
    self.tableView.userInteractionEnabled = NO;
    
    
    CGFloat menu_w = header_w;
    CGFloat menu_x = 0;
    CGFloat menu_y = 0;
    WeakSelf;
    HomeApplicationTopView *topView = [[HomeApplicationTopView  alloc] initWithFrame:CGRectMake(menu_x, menu_y, menu_w, header_h)];
    topView.actionBlock = ^(UIButton *sender) {
        [weakSelf topViewClick:sender];
    };
    [header addSubview:topView];
    
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    
    return   group.items.count ;
}

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myofferGroupModel *group = self.groups[indexPath.section];
    WeakSelf
    if (group.type == SectionGroupTypeApplySubject) {
        HomeApplySubjecttCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeApplySubjecttCell"];
        if (!cell) {
            cell = Bundle(@"HomeApplySubjecttCell");
        }
        cell.actionBlock = ^(NSString *name) {
            [weakSelf caseArea:name];
        };
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeArticleColumn) {
        HomeApplycationArtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeApplycationArtCell"];
        if (!cell) {
            cell = Bundle(@"HomeApplycationArtCell");
        }
        cell.item = group.items[indexPath.row];
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeApplyUniversity) {
        HomeApplyUniCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeApplyUniCell"];
        if (!cell) {
            cell = Bundle(@"HomeApplyUniCell");
        }
        cell.item = group.items[indexPath.row];
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeApplyDestination) {
        HomeApplicationDestinationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeApplicationDestinationCell"];
        if (!cell) {
            cell = Bundle(@"HomeApplicationDestinationCell");
        }
        cell.items = group.items[indexPath.row];
        cell.actionBlock = ^(NSDictionary *item) {
            [weakSelf caseApplyDestination:item];
        };
        return cell;
    }
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row = %ld",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.groups[indexPath.section];
    if (group.type == SectionGroupTypeArticleColumn) {
        NSDictionary *item = group.items[indexPath.row];
        MessageDetaillViewController *vc = [[MessageDetaillViewController alloc] initWithMessageId:item[@"id"]];
        PushToViewController(vc);
    }
    
    if (group.type == SectionGroupTypeApplyUniversity) {
        NSDictionary *item = group.items[indexPath.row];
        [self.navigationController pushUniversityViewControllerWithID:item[@"id"] animated:YES];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    WeakSelf
    HomeSecView *header = [[HomeSecView alloc] init];
    header.leftMargin = 20;
    header.group = self.groups[section];
    header.actionBlock = ^(SectionGroupType type) {
        [weakSelf caseHeaderView:type];
    };
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [UIView new];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    
    return group.section_header_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  HEIGHT_ZERO;
}

#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgView) {
//        NSLog(@"Aaaaaaaa --- %lf bgView = %d", scrollView.mj_offsetY,scrollView.userInteractionEnabled);
        if (self.isTableOnMoving) return;
        self.tableView.mj_y =  (XSCREEN_HEIGHT - 1.5*scrollView.mj_offsetY);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.bgView == scrollView ) {
        
//        NSLog(@"BBBBB --- %lf  bgView   %lf", scrollView.mj_offsetY,XSCREEN_WIDTH * 0.3);
        
        self.isTableOnMoving = (scrollView.mj_offsetY >= XSCREEN_WIDTH * 0.3);
        
        if (!self.isTableOnMoving) return;
        if (scrollView.mj_offsetY >= XSCREEN_WIDTH * 0.3) {
//            NSLog(@"CCCCCC --- %lf   bgView", scrollView.mj_offsetY);
            [self caseToTop];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.tableView == scrollView) {
        
        if (-scrollView.mj_offsetY >= XSCREEN_WIDTH * 0.2) {
//            NSLog(@"-----DDDDD---- %lf    %d  tableView",scrollView.mj_offsetY,decelerate);
            [self caseToBottom];
        }
    }
    
}

- (void)caseToTop{
    
    
//    NSLog(@"-----caseToTop----caseToTop start");
    
    self.isTableOnMoving = YES;
    self.bgView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.tableView.mj_y =  MENU_HEIGHT;
        self.meiqiaBtn.alpha = 1;
    } completion:^(BOOL finished) {
        
        [self.bgView setContentOffset:CGPointZero animated:NO];
        self.tableView.userInteractionEnabled = YES;
        self.isTableOnMoving = NO;
        
//        NSLog(@"-----caseToTop----caseToTop   end");
        
    }];
}

- (void)caseToBottom{
    
    
//    NSLog(@"-----caseToBottom----caseToBottom start");
    
    self.isTableOnMoving = YES;
    self.tableView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.tableView.mj_y = XSCREEN_HEIGHT - MENU_HEIGHT;
        self.meiqiaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.bgView.userInteractionEnabled = YES;
        self.isTableOnMoving = NO;
//        NSLog(@"-----caseToBottom----caseToBottom end");
        
    }];
}

- (void)topViewClick:(UIButton *)sender{
    
    if (!sender) {
        [self caseSearch];
    }
    if ([sender.currentTitle isEqualToString:@"我要留学"]) {
        [self caseWYLX];
    }
    if ([sender.currentTitle isEqualToString:@"留学指南"]) {
        [self caseGuide];
    }
    if ([sender.currentTitle isEqualToString:@"智能匹配"]) {
        [self casePipei];
    }
    if ([sender.currentTitle isEqualToString:@"资讯宝典"]) {
        [self caseMessage];
    }
}
//跳转搜索
- (void)caseSearch{
    [self presentViewController:[[MyofferNavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]] animated:YES completion:nil];
    
}
//跳转我要留学
- (void)caseWYLX{
    [MobClick event:@"WoYaoLiuXue"];
    [self presentViewController:[[WYLXViewController alloc] init]  animated:YES completion:nil];
}
//跳转留学指南
- (void)caseGuide{
    [MobClick event:@"XiaoBai"];
    PushToViewController([[GuideOverseaViewController alloc] init]);
}
//跳转智能匹配
- (void)casePipei{
    [MobClick event:@"PiPei"];
    
    if (!LOGIN)  self.recommendationsCount = 0;
    if (self.recommendationsCount > 0) {
        RequireLogin
        PushToViewController([[IntelligentResultViewController alloc] init] );
        return;
    }
    PushToViewController([[PipeiEditViewController alloc] init] );
}

//跳转目的地
- (void)caseApplyDestination:(NSDictionary *)item{
    
    NSString *path = item[@"path"];
    if (path.length > 0) {
        WebViewController  *vc =  [[WebViewController alloc] initWithPath:path];
        PushToViewController(vc);
        
        return;
    }
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_CITY value:item[@"city"] country:item[@"country"]];
    PushToViewController(vc);
}

- (void)caseHeaderView:(SectionGroupType)type{
    
    switch (type) {
        case SectionGroupTypeArticleColumn:
            [self caseMessage];
            break;
        case SectionGroupTypeApplyUniversity:
        {
            NSString *key = KEY_COUNTRY;
            SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:key value:@"英国"];
            PushToViewController(vc);
        }
            break;
        default:
            break;
    }
}
//跳转资讯宝典
- (void)caseMessage{
    [self.tabBarController setSelectedIndex:2];
}

- (void)caseArea:(NSString *)name{
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_AREA value:name];
    PushToViewController(vc);
}

//判断是否有智能匹配数据或收藏学校
-(void)checkZhiNengPiPei{
    
    if (!LOGIN) return;
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet parameters:nil showHUD:NO errorAlertDismissAction:nil success:^(NSInteger statusCode, id response) {
        weakSelf.recommendationsCount = response[@"university"] ? 1 : 0;
    }];
}

- (void)meiqiaClick{
    
    self.isMeiqiaPush = YES;
    [MeiqiaServiceCall callWithController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
