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
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)SuperMasterHomeDemol *smModel;//总数据源
@property(nonatomic,strong)SDCycleScrollView *autoLoopView;//轮播图
@property(nonatomic,strong)SMNewsOnLineView *onLineView;//线下活动
@property(nonatomic,strong)NSDate *login_date;

@end

@implementation SuperMasterViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page超导首页"];
    
    [MobClick event:@"ALL_PageView"];


}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page超导首页"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeData];
    
    [self recordMobClick];
   
    self.login_date = [NSDate date];
}


#pragma mark : 网络请求
- (void)makeData{
  
    WeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorSuperMasterHome parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf showError];
    }];
    
}


- (void)updateUIWithResponse:(id)response{

    SuperMasterHomeDemol *home = [SuperMasterHomeDemol mj_objectWithKeyValues:response];
    self.smModel = home;
    
    NSMutableArray *group_temp = [NSMutableArray array];
    
    // 1  最新超导
    if (home.newest.count > 0) {
        
        NSMutableArray *news_temp = [NSMutableArray array];
        for (SMHotModel *news in home.newest){
            
            [news_temp addObject:[SMNewsFrame frameWithHot:news]];
        }
        NSArray *news_frames = [news_temp copy];
        
        SMHomeSectionModel *new_group = [SMHomeSectionModel sectionInitWithTitle:@"最新超导" Items:@[news_frames] groupType:SMGroupTypeNews];
        
        if (new_group.items.count > 0)  [group_temp addObject:new_group];
  
    }
  
    
    if (home.tag.subject.count > 0 || home.tag.topic.count > 0) {
        
        // 2  选分类
        SMTagFrame *tapFrame = [SMTagFrame frameWithtag:home.tag];
        SMHomeSectionModel *tag_group = [SMHomeSectionModel sectionInitWithTitle:@"选分类"  Items:@[tapFrame] groupType:SMGroupTypeTags];
        
        if (tag_group.items.count > 0)  [group_temp addObject:tag_group];

    }
   
    
    if (home.hots.count > 0) {
        // 3  火热推荐
        NSMutableArray *hots_temp = [NSMutableArray array];
        for (SMHotModel *hot in home.hots){
            
            [hots_temp addObject:[SMHotFrame frameWithHot:hot]];
        }
        SMHomeSectionModel *hot_group = [SMHomeSectionModel sectionInitWithTitle:@"火热推荐"  Items:[hots_temp copy] groupType:SMGroupTypeHot];
        hot_group.show_All_data = (hot_group.item_all.count < hot_group.limit_count);
        hot_group.accessory_title = @"查看全部";
        hot_group.action = NSStringFromSelector(@selector(hotRowDidClick:));
        if (hot_group.items.count > 0)  [group_temp addObject:hot_group];
        
    }
    
    self.groups = [group_temp copy];
    
    
    [self makeTableViewHeaderView];
    
    
    [self.tableView reloadData];
    
}


#pragma mark :  添加UI

- (SMNewsOnLineView *)onLineView{
    
    if (!_onLineView) {
        
        _onLineView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMNewsOnLineView class]) owner:self options:nil].firstObject;
        WeakSelf
        _onLineView.actionBlock = ^(NSString *urlStr) {
            
            [weakSelf safariWithPath:urlStr];
        };
    }
    
    return _onLineView;
}


- (void)makeUI{
    
    [self makeTableView];
    
    self.title = @"超级导师";
    
}

