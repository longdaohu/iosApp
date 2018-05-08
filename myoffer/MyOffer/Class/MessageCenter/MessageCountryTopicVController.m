//
//  MessageCountryTopicVController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageCountryTopicVController.h"
#import "messageCatigroyCountryModel.h"
#import "myofferAnchorButton.h"
#import "UniversityCourseFilterCell.h"
#import "MessageCountryTopicModel.h"
#import "MessageTopicCatigoryView.h"
#import "MessageTopicCountryContentVController.h"
#import "messageCatigroySubModel.h"
#import "MyOfferArticle.h"
#import "XWGJMessageFrame.h"
 
@interface MessageCountryTopicVController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *catigroyGroup;
@property(nonatomic,strong) messageCatigroyCountryModel *country_catigory_current;
@property(nonatomic,strong) MessageTopicCatigoryView *topView;
@property(nonatomic,strong) UIScrollView *bgView;
@property(nonatomic,strong) UIView *countryBgView;
@property(nonatomic,strong) UIButton *coverView;
@property(nonatomic,strong) UITableView *countryTableView;
@property(nonatomic,strong) myofferAnchorButton *titleView;
@property(nonatomic,strong) NSMutableArray *childVCes;
@property(nonatomic,strong) NSArray *groups;

@end

#define CELL_HIGHT_DEFAULT 44

@implementation MessageCountryTopicVController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page资讯国家专题"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯国家专题"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeCatigoryData];
    
    [self makeUI];
    
}


- (NSMutableArray *)childVCes{
    
    if (!_childVCes) {
        
        _childVCes = [NSMutableArray array];
    }
    
    return _childVCes;
}

- (void)topviewOnClick:(NSInteger)index{
    
    //1-1判断是否大于1 如果大于1，则没有动画效果
    CGFloat  page  = (index * self.bgView.mj_w -  self.bgView.contentOffset.x) / self.bgView.mj_w;
    
    if (fabs(page) <= 1) {
        
        WeakSelf
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            weakSelf.bgView.contentOffset = CGPointMake(index * self.bgView.mj_w , 0);
            
        } completion:^(BOOL finished) {
            
            [weakSelf makeDataWithCatigroyIndex:index page:0];
            
        }];
        
        
    }else{
    
        [self.bgView setContentOffset:CGPointMake(index * self.bgView.mj_w , 0) animated:NO];
        [self makeDataWithCatigroyIndex:index page:0];

        
    }

    
}

