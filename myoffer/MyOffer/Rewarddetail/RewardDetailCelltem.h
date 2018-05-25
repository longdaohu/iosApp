//
//  RewardDetailCelltem.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardDetailCelltem : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *sub;
+ (instancetype)itemWithTitle:(NSString *)title sub:(NSString *)sub;

@end
