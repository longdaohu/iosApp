//
//  MessageTopiccGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTopiccGroup : NSObject

@property(nonatomic,strong)NSArray *topic;

@property(nonatomic,assign)NSInteger index;

+ (instancetype)groupWithIndex:(NSInteger)index;

@end
