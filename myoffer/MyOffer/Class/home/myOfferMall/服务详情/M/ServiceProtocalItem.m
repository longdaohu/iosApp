//
//  ServiceProtocalItem.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/30.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceProtocalItem.h"

@implementation ServiceProtocalItem


- (CGFloat)height{
    
    return self.isClose ? 0 : self.web.mj_h;
}

@end
