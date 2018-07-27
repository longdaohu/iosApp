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

@interface HomeRoomVC ()
@property(nonatomic,strong)NSArray *roomGroups;

@end

@implementation HomeRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //关于地图方面
    //https://www.mapbox.com/ios-sdk/maps/overview/
    //https://blog.csdn.net/zhengang007/article/details/79170558
    //https://github.com/wangzhengang/MapboxExample/
    [self makeUI];
}

- (void)makeUI{

    WeakSelf
    HomeRoomTopView  *roomHeaderView = [[HomeRoomTopView alloc] initWithFrame:CGRectMake(0, 120, XSCREEN_WIDTH, 300)];
    roomHeaderView.actionBlock = ^(UIButton *sender) {
        [weakSelf headerButtonClick:sender];
    };
    
    self.headerView = roomHeaderView;
    
    self.groups = self.roomGroups;
}


- (NSArray *)roomGroups{
    
    if (!_roomGroups) {
        
        myofferGroupModel *hot_activity  = [myofferGroupModel groupWithItems:nil header:@"热门活动"];
        hot_activity.type = SectionGroupTypeRoomHotActivity;
        
        NSArray *cities = @[
                                @{@"country":@"英国",@"city":@"伦敦",@"name":@"伦敦\nLondon", @"icon":@"city_ld.jpg",},
                                @{@"country":@"英国",@"city":@"曼彻斯特",@"name":@"曼彻斯特\nManchester", @"icon":@"city_mcst.jpg",},
                                @{@"country":@"英国",@"city":@"伯明翰",@"name":@"伯明翰\nBirmingham", @"icon":@"city_bmh.jpg",},
                                @{@"country":@"澳大利亚",@"city":@"悉尼",@"name":@"悉尼\nSydney", @"icon":@"city_xn.jpg",},
                                @{@"country":@"澳大利亚",@"city":@"墨尔本",@"name":@"墨尔本\nMelbourne", @"icon":@"city_mrb.jpg",},
                                @{@"country":@"新西兰",@"city":@"奥克兰",@"name":@"奥克兰\nAuckland", @"icon":@"city_akl.jpg"}
                            ];
        myofferGroupModel *hot_city  = [myofferGroupModel groupWithItems:@[cities] header:@"热门城市"];
        hot_city.accesory_title= @"查看更多";
        hot_city.type = SectionGroupTypeRoomHotCity;
        hot_city.cell_height_set = 185;

         myofferGroupModel *apartment  = [myofferGroupModel groupWithItems:@[ cities ] header:@"公寓推荐"];
        apartment.type = SectionGroupTypeRoomApartmentRecommendation;
        apartment.cell_height_set = 252;
        
        myofferGroupModel *homestay  = [myofferGroupModel groupWithItems:@[cities] header:@"精选民宿"];
        homestay.type = SectionGroupTypeRoomHomestay;
        homestay.accesory_title= @"查看更多";
        CGFloat item_w =  (XSCREEN_WIDTH - 50) * 0.5;
        CGFloat item_h =  item_w + 80;
        NSInteger row = (NSInteger)(cities.count * 0.5 + 0.5);
        homestay.cell_height_set = (item_h + 10) * row + 30;
        
        myofferGroupModel *praise  = [myofferGroupModel groupWithItems:@[ cities ] header:@"客户好评"];
        praise.type = SectionGroupTypeRoomCustomerPraise;
        praise.cell_height_set = 228 + 30;
        
        _roomGroups = @[hot_activity,hot_city,apartment,homestay,praise];

    }
    
    return _roomGroups;
}

- (void)headerButtonClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case HomeRoomTopViewButtonTypeUK:{
            
        }
             break;
        case HomeRoomTopViewButtonTypeAU:{
            
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
