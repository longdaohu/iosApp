//
//  MyofferFooterView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/15.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyofferFooterView : UIView
@property(nonatomic,copy)NSString *iconName;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)void(^actionBlock)(void);

+ (instancetype)footer;

@end
