//
//  GonglueItem.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  gonglueTip;

@interface GonglueItem : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,strong)gonglueTip *tip;
@property(nonatomic,strong)NSArray *articles;


@end
