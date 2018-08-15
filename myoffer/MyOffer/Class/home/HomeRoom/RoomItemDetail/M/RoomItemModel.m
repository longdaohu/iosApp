//
//  RoomItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemModel.h"
#import "RoomTypeItemModel.h"
#import "RoomTypeBookItemModel.h"

@implementation RoomItemModel

//- (NSArray *)feature{
//
//    return @[@"新闻",@"土耳其",@"埃氏政权",@"北约",@"维基解密",@"阿桑奇"];
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"room_id" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"roomtypes" :  NSStringFromClass([RoomTypeItemModel class])
             };
}

- (void)setRoomtypes:(NSArray *)roomtypes{
    _roomtypes = roomtypes;
    
    NSLog(@"roomtypesroomtypesroomtypesroomtypesroomtypes  %ld",roomtypes.count);
 
}

- (void)setUnit:(NSString *)unit{
    
    _unit = unit;
 
}

- (void)setCurrency:(NSString *)currency{
    
    _currency = currency;
    NSLog(@"currencycurrencycurrencycurrencycurrencycurrency  %@",currency);

}


- (NSArray *)ameniti_arr{
    
    if (!_ameniti_arr) {
    
        if (self.amenities.count > 0) {
            
            NSString *tmp = self.amenities.firstObject;
            NSArray *items = [tmp componentsSeparatedByString:@"\r\n"];
            _ameniti_arr = items;
        }
        
    }
    
    return _ameniti_arr;
}

- (NSString *)price{
    
    if (!_price) {
        _price = [NSString stringWithFormat:@"%@ %@",self.currency,self.max_rent];
    }
    return _price;
}


- (NSString *)identifierNumber{
    
    if (!_identifierNumber) {
        _identifierNumber = [NSString stringWithFormat:@"房源编号：GB-00%@",self.room_id];
    }
    
    return _identifierNumber;
}

- (NSArray *)imageURLs{
    
    if (!_imageURLs) {
        
        if (self.pics.count > 0) {
            _imageURLs = [self.pics valueForKeyPath:@"url"];
        }
    }
    return _imageURLs;
}

@end


