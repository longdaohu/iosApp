//
//  NotiItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "NotiItem.h"

@implementation NotiItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"NO_id" : @"_id"};

}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"content"] ||  [property.name isEqualToString:@"state"]) {
       
        if (oldValue == nil) return @"";
    }
    return oldValue;
}


- (NSString *)create_time_short{

    return [self.create_at componentsSeparatedByString:@" "][0];
}

- (void)setState_read:(BOOL)state_read{

    _state_read = state_read;
    
    if (state_read ) {
        
        self.state = @"Read";
    }
    
}

/*

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"statuses" : @"MJStatus",
             @"ads" : @"MJAd"
             };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             @"desc" : @"desciption",
             @"oldName" : @"name.oldName",
             @"nowName" : @"name.newName",
             @"nameChangedTime" : @"name.info[1].nameChangedTime",
             @"bag" : @"other.bag"
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"publisher"]) {
        if (oldValue == nil) return @"";
    } else if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt dateFromString:oldValue];
    }

    return oldValue;
}
 
 */
@end
