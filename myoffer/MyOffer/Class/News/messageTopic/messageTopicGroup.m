//
//  messageTopicGroup.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/7.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "messageTopicGroup.h"
#import "XWGJMessageFrame.h"

@implementation messageTopicGroup

+ (instancetype)groupWithMessages:(NSMutableArray *)messages page:(NSInteger)page catigoryIndex:(NSInteger)catigoryIndex{

    messageTopicGroup *group = [[messageTopicGroup  alloc] init];
    
    group.messages = messages;
    
    group.page = page;
    
    group.catigroyIndex = catigoryIndex;
    
 
    return group;
}

- (NSMutableArray *)messageFrames{

    if (!_messageFrames) {
        
        _messageFrames = [NSMutableArray array];
    }
    
    return _messageFrames;
}


@end
