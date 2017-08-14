//
//  HeadItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHeaderFrame.h"

typedef void(^itemBlock)(NSInteger index);
@interface HeadItem : UIView
@property(nonatomic,copy)itemBlock actionBlock;

@property(nonatomic,strong)HomeHeaderFrame *headerFrame;

+ (instancetype)itemInitWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