- (void)makeTableViewHeaderView{

    
    BOOL banners_true = self.smModel.banners.count > 0 ;
    BOOL offline_true = [self.smModel.offline allKeys].count > 0;
    //都不存在时，不设置表头
    if (!banners_true && !offline_true)  return;
    
    
    
    CGFloat header_Height = 0;

    UIView *header =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.mj_w, header_Height)];
    header.clipsToBounds = YES;
    

    //1 如果有banner
    if (banners_true ) {
        
         self.autoLoopView.imageURLStringsGroup = [self.smModel.banners valueForKeyPath:@"image_url"];
      
        WeakSelf
        [UIView animateWithDuration:ANIMATION_DUATION * 2 animations:^{
            
            weakSelf.autoLoopView.alpha = 1;
        }];
        
        [header addSubview:self.autoLoopView];
        
        
        header_Height += self.autoLoopView.mj_h;
        
    }
    
     //1 如果有最新线下活动
    if (offline_true) {
    
        header_Height  += self.onLineView.mj_h;
        
        [header addSubview:self.onLineView];
        
        self.onLineView.offline = self.smModel.offline;
        
    }

    header.mj_h = header_Height;
    
    self.tableView.tableHeaderView = header;
  
}


// 创建轮播图头部

- (SDCycleScrollView *)autoLoopView{

    if (!_autoLoopView) {
        
        CGFloat auto_X = 0;
        CGFloat auto_Y = 0;
        CGFloat auto_W = XSCREEN_WIDTH;
        CGFloat auto_H = AdjustF(160.f);
        CGRect autoFrame = CGRectMake(auto_X, auto_Y, auto_W, auto_H);
        WeakSelf
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
    WeakSelf

    switch (group.groupType) {
            
        case SMGroupTypeNews:
        {
            SMNewsCell *news_cell = [SMNewsCell cellWithTableView:tableView];
            news_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            news_cell.newsGroup = group.items;
            news_cell.actionBlock = ^(NSString *message_id,NSString *off_line,BOOL show_push) {
                
                if (message_id) {
                    
                    SMDetailViewController *detail = [[SMDetailViewController alloc] init];
                    detail.message_id = message_id;
                    [weakSelf pushWithVC:detail];
                    
                }else if(off_line){
                
                    [weakSelf safariWithPath:off_line];
                
                }else{
                
                    [weakSelf pushWithVC:[[SMListViewController alloc] init]];

                }
        
                
            };
            
            return  news_cell;
        }
            break;
        case SMGroupTypeTags:
        {
            
            SMTagCell *tag_cell = [SMTagCell cellWithTableView:tableView];
            tag_cell.tagFrame = group.items.firstObject;
            tag_cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tag_cell.actionBlock = ^(NSString *tag, NSString *subject_id) {
                
                
                SMListViewController *vc = [[SMListViewController alloc] init];
                // 超导标签: ['留学生活', '大学招生官', '专业解析', '职业发展', '海外学习辅导']
               //@"海外学习辅导";
                tag ?  (vc.tag =  tag) : (vc.area_id = subject_id);
        
                [weakSelf pushWithVC:vc];
                
                
            };
            
            return tag_cell;
            
        }
            break;
            
        default:{
        
            SMHotCell *hot_cell = [SMHotCell cellWithTableView:tableView];
            hot_cell.hotFrame = group.items[indexPath.row];
            
            return hot_cell;
        
        }
            break;
    }
    
  
  
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    
    if (group.show_All_data) {
     
        return nil;
    }
    
    WeakSelf
    SMHotSectionFooterView *footer = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SMHotSectionFooterView class]) owner:self options:nil].firstObject;
    footer.actionBlock = ^{
        
             group.show_All_data = YES;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            
    };
        
    return  footer;

 }


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    SMHomeSectionModel *group = self.groups[section];
    
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:group.title];
    
    SectionView.backgroundColor = (group.groupType == SMGroupTypeNews) ? XCOLOR_BG : XCOLOR_WHITE;
 
    SectionView.accessory_title = group.accessory_title;
    
    [SectionView arrowButtonHiden:(group.groupType != SMGroupTypeHot)];
    
    WeakSelf
    SectionView.actionBlock = ^{
 
        [weakSelf pushWithVC:[[SMListViewController alloc] init]];
        
    };
    
    return SectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMHomeSectionModel *group = self.groups[indexPath.section];
    //在添加数据时已经做了判断，不会出现空数组情况
    CGFloat   height = 0;
    switch (group.groupType) {
            
        case SMGroupTypeNews:
        {
            NSArray *item_section = group.items[0];
            SMNewsFrame *news_frame = item_section[indexPath.row];
            height =  news_frame.cell_height;

        }
            break;
        case SMGroupTypeTags:{
            SMTagFrame *tagFrame = group.items.firstObject;
            height = tagFrame.cell_height;
        }
            break;
        default:
        {
            SMHotFrame *hot_frame  =  group.items[indexPath.row];
             height = hot_frame.cell_height;
        }
            break;
    }
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  Section_header_Height_nomal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    SMHomeSectionModel *group = self.groups[section];
    
    if (!group.show_All_data)  return Section_footer_Height_Title;
    
    return Section_footer_Height_nomal;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMHomeSectionModel *group = self.groups[indexPath.section];
    
    if (group.groupType != SMGroupTypeHot) return;
    
    if (group.action) {
        
        SMHotFrame *hot_frame  =  group.items[indexPath.row];
        
        [self performSelector:NSSelectorFromString(group.action) withObject:hot_frame afterDelay:0.0];
        
    }
 
    
}

