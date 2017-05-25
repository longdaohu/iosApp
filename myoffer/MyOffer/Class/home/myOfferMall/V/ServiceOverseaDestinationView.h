//
//  ServiceOverseaDestinationView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/5/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OverseaViewBlock)(NSString *);

@interface ServiceOverseaDestinationView : UIView
@property(nonatomic,copy)OverseaViewBlock actionBlock;
@property(nonatomic,strong)NSArray *group;
+ (instancetype)overseaView;

@end
