//
//  XWGJMessage.h
//  myOffer
//
//  Created by sara on 16/2/16.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJMessage : NSObject
@property(nonatomic,copy)NSString *LogoName;
@property(nonatomic,copy)NSString *messageTitle;
@property(nonatomic,copy)NSString *FocusCount;
@property(nonatomic,copy)NSString *Update_time;
@property(nonatomic,copy)NSString *messageID;

+(instancetype)messageWithDictionary:(NSDictionary *)messageDic;
-(instancetype)initWithDictionary:(NSDictionary *)messageDic;
@end
