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
#import "RoomItemDetailVC.h"
#import <Mapbox/Mapbox.h>
#import "JHAnnotationView.h"
#import "JHPointAnnotation.h"

@interface RoomMapVC ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MGLMapViewDelegate>
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong) UICollectionView *bgView;
@property(nonatomic,strong)MGLMapView *mapView;
@property(nonatomic,strong)NSArray *annotationsArray;
@property(nonatomic,strong)JHPointAnnotation *current_annotation;
@property(nonatomic,strong)HomeRoomIndexFlatsObject *current_item;
@property(nonatomic,assign) BOOL isMapCanLoding;

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
 
    [self makeMapView];
    [self makeOtherView];
}

- (void)makeMapView{
    
    NSURL *url = [NSURL URLWithString:@"mapbox://styles/mapbox/streets-v10"];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:url];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mapView];
    mapView.showsScale = YES;
    mapView.minimumZoomLevel  = 11;
    mapView.pitchEnabled  = YES;//是否倾斜地图
    mapView.rotateEnabled  = YES; //是否旋转地图
    mapView.delegate  = self;
    self.mapView = mapView;
    
    if (self.itemFrameModel) {
        
       RoomItemModel *item = self.itemFrameModel.item;
        
        JHPointAnnotation *note = [[JHPointAnnotation alloc] init];
        note.coordinate  = CLLocationCoordinate2DMake(item.lat.floatValue, item.lng.floatValue);
        note.title  = [NSString stringWithFormat:@"%@",item.price];
        note.index = 0;
        self.annotationsArray = @[note];
        
    }else{
        
        CLLocationCoordinate2D London = CLLocationCoordinate2DMake(51.516438, -0.115063);
        CLLocationCoordinate2D Sydney = CLLocationCoordinate2DMake(-33.8875694, 151.2043603);
        CLLocationCoordinate2D local = self.isUK ? London : Sydney;
        [mapView setCenterCoordinate: local
                                    zoomLevel:11
                                     animated:YES];
    }
    
}


- (void)makeOtherView{
 
    
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
    bgView.layer.shadowColor = XCOLOR_BLACK.CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowOpacity = 0.3;
    bgView.clipsToBounds = NO;
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
    
    if (self.itemFrameModel) {
        
        [self casePop];
    }
    
    if (self.current_item) {
        
        RoomItemDetailVC *vc = [[RoomItemDetailVC alloc] init];
        vc.room_id = self.current_item.no_id;
        vc.isFromMap = YES;
        PushToViewController(vc);
        
    }
    
}

#pragma mark : UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self caseSearch];
    return NO;
}

#pragma mark : 网络请求
- (void)makeDataWithMapCoordinate:(CLLocationCoordinate2D)coordinate{
    
    NSString *value = [NSString stringWithFormat:@"%lf,%lf",coordinate.latitude,coordinate.longitude];
    NSDictionary *prm = @{
                              KEY_PAGE: @"1",
                              KEY_PAGESIZE: @"10",
                              KEY_TYPE: @"location",
                              KEY_TYPE_ID:value
                          };
    [self makeData:prm];
}

- (void)makeData:(NSDictionary *)parameter{

    WeakSelf;
    [self property_listWhithParameters:parameter additionalSuccessAction:^(id response, int status) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSError *error, int status) {
        
    }];
}

- (void)updateUIWithResponse:(id)response{
 
    NSDictionary *result = (NSDictionary *)response;
    NSString *unit = result[@"unit"];
    NSArray *properties  = result[@"properties"];
    
    NSArray *items  = [HomeRoomIndexFlatsObject  mj_objectArrayWithKeyValuesArray:properties];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeRoomIndexFlatsObject *it = (HomeRoomIndexFlatsObject *)obj;
        it.unit = unit;
    }];
    self.items =items;
    
    if (items.count > 0) {
        self.itemFrameModel = nil;
        self.current_item = items.firstObject;
    }else{
        self.current_item = nil;
    }
    [self caseCellDose];
    [self.bgView reloadData];
    [self toLoLoadWithItems:items];
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
                           KEY_PAGESIZE: @"30",
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

