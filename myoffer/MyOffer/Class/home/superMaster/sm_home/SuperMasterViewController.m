//
//  SuperMasterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SuperMasterViewController.h"
#import "SuperMasterHomeDemol.h"
#import "SMHomeSectionModel.h"
#import "HomeSectionHeaderView.h"
#import "SMHotFrame.h"
#import "SMTagModel.h"
#import "SMHotModel.h"
#import "SMHotCell.h"
#import "SMNewsCell.h"
#import "SMTagCell.h"
#import "SMNewsFrame.h"
#import "SMTagFrame.h"
#import "SDCycleScrollView.h"
#import "SMNewsOnLineView.h"
#import "SMBannerModel.h"
#import "SMListViewController.h"
#import "SMDetailViewController.h"
#import "SMHotSectionFooterView.h"

@interface SuperMasterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)SuperMasterHomeDemol *homeModel;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)SDCycleScrollView *autoLoopView;
@property(nonatomic,strong)SMNewsOnLineView *onLineView;

@end

@implementation SuperMasterViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeData];
}


#pragma mark : 网络请求
- (void)makeData{
    
    [self startAPIRequestWithSelector:@"GET api/sm/index" parameters:nil success:^(NSInteger statusCode, id response) {
        
//            NSLog(@" ？%@？  >>>>>>>>>>>>> [%@]",response[@"offline"],[response[@"offline"] class]);

        
        SuperMasterHomeDemol *home = [SuperMasterHomeDemol mj_objectWithKeyValues:response];
        self.homeModel = home;
        //         NSLog(@" 最新超导 >>>>>> %@  -------- %@",home.tag.topic,home.tag.subject);
        
        NSMutableArray *news_temp = [NSMutableArray array];
        for (SMHotModel *news in home.newest){
            
            SMNewsFrame *newsFrame = [SMNewsFrame frameWithHot:news];
            
            [news_temp addObject:newsFrame];
        }
        NSArray *news_frames = [news_temp copy];
        SMHomeSectionModel *one = [SMHomeSectionModel sectionInitWithTitle:@"最新超导" Items:@[news_frames] index:0];
        
        
        SMTagFrame *tapFrame = [SMTagFrame frameWithtag:home.tag];
        SMHomeSectionModel *second = [SMHomeSectionModel sectionInitWithTitle:@"选分类"  Items:@[tapFrame] index:1];
        
        
        
        NSMutableArray *hots_temp = [NSMutableArray array];
        
        for (SMHotModel *hot in home.hots){
            
            [hots_temp addObject:[SMHotFrame frameWithHot:hot]];
        }
        
        
        NSArray *hotArr = hots_temp.count > 2 ? [hots_temp subarrayWithRange:NSMakeRange(0, 2)] : hots_temp;
        
        SMHomeSectionModel *third = [SMHomeSectionModel sectionInitWithTitle:@"火热推荐"  Items:hotArr index:2];
        
        third.accessory_title = @"查看全部";
        
        third.item_all = [hots_temp copy];
        
        self.groups = @[one,second,third];
        
        [self makeTableViewHeaderView];
        
        [self.tableView reloadData];
        
        
    }];
}




#pragma mark :  添加UI

- (void)makeUI{
    
    [self makeTableView];
    
    self.title = @"超级导师";
}

- (void)makeTableViewHeaderView{

    CGFloat header_Height = 0;

    UIView *header =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.mj_w, header_Height)];
    header.clipsToBounds = YES;
    
    if (self.homeModel.banners.count > 0 ) {
        
         self.autoLoopView.imageURLStringsGroup = [self.homeModel.banners valueForKey:@"image_url_mc"];
      
        XWeakSelf
        [UIView animateWithDuration:ANIMATION_DUATION * 2 animations:^{
            
            weakSelf.autoLoopView.alpha = 1;
        }];
        
        [header addSubview:self.autoLoopView];
        
        
        header_Height += self.autoLoopView.mj_h;
        
    }
    
    if ([self.homeModel.offline allKeys].count > 0) {
    
        header_Height  += self.onLineView.mj_h;
        
        [header addSubview:self.onLineView];
        
        self.onLineView.offline = self.homeModel.offline;
        
    }

    header.mj_h = header_Height;
    
    
    self.tableView.tableHeaderView = header;
   
    
 
}

- (SMNewsOnLineView *)onLineView{

    if (!_onLineView) {
        
        _onLineView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMNewsOnLineView class]) owner:self options:nil].firstObject;
        XWeakSelf
        _onLineView.actionBlock = ^(NSString *urlStr) {
            
            [weakSelf safariWithPath:urlStr];
        };
    }
    
    return _onLineView;
}


// 创建轮播图头部

