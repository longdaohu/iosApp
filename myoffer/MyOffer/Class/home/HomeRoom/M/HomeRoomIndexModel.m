//
//  HomeRoomIndexModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexModel.h"

@implementation HomeRoomIndexModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isUK = YES;
    }
    return self;
}

- (NSInteger)country_code{
    
    if (self.isUK) {
        return 0;
    }
    return 4;
}

- (HomeRoomIndexFrameObject *)current_roomFrameObj{
    
    if (self.isUK) {
        return self.UKRoomFrameObj;
    }
    return self.AURoomFrameObj;
}


- (NSArray *)groups{
    
    if (!_groups) {
        
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
        
        _groups = @[hot_activity,hot_city,apartment,homestay,praise];
        
    }
    
    return _groups;
}

- (void)updateGroupData{
    
    for (myofferGroupModel *group in self.groups) {
        
        NSArray *items = nil;
        CGFloat cell_height = 0;
        switch (group.type) {
            case SectionGroupTypeRoomHotActivity:
            {
                items = @[self.current_roomFrameObj];
                cell_height = self.current_roomFrameObj.event_Section_Height;
            }
                break;
            case SectionGroupTypeRoomHomestay:
            {
                items = @[self.current_roomFrameObj];
                cell_height = self.current_roomFrameObj.flat_Section_Height;
            }
                break;
            case SectionGroupTypeRoomApartmentRecommendation:
            {
                items = @[self.current_roomFrameObj];
                cell_height = self.current_roomFrameObj.accommodation_Section_Height;
            }
                break;
            case SectionGroupTypeRoomHotCity:
            {
                items = @[self.current_roomFrameObj];
                cell_height = self.current_roomFrameObj.hot_city_Section_Height;
            }
                break;
            case SectionGroupTypeRoomCustomerPraise:
            {
                items = @[self.current_roomFrameObj];
                cell_height = self.current_roomFrameObj.comment_Section_Height;
            }
                break;
            default:
                break;
        }
        if (items.count > 0 && cell_height > 0) {
            group.items = items;
            group.cell_height_set = cell_height;
        }
    }
    
    
}



@end
