//
//  FilterSection.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/16.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterSection : NSObject
@property(nonatomic,strong)NSArray *subjectArray;
@property(nonatomic,copy)NSString *subjectID;
@property(nonatomic,copy)NSString *subjectName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)FilterSectionWithDictionary:(NSDictionary *)dict;


@end
