//
//  CountryItem.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryItem : NSObject
@property(nonatomic,copy)NSString *NOid;
@property(nonatomic,copy)NSString *CountryName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)CountryWithDictionary:(NSDictionary *)dict;
@end
