//
//  messageTopicGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/7.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageTopicGroup : NSObject

@property(nonatomic,assign)BOOL endPage;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)NSInteger catigroyIndex;

@property(nonatomic,strong)NSMutableDictionary *parameter;

@property(nonatomic,strong)NSMutableArray *messages;

@property(nonatomic,strong)NSMutableArray *messageFrames;

+(instancetype)groupWithMessages:(NSMutableArray *)messages page:(NSInteger)page catigoryIndex:(NSInteger)catigoryIndex;

@end
