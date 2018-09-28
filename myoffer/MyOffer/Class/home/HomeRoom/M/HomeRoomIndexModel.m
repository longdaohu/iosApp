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
        
        if (group.type == SectionGroupTypeRoomHotActivity) {
            if (self.current_roomFrameObj.item.events.count == 0) continue;
            group.items = @[self.current_roomFrameObj];
            group.cell_height_set = self.current_roomFrameObj.event_Section_Height;
          
//            self.eventCellView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, self.current_roomFrameObj.event_Section_Height);
//            NSArray *imageGroup = [self.current_roomFrameObj.item.events valueForKey:@"img"];
//            [self.eventCellView makeBannerWithImages:imageGroup   bannerSize:self.current_roomFrameObj.event_item_size];
        }
        
        if (group.type == SectionGroupTypeRoomHomestay) {
            if (self.current_roomFrameObj.item.flats.count == 0) continue;
            group.items = @[self.current_roomFrameObj];
            group.cell_height_set = self.current_roomFrameObj.flat_Section_Height;
        }
        if (group.type == SectionGroupTypeRoomApartmentRecommendation) {
            if (self.current_roomFrameObj.item.accommodations.count == 0) continue;
            group.items = @[self.current_roomFrameObj];
            group.cell_height_set = self.current_roomFrameObj.accommodation_Section_Height;
        }
        if (group.type == SectionGroupTypeRoomHotCity) {
            
            if (self.current_roomFrameObj.item.hot_city.count == 0)  continue;
            group.items = @[self.current_roomFrameObj];
            group.cell_height_set = self.current_roomFrameObj.hot_city_Section_Height;
        }
        if (group.type == SectionGroupTypeRoomCustomerPraise) {
            if (self.current_roomFrameObj.item.comments.count == 0) continue;
            group.items = @[self.current_roomFrameObj];
            group.cell_height_set = self.current_roomFrameObj.comment_Section_Height;
            
        }
    }
    
    
}



@end