#pragma mark : 事件处理
- (void)caseBannerWithIndex:(NSInteger)index{
    
   SMBannerModel  *banner = self.smModel.banners[index];
   
     if ([banner.link_app containsString:@"myoffer://home"]) {
         
         [self dismiss];
         
     }else if([banner.link_app containsString:@"myoffer://articles"]){
         
         [self.tabBarController setSelectedIndex:2];
         
         [self dismiss];
         
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


- (void)hotRowDidClick:(SMHotFrame *)hot_frame{


    if (hot_frame.hot.messageType == SMMessageTypeOffLine) {
        
        [self safariWithPath:hot_frame.hot.offline_path];
        
        return;
    }
    
    SMDetailViewController *detail = [[SMDetailViewController alloc] init];
    detail.message_id = hot_frame.hot.message_id;
    [self pushWithVC:detail];
    
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    CGFloat online_y = (self.smModel.banners.count > 0) ? CGRectGetMaxY(self.autoLoopView.frame) : 0;
    
    self.onLineView.frame = CGRectMake(0, online_y, self.tableView.mj_w, 110);

}

//显示错误提示
- (void)showError{
    
    if (self.groups.count == 0) {
        
         [self.tableView emptyViewWithError:NetRequest_ConnectError];
        
    }
   
}

/*
 记录用户终端id进入超导模块的次数。访问超导一台电脑客户端为一个访客。00:00-24:00内相同的客户端只被计算一次。
 */
- (void)recordMobClick{
    

    NSString  *sm_key = @"lastSMP";

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *last_value = [ud valueForKey:sm_key];
    
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *now_date = [NSDate date];

    if (!last_value) {
        
        last_value  =  [formatter stringFromDate:now_date];
        [ud setValue: last_value forKey:sm_key];
        [ud synchronize];

        [MobClick event:@"IP_PageView"];
        
    }else{

        NSString *now_date_str = [formatter stringFromDate:now_date];
        
        NSInteger time_distance =(now_date_str.integerValue - last_value.integerValue);
 
        if (time_distance > 0) {
           
            last_value  =  [formatter stringFromDate:now_date];
            [ud setValue: last_value forKey:sm_key];
            [ud synchronize];
            
            [MobClick event:@"IP_PageView"];

        }

    }


}




- (void)dealloc{

    //这个参数是时间
    NSInteger timeIntervalSinceNow = (NSInteger)[self.login_date  timeIntervalSinceNow];
    NSDictionary *dict = @{ @"second" : [NSString stringWithFormat:@"%ld",-timeIntervalSinceNow]};
    [MobClick event:@"ALL_Playduration" attributes:dict];
    
    KDClassLog(@"导师主页 + SuperMasterViewController + dealloc");
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
