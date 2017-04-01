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
@property(nonatomic,assign)CGRect nameFrame;
@property(nonatomic,assign)CGRect priceFrame;
@property(nonatomic,assign)CGRect display_priceFrame;
@property(nonatomic,assign)CGRect firstlineFrame;
@property(nonatomic,assign)CGRect countryFrame;
@property(nonatomic,assign)CGRect countryBgFrame;
@property(nonatomic,strong)NSArray *countryItemFrames;
@property(nonatomic,assign)CGRect serviceTypeFrame;
@property(nonatomic,assign)CGRect serviceTypeBgFrame;
@property(nonatomic,strong)NSArray *serviceItemFrames;
@property(nonatomic,assign)CGRect secondFrame;
@property(nonatomic,assign)CGRect thirdFrame;
@property(nonatomic,assign)CGRect peopleFrame;
@property(nonatomic,assign)CGRect personDisc_Frame;
@property(nonatomic,assign)CGRect presentFrame;
@property(nonatomic,assign)CGRect presentDisc_Frame;
@property(nonatomic,assign)CGRect headerViewFrame;
@property(nonatomic,assign)CGRect header_BgViewFrame;
@property(nonatomic,assign)CGRect header_bottomView_Frame;



@end
