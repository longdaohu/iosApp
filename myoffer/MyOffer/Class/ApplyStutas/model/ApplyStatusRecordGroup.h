//
//  ApplyRecordGroup.h
//  myOffer
//
//  Created by sara on 16/2/16.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ApplyStatusRecord;
@class UniItemFrame;
@interface ApplyStatusRecordGroup : NSObject
@property(nonatomic,strong)UniItemFrame *universityFrame;   //学校模型数据
@property(nonatomic,strong)ApplyStatusRecord *record;

+(instancetype)ApplyRecourseGroupWithDictionary:(NSDictionary *)recordDic;


@end
