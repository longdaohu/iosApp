//
//  HomeRoomSearchVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomSearchVC.h"
#import "FiltContent.h"
#import "FilterContentFrame.h"
#import "FilterTableViewCell.h"
#import "RoomSearchResultVC.h"
#import "HomeRoomSearchCountryView.h"
#import "HomeRoomSearchResultView.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "RoomSearchResultItemModel.h"

@interface HomeRoomSearchVC ()<UITableViewDelegate,UITableViewDataSource,FilterTableViewCellDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITextField *search_TF;
@property(nonatomic,strong)HomeRoomSearchCountryView *countryView;
@property(nonatomic,strong)HomeRoomSearchResultView *resultView;
@property(nonatomic,strong)UIButton *countyBtn;
@property(nonatomic,assign)NSInteger country_code;

@end

@implementation HomeRoomSearchVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page新版首页"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page新版首页"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
    [self makeDara];
}


- (NSMutableArray *)groups{
    
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    
    return _groups;
}

- (HomeRoomSearchCountryView *)countryView{
    
    if (!_countryView) {
        WeakSelf
        _countryView = [[HomeRoomSearchCountryView alloc] initWithFrame:self.view.bounds];
        _countryView.actionBlock = ^(NSDictionary *item) {
            [weakSelf caseChangeCountry:item];
        };
       [self.view addSubview:_countryView];
    }
    
    return _countryView;
}

- (HomeRoomSearchResultView *)resultView{
    
    if (!_resultView) {
        
        WeakSelf
        _resultView  = [HomeRoomSearchResultView viewWithHidenCompletion:^(BOOL finished) {
            
             weakSelf.search_TF.text = @"";
            [weakSelf.search_TF resignFirstResponder];
            
        }];
         _resultView.frame = self.view.bounds;
        _resultView.actionBlock = ^(RoomSearchResultItemModel  *item) {
            [weakSelf caseSearchWithItem:item];
        };
        [self.view addSubview:_resultView];
    }
    
    return _resultView;
}

- (void)makeUI{
 
    [self makeNavigationView];
    [self makeTableView];
}

- (void)makeNavigationView{
    
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_view];
    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [one setImage:XImage(@"home_room_uk") forState:UIControlStateNormal];
    [left_view addSubview:one];
    [one addTarget:self action:@selector(countryOnClick) forControlEvents:UIControlEventTouchUpInside];
    self.countyBtn = one;
    
    UIButton *two = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 15, 30)];
    two.contentMode = UIViewContentModeScaleAspectFit;
    [two setImage:XImage(@"Trp_Black_Down") forState:UIControlStateNormal];
    [two addTarget:self action:@selector(countryOnClick) forControlEvents:UIControlEventTouchUpInside];
    [left_view addSubview:two];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pageDismiss)];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH , 26)];
    searchTF.font = XFONT(10);
    searchTF.backgroundColor = XCOLOR(243, 246, 249, 1);
    searchTF.layer.cornerRadius = 13;
    searchTF.layer.masksToBounds = YES;
    searchTF.placeholder = @"输入关键字搜索城市，大学，公寓";
    self.navigationItem.titleView = searchTF;
    searchTF.clearButtonMode =  UITextFieldViewModeAlways;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.delegate = self;
    self.search_TF = searchTF;
    [searchTF addTarget:self action:@selector(caseSearchValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView setImage:XImage(@"home_application_search_icon")];
    searchTF.leftView = leftView;
    searchTF.leftViewMode =  UITextFieldViewModeAlways;
    
    if (self.actionBlock) {
        [searchTF becomeFirstResponder];
    }
}

