//
//  myOfferMenuItem.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myOfferMenuItem : NSObject
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)BOOL    accessoryArrow;
@property(nonatomic,assign)CGFloat  cell_height;
@property(nonatomic,copy)NSString *accessory_title;
@property(nonatomic,copy)NSString *accessory_image;
@property(nonatomic,copy)NSString *active;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title arrow:(BOOL)arrow accessoryTitle:(NSString *)accessoryTitle accessoryImage:(NSString *)accessoryImage  active:(NSString *)active;

@end

