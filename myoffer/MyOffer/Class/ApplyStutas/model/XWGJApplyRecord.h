//
//  ApplyStatus.h
//  myOffer
//
//  Created by sara on 16/2/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Applycourse;
@interface XWGJApplyRecord : NSObject
@property(nonatomic,strong)Applycourse *Course;
@property(nonatomic,copy)NSString      *Status;
+(instancetype)ApplyStatusWithDictionary:(NSDictionary *)recordDic;

@end