- (SDCycleScrollView *)autoLoopView{

    if (!_autoLoopView) {
        
        CGFloat auto_X = 0;
        CGFloat auto_Y = 0;
        CGFloat auto_W = XSCREEN_WIDTH;
        CGFloat auto_H = AdjustF(160.f);
        CGRect autoFrame = CGRectMake(auto_X, auto_Y, auto_W, auto_H);
        XWeakSelf
        _autoLoopView = [SDCycleScrollView cycleScrollViewWithFrame:autoFrame delegate:nil placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
         _autoLoopView.alpha = 0;
        _autoLoopView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _autoLoopView.currentPageDotColor = XCOLOR_LIGHTBLUE;
        _autoLoopView.clickItemOperationBlock = ^(NSInteger index) {
            
             [weakSelf  caseBannerWithIndex:index];
        };
    }
    
    return _autoLoopView;
}




-(void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
  
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   SMHomeSectionModel *group = self.groups[section];
    
    return group.items.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMHomeSectionModel *group = self.groups[indexPath.section];
 
    if (group.index == 0) {
        
        SMNewsCell *news_cell = [SMNewsCell cellWithTableView:tableView];
        
        news_cell.newsGroup = group.items;
        
        news_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        XWeakSelf
        news_cell.actionBlock = ^(NSString *message_id) {
            
            SMDetailViewController *detail = [[SMDetailViewController alloc] init];
            
            detail.message_id = message_id;
            
            [weakSelf pushWithVC:detail];
          
        };
        
        return  news_cell;
        
        
    }else if(group.index == 1){

        SMTagCell *tag_cell = [SMTagCell cellWithTableView:tableView];

        tag_cell.tagFrame = group.items.firstObject;
        
        tag_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        tag_cell.actionBlock = ^(NSString *tag, NSString *subject_id) {
  

        SMListViewController *vc = [[SMListViewController alloc] init];
            
            if (tag) {
                // 超导标签: ['留学生活', '大学招生官', '专业解析', '职业发展', '海外学习辅导']
                vc.tag =  tag; //@"海外学习辅导";
                
            }else{
            
                vc.area_id = subject_id;

            }
            
            [self pushWithVC:vc];

            
        };
        
        return tag_cell;
        
    }else{
    
        SMHotCell *hot_cell = [SMHotCell cellWithTableView:tableView];
        
        hot_cell.hotFrame = group.items[indexPath.row];
        

        return hot_cell;
     
    }
  
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    
    if (group.index == 2 && group.item_all.count > 2 && !group.showMore) {
        
         XWeakSelf
    SMHotSectionFooterView *footer = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMHotSectionFooterView class]) owner:self options:nil].firstObject;
        
        footer.actionBlock = ^{
        
             group.showMore = YES;
             
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            
        };
        
        
        return  footer;
    
    }
    
    return nil;

 }


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    SMHomeSectionModel *group = self.groups[section];
    
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:group.title];
    
    if (group.index == 0) {
        
        SectionView.backgroundColor = XCOLOR_BG;

    }else{
        SectionView.backgroundColor = XCOLOR_WHITE;

    }
    
    SectionView.accessory_title = group.accessory_title;
    
    [SectionView arrowButtonHiden:(group.index != 2)];
    
    
    XWeakSelf
    SectionView.actionBlock = ^{
 
        [weakSelf pushWithVC:[[SMListViewController alloc] init]];
        
    };
    
    return SectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMHomeSectionModel *group = self.groups[indexPath.section];

    if (group.index == 0) {
        
       NSArray *item_section = group.items.firstObject;
        
       SMNewsFrame *news_frame = item_section.firstObject;
        
        return news_frame.cell_height;

    }else if(group.index == 1) {
        
        SMTagFrame *tagFrame = group.items.firstObject;
        
        return  tagFrame.cell_height;
        
    }else{
        
        SMHotFrame *hot_frame  =  group.items[indexPath.row];
        
        return  hot_frame.cell_height;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];

    if (group.index == 2 && group.item_all.count > 2 && !group.showMore) {
        
        return 80;
    }
    
   return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SMHomeSectionModel *group = self.groups[indexPath.section];

    if (group.index == 2) {
        
        SMHotFrame *hot_frame  =  group.items[indexPath.row];
        
        SMDetailViewController *detail = [[SMDetailViewController alloc] init];
        
        detail.message_id = hot_frame.hot.message_id;
        
        [self pushWithVC:detail];
    }
    
}

#pragma mark : 事件处理
- (void)caseBannerWithIndex:(NSInteger)index{
    
   SMBannerModel  *banner = self.homeModel.banners[index];
    
     if ([banner.link_app containsString:@"myoffer://home"]) {
         
         [self dismiss];
         
     }else if([banner.link_app containsString:@"myoffer://articles"]){
         
         [self.tabBarController setSelectedIndex:2];
         
     }else{
 
         [self safariWithPath:banner.link_app];
         
     }
    
}

- (void)pushWithVC:(UIViewController *)vc{

    [self.navigationController pushViewController:vc animated:YES];
}


- (void)safariWithPath:(NSString *)path{

    [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:path]];

}


- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    CGFloat online_y = (self.homeModel.banners.count > 0) ? CGRectGetMaxY(self.autoLoopView.frame) : 0;
    
    self.onLineView.frame = CGRectMake(0, online_y, self.tableView.mj_w, 110);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
