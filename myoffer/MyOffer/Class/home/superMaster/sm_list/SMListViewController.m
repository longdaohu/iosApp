//
//  SMListViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/20.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMListViewController.h"
#import "SMHotModel.h"
#import "SMHotCell.h"
#import "SMHotFrame.h"
#import "SMDetailViewController.h"
#import "UniversityCourseFilterViewController.h"


@interface SMListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MyOfferTableView  *tableView;

@property(nonatomic,strong)NSMutableArray  *items;
@property(nonatomic,strong)NSMutableDictionary *parameters;
@property(nonatomic,strong)UniversityCourseFilterViewController *filter;
@property(nonatomic,strong)NSArray *areas;
@end

@implementation SMListViewController


- (NSMutableArray *)items{

    if (!_items) {
        
        _items = [NSMutableArray array];
    }
    
    return _items;
}

- (NSMutableDictionary *)parameters{

    if (!_parameters) {
        
        _parameters = [NSMutableDictionary dictionary];
        
        [_parameters setValue:@0 forKey:KEY_PAGE];
        
        [_parameters setValue:@10 forKey:KEY_SIZE];
    }
    
    return _parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUI];
    
    [self makeData];
    
}

#pragma mark : 网络加载

- (void)makeData{
    

    NSString *tag = self.tag ? self.tag : @"";
    [self.parameters setValue:tag forKey:@"tag"];
 
    NSString *area_id = self.area_id ? self.area_id : @"";
    [self.parameters setValue:area_id forKey:@"area_id"];
    
    [self makeSupeMasterData];
    
}

- (void)makeSupeMasterData{
    
    XWeakSelf
    
    [self startAPIRequestWithSelector:@"GET api/sm/lectures" parameters:self.parameters expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        if (weakSelf.items.count <= 0) {
           
            [weakSelf.tableView emptyViewWithError:@"网络请求错误，请确认网络是否连接！"];

        }
        
        [weakSelf.tableView.mj_footer endRefreshing];

    }];
    
}

- (void)updateUIWithResponse:(id)response{
    
    NSInteger page =   [response[@"page"] integerValue];
    // 1  (page == 0)  移除数据
    if (page == 0)  {
    
        [self.items removeAllObjects];
        
        [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

     }
    
    
    //2 字典转数组
    NSArray *items = [SMHotModel mj_objectArrayWithKeyValuesArray:response[@"items"]];
    NSMutableArray *hots_temp = [NSMutableArray array];
    for (SMHotModel *hot in items){
        
        [hots_temp addObject:[SMHotFrame frameWithHot:hot]];
    }
    
    [self.items addObjectsFromArray:hots_temp];
    
    
    //3 参数 page + 1
    [self.parameters setValue:@(page + 1) forKey:KEY_PAGE];
    
    
    //4 判断数据是否加载完成
    if ([response[@"counts"] integerValue] > self.items.count) {
        
        [self.tableView.mj_footer endRefreshing];
        
    }else{
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }
    
    //5 消息提示
    if (self.items.count > 0) {
        
        [self.tableView emptyViewWithHiden:YES];
        
    }else{
        
        [self.tableView emptyViewWithError:@"亲...抱歉找不到您要的内容，我们会再接再劢的！"];
    }
    
    
    [self.tableView reloadData];

    
}


#pragma mark : 添加 UI

- (void)makeUI{

    self.title = @"超级导师列表";
    
    [self makeTableView];
    
    [self makeFilter];
    
}

-(void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, XNAV_HEIGHT, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)makeFilter{
    
    XWeakSelf
    
    UniversityCourseFilterViewController *filter =[[UniversityCourseFilterViewController alloc] initWithActionBlock:^(NSString *value, NSString *key) {
        
        
        NSString *real_value = value;
        
        if ([key isEqualToString:@"area_id"]) {
            
            NSArray *names = [self.areas valueForKey:@"name"];
            
            if ([names containsObject:value]) {
                
                NSInteger index = [names indexOfObject:value];
                
                NSArray *idArr = [self.areas valueForKeyPath:@"id"];

                real_value = idArr[index];

            }
            
        }
        
        [weakSelf.parameters setValue:real_value forKey:key];
        
        [weakSelf.parameters setValue:@0 forKey:KEY_PAGE];
        
        [weakSelf makeSupeMasterData];
        
        
    }];
    
    [self addChildViewController:filter];
    
    self.filter = filter;
    
    CGFloat base_Height = XNAV_HEIGHT + 50;
    filter.base_Height = base_Height;
    filter.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, base_Height);
    
    NSMutableArray  *temps = [[self.areas valueForKeyPath:@"name"] mutableCopy];
    
    [temps insertObject:KEY_ALL  atIndex:0];
    
    filter.rightInfo = @{
                         @"key" : @"area_id",
                         @"title" : @"专业方向",
                         @"items" : [temps copy]
                         };
    filter.leftInfo = @{
                        
                        @"key" : @"tag",
                        @"title" : @"活动主题",
                        @"items" : @[KEY_ALL,@"留学生活",@"大学招生官",@"职业发展",@"海外学习辅导"]
                        };
    
    filter.current_Level = self.tag ? self.tag : KEY_ALL;
    
   
    NSArray *idArr = [self.areas valueForKeyPath:@"id"];
    
    NSString *area = KEY_ALL;
    if ([idArr containsObject:self.area_id]) {
        
        NSInteger index = [idArr indexOfObject:self.area_id];
        
        area = [self.areas[index] valueForKey:@"name"];
    }
    
    filter.current_area =  self.area_id ? area : KEY_ALL;
    
    [self.view addSubview:filter.view];
    
    
}

-(NSArray *)areas
{
    if (!_areas) {
        
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        
        _areas = [ud valueForKey:@"Subject_CN"];
    }
    
    return _areas;
}



#pragma mark :  UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    SMHotFrame *hot_frame  = self.items[indexPath.row];
    
    return  hot_frame.cell_height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMHotCell *hot_cell = [SMHotCell cellWithTableView:tableView];
    
    hot_cell.hotFrame = self.items[indexPath.row];
    
    return hot_cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMHotFrame *hot_frame  = self.items[indexPath.row];
    
    SMDetailViewController *detail = [[SMDetailViewController alloc] init];
    
    detail.message_id = hot_frame.hot.message_id;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark : 事件处理
- (void)loadMoreData{

    [self makeSupeMasterData];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

