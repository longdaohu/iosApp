//
//  ServiceOverSeaDestination.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceOverSeaDestination.h"

@implementation ServiceOverSeaDestination

+ (instancetype)destinationWithImage:(NSString *)image name:(NSString *)name{

    ServiceOverSeaDestination *des = [[ServiceOverSeaDestination alloc] init];
    
    des.image = image;
    
    des.name = name;
    
    return  des;
}

@end
