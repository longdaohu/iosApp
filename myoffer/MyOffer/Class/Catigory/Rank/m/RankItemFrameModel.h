//
//  RankItemFrameModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankTypeModel.h"

@interface RankItemFrameModel : NSObject
@property(nonatomic,strong)RankTypeModel *rankItem;
@property(nonatomic,assign)CGRect desc_frame;
@property(nonatomic,assign)CGRect header_frame;
@property(nonatomic,strong)NSArray *university_frames;

@end
