//
//  HomeRoomIndexCommentsObject.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/1.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeRoomIndexCommentsObject.h"

@implementation HomeRoomIndexCommentsObject

- (NSString *)fromUni{
    
    if (!_fromUni) {
         _fromUni = [NSString stringWithFormat:@"来自%@  %@",self.from,self.university];
     }
    
    return _fromUni;
}

@end
