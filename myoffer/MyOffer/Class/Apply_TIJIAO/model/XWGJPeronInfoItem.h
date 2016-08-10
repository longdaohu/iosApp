//
//  peronInfoItem.h
//  MyOffer
//
//  Created by xuewuguojie on 15/10/10.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJPeronInfoItem : NSObject
@property(nonatomic,copy)NSString *itemName;
@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,assign)BOOL  Accessory;

+(instancetype)personInfoItemInitWithPlacehoder:(NSString *)placehoder andAccessroy:(BOOL )assessory;

@end