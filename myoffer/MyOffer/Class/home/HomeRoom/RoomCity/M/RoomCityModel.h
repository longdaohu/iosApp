//
//  RoomCityModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/10.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomCityModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *name_cn;
@property(nonatomic,copy)NSString *cityName;

@end
//
//[
//    {
//        group: "A",
//        cities:[
//                {
//                    id :33,
//                    name = "Aberdeen";
//                     = "阿伯丁";
//                },
//                {
//                    id :41,
//                    name = "Aberystwyth";
//                    name_cn = "阿马尼";
//                },
//                ]
//    },
//
//     {
//     group: "B",
//     cities:[
//             {
//                 id :54,
//                 name = "Baaaaaaa";
//                 name_cn = "B阿柳芳";
//             },
//             {
//                 id :61,
//                 name = "Bbesfddth";
//                 name_cn = "B阿a术有专攻";
//             },
//             ]
//     }
//
//]