- (void)makeUI{
    
    //1 顶部筛选栏
    WeakSelf
    self.topView = [MessageTopicCatigoryView topViewWithBlock:^(NSInteger catigory_index) {
        
        [weakSelf topviewOnClick:catigory_index];
        
    }];
    [self.view addSubview:self.topView];
    
    
    //2 添加tableView容器
    CGFloat base_y = CGRectGetMaxY(self.topView.frame);
    CGFloat base_w = XSCREEN_WIDTH;
    CGFloat base_h = XSCREEN_HEIGHT - base_y;
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, base_y, base_w,base_h - XNAV_HEIGHT)];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    bgView.pagingEnabled = YES;
    bgView.delegate = self;
    bgView.showsHorizontalScrollIndicator=NO;
    bgView.showsVerticalScrollIndicator=NO;

    
    //3 -1 国家选择项背景
    UIView *countryBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:countryBgView];
    self.countryBgView = countryBgView;
    countryBgView.alpha = 0;
    
    //3-2 黑色背景
    UIButton *cover = [[UIButton alloc] initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.coverView = cover;
    cover.alpha = 0;
    [countryBgView addSubview:cover];
    [cover   addTarget:self action:@selector(coverOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //3-3 国家选择项列表
    UITableView *tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.countryTableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[[UIView alloc] init];
    [self.countryBgView addSubview:tableView];
    tableView.mj_h = 0;
    
    
    //4 标题名称
    myofferAnchorButton *titleView = [[myofferAnchorButton alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    self.titleView = titleView;
    titleView.title = self.countryName;
    UIView  *nav_titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.navigationItem.titleView = nav_titleView;
    [nav_titleView  addSubview:titleView];
    titleView.center = nav_titleView.center;
    titleView.actionBlock= ^(UIButton *sender){
        
        [weakSelf titleViewOnClick:sender];
        
    };
 
}

#pragma mark : 网络请求 得到基础数据
- (void)makeCatigoryData{
    
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorArticleArticleCategory parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateTopViewUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
        [weakSelf dismiss];
        
    }];
    
}


//根据条件请求网络
- (void)makeDataWithCatigroyIndex:(NSInteger)index page:(NSInteger)page{
    
    
    MessageCountryTopicModel *topic  =  self.groups[index];
    topic.page = page;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setValue:self.country_catigory_current.code  forKey:@"first"];
    messageCatigroyModel *catigory = self.country_catigory_current.subs[index];
    [paras setValue:catigory.code  forKey:@"second"];
    [paras setValue:@(topic.page)  forKey:KEY_PAGE];
    [paras setValue:@20  forKey:@"size"];
    
    for (messageCatigroySubModel *catigory_sub in catigory.subs) {
        
        if (catigory_sub.isSelected) {
            
            [paras setValue:catigory_sub.code  forKey:@"third"];
            
            break;
        }
    }
    
    topic.parameters = [paras mutableCopy];
    
    MessageTopicCountryContentVController  *vc = self.childVCes[index];
    
    [self startAPIRequestWithSelector:kAPISelectorArticalesList  parameters:paras expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, NSDictionary *response) {
        
        //1 page == 0 时清空所有数据
        if (page == 0)   [topic.messageFrames removeAllObjects];
        
        
        //2 添加数据
        NSArray *items = [MyOfferArticle mj_objectArrayWithKeyValuesArray: response[@"items"]];
        NSMutableArray *temps = [NSMutableArray array];
        for (MyOfferArticle *article in items) {
            
            [temps addObject:[XWGJMessageFrame messageFrameWithMessage:article]];
        }
        
        [topic.messageFrames addObjectsFromArray:temps];
        
        
        //3 判断是否加载完数据
        if (topic.messageFrames.count > [response[@"counts"] integerValue]) {
            
            topic.endPage = YES;
            
        }else{
            
            topic.page++;//网络请求成功，+一页，请求下一页数据
            [topic.parameters setValue:@(topic.page) forKey:KEY_PAGE];
        }
        
        
        //4 给对应子视图添加数据
        vc.group = topic;
        
        // 5 当page == 0时，让子视图table回到顶部
        if (page == 0) [vc tableViewScrollToTop];
        
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [vc showError];
        
    }];
    
}


// 根据国家主题  数据修改 topView内容
- (void)updateTopViewUIWithResponse:(id)response{
    
    //1  数据转模型
    self.catigroyGroup = [messageCatigroyCountryModel mj_objectArrayWithKeyValuesArray:response];
    
    //2  记录当前国家  刷新数据
    NSArray *countries = [self.catigroyGroup valueForKeyPath:@"name"];
    
    [self.countryTableView reloadData];
    
    //3 根据当前主题添加展示表格 及添加基本数据
    NSInteger index = [countries indexOfObject:self.countryName];
    
    messageCatigroyCountryModel *country_catigory = self.catigroyGroup[index];
    
    //4 根据当前主题添加展示表格 4 的优先及大于 5
    [self makeTableWithCountryCatigory: country_catigory];
    
    //5 topView 添加数据 并发起网络请求
    self.topView.catigoryCountry = country_catigory;
    
}


