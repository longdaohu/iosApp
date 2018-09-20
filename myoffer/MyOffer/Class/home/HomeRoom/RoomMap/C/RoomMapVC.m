//
//  RoomMapVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomMapVC.h"
#import "RoomItemMapCell.h"
#import "HomeRoomSearchVC.h"
#import "HomeRoomIndexFlatsObject.h"

@interface RoomMapVC ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong) UICollectionView *bgView;
@property(nonatomic,strong)HomeRoomIndexFlatsObject *current_item;
@end

@implementation RoomMapVC

-(void)viewWillAppear:(BOOL)animated
{
    NavigationBarHidden(YES);
    [MobClick beginLogPageView:@"page51Room房源详情"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page51Room房源详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}

- (void)makeUI{
    
    CGFloat left_margin = 20;
    CGFloat item_y = XStatusBar_Height + 20;
    CGSize item_size = CGSizeMake(36, 36);
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(left_margin, item_y , item_size.width, item_size.height)];
    backBtn.layer.cornerRadius = item_size.height * 0.5;
    [backBtn setImage:XImage(@"back_arrow_black") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.backgroundColor = XCOLOR_WHITE;
    backBtn.layer.cornerRadius = item_size.height * 0.5;
    

    CGFloat search_x = left_margin + item_size.width + 10;
    CGFloat search_w = XSCREEN_WIDTH - left_margin - search_x;
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(search_x, item_y, search_w , item_size.height)];
    [self.view addSubview:searchTF];
    searchTF.font = XFONT(10);
    searchTF.backgroundColor = XCOLOR_WHITE;
    searchTF.layer.cornerRadius = item_size.height * 0.5;
    searchTF.placeholder = @"输入关键字搜索城市，大学，公寓";
    searchTF.clearButtonMode =  UITextFieldViewModeAlways;
    searchTF.layer.shadowColor = XCOLOR_BLACK.CGColor;
    searchTF.layer.shadowOffset = CGSizeMake(0, 3);
    searchTF.layer.shadowOpacity = 0.1;
 
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView setImage:XImage(@"home_application_search_icon")];
    searchTF.leftView = leftView;
    searchTF.leftViewMode =  UITextFieldViewModeUnlessEditing;
    searchTF.delegate = self;
 
    UICollectionViewFlowLayout  *flow = [[UICollectionViewFlowLayout alloc] init];
    CGFloat bg_x  = 0;
    CGFloat bg_h  = 149;
    CGFloat bg_y  = self.view.mj_h - bg_h;
    CGFloat bg_w  = XSCREEN_WIDTH;
    flow.itemSize = CGSizeMake(bg_w, bg_h);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing = 0;
    UICollectionView *bgView = [[UICollectionView alloc] initWithFrame:CGRectMake(bg_x, bg_y, bg_w, bg_h) collectionViewLayout:flow];
    [self.view addSubview:bgView];
    bgView.dataSource = self;
    bgView.delegate = self;
    bgView.pagingEnabled = YES;
    [bgView registerNib:[UINib nibWithNibName:@"RoomItemMapCell" bundle:nil] forCellWithReuseIdentifier:@"RoomItemMapCell"];
    self.bgView = bgView;
    [self caseCellDose];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.itemFrameModel || self.current_item) {
        return 1;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomItemMapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomItemMapCell" forIndexPath:indexPath];
    if (self.itemFrameModel) {
        cell.itemFrameModel = self.itemFrameModel;
    }
    if (self.current_item) {
        cell.item = self.current_item;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark : UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self caseSearch];
    return NO;
}


#pragma mark : 网络请求
- (void)makeData:(NSDictionary *)parameter{
    /*
     page    Int     = 1
     pagesize    int    =10
     type    string    City, university
     type_id    string    19
     max    string    租金区间 最多
     min    srting    租金区间 最少
     lease    Int     最大租期，租多少周  如：52
     */
    //    [self.parameter setValue:[NSString stringWithFormat:@"%ld",self.next_page] forKey:KEY_PAGE];
    
    WeakSelf;
    [self property_listWhithParameters:parameter additionalSuccessAction:^(id response, int status) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSError *error, int status) {
        
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    NSDictionary *result = (NSDictionary *)response;
    //    NSString *total_page = result[@"total_page"];
    //    NSString *current_page = result[@"current_page"];
    NSString *unit = result[@"unit"];
    NSArray *properties  = result[@"properties"];
    
    NSArray *items  = [HomeRoomIndexFlatsObject  mj_objectArrayWithKeyValuesArray:properties];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeRoomIndexFlatsObject *it = (HomeRoomIndexFlatsObject *)obj;
        it.unit = unit;
    }];
    self.items =items;
    
    if (items.count > 0) {
        self.current_item = items.firstObject;
    }else{
        self.current_item = nil;
    }
    [self caseCellDose];
    [self.bgView reloadData];
 
}


#pragma mark : 事件处理
- (void)casePop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)caseSearch{
    
    HomeRoomSearchVC *vc = [[HomeRoomSearchVC alloc] init];
    MyOfferWhiteNV *nav = [[MyOfferWhiteNV alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    WeakSelf
    vc.actionBlock = ^(RoomSearchResultItemModel *item) {
        [weakSelf caseSearchResultWithItem:item];
    };
}

- (void)caseSearchResultWithItem:(RoomSearchResultItemModel *)item{
    
    NSDictionary *prm = @{
                           KEY_PAGE: @"1",
                           KEY_PAGESIZE: @"10",
                           KEY_TYPE: item.type,
                           KEY_TYPE_ID:item.item_id
                           };
    [self makeData:prm];
}

- (void)caseCellDose{
    
    if (self.itemFrameModel || self.items.count > 0) {
        self.bgView.hidden = false;
    }else{
        self.bgView.hidden = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
