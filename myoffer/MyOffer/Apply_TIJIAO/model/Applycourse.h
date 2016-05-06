//
//  Applycourse.h
//  myOffer
//
//  Created by sara on 15/12/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Applycourse : NSObject
@property(nonatomic,copy)NSString *official_name;
@property(nonatomic,copy)NSString *courseName;
@property(nonatomic,copy)NSString *courseID;
 
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)applyCourseWithDictionary:(NSDictionary *)dict;

@end
