//
//  ServiceItemHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/29.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceItemFrame.h"

typedef void(^abcBlock)(NSString *service_id);

@interface ServiceItemHeaderView : UIView
@property(nonatomic,strong)ServiceItemFrame *itemFrame;
@property(nonatomic,copy)abcBlock actionBlcok;
@end
