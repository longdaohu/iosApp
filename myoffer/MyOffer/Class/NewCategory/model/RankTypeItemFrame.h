//
//  RankTypeItemFrame.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankTypeItem.h"

@interface RankTypeItemFrame : NSObject
@property(nonatomic,strong)RankTypeItem *item;
@property(nonatomic,assign)CGRect bg_frame;
@property(nonatomic,assign)CGRect bgimage_frame;
@property(nonatomic,assign)CGRect icon_frame;
@property(nonatomic,assign)CGRect cn_frame;
@property(nonatomic,assign)CGRect en_frame;
@property(nonatomic,assign)CGRect cell_frame;

@end
