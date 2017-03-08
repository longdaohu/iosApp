//
//  ApplyStatus.h
//  myOffer
//
//  Created by sara on 16/2/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Applycourse;
@interface ApplyStatusRecord : NSObject
/*
@property(nonatomic,copy)NSString *update_at;
@property(nonatomic,copy)NSString *create_at;
@property(nonatomic,copy)NSString *CRM_id;
@property(nonatomic,copy)NSString *record_id;
@property(nonatomic,copy)NSString *course_id;
@property(nonatomic,copy)NSString *stateRaw;
*/

@property(nonatomic,copy)NSString *state;
@property(nonatomic,strong)Applycourse *course;



@end
 
