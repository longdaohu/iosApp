//
//  HomeRoomVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomVC.h"
#import "RoomCityVC.h"
#import "RoomItemDetailVC.h"
#import "HomeRoomSearchVC.h"
#import "HomeRoomTopView.h"
#import "HomeRoomIndexObject.h"
#import "HttpApiClient_API_51ROOM.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "HomeRoomIndexFrameObject.h"
#import "HomeRoomHorizontalCell.h"
#import "HomeRoomVerticalCell.h"
#import "MyOfferWhiteNV.h"
#import "HomeRoomIndexFlatFrameObject.h"
#import "RoomSearchResultVC.h"
#import "RoomMapVC.h"
#import "RoomBannerView.h"

@interface HomeRoomVC ()
@property(nonatomic,strong)NSArray *roomGroups;
@property(nonatomic,strong)HomeRoomIndexFrameObject *UKRoomFrameObj;
@property(nonatomic,strong)HomeRoomIndexFrameObject *AURoomFrameObj;
@property(nonatomic,assign)BOOL isUK;
@property(nonatomic,strong)RoomBannerView *eventCellView;
@end

@implementation HomeRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //关于地图方面
    //https://www.mapbox.com/ios-sdk/maps/overview/
    //https://blog.csdn.net/zhengang007/article/details/79170558
    //https://github.com/wangzhengang/MapboxExample/
    [self makeUI];
    [self makeData];
}

- (RoomBannerView *)eventCellView{
    
    if (!_eventCellView) {
//        WeakSelf
        _eventCellView = [RoomBannerView new];
        _eventCellView.actionBlock = ^(NSInteger index) {
            
        };
    }
    return _eventCellView;
}

- (void)makeUI{

    WeakSelf
    HomeRoomTopView  *roomHeaderView = [[HomeRoomTopView alloc] initWithFrame:CGRectMake(0, 120, XSCREEN_WIDTH, 300)];
    roomHeaderView.actionBlock = ^(UIButton *sender) {
        [weakSelf headerButtonClick:sender];
    };
    self.headerView = roomHeaderView;
 
    NSString * appKey = @"24964499";
    NSString * appSecret = @"8ec406d891d9ba9278a3ced8d8b13b39";
    [[HttpApiClient_API_51ROOM instance] setAppKeyAndAppSecret:appKey appSecret:appSecret];
    [[HttpsApiClient_API_51ROOM instance] setAppKeyAndAppSecret:appKey appSecret:appSecret];
    
    BOOL (^pVerifyCerts)(NSURLAuthenticationChallenge *x);
    pVerifyCerts = ^(NSURLAuthenticationChallenge* certHandler)
    {
        return YES;
    };
    [[[HttpsApiClient_API_51ROOM instance] client] setVerifyHttpsCert:pVerifyCerts];
    self.isUK = YES;
}


