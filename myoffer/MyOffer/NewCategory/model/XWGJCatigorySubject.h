//
//  XWGJCatigorySubject.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJCatigorySubject : NSObject
@property(nonatomic,copy)NSString *IconName;
@property(nonatomic,copy)NSString *TitleName;
+(instancetype)subjectItemInitWithIconName:(NSString *)iconName TitleName:(NSString *)Name;
-(instancetype)initWithIconName:(NSString *)iconName TitleName:(NSString *)Name;

@end