//
//  ServiceHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOfferServiceMallHeaderFrame.h"

typedef void(^ServiceHeaderViewBlock)(NSString *countryName);
@interface ServiceHeaderView : UIView
@property(nonatomic,strong)MyOfferServiceMallHeaderFrame *headerFrame;

+ (instancetype)headerViewWithFrame:(CGRect)frame ationBlock:(ServiceHeaderViewBlock)actionBlock;

@end
