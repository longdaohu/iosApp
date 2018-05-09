//
//  SMBannerModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMBannerModel : NSObject
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *image_url_mc;
@property(nonatomic,copy)NSString *image_url_pc;
@property(nonatomic,copy)NSString *link_app;
@property(nonatomic,copy)NSString *link_mc;
@property(nonatomic,copy)NSString *link_pc;
@property(nonatomic,copy)NSString *banner_id;
@property(nonatomic,assign)BOOL rank;
@property(nonatomic,copy)NSString *title;


@end
