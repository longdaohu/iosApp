//
//  XWGJAbout.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWGJAbout : NSObject
@property(nonatomic,copy)NSString *Logo;
@property(nonatomic,copy)NSString *contentName;
@property(nonatomic,copy)NSString *SubName;
@property(nonatomic,copy)NSString *RightImageName;

+ (instancetype)aboutWithLogo:(NSString *)logoName andContent:(NSString *)contentName andsubTitle:(NSString *)subName andRightAccessoryImage:(NSString *)rightImageName;



@end
