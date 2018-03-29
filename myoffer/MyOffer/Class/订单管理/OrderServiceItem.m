//
//  OrderLeftItem.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "OrderServiceItem.h"

@implementation OrderServiceItem
-(void)setName:(NSString *)name{
    
    _name = name;
    
//    CGSize titleSize = [name boundingRectWithSize:CGSizeMake(XSCREEN_WIDTH * 0.5 - 10, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
//     self.cellHeight = titleSize.height > 32 ? titleSize.height + 17 : 40;

}


@end
