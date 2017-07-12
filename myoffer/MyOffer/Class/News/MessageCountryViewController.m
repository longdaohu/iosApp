//
//  MessageCountryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/11.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageCountryViewController.h"
#import "MessageTopicTopView.h"
#import "UniversityCourseFilterCell.h"
#import "MessageCountryTopicModel.h"
#import "messgeNewModel.h"
#import "XWGJMessageFrame.h"
#import "MessageCell.h"
#import "MessageDetaillViewController.h"

#define CELL_HIGHT_DEFAULT 44
#define PARA_PAGE @"page"

@interface MessageCountryViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *titleView;
@property(nonatomic,strong)MessageTopicTopView *topView;
@property(nonatomic,strong)UIScrollView *bgView;
@property(nonatomic,strong)UIView *countryBgView;
@property(nonatomic,strong)UIButton *coverView;
@property(nonatomic,strong)UITableView *countryTableView;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)NSArray *catigroyGroup;
@property(nonatomic,strong)MessageCountryTopicModel *topic_current;


@end

@implementation MessageCountryViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page资讯专题"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯专题"];
}


- (NSMutableArray *)groups{
    
    if (!_groups) {
        
        _groups = [NSMutableArray array];
        
    }
    return _groups;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeCatigoryData];
    
    [self makeUI];

}


- (void)makeUI{
    
    //顶部筛选栏

    XWeakSelf
    self.topView = [MessageTopicTopView topViewWithBlock:^(NSDictionary *parameter ,NSInteger catigory_index) {
        
        [weakSelf filterWithparameter:parameter catigroyIndex:catigory_index];
        
    }];
    [self.view addSubview:self.topView];
    
  
     //添加tableView容器
    CGFloat base_y = CGRectGetMaxY(self.topView.frame);
    CGFloat base_w = XSCREEN_WIDTH;
    CGFloat base_h = XSCREEN_HEIGHT - base_y;
    UIScrollView *baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, base_y, base_w,base_h - XNAV_HEIGHT)];
    [self.view addSubview:baseView];
    self.bgView = baseView;
