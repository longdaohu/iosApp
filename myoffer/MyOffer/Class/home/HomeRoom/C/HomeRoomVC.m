//
//  HomeRoomVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomVC.h"
#import "HomeRoomTopView.h"
#import "HomeRoomSearchVC.h"
#import "HomeRoomIndexObject.h"
#import "HttpApiClient_API_51ROOM.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "HomeRoomIndexFrameObject.h"

@interface HomeRoomVC ()
@property(nonatomic,strong)NSArray *roomGroups;
@property(nonatomic,strong)HomeRoomIndexObject *UKRoomObj;
@property(nonatomic,strong)HomeRoomIndexObject *AURoomObj;
@property(nonatomic,strong)HomeRoomIndexFrameObject *UKRoomFrameObj;
@property(nonatomic,strong)HomeRoomIndexFrameObject *AURoomFrameObj;
@property(nonatomic,assign)BOOL isUK;

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

- (void)makeData{
    
    
    NSInteger  index = self.isUK ? 0 : 4;
    if (self.isUK && self.UKRoomObj) {
        self.roomFrameObj = self.UKRoomFrameObj;
        [self reLoadWithRoomData:self.UKRoomObj];
        return;
    }
    
    if (!self.isUK && self.AURoomObj) {
        self.roomFrameObj = self.AURoomFrameObj;
        [self reLoadWithRoomData:self.AURoomObj];
        return;
    }

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
        self.UKRoomObj = indexObj;
        self.UKRoomFrameObj = roomFrameObj;
    }else{
        self.AURoomObj = indexObj;
        self.AURoomFrameObj = roomFrameObj;
    }
    
        [self reLoadaaaaWithRoomFrameData:roomFrameObj];
    //    [self reLoadWithRoomData:indexObj];
}

- (void)reLoadaaaaWithRoomFrameData:(HomeRoomIndexFrameObject *)roomFrameObj{
    
    
    for (myofferGroupModel *group in self.roomGroups) {
        
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
        
        self.groups = self.roomGroups;
        [self toReLoadTable];
    }
}

- (void)reLoadWithRoomData:(HomeRoomIndexObject *)indexObj{

    
    for (myofferGroupModel *group in self.roomGroups) {

        if (group.type == SectionGroupTypeRoomHotCity) {

            if (indexObj.hot_city.count == 0)  continue;
            group.items = @[indexObj.hot_city];
            group.cell_height_set = 185;
        }

        if (group.type == SectionGroupTypeRoomApartmentRecommendation) {

            if (indexObj.accommodations.count == 0) continue;
            group.items = @[indexObj.accommodations];
            group.cell_height_set = 252;

        }
        
        if (group.type == SectionGroupTypeRoomHomestay) {
            if (indexObj.flats.count == 0) continue;
            group.items = @[indexObj.flats];
            group.cell_height_set = self.roomFrameObj.flat_Section_Height;
        }
        
        if (group.type == SectionGroupTypeRoomCustomerPraise) {

            if (indexObj.comments.count == 0) continue;
            group.items = @[indexObj.comments];
            group.cell_height_set = 228 + 30;

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
        homestay.accesory_title= @"查看更多";
 
        myofferGroupModel *praise  = [myofferGroupModel groupWithItems:nil header:@"客户好评"];
        praise.type = SectionGroupTypeRoomCustomerPraise;
        
        _roomGroups = @[hot_activity,hot_city,apartment,homestay,praise];

    }
    
    return _roomGroups;
}

- (void)headerButtonClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case HomeRoomTopViewButtonTypeUK:{
            self.isUK = YES;
            [self makeData];
        }
             break;
        case HomeRoomTopViewButtonTypeAU:{
            self.isUK = NO;
            [self makeData];
        }
            break;
        case HomeRoomTopViewButtonTypeSearch:{
            [self caseRoomSearch];
        }
            break;
        case HomeRoomTopViewButtonTypeMap:{
            
        }
            break;
        default:
            break;
    }
}
- (void)caseRoomSearch{
    
    HomeRoomSearchVC *vc = [[HomeRoomSearchVC alloc] init];
    MyofferNavigationController *nav = [[MyofferNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
