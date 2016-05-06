//
//  XWGJAbout.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJAbout.h"

@implementation XWGJAbout



- (instancetype)initAboutWithLogo:(NSString *)logoName andContent:(NSString *)contentName andsubTitle:(NSString *)subName andRightAccessoryImage:(NSString *)rightImageName
{
    if ([super init]) {
    
        self.Logo = logoName;
        self.contentName = contentName;
        self.SubName =subName;
        self.RightImageName = rightImageName;
    }
    
    return self;
    
}

+ (instancetype)aboutWithLogo:(NSString *)logoName andContent:(NSString *)contentName andsubTitle:(NSString *)subName andRightAccessoryImage:(NSString *)rightImageName
{
    return [[self alloc]  initAboutWithLogo:logoName andContent:contentName andsubTitle:subName andRightAccessoryImage:rightImageName];
}

@end
