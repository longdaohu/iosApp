//
//  ServiceItemAttribute.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceItemAttribute : NSObject
@property(nonatomic,copy)NSString *key;
@property(nonatomic,strong)NSArray *options;
/*
 "options": [
 
 {
 "value": "英国",
 "selected": true,
 "_id": "582964130d49e48a22c09991",
 "rank": 20,
 "short_id": "5"
 },
 
 {
 "_id": "582bc5c20df33e5a3c5a1ccb",
 "value": "澳大利亚",
 "rank": 19,
 "short_id": "14"
 }]

 */
@end
