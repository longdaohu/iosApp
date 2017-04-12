//
//  UniversityDetailItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//  雅思 、 托福  、 学费 、就业 、 本地国际

#import <UIKit/UIKit.h>

@interface UniversityDetailItem : UIView

+ (instancetype)ItemInitWithImage:(NSString *)imageName title:(NSString *)title  count:(NSString *)count;

@end
