//
//  XWGJCityCollectionViewHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^headerViewBlock)(UIButton *);
@interface XWGJCityCollectionViewHeaderView : UIView
@property(nonatomic,strong)UILabel *panding;
@property(nonatomic,strong)UILabel *countryLab;
//英国选项
@property(nonatomic,strong)UIButton *englishBtn;
//澳大利亚选项
@property(nonatomic,strong)UIButton *autraliaBtn;
@property(nonatomic,copy)headerViewBlock actionBlock;

@end
