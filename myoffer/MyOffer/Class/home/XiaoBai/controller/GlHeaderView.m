//
//  GlHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/9/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GlHeaderView.h"

@implementation GlHeaderView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    
    self.headerTitleLab.font = XFONT(KDUtilSize(20));
    self.titleLab.font = XFONT(KDUtilSize(18));
    self.subTitleLab.font = XFONT(KDUtilSize(13));
    self.subTitleLab.textColor = XCOLOR_DARKGRAY;
    
    self.centerView.layer.cornerRadius = 5;
    self.centerView.backgroundColor = BACKGROUDCOLOR;
    self.centerView.layer.shadowColor = XCOLOR_BLACK.CGColor;
    self.centerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.centerView.layer.shadowOpacity = 0.2;
    
    self.downView.backgroundColor = BACKGROUDCOLOR;
   
}

-(void)setSubTitle:(NSString *)subTitle{

    _subTitle = subTitle;
    
    self.subTitleLab.text = subTitle;


    CGFloat centerHeight   =  CGRectGetHeight(self.centerView.bounds);
    
    self.HeaderHeight      =  AdjustF(160.f)  + centerHeight - CGRectGetMaxY(self.titleLab.frame);
    
    

    
    [self layoutIfNeeded];
    
    [self setNeedsLayout];
    
    
    self.frame = CGRectMake(0, 0, XScreenWidth, (AdjustF(160.f)  + centerHeight - CGRectGetMaxY(self.titleLab.frame)));
    
    NSLog(@"--------- %@", NSStringFromCGRect(self.centerView.frame));
    
    self.downconstraintHeight.constant =  CGRectGetHeight(self.centerView.frame) - CGRectGetMaxY(self.logoView.frame) ;

 }



- (void)layoutSubviews {
    
    [super layoutSubviews];
    
 
    //    self.downView.height   =  20 + CGRectGetHeight(self.centerView.frame);

    
    
    

    

}


@end
