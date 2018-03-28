//
//  ApplyStatusModelFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplyStutasModel.h"

@interface ApplyStatusModelFrame : NSObject
@property(nonatomic,strong)ApplyStutasModel *statusModel;
@property(nonatomic,assign)CGRect status_Frame;
@property(nonatomic,assign)CGRect date_Frame;
@property(nonatomic,assign)CGFloat cell_Height;
@property(nonatomic,assign)CGRect title_Frame;
@property(nonatomic,assign)CGRect tag_Frame;
@property(nonatomic,assign)CGRect paddingFrame;
@property(nonatomic,assign)CGFloat padding_bottom_distance;

+ (instancetype)frameWithStatusModel:(ApplyStutasModel *)statusModel;

@end
