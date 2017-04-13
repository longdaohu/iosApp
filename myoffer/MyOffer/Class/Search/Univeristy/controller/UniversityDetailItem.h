//
//  UniversityDetailItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//  雅思 、 托福  、 学费 、就业 、 本地国际

#import <UIKit/UIKit.h>
#import "UniversityNewFrame.h"

@interface UniversityDetailItem : UIView

@property(nonatomic,strong)UniversityNewFrame *Uni_Frame;

+ (instancetype)ItemInitWithImage:(NSString *)imageName title:(NSString *)title  count:(NSString *)count;


@end
