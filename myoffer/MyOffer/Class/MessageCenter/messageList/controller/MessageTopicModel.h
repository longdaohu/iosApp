//
//  MessageTopicModel.h
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTopicModel : NSObject
@property(nonatomic,copy)NSString *category;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,strong)NSArray *articles;
@property(nonatomic,strong)NSArray *messageFrames;

@end
