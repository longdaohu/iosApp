//
//  SMAudioItemFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAudioItem.h"

@interface SMAudioItemFrame : NSObject
@property(nonatomic,strong)SMAudioItem *item;

@property(nonatomic,assign)CGRect play_Frame;
@property(nonatomic,assign)CGRect icon_Frame;
@property(nonatomic,assign)CGRect name_Frame;
@property(nonatomic,assign)CGRect time_Frame;
@property(nonatomic,assign)CGRect bottom_line_Frame;
@property(nonatomic,assign)CGFloat cell_height;

+ (instancetype)frameWitAudioItem:(SMAudioItem *)item;

@end
