//
//  SubjectItem.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/18.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectItem : NSObject
@property(nonatomic,copy)NSString *NOid;
@property(nonatomic,copy)NSString *subjectName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)subjectWithDictionary:(NSDictionary *)dict;
@end
