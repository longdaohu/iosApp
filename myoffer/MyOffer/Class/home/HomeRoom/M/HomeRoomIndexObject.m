//
//  HomeRoomIndexObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexObject.h"
#import "HomeRoomIndexCityObject.h"
#import "HomeRoomIndexCommentsObject.h"
#import "HomeRoomIndexEventsObject.h"
#import "HomeRoomIndexFlatsObject.h"

@implementation HomeRoomIndexObject

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
                 @"events" : @"HomeRoomIndexEventsObject",
                 @"hot_city" : @"HomeRoomIndexCityObject",
                 @"accommodations" : @"HomeRoomIndexFlatsObject",
                 @"flats" : @"HomeRoomIndexFlatsObject",
                 @"comments" : @"HomeRoomIndexCommentsObject"
             };
}

- (void)setAccommodations:(NSArray *)accommodations{
    _accommodations = accommodations;
    
    NSString *tmp = @"寻那段历史中最有价值的精神本源以及它对后世的深刻影响。三国时期是中国历史上一个著名的乱世，同时也是一个英雄豪杰辈出的时代，那个时代沉淀下来的智慧、精神、思想被后人称作文明遗产，不断实现着历史对现实的借鉴意义。“三国”有关的历史文化内容，已成为世界性的文化遗产。";
    
    for (HomeRoomIndexFlatsObject *item in accommodations ) {
        item.name = [tmp substringToIndex:arc4random() % 50];
    }
}

- (void)setFlats:(NSArray *)flats{

    _flats = flats;


    NSString *tmp = @"本片以严谨的历史态度、新鲜的观察视角，通过讲述“三国”和其中人物的命运故事，传递他们所承载的传续千年的精神力量和文化底蕴，并探寻那段历史中最有价值的精神本源以及它对后世的深刻影响。三国时期是中国历史上一个著名的乱世，同时也是一个英雄豪杰辈出的时代，那个时代沉淀下来的智慧、精神、思想被后人称作文明遗产，不断实现着历史对现实的借鉴意义。“三国”有关的历史文化内容，已成为世界性的文化遗产。";

    for (HomeRoomIndexFlatsObject *item in flats ) {
        item.name = [tmp substringToIndex:arc4random() % 40];
    }
}

@end

