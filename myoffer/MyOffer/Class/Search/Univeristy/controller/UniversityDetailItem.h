//
//  UniversityDetailItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//  雅思 、 托福  、 学费 、就业 、 本地国际

#import <UIKit/UIKit.h>

@interface UniversityDetailItem : UIView
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel     *titleLab;
@property(nonatomic,strong)UILabel     *subtitleLab;
+ (instancetype)ViewWithImage:(NSString *)imageName title:(NSString *)titleName subtitle:(NSString *)subName;

@end