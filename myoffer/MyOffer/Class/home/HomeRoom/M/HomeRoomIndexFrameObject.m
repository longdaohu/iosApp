//
//  HomeRoomIndexFrameObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexFrameObject.h"
#import "HomeRoomIndexFlatsObject.h"
#import "HomeRoomIndexFlatFrameObject.h"

@implementation HomeRoomIndexFrameObject

- (void)setItem:(HomeRoomIndexObject *)item{
    _item = item;
    
    self.minimumLineSpacing = 12;
    self.minimumInteritemSpacing = 15.8;
    
    [self makeEventFrame];
    [self makeFlatsFrame];
    [self makeAccommodationsFrame];
    [self makeHotCityFrame];
    [self makeCommentFrame];
}

//热门活动
- (void)makeEventFrame{
    
    CGFloat item_width = XSCREEN_WIDTH - 40;
    CGFloat item_height = item_width * 378.0/670;
    self.event_item_size = CGSizeMake(item_width, item_height);
    self.event_Section_Height = item_height +  30;
    if (self.item.events.count > 1) {
        self.event_Section_Height = item_height +  30;
    }else  if (self.item.events.count > 1) {
        self.event_Section_Height = item_height;
    }else{
        self.event_Section_Height = 0;
    }
}

//客户好评
- (void)makeCommentFrame{
 
    CGFloat item_width = 255;
    CGFloat item_height = 228;
    self.comment_item_size = CGSizeMake(item_width, item_height);
    self.comment_Section_Height = item_height + 30;
}

//热门城市
- (void)makeHotCityFrame{
    
    CGFloat item_width = 115;
    CGFloat item_height = 165;
    self.hot_city_item_size = CGSizeMake(item_width, item_height);
    self.hot_city_Section_Height = item_height + 30;
}

//公寓推荐
- (void)makeAccommodationsFrame{

    CGFloat item_width = 235;
    CGFloat item_height = 220;
    NSMutableArray *flat_Arr = [NSMutableArray array];
    for (HomeRoomIndexFlatsObject *it in self.item.accommodations) {
        
        HomeRoomIndexFlatFrameObject *flatFrameObj = [[HomeRoomIndexFlatFrameObject alloc] init];
        flatFrameObj.type = HomeRoomIndexFlatTypeHorizontal;
        flatFrameObj.item_width = item_width;
        flatFrameObj.item_height = item_height;
        flatFrameObj.item = it;
        [flat_Arr addObject:flatFrameObj];
    }
    self.accommodationsFrames = [flat_Arr mutableCopy];
    self.accommodation_Section_Height = item_height + 30;
    
}

//精选民宿
- (void)makeFlatsFrame{
 

    CGFloat item_width = (XSCREEN_WIDTH - 40 - self.minimumInteritemSpacing - 2) * 0.5;
    NSMutableArray *flat_Arr = [NSMutableArray array];
    
    HomeRoomIndexFlatFrameObject *last = nil;
    CGFloat row_height = 0;
    CGFloat all_item_height = 0;
    
    for (NSInteger index = 0; index < self.item.flats.count; index++) {
        HomeRoomIndexFlatsObject *it = self.item.flats[index];
        HomeRoomIndexFlatFrameObject *flatFrameObj = [[HomeRoomIndexFlatFrameObject alloc] init];
        flatFrameObj.item_width = item_width;
        flatFrameObj.item = it;
        [flat_Arr addObject:flatFrameObj];
        
        
        
        if (index%2 == 0) {
            last = flatFrameObj;
            row_height = flatFrameObj.item_height;
            all_item_height +=  (row_height + self.minimumInteritemSpacing);
        }else{
            all_item_height -=  (row_height + self.minimumInteritemSpacing);
            CGFloat current_height = flatFrameObj.item_height;
            if (current_height > row_height) {
                row_height = current_height;
            }
            
            last.item_height = row_height;
            flatFrameObj.item_height = row_height;
            all_item_height += 2*(row_height + self.minimumInteritemSpacing);
        }

    }
    
    if (flat_Arr.count%2 == 0) {
        self.flat_Section_Height = (all_item_height * 0.5 - self.minimumInteritemSpacing) + 30;
    }else{
        self.flat_Section_Height = (all_item_height - row_height) * 0.5 + (row_height - self.minimumInteritemSpacing) + 30;
    }
    self.flatsFrames = [flat_Arr mutableCopy];
}

@end
