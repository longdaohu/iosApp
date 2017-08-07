//
//  MessageHotTopicMedel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageHotTopicMedel.h"

@implementation MessageHotTopicMedel

- (NSString *)cover_path{
    
    return [_cover_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
