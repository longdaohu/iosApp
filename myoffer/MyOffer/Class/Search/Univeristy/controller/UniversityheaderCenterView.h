//
//  UniversityheaderCenterView.h
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityNewFrame.h"

typedef void(^UniversityCenterViewBlock)(UIButton *sender);
@interface UniversityheaderCenterView : UIView
@property(nonatomic,strong)UniversityNewFrame  *itemFrame;
@property(nonatomic,strong)LogoView     *logo;
@property(nonatomic,strong)UILabel      *nameLab;
@property(nonatomic,strong)UILabel      *official_nameLab;
@property(nonatomic,strong)UIButton     *address_detailBtn;
@property(nonatomic,strong)UIButton     *websiteBtn;
@property(nonatomic,strong)UIView       *dataView;
@property(nonatomic,strong)UILabel      *line;
@property(nonatomic,strong)UILabel      *introductionLab;
@property(nonatomic,strong)UIButton     *moreBtn;
@property(nonatomic,strong)UIView       *gradientBgView;
@property(nonatomic,copy)UniversityCenterViewBlock actionBlock;
+(instancetype)View;


@end
