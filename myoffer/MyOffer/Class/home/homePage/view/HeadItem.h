//
//  HeadItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^itemBlock)(UIView *item);
@interface HeadItem : UIView
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)itemBlock actionBlock;
+ (instancetype)itemWithTitle:(NSString *)title imageName:(NSString *)imageName;
@end
