//
//  CatigorySubject.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatigorySubject : NSObject
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
+ (instancetype)subjectItemInitWithIcon:(NSString *)icon title:(NSString *)title;

@end
