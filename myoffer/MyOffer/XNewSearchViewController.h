//
//  XNewSearchViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface XNewSearchViewController : BaseViewController
//原始国家参数
@property(nonatomic,copy)NSString *CoreCountry;
//原始地区参数
@property(nonatomic,copy)NSString *CoreState;
//原始城市参数
@property(nonatomic,copy)NSString *Corecity;
//原始科目参数
@property(nonatomic,copy)NSString *CoreArea;
- (instancetype)initWithSearchText:(NSString *)text orderBy:(NSString *)orderBy;
- (instancetype)initWithFilter:(NSString *)key value:(NSString *)value orderBy:(NSString *)orderBy;

@end
