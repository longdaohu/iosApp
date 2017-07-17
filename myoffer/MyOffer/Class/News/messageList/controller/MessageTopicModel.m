//
//  MessageTopicModel.m
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import "MessageTopicModel.h"
#import "MyOfferArticle.h"
#import "XWGJMessageFrame.h"

@implementation MessageTopicModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"articles" : NSStringFromClass([MyOfferArticle class])};
}

- (void)setArticles:(NSArray *)articles{

    _articles = articles;

    
    NSMutableArray *temps = [NSMutableArray array];

    for (MyOfferArticle *ms in articles) {
        
        [temps addObject:[XWGJMessageFrame messageFrameWithMessage:ms]];
    }
    
    self.messageFrames = [temps copy];
    
}



@end


 
