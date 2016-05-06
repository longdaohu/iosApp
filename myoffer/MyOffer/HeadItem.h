//
//  HeadItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^itemBlock)(UIButton *);
@interface HeadItem : UIView
@property(nonatomic,assign)NSInteger iconTag;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)itemBlock actionBlock;

@end
