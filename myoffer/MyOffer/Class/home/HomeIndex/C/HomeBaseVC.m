//
//  HomeBaseVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#define  MENU_HEIGHT  XNAV_HEIGHT + 16
#import "HomeBaseVC.h"
#import "HomeApplySubjecttCell.h"
#import "HomeApplycationArtCell.h"
#import "HomeApplyUniCell.h"
#import "HomeApplicationDestinationCell.h"
#import "HomeSecView.h"
#import "SearchUniversityCenterViewController.h"
#import "MessageDetaillViewController.h"
#import "MeiqiaServiceCall.h"
//
//#import "HomeRoomHotCityCell.h"
//#import "HomeRoomApartmentCell.h"
//#import "HomeRoomPraiseCell.h"
#import "HomeRoomHorizontalCell.h"
#import "HomeRoomVerticalCell.h"


@interface HomeBaseVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *bgView;
@property(nonatomic,strong)UIButton *upBtn;
@property(nonatomic,strong)UIButton *meiqiaBtn;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isMeiqiaPush;
@property(nonatomic,assign)BOOL isTableOnMoving;
@property(nonatomic,assign)BOOL isloaded;

@end

@implementation HomeBaseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XCOLOR(0, 0, 0, 0);
    self.view.clipsToBounds = YES;
}

- (void)makeBaseUI{
    
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
    self.tableView =[[MyOfferTableView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT, XSCREEN_WIDTH, XSCREEN_HEIGHT - MENU_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XTabBarHeight + 30, 0);
    self.tableView.backgroundColor = XCOLOR_WHITE;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.userInteractionEnabled = NO;

    self.tableView.tableHeaderView = self.headerView;
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
    
    if (group.type == SectionGroupTypeArticleColumn) {
        HomeApplycationArtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeApplycationArtCell"];
        if (!cell) {
            cell = Bundle(@"HomeApplycationArtCell");
        }
        cell.item = group.items[indexPath.row];
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeApplySubject) {
        HomeApplySubjecttCell *cell = Bundle(@"HomeApplySubjecttCell");
        cell.actionBlock = ^(NSString *name) {
            [weakSelf caseArea:name];
        };
        
        return cell;
    }
 
    if (group.type == SectionGroupTypeApplyUniversity) {
        HomeApplyUniCell *cell = Bundle(@"HomeApplyUniCell");
        cell.item = group.items[indexPath.row];
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeApplyDestination) {
        HomeApplicationDestinationCell *cell = Bundle(@"HomeApplicationDestinationCell");
        cell.items = group.items[indexPath.row];
        cell.actionBlock = ^(NSDictionary *item) {
            [weakSelf caseApplyDestination:item];
        };
        return cell;
    }
    
    if ((group.type == SectionGroupTypeRoomHotCity) || (group.type == SectionGroupTypeRoomApartmentRecommendation) || (group.type == SectionGroupTypeRoomCustomerPraise)) {

        HomeRoomHorizontalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeRoomHorizontalCell"];
        if (!cell) {
            cell = [[HomeRoomHorizontalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HomeRoomHorizontalCell"];
        }
        cell.group = group;
        cell.actionBlock = ^(NSInteger index, id item) {
             if ([item isKindOfClass:[HomeRoomIndexCityObject class]]){
                    HomeRoomIndexCityObject *city = (HomeRoomIndexCityObject *)item;
                    NSLog(@"%@",city.name);
            }
             if ([item isKindOfClass:[HomeRoomIndexFlatsObject class]]){
                HomeRoomIndexFlatsObject *flat = (HomeRoomIndexFlatsObject *)item;
                NSLog(@"%@",flat.name);
            }

        };

        return  cell;
    }
    
    if (group.type == SectionGroupTypeRoomHomestay){
        
        HomeRoomVerticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeRoomVerticalCell"];
        if (!cell) {
            cell = [[HomeRoomVerticalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HomeRoomVerticalCell"];
        }
        cell.roomFrameObj = group.items.firstObject;
        cell.actionBlock = ^(NSInteger index, id item) {
            if ([item isKindOfClass:[HomeRoomIndexFlatsObject class]]){
                HomeRoomIndexFlatsObject *flat = (HomeRoomIndexFlatsObject *)item;
                NSLog(@"%@",flat.name);
            }
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
        [self caseArticleMessage:item[@"id"]];
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
   myofferGroupModel *group = self.groups[indexPath.section];
      if (group.cell_height_set) {
        
        return group.cell_height_set;
    }
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

#pragma mark : 事件处理

- (void)caseArea:(NSString *)name{

    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_AREA value:name];
    PushToViewController(vc);
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

- (void)caseArticleMessage:(NSString *)articel_id{
    
    MessageDetaillViewController *vc = [[MessageDetaillViewController alloc] initWithMessageId:articel_id];
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

- (void)meiqiaClick{
    
    self.isMeiqiaPush = YES;
    [MeiqiaServiceCall callWithController:self];
}


- (void)caseToTop{
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.isTableOnMoving = YES;
    self.bgView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.tableView.mj_y =  MENU_HEIGHT;
        self.meiqiaBtn.alpha = 1;
    } completion:^(BOOL finished) {
        
        [self.bgView setContentOffset:CGPointZero animated:NO];
        self.tableView.userInteractionEnabled = YES;
        self.isTableOnMoving = NO;
    }];
    
}

- (void)caseToBottom{
    
    self.tabBarController.tabBar.hidden = YES;
    self.isTableOnMoving = YES;
    self.tableView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.tableView.mj_y = XSCREEN_HEIGHT + 50;
        self.meiqiaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.bgView.userInteractionEnabled = YES;
        self.isTableOnMoving = NO;
    }];
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


- (void)toLoadView{
    
    if (self.upBtn) {
        [self upButtonAnimate:self.upBtn];
    }
    if (self.isloaded) return;
    self.isloaded = YES;
    [self makeBaseUI];
 
}

- (void)toSetTabBarhidden{
    
    if (self.meiqiaBtn) {
        self.tabBarController.tabBar.hidden = (self.meiqiaBtn.alpha > 0 ? NO : YES);
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)reloadSection:(NSInteger)section{

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)toReLoadTable{
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
