//
//  ServiceItemFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/29.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceItem.h"

@interface ServiceItemFrame : NSObject
@property(nonatomic,strong)ServiceItem *item;
@property(nonatomic,assign)CGRect name_Frame;
@property(nonatomic,assign)CGRect priceFrame;
@property(nonatomic,assign)CGRect display_priceFrame;
@property(nonatomic,assign)CGRect firstlineFrame;
@property(nonatomic,assign)CGRect centerView_Frame;
@property(nonatomic,assign)CGRect second_line_Frame;
@property(nonatomic,assign)CGRect thirdFrame;
@property(nonatomic,assign)CGRect peopleFrame;
@property(nonatomic,assign)CGRect personDisc_Frame;
@property(nonatomic,assign)CGRect presentFrame;
@property(nonatomic,assign)CGRect presentDisc_Frame;
@property(nonatomic,assign)CGRect headerViewFrame;
@property(nonatomic,assign)CGRect header_BgViewFrame;
@property(nonatomic,assign)CGRect header_bottomView_Frame;
@property(nonatomic,strong)NSArray *attributeFrames;
@property(nonatomic,strong)NSArray *commentFrames;
@property(nonatomic,strong)NSArray *centerViewCell_Frames;



@end
