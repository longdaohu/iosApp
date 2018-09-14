//
//  PriceCellView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YasiCatigoryItemModel;

@interface PriceCellView : UIView
@property(nonatomic,strong)YasiCatigoryItemModel *item;
@property(nonatomic,copy)void(^actionBlock)(BOOL isPay);
@end

