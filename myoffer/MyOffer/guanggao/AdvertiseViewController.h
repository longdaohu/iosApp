//
//  AdvertiseViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSingleNewsBO.h"
@interface AdvertiseViewController : BaseViewController
@property(nonatomic,copy)NSString *path;
@property(nonatomic,copy)NSString *advertise_title;
@property(nonatomic,strong)YYSingleNewsBO *StatusBarBannerNews;

@end
