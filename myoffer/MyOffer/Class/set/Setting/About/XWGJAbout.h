//
//  XWGJAbout.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, XWGJAboutType) {
    XWGJAboutTypeDefault = 0,
    XWGJAboutTypeServiceStatus
};


@interface XWGJAbout : NSObject

@property(nonatomic,copy)NSString *Logo;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *sub_title;
@property(nonatomic,copy)NSString *acc_title;
@property(nonatomic,copy)NSString *acc_icon;
@property(nonatomic,copy)NSString *action;
@property(nonatomic,copy)NSString *item_class;
@property(nonatomic,assign)BOOL accessoryType;
@property(nonatomic,assign)XWGJAboutType  item_Type;
@property(nonatomic,assign)CGFloat cell_height;

+ (instancetype)cellWithLogo:(NSString *)logo title:(NSString *)title sub_title:(NSString *)subName accessory_title:(NSString *)acc_title accessory_icon:(NSString *)acc_icon;

+ (instancetype)cellWithLogo:(NSString *)logo title:(NSString *)title action:(NSString *)action itemClass:(NSString *)item_class;


@end
