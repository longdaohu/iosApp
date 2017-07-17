//
//  MessageTopiccGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "messageCatigroyModel.h"

@interface MessageTopiccGroup : NSObject

@property(nonatomic,strong)NSArray *contents;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)messageCatigroyModel *catigory;

+ (instancetype)groupWithCatigroy:(messageCatigroyModel *)catigory  index:(NSInteger)index;

@end
