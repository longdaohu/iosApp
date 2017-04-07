//
//  ServiceItemHeaderCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceItemCellFrame.h"

typedef void(^ServiceItemCellBlock)(NSString *);

@interface ServiceItemHeaderCell : UIView

@property(nonatomic,strong)ServiceItemCellFrame *cellFrame;
@property(nonatomic,copy)ServiceItemCellBlock actionBlcok;


@end
