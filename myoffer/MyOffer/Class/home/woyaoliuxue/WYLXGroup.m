//
//  WYLXGroup.m
//  myOffer
//
//  Created by xuewuguojie on 2016/12/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "WYLXGroup.h"

@implementation WYLXGroup
//+ (instancetype)groupWithHeader:(NSString *)headerTitle content:(NSString *)content cellKey:(NSString *)key{
//
//    WYLXGroup *group = [[WYLXGroup alloc] init];
// 
//    group.content = content;
//    group.headerTitle = headerTitle;
//    group.cellKey = key;
//    
//    return group;
//}

+ (instancetype)groupWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content groupKey:(NSString *)key spod:(BOOL)spod{

    WYLXGroup *group = [[WYLXGroup alloc] init];
    
    group.title = title;
    group.placeHolder = placeHolder;
    group.content = content;
    group.key = key;
    group.spod = spod;
    
    
    CGFloat title_X = 14;
    CGFloat title_Y = 20+ XFONT_SIZE(1) * 5;
    CGFloat title_W = XSCREEN_WIDTH;
    CGFloat title_H = 14;
    group.titleFrame = CGRectMake(title_X, title_Y, title_W, title_H);
    
    CGFloat input_X = title_X;
    CGFloat input_Y = CGRectGetMaxY(group.titleFrame);
    CGFloat input_W = XSCREEN_WIDTH;
    CGFloat input_H = 50;
    group.inputFrame = CGRectMake(input_X, input_Y, input_W, input_H);
    
    CGFloat spod_W = 10;
    CGFloat spod_H = spod_W;
    CGFloat spod_X = XSCREEN_WIDTH - spod_W - 20;
    CGFloat spod_Y = input_Y + (input_H - spod_H) * 0.5;
    group.spodFrame = CGRectMake(spod_X, spod_Y, spod_W, spod_H);
    
    
    CGFloat line_X = title_X;
    CGFloat line_H = 0.5;
    CGFloat line_Y = CGRectGetMaxY(group.inputFrame) - line_H;
    CGFloat line_W = XSCREEN_WIDTH - line_X * 2;
    group.lineFrame = CGRectMake(line_X, line_Y, line_W, line_H);
    
    group.cell_Height = CGRectGetMaxY(group.lineFrame);
    
    
    return group;
}


@end
