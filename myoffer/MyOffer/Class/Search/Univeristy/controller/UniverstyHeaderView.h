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
@property(nonatomic,strong)UIView  *upView;
@property(nonatomic,strong)UniversityheaderCenterView *centerView;
@property(nonatomic,strong)UIView   *downView;
@property(nonatomic,strong)UniversityRightView *rightView;
@property(nonatomic,strong)UILabel *QSrankLab;
@property(nonatomic,strong)UILabel *TIMESLab;
@property(nonatomic,strong)UILabel *tagOneLab;
@property(nonatomic,strong)UILabel *tagTwoLab;
@property(nonatomic,copy)UniverstyHeaderViewBlock  actionBlock;


@end

