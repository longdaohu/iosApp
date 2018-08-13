//
//  RoomTypeItemModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomTypeItemModel.h"

@implementation RoomTypeItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"room_id" : @"id",@"desc":@"description"};
}

//- (NSString *)name{
//
//    NSString *tmp = @"寻那段历史中最有价值的精神本源以及它对后世的深刻影响。三国时期是中国历史上一个著名的乱世，同时也是一个英雄豪杰辈出的时代，那个时代沉淀下来的智慧、精神、思想被后人称作文明遗产，不断实现着历史对现实的借鉴意义。“三国”有关的历史文化内容，已成为世界性的文化遗产。";
//    NSInteger index  = arc4random() % 20;
//    NSString *sub = [tmp substringWithRange:NSMakeRange(index, index + arc4random() % 20)];
//     if (!_name) {
//
//
//        _name = sub;
//    }
//
//    return _name;
//}

- (NSString *)price{
    if (!_price) {
        
        _price = @"";
         if (self.prices.count > 0) {
             NSDictionary *price_dic = self.prices.firstObject;
             _price = [NSString stringWithFormat:@"%@ %@",self.currency,price_dic[@"price"]];
        }
    }
    
    return _price;
}

- (NSString *)state{
    
    if (!_state) {
        
        _state = @"热订中";
        if (self.prices.count > 0) {
            NSDictionary *price_dic = self.prices.firstObject;
            NSString *state_str = [NSString stringWithFormat:@"%@",price_dic[@"state"]];
            _state = [state_str isEqualToString:@"1"] ? @"满房":@"热订中";
        }
    }
    
    return _state;
    
}

- (NSString *)pic{
    
    if (!_pic) {
        if (self.pics.count > 0) {
            
            NSDictionary *pic_dic = self.pics.firstObject;
 
            _pic = pic_dic[@"url"];
        }
    }
    
    return _pic;
    
}

@end

