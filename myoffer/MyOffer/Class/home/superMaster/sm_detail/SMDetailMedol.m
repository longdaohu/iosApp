//
//  SMDetailMedol.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMDetailMedol.h"
#import "SMHotModel.h"
#import "ServiceSKU.h"

@implementation SMDetailMedol
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"message_id" : @"_id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"related" :  NSStringFromClass([SMHotModel class]),
             @"sku" :  NSStringFromClass([ServiceSKU class])
             };
}

- (NSString *)guest_subject_uni{

    return [NSString stringWithFormat:@"%@  |  %@",self.guest_university,self.guest_subject];
}



- (NSString *)type_imageName{

    if ([self.type isEqualToString:@"offline"]) {
        
        return @"sm_off_tag";
    }
    
    
    NSString  *type =  @"audio_vedio";
    
    if (self.has_video && self.has_audio) {
        
        type = @"audio_vedio";
        
    }else if(self.has_video){
        
        type = @"sm_vedio_tag";
        
    }else{
        
        type = @"sm_audio_tag";
        
    }
    
    
    return type;
}




@end