//根据当前国家catigory.subs添加tableView
- (void)makeTableWithCountryCatigory:(messageCatigroyCountryModel *)country{
    
    //当前国家数据
    self.country_catigory_current = country;
    
    //1 清空旧数据
    if(self.groups.count > 0)  self.groups = nil;
       
    
    //2 添加展示表格、及初始化数组
    NSMutableArray *temps_content = [NSMutableArray array];
    
    for(NSInteger index = 0 ; index < country.subs.count ; index++){
        
        //2-1 清空数据后，再新选择请求参数时不重复添加表格
        if ((index + 1)> self.childVCes.count){
            
            MessageTopicCountryContentVController *vc = [[MessageTopicCountryContentVController alloc] init];
            [self.childVCes addObject:vc];
            [self addChildViewController:vc];
        }
        
        //2-2 初始化数据
        MessageCountryTopicModel *topic = [MessageCountryTopicModel countryTopicWithMessageFrames:[NSMutableArray array] catigoryIndex:index];
        [temps_content addObject:topic];
        
    }
    self.groups = [temps_content copy];
    
    //3 给对应子视图添加数据
    for (NSInteger gindex = 0 ; gindex < self.childVCes.count; gindex++) {
        
        MessageCountryTopicModel *topic = self.groups[gindex];
        
        MessageTopicCountryContentVController *vc = self.childVCes[gindex];
        vc.group = topic;
        
        CGFloat vcx = gindex * self.bgView.mj_w;
        vc.view.mj_x = vcx;
        [self.bgView addSubview:vc.view];
    }
    
    //4  设置容器contentSize 及回到子视图
    self.bgView.contentSize = CGSizeMake(self.childVCes.count * self.bgView.mj_w, 0);
    [self.bgView setContentOffset:CGPointZero animated:NO];
    
}





#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = CELL_HIGHT_DEFAULT;
    
    return height;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return self.catigroyGroup.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1 国家筛选数表格
    if (tableView == self.countryTableView) {
        
        UniversityCourseFilterCell *cell = [[UniversityCourseFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        NSArray *names = [self.catigroyGroup valueForKeyPath:@"name"];
        
        NSString *title = names[indexPath.row];
        
        cell.title = title;
        
        cell.onSelected = [title isEqualToString:self.countryName];
        
        return cell;
        
    }else{
        
        return [[UITableViewCell alloc] init];
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.countryTableView) {
        
        //1 收起国家表格
        [self coverOnClick:self.coverView];
        
        //2 选择项一样时不刷新当前数据
        messageCatigroyCountryModel *country = self.catigroyGroup[indexPath.row];
        if ([self.countryName isEqualToString:country.name])  return;
        
        //3 设置当前国家
        self.countryName =country.name;
        
        //3-2设置当前标题
        self.titleView.title = self.countryName;
        
        
        //4 根据当前主题添加展示表格 4 的优先及大于 5
        [self makeTableWithCountryCatigory: country];
        
        //5 筛选项添加数据
        self.topView.catigoryCountry = country;
        
        
        return;
    }
    
}


#pragma mark : UIScrollViewDelege

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgView) {
        
        //监听滚动，实现顶部工具条按钮切换
        CGFloat offsetX = scrollView.contentOffset.x;
        
        CGFloat width = scrollView.frame.size.width;
        
        NSInteger index =  (offsetX + .5f *  width) / width;
        
        [self.topView superViewSetScrollViewToCatigoryIndex:index];
        
    }
    
}


#pragma mark : 事件处理

- (void)titleViewOnClick:(UIButton *)sender{
    
    //1 展示表格
    [self countryTableViewShow:sender.selected];
    
    
    if (sender.selected)  [self.countryTableView reloadData];
    
}

//点击背景，收起表格
- (void)coverOnClick:(UIButton *)sender{
    
    [self.titleView titleButtonOnClick];
}


- (void)countryTableViewShow:(BOOL)show{
    
    CGFloat distance = show ? self.catigroyGroup.count * CELL_HIGHT_DEFAULT : 0 ;
    
    CGFloat alpha = show ? 1 : 0;
    
    if (show) self.countryBgView.alpha = alpha;
    
    WeakSelf
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        weakSelf.countryTableView.mj_h = distance;
        
        weakSelf.coverView.alpha = alpha;
        
    } completion:^(BOOL finished) {
        
        if (!show) {
            
            weakSelf.countryBgView.alpha = alpha;
            
        }
    }];
    
    
}

- (void)dealloc{
    
    NSLog(@"资讯国家专题 dealloc");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