//    baseView.backgroundColor = XCOLOR_LIGHTBLUE;
    baseView.pagingEnabled = YES;
    baseView.delegate = self;
    baseView.showsHorizontalScrollIndicator=NO;
    baseView.showsVerticalScrollIndicator=NO;
    
    
    //国家选择项背景
    UIView *countryBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:countryBgView];
    self.countryBgView = countryBgView;
    countryBgView.alpha = 0;
    
    //黑色背景
    UIButton *cover = [[UIButton alloc] initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.coverView = cover;
    cover.alpha = 0;
    [countryBgView addSubview:cover];
    [cover   addTarget:self action:@selector(coverOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //国家选择项列表
    UITableView *tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.countryTableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[[UIView alloc] init];
    [self.countryBgView addSubview:tableView];
    tableView.mj_h = 0;
    
    
    //标题名称
    UIButton *titleView = [[UIButton alloc] init];
    self.titleView = titleView;
    [titleView addTarget:self action:@selector(titleOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleView;
    [self titleButtonFitWithTitle:self.countryName];
    
}


//网络请求 得到基础数据
- (void)makeCatigoryData{
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorArticleArticleCategory parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateTopViewUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [MBProgressHUD showError:@"网络请求失败" toView:self.view];
        
        [weakSelf dismiss];
        
    }];
    
}


//topView 筛选条件请求
- (void)filterWithparameter:(NSDictionary *)parameter catigroyIndex:(NSInteger)catigroyIndex{
    
    
    NSLog(@" >>>>>  filterWithparamet   %ld >>>>  %ld",self.topic_current.catigoryIndex ,catigroyIndex);
    
    MessageCountryTopicModel *topic = self.groups[catigroyIndex];
    self.topic_current  = topic;
    
    // 1 添加参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:parameter];
     // 1 - 1 判断page参数否是点击了【全部】按钮
    NSInteger  p_page = ([parameter[PARA_PAGE] integerValue] == DEFAULT_NUMBER) ? 0 : [parameter[PARA_PAGE] integerValue];
    
    NSDictionary *parameter_base = @ { PARA_PAGE : @(p_page),  @"size" : @"30"};

    [parameters  setValuesForKeysWithDictionary:parameter_base];
    
    //3 获取当前所在主题  记录当前所在专题数据在第几页及网络请求参数
    topic.page = p_page;
    topic.parameters = parameters;
    
    NSLog(@"2 筛选条件请求 >>>>>>  %@  ",self.topic_current.parameters);
    
 //    //4 选择对应的选项是滚动到对应页面
    [self.bgView setContentOffset:CGPointMake(self.bgView.mj_w * catigroyIndex, 0) animated:YES];
    
    
    //2 根据参数请求数据
    [self makeDataWithURLString:kAPISelectorArticalesList parameters:parameters];
    
}


//根据条件请求网络
- (void)makeDataWithURLString:(NSString *)urlStr parameters:(NSDictionary *)parameters{
    
    XWeakSelf
    [self startAPIRequestWithSelector:urlStr parameters:parameters expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, NSDictionary *response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [MBProgressHUD showError:@"网络请求失败" toView:self.view];
        
    }];
    
}


/*
 response.allKeys
 
 size  20,
 items [],
 counts  71,
 page  0
 */
//更新结果页内容
- (void)updateUIWithResponse:(NSDictionary *)response {
    
    //1  专题page == 0 时，清空数据
    if (0 == self.topic_current.page){
        
       [self.topic_current.messageFrames removeAllObjects];
     }
    
    //2 字典转模型
    NSArray  *items  = [messgeNewModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
    
    
    NSMutableArray *temps = [NSMutableArray array];
    for (messgeNewModel *item in items) {
        
        [temps addObject: [XWGJMessageFrame messageFrameWithNewMessage:item]];
    }
    [self.topic_current.messageFrames  addObjectsFromArray:temps];

    //3 判断是否是最近一页
    self.topic_current.endPage = items.count < [response[@"size"] integerValue];
    
//    NSLog(@">>>>>>updateUIWithResponse>>>>>>> %ld  %ld",self.topic_current.messageFrames.count,items.count);
    
    
    //4 数据刷新  或page为0时回到表格顶部
    UITableView *table = (UITableView *)self.bgView.subviews[self.topic_current.catigoryIndex];
    
    if (0 == self.topic_current.page){
        
        table.contentOffset = CGPointZero;
    }

    [table reloadData];

    //5 确认该专题数据是否还有数据
    self.topic_current.page++;
    [self.topic_current.parameters setValue:@(self.topic_current.page) forKey:PARA_PAGE];

}


// 根据数据修改 topView内容
- (void)updateTopViewUIWithResponse:(id)response{
    
    //1  数据转模型
    self.catigroyGroup = [messageCatigroyCountryModel mj_objectArrayWithKeyValuesArray:response];
    
    //2  记录当前国家  刷新数据
    NSArray *countries = [self.catigroyGroup valueForKeyPath:@"name"];
    NSInteger index = [countries indexOfObject:self.countryName];
     [self.countryTableView reloadData];
    
    
    //3 根据当前主题添加展示表格 及添加基本数据
    messageCatigroyCountryModel *country_catigory = self.catigroyGroup[index];
    
    [self makeTableWithCountryCatigory: country_catigory];
    
    //4 筛选项添加数据
    self.topView.catigoryCountry = country_catigory;
    
}

//根据当前国家catigory.subs添加tableView
- (void)makeTableWithCountryCatigory:(messageCatigroyCountryModel *)countryCatigory{
 
//    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
      //1 清空旧数据
     if(self.groups.count > 0){
    
        //这里清空之前的数据
         [self.groups removeAllObjects];
         
         [self.topic_current.messageFrames removeAllObjects];
         self.topic_current = nil;
         
        //这里清空之前的数据，刷新表格
         for (UITableView *table in self.bgView.subviews) {
            
             [table reloadData];
         }
            
     }
    
    
    //2 添加展示表格、及初始化数组
    NSInteger group_count = self.bgView.subviews.count;
    
    NSMutableArray *temps = [NSMutableArray array];
    
    for(NSInteger index = 0 ; index < countryCatigory.subs.count ; index++){
        
        //清空数据后，再新选择请求参数时不重复添加表格
        if (index > (group_count -1)){
        
            [self makeTableViewWithTag:index superView:self.bgView];
        }
        
        //初始化数据
        MessageCountryTopicModel *topic = [MessageCountryTopicModel countryTopicWithMessages:[NSMutableArray array] catigoryIndex:index];
      
        [temps addObject:topic];
        
//        NSLog(@" %ld   groups %ld  topic = %p   %p",group_count,self.groups.count,topic,self.topic_current);
        
        //设置当前所在主题
        if (!self.topic_current)  self.topic_current = self.groups.firstObject;
        
    }
    
    self.groups = [temps mutableCopy];
    
    //3 设置容器contentSize 及回到子视图
    self.bgView.contentSize = CGSizeMake(countryCatigory.subs.count * self.bgView.mj_w, 0);
    
    [self.bgView setContentOffset:CGPointZero animated:YES];
    
}

//添加子表格
-(void)makeTableViewWithTag:(NSInteger)tag superView:(UIView *)superView
{
    CGFloat t_w = self.bgView.mj_w;
    CGFloat t_y = 0;
    CGFloat t_h = self.bgView.mj_h;
    CGFloat t_x = tag * t_w;
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(t_x, t_y, t_w, t_h) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[[UIView alloc] init];
    tableView.tag = tag;
    [superView addSubview:tableView];
    
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = CELL_HIGHT_DEFAULT;
    
    if (tableView != self.countryTableView ){
   
        XWGJMessageFrame *messageFrame =  self.topic_current.messageFrames[indexPath.row];
        
        height = messageFrame.cell_Height;
     }
    
    return height;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *rows = self.topic_current.messageFrames;
    
    if (tableView == self.countryTableView) {
        
      rows  =  self.catigroyGroup;
        
    }
    
    return rows.count;
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
    }
    
 
    //2 正常展示数据
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    
    cell.messageFrame =  self.topic_current.messageFrames[indexPath.row];
    
    if (indexPath.row == (self.topic_current.messageFrames.count - 1) && !self.topic_current.endPage) {
        
        [self filterWithparameter:self.topic_current.parameters catigroyIndex:self.topic_current.catigoryIndex];
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.countryTableView) {
 
        //1 收起国家表格
        [self coverOnClick:self.coverView];
        
        
        messageCatigroyCountryModel *country = self.catigroyGroup[indexPath.row];
        
        //2 选择项一样时不刷新当前数据
        if ([self.countryName isEqualToString:country.name]) {
            
            return;
        }
        
        //3 设置当前国家
        self.countryName =country.name;
        [self titleButtonFitWithTitle:country.name];
        
        //4 根据当前主题添加展示表格
        [self makeTableWithCountryCatigory: country];
        
        //5 筛选项添加数据
        self.topView.catigoryCountry = country;
        

        
        return;
    }

    
    XWGJMessageFrame  *messageFrame =  self.topic_current.messageFrames[indexPath.row];
    
    [self.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:messageFrame.message.message_id] animated:YES];
    
}



