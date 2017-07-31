//
//  SMHotModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMHotModel.h"

@implementation SMHotModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"message_id" : @"_id"};
}

- (SMMessageType)messageType{

    
    if ([self.type isEqualToString:@"offline"]) {
    
        return SMMessageTypeOffLine;
    }
   
    SMMessageType type = SMMessageTypeAudio;
    
    if (self.has_video && self.has_audio) {
        
        type = SMMessageTypeAudioVedio;
        
    }else if(self.has_video){
    
        type = SMMessageTypeVedio;
        
    }else{
    
        type = SMMessageTypeAudio;

    }
    
    return type;
}

- (NSString *)type_name{

    
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

