//
//  rankFilter.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rankFilter : NSObject
@property(nonatomic,strong)NSMutableArray *countries;
@property(nonatomic,strong)NSArray *countri_arr;
@property(nonatomic,copy)NSString *countryName;
@property(nonatomic,copy)NSString *countryCode;
@property(nonatomic,strong)NSMutableArray *types;
@property(nonatomic,strong)NSArray *type_arr;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *typeCode;
@property(nonatomic,strong)NSMutableArray *years;
@property(nonatomic,strong)NSArray *year_arr;
@property(nonatomic,copy)NSString *yearName;
@property(nonatomic,copy)NSString *yearCode;
@property(nonatomic,strong)NSMutableDictionary *papa_m;
@end

