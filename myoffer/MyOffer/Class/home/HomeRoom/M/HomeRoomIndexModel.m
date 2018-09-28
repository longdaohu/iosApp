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


@end
