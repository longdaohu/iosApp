//
//  ServiceOverSeaDestination.h
//  myOffer
//
//  Created by xuewuguojie on 2017/5/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceOverSeaDestination : NSObject
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *name;

+ (instancetype)destinationWithImage:(NSString *)image name:(NSString *)name;

@end
