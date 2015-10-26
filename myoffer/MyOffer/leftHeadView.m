//
//  leftHeadView.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "leftHeadView.h"
@interface leftHeadView()

@end
@implementation leftHeadView

-(void)awakeFromNib
{
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2.0f;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = 2;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundColor =[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    
 }
@end
