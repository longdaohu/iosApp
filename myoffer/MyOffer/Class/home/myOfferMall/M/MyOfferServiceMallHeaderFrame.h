//
//  MyOfferServiceMallHeaderFrame.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/5.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOfferServiceMallHeaderFrame : NSObject
@property(nonatomic,assign)CGRect autoScroller_frame;
@property(nonatomic,assign)CGRect downView_frame;
@property(nonatomic,strong)NSArray *headerItem_frames;
@property(nonatomic,assign)CGRect header_frame;
@property(nonatomic,assign)CGRect bottom_line_frame;

@property(nonatomic,assign)CGRect icon_frame;
@property(nonatomic,assign)CGRect title_frame;

@end
