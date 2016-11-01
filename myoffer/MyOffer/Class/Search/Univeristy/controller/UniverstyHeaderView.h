//
//  UniverstyHeaderView.h
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityNewFrame.h"
#import "UniversityRightView.h"

typedef void(^UniverstyHeaderViewBlock)(UIButton *sender);
@class UniversityheaderCenterView;
@interface UniverstyHeaderView : UIView
@property(nonatomic,strong)UniversityNewFrame *itemFrame;
//上部分View
@property(nonatomic,strong)UIView  *upView;
//中间部分
@property(nonatomic,strong)UniversityheaderCenterView *centerView;
//下部分View
@property(nonatomic,strong)UIView   *downView;
//收藏、分享
@property(nonatomic,strong)UniversityRightView *rightView;
//世界排名
@property(nonatomic,strong)UILabel *QSrankLab;
//本国排名
@property(nonatomic,strong)UILabel *TIMESLab;
//标签
@property(nonatomic,strong)UILabel *tagOneLab;
//标签
@property(nonatomic,strong)UILabel *tagTwoLab;
@property(nonatomic,copy)UniverstyHeaderViewBlock  actionBlock;

+ (instancetype)headerTableViewWithUniFrame:(UniversityNewFrame *)universityFrame;


@end

