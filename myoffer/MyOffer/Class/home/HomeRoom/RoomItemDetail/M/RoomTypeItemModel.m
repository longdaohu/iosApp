//
//  RoomTypeItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomTypeItemModel.h"
#import "RoomTypeBookItemModel.h"

@implementation RoomTypeItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"room_id" : @"id",@"desc":@"description"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"prices" :  NSStringFromClass([RoomTypeBookItemModel class])
             };
}

- (RoomTypeBookItemModel *)firstPrice{
    
    if (!_firstPrice) {
        if (self.prices.count > 0) {
           _firstPrice = self.prices.firstObject;
        }
     }
    
    return _firstPrice;
}

- (NSArray *)pictures{
   
        if (!_pictures) {
            if (self.pics.count > 0) {
                _pictures = [self.pics valueForKeyPath:@"url"];
            }
        }
        
   return _pictures;
}

- (NSString *)pic{
    
    if (!_pic) {
        if (self.pics.count > 0) {
            _pic = self.pictures.firstObject;
        }
    }
    
    return _pic;
}



@end