-(void)makeDara{
    
    if (self.actionBlock) return;
 
    FiltContent  *historyHot = [FiltContent filterWithIcon:nil  title:@"热门搜索" subtitlte:@"" filterOptionItems:nil];
    FilterContentFrame *historyHotFrame = [FilterContentFrame filterFrameWithFilter:historyHot];
    WeakSelf
    //请求推荐数据
    [self startAPIRequestWithSelector:kAPISelectorSearchRecommand parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *items = (NSArray *)response;
        historyHot.optionItems = items;
        historyHotFrame.filter = historyHot;
         [weakSelf.groups addObject:historyHotFrame];
    
        [weakSelf.tableView reloadData];
    }];
    
    
    if (!LOGIN)return; //未登录不加载下一步
    
    FiltContent  *history = [FiltContent filterWithIcon:nil   title:@"历史搜索" subtitlte:@"" filterOptionItems:nil];
    FilterContentFrame *historyFrame = [FilterContentFrame filterFrameWithFilter:history];
 
    //请求历史数据
    [self startAPIRequestWithSelector:kAPISelectorhistorySearch parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *text_arr =  [response valueForKeyPath:@"text"];
        history.optionItems = text_arr;
        historyFrame.filter = history;
 
        [weakSelf.groups addObject:historyFrame];
        [weakSelf.tableView reloadData];
    }];
 
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    FilterTableViewCell *cell =[FilterTableViewCell cellInitWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.upButton.hidden = YES;
    cell.delegate   = self;
    cell.indexPath   = indexPath;
    cell.filterFrame  = self.groups[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterContentFrame *fileritem = self.groups[indexPath.row];
    
    return fileritem.cellHeigh;
}

#pragma mark: FilterTableViewCellDelegate
-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath
{
 
    self.search_TF.text = sender.currentTitle;
    [self.search_TF becomeFirstResponder];
    
}

#pragma mark :  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    [self caseSearchValueChange:textField];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
    [self.countryView hide];
    [self.resultView show];
    if (textField.text.length > 0) {
        [self caseSearchValueChange:textField];
    }
    
    return YES;
}


#pragma mark : 事件处理
-  (void)pageDismiss{
    
//    if(self.resultView.state){
//
//        [self.resultView hide];
//        self.search_TF.text = @"";
//        return;
//    }
//
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)countryOnClick{
    
    [self.search_TF resignFirstResponder];
    if (self.countryView.coverIsHiden) {
        [self.countryView show];
    }else{
        [self.countryView hide];
    }
}

- (void)caseSearchWithItem:(RoomSearchResultItemModel *)item{
 

    [self.view endEditing:YES];
//    if (self.actionBlock) {
//        self.actionBlock(item_id);
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
    RoomSearchResultVC *vc = [[RoomSearchResultVC alloc] init];
    vc.item = item;
    PushToViewController(vc);
}

- (void)caseChangeCountry:(NSDictionary *)item{
    
    NSString *code = item[@"code"];
    NSString *icon = item[@"icon"];
    //    判断是否是当前与选择国家是否一样
    if (code.integerValue == self.country_code) return;
    //    添加相关属性
    [self.countyBtn setImage:XImage(icon) forState:UIControlStateNormal];
    self.country_code = code.integerValue;
    
    //    重新搜索
    if (self.search_TF.text.length > 0) {
        [self caseSearchValueChange:self.search_TF];
    }
}

- (void)caseSearchValueChange:(UITextField *)textField{
 
    [self caseSearchWithText:textField.text];
    
}

- (void)caseSearchWithText:(NSString *)text{

    //    输入框为空时,不做网请求操作
    if (text.length == 0 || !text) {
        [self.resultView clearAllData];
        return;
    }
    /*
         self.country_code  =   英国 0 、 澳州  4 ；默认英国
         keywords 搜索关键字
     */
    WeakSelf
    [[HttpsApiClient_API_51ROOM instance] Search_Place:self.country_code keywords:[text toUTF8WithString] completionBlock:^(CACommonResponse *response) {
        NSString *status = [NSString stringWithFormat:@"%d",response.statusCode];
        if (![status isEqualToString:@"200"]) {
            [self.resultView showError:@"网络请求错误,请确认网络是否正常"];
            return ;
        }
        id result = [response.body KD_JSONObject];
        [weakSelf updateSearchUIWithResponse:result];
    }];
}

- (void)updateSearchUIWithResponse:(id)response{
 
    NSArray *items = [RoomSearchResultItemModel mj_objectArrayWithKeyValuesArray:response];
    if (items.count == 0) {
        [self.resultView showError:@"没有搜到相关信息，请检查关键字是否输入正确。"];
        return;
    }
    self.resultView.items = items;
}

//- (void)viewDidDisappear:(BOOL)animated{
//
//    HttpsApiClient_API_51ROOM *item = [HttpsApiClient_API_51ROOM instance];
//    item = nil;
//}

- (void)dealloc{

    KDClassLog(@"51ROOM搜索 + HomeRoomSearchVC + dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