- (void)toLoLoadWithItems:(NSArray *)items{
    
    self.current_annotation = nil;
    [self.mapView removeAnnotations:self.annotationsArray];
 
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSInteger index = 0; index < items.count; index++) {
    
        HomeRoomIndexFlatsObject *item = items[index];
        JHPointAnnotation *note = [[JHPointAnnotation alloc] init];
        note.coordinate  = CLLocationCoordinate2DMake(item.lat.floatValue, item.lng.floatValue);
        note.title  = [NSString stringWithFormat:@"%@",item.rent];
        note.index = index;
        [tmp addObject:note];
    }
    
    if (tmp > 0) {
        self.annotationsArray = [tmp copy];
        [self mapViewDidFinishLoadingMap:self.mapView];
//        [self reloadAnnotationViewWithAnnotation:self.current_annotation];
    }
}


#pragma mark MGLMapViewDelegate
///是否显示气泡
-(BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    
    return false;
}

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    if (self.annotationsArray.count == 0) {
        return;
    }
    ///地图加载完成时加载大头针
    JHPointAnnotation *item = self.annotationsArray.firstObject;
    item.onSelected = YES;
    self.current_annotation = item;
    [mapView addAnnotations:self.annotationsArray];
    
    if (self.itemFrameModel) {
        [mapView setCenterCoordinate: self.current_annotation.coordinate zoomLevel: 13 animated:YES];
    }else{
        [self.mapView showAnnotations:self.annotationsArray edgePadding:UIEdgeInsetsMake(160, 50, 200, 50) animated:YES];
     }
    
}

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    
    WeakSelf
    JHPointAnnotation *anno = (JHPointAnnotation *)annotation;
    JHAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MGLAnnotationView"];
    if (annotationView == nil) {
        annotationView = [[JHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MGLAnnotationView"];
        [annotationView setFrame:CGRectMake(0, 0, 98, 50)];
        annotationView.actionBlock = ^(id sender) {
            [weakSelf reloadAnnotationViewWithAnnotation:sender];
        };
    }
    annotationView.title = annotation.title;
    annotationView.annotationViewState = anno.onSelected;
    
    return annotationView;
}


// 自定事件
- (void)reloadAnnotationViewWithAnnotation:(id<MGLAnnotation>)annotation{
    
    if (self.current_annotation == annotation) {
        
        JHPointAnnotation *point = (JHPointAnnotation *)annotation;
        JHAnnotationView *annotationView  = (JHAnnotationView *)[self.mapView viewForAnnotation:point];
        [annotationView.superview  bringSubviewToFront:annotationView];
        
        return;
    }
    
    self.current_annotation.onSelected = NO;
    JHAnnotationView *currnt_annotationView  = (JHAnnotationView *)[self.mapView viewForAnnotation:self.current_annotation];
    currnt_annotationView.annotationViewState = self.current_annotation.onSelected;
 
    
    JHPointAnnotation *point = (JHPointAnnotation *)annotation;
    point.onSelected =  YES;
    JHAnnotationView *annotationView  = (JHAnnotationView *)[self.mapView viewForAnnotation:point];
    annotationView.annotationViewState = point.onSelected;
    self.current_annotation = point;
    [annotationView.superview  bringSubviewToFront:annotationView];
    
    self.current_item = self.items[self.current_annotation.index];
    [self.bgView reloadData];
}

- (void)mapView:(MGLMapView *)mapView regionDidChangeWithReason:(MGLCameraChangeReason)reason animated:(BOOL)animated{
 
//    CLLocation *orig = [[CLLocation alloc] initWithLatitude:self.current_annotation.coordinate.latitude  longitude:self.current_annotation.coordinate.longitude];
//
//    CLLocation *target = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude  longitude:mapView.centerCoordinate.longitude];
//    CLLocationDistance kilometers = [orig distanceFromLocation:target];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    self.mapView.delegate = nil;
    self.mapView = nil;
    KDClassLog(@"房源详情 + 地图RoomMapVC + dealloc");
}

@end
