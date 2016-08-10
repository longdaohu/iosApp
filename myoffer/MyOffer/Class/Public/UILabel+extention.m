//
//  UILabel+extention.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UILabel+extention.h"

@implementation UILabel (extention)


+(UILabel *)labelWithFontsize:(CGFloat)fontSize TextColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *lab =[[UILabel alloc] init];
    lab.textColor = textColor;
    lab.font = [UIFont systemFontOfSize:fontSize];
    lab.textAlignment = textAlignment;
    return lab;
}

@end
