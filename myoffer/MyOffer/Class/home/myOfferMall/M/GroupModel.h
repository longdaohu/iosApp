//
//  GroupModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/11.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)NSString *header;
@property(nonatomic,copy)NSString *footer;
@property(nonatomic,strong)NSArray *items;
+ (instancetype)groupWithIndex:(NSInteger)index header:(NSString *)header footer:(NSString *)footer items:(NSArray *)items;
@end
