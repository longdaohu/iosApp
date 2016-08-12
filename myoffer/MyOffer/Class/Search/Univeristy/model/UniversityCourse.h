//
//  UniversityCourse.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/12.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversityCourse : NSObject
@property(nonatomic,copy)NSString *official_name;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,strong)NSArray *areas;
@property(nonatomic,copy)NSString *NO_id;
@property(nonatomic,assign)BOOL applied;

@end
