//
//  HomeRoomSearchVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomSearchVC.h"
#import "HomeRoomSearchCountryView.h"
#import "HomeRoomSearchResultView.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "HomeSecView.h"

static NSString *const KEY_RECORD = @"roomSearchHistoryRecorded";

@interface HomeRoomSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITextField *search_TF;
@property(nonatomic,strong)HomeRoomSearchCountryView *countryView;
@property(nonatomic,strong)HomeRoomSearchResultView *resultView;
@property(nonatomic,strong)UIButton *countyBtn;
@property(nonatomic,assign)NSInteger country_code;
@property(nonatomic,strong)myofferGroupModel *group;
@property(nonatomic,strong)NSMutableArray *recordList;
@property(nonatomic,strong)HomeSecView *sectinHeader;

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


- (NSMutableArray *)recordList{
    
    if (!_recordList) {
        _recordList = [NSMutableArray array];
    }
    
    return _recordList;
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

- (HomeSecView *)sectinHeader{
    
    if (!_sectinHeader) {
        WeakSelf;
        _sectinHeader = [[HomeSecView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 50)];
        _sectinHeader.titleFontSize = 14;
        _sectinHeader.actionBlock = ^(SectionGroupType type) {
            [weakSelf caseSectionAccessory];
        };
    }
    
    return _sectinHeader;
}


- (HomeRoomSearchResultView *)resultView{
    
    if (!_resultView) {
        
        WeakSelf
        _resultView  = [HomeRoomSearchResultView resultView];
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
    self.view.backgroundColor = XCOLOR_WHITE;
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
 
     NSArray *recordList  = [USDefault valueForKey:KEY_RECORD];
     [self.recordList addObjectsFromArray:recordList];
     NSArray *items = [RoomSearchResultItemModel mj_objectArrayWithKeyValuesArray:recordList];
    if (items.count > 10) {
       items = [items subarrayWithRange:NSMakeRange(0, 10)];
    }
     self.group = [myofferGroupModel groupWithItems:items header:@"历史搜索" footer:nil accessory:@"清空"];
     self.sectinHeader.group = self.group;
     self.tableView.tableHeaderView = self.sectinHeader;
 
     [self.tableView reloadData];
}

-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = XCOLOR_WHITE;
    self.tableView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.sectionHeaderHeight = 50;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"history_cell"];
        cell.textLabel.font = XFONT(14);
    }
    if (self.group.items.count > 0) {
        RoomSearchResultItemModel *item = self.group.items[indexPath.row];
        cell.textLabel.text = item.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RoomSearchResultItemModel *item = self.group.items[indexPath.row];
    
    [self caseSearchWithItem:item];
    
}


#pragma mark :  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
    [self.countryView hide];
    if (textField.text.length > 0) {
        [self caseSearchValueChange:textField];
    }
    
    return YES;
}


#pragma mark : 事件处理
-  (void)pageDismiss{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
 
   
    if (![self.group.items containsObject:item]) {
        NSDictionary *values = item.mj_keyValues;
        [self.recordList insertObject:values atIndex:0];
        [USDefault setValue:self.recordList forKey:KEY_RECORD];
        [USDefault synchronize];
    }
   
    [self.view endEditing:YES];
    if (self.actionBlock) {
        self.actionBlock(item);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }

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

    //    输入框为空时,隐藏结果列表
    if (text.length == 0 || !text) {
        [self.resultView hide];
        return;
    }
    /*
         self.country_code  =   英国 0 、 澳州  4 ；默认英国
         keywords 搜索关键字
     */
    [self.resultView show];
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

//清空
- (void)caseSectionAccessory{

    self.recordList = nil;
    self.group.items = nil;
    [self.tableView reloadData];
    [USDefault setValue:nil forKey:KEY_RECORD];

}

- (void)dealloc{

    KDClassLog(@"51ROOM搜索 + HomeRoomSearchVC + dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

