//
//  MyOfferService.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOfferService : NSObject
@property(nonatomic,assign)BOOL login_status;
@property(nonatomic,strong)NSArray *skus;
@property(nonatomic,strong)NSArray *banners;

@end


