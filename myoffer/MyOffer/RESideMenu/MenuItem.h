//
//  MenuItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,assign)BOOL newMessage;
+(instancetype)menuItemInitWithName:(NSString *)name icon:(NSString *)icon;
@end
