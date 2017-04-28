//
//  SearchUniversityCenterViewController.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchUniversityCenterViewController : BaseViewController
@property(nonatomic,copy)NSString *coreCountry;
@property(nonatomic,copy)NSString *coreState;
@property(nonatomic,copy)NSString *coreCity;
@property(nonatomic,copy)NSString *coreArea;
@property(nonatomic,copy)NSString *coreSubject;

- (instancetype)initWithSearchValue:(NSString *)searchValue;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;


@end
