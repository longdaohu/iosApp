//
//  AppButton.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyofferButtonType) {
    
    MyofferButtonTypeImageLeft = 0,
    MyofferButtonTypeImageRight,
    MyofferButtonTypeImageTop,
    MyofferButtonTypeImageBottom
};

@interface AppButton : UIButton

@property(nonatomic,assign)MyofferButtonType type;

//主要针对图片大小
@property(nonatomic,assign)CGFloat image_width;
/*
 MyofferButtonTypeImageLeft  MyofferButtonTypeImageRight 是设置大于1px的间距;
 MyofferButtonTypeImageTop,MyofferButtonTypeImageBottom  是设置间距为父控件高的百份比动态间距，也可以是大于1px固定间距;
 */
@property(nonatomic,assign)CGFloat margin;


@end
