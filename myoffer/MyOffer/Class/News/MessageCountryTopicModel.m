//
//  MessageCountryTopicModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/11.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageCountryTopicModel.h"

@implementation MessageCountryTopicModel


+ (instancetype)countryTopicWithMessageFrames:(NSMutableArray *)messageFrames catigoryIndex:(NSInteger)catigoryIndex{
    
    MessageCountryTopicModel *topic = [[MessageCountryTopicModel  alloc] init];
    
    topic.messageFrames = [messageFrames mutableCopy];
    
    topic.catigoryIndex = catigoryIndex;
    
    
    return topic;
}


@end
