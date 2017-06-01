//
//  WYLXGroup.m
//  myOffer
//
//  Created by xuewuguojie on 2016/12/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "WYLXGroup.h"

@implementation WYLXGroup

+ (instancetype)groupWithType:(EditType)type title:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content groupKey:(NSString *)key spod:(BOOL)spod{
    
    return [[WYLXGroup alloc] initWithType:type title:title placeHolder:placeHolder content:content groupKey:key spod:spod cellType:0];
}

+ (instancetype)groupWithType:(EditType)type title:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content groupKey:(NSString *)key spod:(BOOL)spod cellType:(CellGroupType)cellType{
    
    
    return [[WYLXGroup alloc] initWithType:type title:title placeHolder:placeHolder content:content groupKey:key spod:spod cellType:cellType];
}



- (instancetype)initWithType:(EditType)type title:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content groupKey:(NSString *)key spod:(BOOL)spod cellType:(CellGroupType)cellType{
    
    WYLXGroup *group = [[WYLXGroup alloc] init];
    
    group.title = title;
    group.placeHolder = placeHolder;
    group.content = content;
    group.key = key;
    group.spod = spod;
    group.groupType = type;
    group.areaCode = @"86";
    group.CellType = cellType;
    
    
    CGFloat title_X = cellType == CellGroupTypeView ? 25 : 14;
    CGFloat title_Y = 20+ XFONT_SIZE(1) * 5;
    CGFloat title_W = XSCREEN_WIDTH;
    CGFloat title_H = 14;
    group.titleFrame = CGRectMake(title_X, title_Y, title_W, title_H);
    
    
    CGFloat input_X = title_X;
    CGFloat input_Y = CGRectGetMaxY(group.titleFrame);
    CGFloat input_W = XSCREEN_WIDTH - input_X * 2;
    CGFloat input_H = 50;
    
    if (group.groupType == EditTypeRegistPhone) {
        
        
        CGFloat areaLab_X = input_X;
        CGFloat areaLab_Y = input_Y + 10;
        CGFloat areaLab_W = 50;
        CGFloat areaLab_H = 30;
        group.areacodeLableFrame = CGRectMake(areaLab_X, areaLab_Y, areaLab_W, areaLab_H);
        
        
        CGFloat area_line_X = CGRectGetMaxX(group.areacodeLableFrame) + 10;
        CGFloat area_line_Y = areaLab_Y;
        CGFloat area_line_W = 1;
        CGFloat area_line_H = areaLab_H;
        group.areacodeLineFrame = CGRectMake(area_line_X, area_line_Y, area_line_W, area_line_H);
        
        CGFloat areaTF_X = -5;
        CGFloat areaTF_W = CGRectGetMaxX(group.areacodeLineFrame) + 5;
        CGFloat areaTF_Y = input_Y;
        CGFloat areaTF_H = input_H;
        group.areacodeTFFrame = CGRectMake(areaTF_X, areaTF_Y, areaTF_W, areaTF_H);
        
        
        input_X = CGRectGetMaxX(group.areacodeTFFrame) + 5;
        input_W = XSCREEN_WIDTH - input_X - title_X;
        
    }
    
    group.inputFrame = CGRectMake(input_X, input_Y, input_W, input_H);
    
    
    
    CGFloat spod_W = 10;
    CGFloat spod_H = spod_W;
    CGFloat spod_X = XSCREEN_WIDTH - spod_W - 20;
    CGFloat spod_Y = input_Y + (input_H - spod_H) * 0.5;
    group.spodFrame = CGRectMake(spod_X, spod_Y, spod_W, spod_H);
    
    
    CGFloat line_X = title_X;
    CGFloat line_H =  0.5;
    CGFloat line_Y = CGRectGetMaxY(group.inputFrame) - line_H;
    CGFloat line_W = XSCREEN_WIDTH - line_X * 2;
    group.line_bottom_Frame = CGRectMake(line_X, line_Y, line_W, line_H);
    
    
    group.cell_Height = CGRectGetMaxY(group.line_bottom_Frame);
    
    CGFloat  right_Y = 0;
    CGFloat  right_H = 0;
    CGFloat  right_W = 0;
    CGFloat  right_X = 0;
    
    if (group.groupType == EditTypeVerificationCode) {
        
        right_H = 40;
        right_W = 110;
        right_X = CGRectGetMaxX(group.line_bottom_Frame) - right_W;
        right_Y =input_Y + 5;
        
    }else if (group.groupType == EditTypePasswd) {
        
        right_W = 22;
        right_H = right_W;
        right_X = CGRectGetMaxX(group.line_bottom_Frame) - right_W;
        right_Y = input_Y +(input_H - right_H) * 0.5;

    }
    
    group.rightBttonFrame = CGRectMake(right_X, right_Y, right_W, right_H);
    
  

    return group;
}



@end