#pragma mark : UIScrollViewDelege

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgView) {
        
        //监听滚动，实现顶部工具条按钮切换
        CGFloat offsetX = scrollView.contentOffset.x;
        
        CGFloat width = scrollView.frame.size.width;
        
        NSInteger index =  (offsetX + .5f *  width) / width;

//        if (index == self.topic_current.catigoryIndex) return;

        [self.topView scrollToCatigoryIndex:index];
        
    }
    
}

//设置self.title

- (void)titleButtonFitWithTitle:(NSString *)title{

    [self.titleView setTitle: title forState:UIControlStateNormal];
    
    [self.titleView sizeToFit];
}

- (void)titleOnClick:(UIButton *)sender{
    
     sender.selected = !sender.selected;
    
    [self countryTableViewShow:sender.selected];
    
}

- (void)coverOnClick:(UIButton *)sender{

    [self titleOnClick:self.titleView];
}


- (void)countryTableViewShow:(BOOL)show{

   
    CGFloat distance = show ? self.catigroyGroup.count * CELL_HIGHT_DEFAULT : 0 ;
    
    CGFloat alpha = show ? 1 : 0;
   
    
    if (show) self.countryBgView.alpha = alpha;
    
    [UIView animateWithDuration:ANIMATION_DUATION delay:ANIMATION_DUATION options:UIViewAnimationOptionCurveEaseIn animations:^{
        
            self.countryTableView.mj_h = distance;
        
            self.coverView.alpha = alpha;
        
    } completion:^(BOOL finished) {
        
        if (!show) {
            
            self.countryBgView.alpha = alpha;
            
        }
        
    }];
        
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
