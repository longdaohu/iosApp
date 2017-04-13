//
//  UniversityheaderCenterView.h
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UniversityNewFrame;
typedef enum{
    Uni_Header_CenterItemStyleMore = 100,  //展示
    Uni_Header_CenterItemStyleWeb        //web
}Uni_Header_CenterItemStyle;

typedef void(^UniversityCenterViewBlock)(UIButton *sender);
@interface UniversityheaderCenterView : UIView
@property(nonatomic,strong)UniversityNewFrame  *UniversityFrame;
@property(nonatomic,copy)UniversityCenterViewBlock actionBlock;
+(instancetype)headerCenterViewWithBlock:(UniversityCenterViewBlock)actionBlock;


@end