#pragma mark : UITableView

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

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myofferGroupModel *group = self.groups[indexPath.section];
    WeakSelf
    if ((group.type == SectionGroupTypeRoomHotCity) || (group.type == SectionGroupTypeRoomApartmentRecommendation) || (group.type == SectionGroupTypeRoomCustomerPraise)) {
        HomeRoomHorizontalCell *cell = [[HomeRoomHorizontalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.group = group;
        cell.actionBlock = ^(NSInteger index, id item) {
            
            if ([item isKindOfClass:[HomeRoomIndexCityObject class]]){
                HomeRoomIndexCityObject *city = (HomeRoomIndexCityObject *)item;
                [weakSelf caseCity:city];
            }
 
            if ([item isKindOfClass:[HomeRoomIndexFlatFrameObject class]]){
                HomeRoomIndexFlatFrameObject *flatFrame = (HomeRoomIndexFlatFrameObject *)item;
                [weakSelf caseRoomWithID:flatFrame.item.no_id];
            }
            
        };
        
        return  cell;
    }
    
    if (group.type == SectionGroupTypeRoomHomestay){
        
        HomeRoomVerticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeRoomVerticalCell"];
        if (!cell) {
            cell = [[HomeRoomVerticalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HomeRoomVerticalCell"];
        }
        cell.group = group;
        cell.actionBlock = ^(NSInteger index, id item) {
            if ([item isKindOfClass:[HomeRoomIndexFlatsObject class]]){
                HomeRoomIndexFlatsObject *flat = (HomeRoomIndexFlatsObject *)item;
                [weakSelf caseRoomWithID:flat.no_id];
            }
        };
        
        return cell;
    }
    
    if (group.type == SectionGroupTypeRoomHotActivity){
        
        HomeRoomVerticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionGroupTypeRoomHotActivity"];
        if (!cell) {
            cell = [[HomeRoomVerticalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SectionGroupTypeRoomHotActivity"];
        }
        [cell.contentView addSubview:self.eventCellView];
        return cell;
    }
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row = %ld",indexPath.row];
    
    return cell;
}

#pragma mark : 数据加载
- (void)makeData{
    
    NSInteger  index = self.isUK ? 0 : 4;
    WeakSelf
    [[HttpsApiClient_API_51ROOM instance] homepage:index completionBlock:^(CACommonResponse *response) {
        NSString *status = [NSString stringWithFormat:@"%d",response.statusCode];
        if (![status isEqualToString:@"200"]) {
            NSLog(@" 网络请求错误 ");
            return ;
        }
        id result = [response.body KD_JSONObject];
        [weakSelf updateUIWithResponse:result];
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    NSDictionary *dic = (NSDictionary *)response;
    HomeRoomIndexObject *indexObj = [HomeRoomIndexObject mj_objectWithKeyValues:dic];
    HomeRoomIndexFrameObject *roomFrameObj = [[HomeRoomIndexFrameObject alloc] init];
    roomFrameObj.item = indexObj;
    self.roomFrameObj = roomFrameObj;
    
    if (self.isUK) {
        self.UKRoomFrameObj = roomFrameObj;
    }else{
        self.AURoomFrameObj = roomFrameObj;
    }
    [self reLoadWithRoomData:roomFrameObj];
}

- (void)reLoadWithRoomData:(HomeRoomIndexFrameObject *)roomFrameObj{
    
    for (myofferGroupModel *group in self.roomGroups) {
        
        if (group.type == SectionGroupTypeRoomHotActivity) {
            if (roomFrameObj.item.events.count == 0) continue;
            group.items = @[roomFrameObj];
            group.cell_height_set = roomFrameObj.event_Section_Height;
            self.eventCellView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, roomFrameObj.event_Section_Height);
            NSArray *imageGroup = [roomFrameObj.item.events valueForKey:@"img"];
            [self.eventCellView makeBannerWithImages:imageGroup   bannerSize:roomFrameObj.event_item_size];
        }
        
        if (group.type == SectionGroupTypeRoomHomestay) {
            if (roomFrameObj.item.flats.count == 0) continue;
            group.items = @[roomFrameObj];
            group.cell_height_set = roomFrameObj.flat_Section_Height;
        }
        if (group.type == SectionGroupTypeRoomApartmentRecommendation) {
            if (roomFrameObj.item.accommodations.count == 0) continue;
            group.items = @[roomFrameObj];
            group.cell_height_set = roomFrameObj.accommodation_Section_Height;
        }
        if (group.type == SectionGroupTypeRoomHotCity) {
            
            if (roomFrameObj.item.hot_city.count == 0)  continue;
            group.items = @[roomFrameObj];
            group.cell_height_set = roomFrameObj.hot_city_Section_Height;
        }
        if (group.type == SectionGroupTypeRoomCustomerPraise) {
            if (roomFrameObj.item.comments.count == 0) continue;
            group.items = @[roomFrameObj];
            group.cell_height_set = roomFrameObj.comment_Section_Height;
            
        }
        
    }
    self.groups = self.roomGroups;
    [self toReLoadTable];
}

- (NSArray *)roomGroups{
    
    if (!_roomGroups) {
        
        myofferGroupModel *hot_activity  = [myofferGroupModel groupWithItems:nil header:@"热门活动"];
        hot_activity.type = SectionGroupTypeRoomHotActivity;
        
        myofferGroupModel *hot_city  = [myofferGroupModel groupWithItems:nil header:@"热门城市"];
        hot_city.accesory_title= @"查看更多";
        hot_city.type = SectionGroupTypeRoomHotCity;
        
        myofferGroupModel *apartment  = [myofferGroupModel groupWithItems:nil header:@"公寓推荐"];
        apartment.type = SectionGroupTypeRoomApartmentRecommendation;
        
        myofferGroupModel *homestay  = [myofferGroupModel groupWithItems:nil header:@"精选民宿"];
        homestay.type = SectionGroupTypeRoomHomestay;
        
        myofferGroupModel *praise  = [myofferGroupModel groupWithItems:nil header:@"客户好评"];
        praise.type = SectionGroupTypeRoomCustomerPraise;
        
        _roomGroups = @[hot_activity,hot_city,apartment,homestay,praise];
        
    }
    
    return _roomGroups;
}

#pragma mark : 事件处理

- (void)headerButtonClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case HomeRoomTopViewButtonTypeUK:{
            self.isUK = YES;
            
            if (self.UKRoomFrameObj) {
                self.roomFrameObj = self.UKRoomFrameObj;
                [self reLoadWithRoomData:self.UKRoomFrameObj];
                return;
            }
            [self makeData];
        }
             break;
        case HomeRoomTopViewButtonTypeAU:{
            self.isUK = NO;
            
                if (self.AURoomFrameObj) {
                    self.roomFrameObj = self.AURoomFrameObj;
                    [self reLoadWithRoomData:self.AURoomFrameObj];
                    return;
                }
            [self makeData];
        }
            break;
        case HomeRoomTopViewButtonTypeSearch:{
            [self caseRoomSearch];
        }
            break;
        case HomeRoomTopViewButtonTypeMap:{
            [self caseMap];
        }
            break;
        default:
            break;
    }
}

- (void)caseMap{
    
    RoomMapVC *vc = [[RoomMapVC alloc] init];
    PushToViewController(vc);
}


- (void)caseRoomWithID:(NSString *)room_id{
    
    RoomItemDetailVC *vc  = [[RoomItemDetailVC alloc] init];
    vc.room_id = room_id;
    PushToViewController(vc);
    
}
- (void)caseCity:(HomeRoomIndexCityObject *)city{
    
    RoomSearchResultVC *vc  = [[RoomSearchResultVC alloc] init];
    vc.city = city;
    PushToViewController(vc);
}

- (void)caseRoomSearch{
    
    HomeRoomSearchVC *vc = [[HomeRoomSearchVC alloc] init];
    MyOfferWhiteNV *nav = [[MyOfferWhiteNV alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    WeakSelf
    vc.actionBlock = ^(RoomSearchResultItemModel *item) {
        [weakSelf caseResult:item];
    };
}

- (void)caseResult:(RoomSearchResultItemModel *)item{
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            RoomSearchResultVC *vc = [[RoomSearchResultVC alloc] init];
            vc.item = item;
            PushToViewController(vc);
        });
}

- (void)caseHeaderView:(SectionGroupType)type{
    
    switch (type) {
        case SectionGroupTypeRoomHotCity:
            [self caseMoreCity];
            break;
        default:
            break;
    }
    
}


- (void)caseMoreCity{
    
    HomeRoomIndexCityObject *item = self.roomFrameObj.item.hot_city.firstObject;
    [self caseCity:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
