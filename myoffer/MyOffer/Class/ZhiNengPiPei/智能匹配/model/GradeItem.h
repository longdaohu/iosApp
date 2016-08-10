//
//  GradeItem.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeItem : NSObject
@property(nonatomic,copy)NSString *NOid;
@property(nonatomic,copy)NSString *gradeName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)gradeWithDictionary:(NSDictionary *)dict;
@end
