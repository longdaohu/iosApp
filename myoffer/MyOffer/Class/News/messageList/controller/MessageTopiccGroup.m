//
//  MessageTopiccGroup.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageTopiccGroup.h"
#import "MessageTopicModel.h"
#import "MyOfferArticle.h"
#import "XWGJMessageFrame.h"

@implementation MessageTopiccGroup

+ (instancetype)groupWithIndex:(NSInteger)index{
    
    MessageTopiccGroup *group = [[MessageTopiccGroup alloc] init];
    
    group.index = index;
    
    return group;
}


@end
