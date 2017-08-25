//
//  MenuItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
//cell push class
@property(nonatomic,copy)NSString *action;
@property(nonatomic,copy)NSString *classString;
//cell name
@property(nonatomic,copy)NSString *name;
//cell icon
@property(nonatomic,copy)NSString *icon;
//cell 上的数量
@property(nonatomic,copy)NSString *messageCount;

+(instancetype)menuItemInitWithName:(NSString *)name icon:(NSString *)icon classString:(NSString *)classStr;
+(instancetype)menuItemInitWithName:(NSString *)name icon:(NSString *)icon count:(NSString *)messageCount;

@end
