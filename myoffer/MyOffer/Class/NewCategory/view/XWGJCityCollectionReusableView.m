//
//  XWGJCityCollectionReusableView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJCityCollectionReusableView.h"

@implementation XWGJCityCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    
    self.panding.backgroundColor = XCOLOR_LIGHTBLUE;
    self.panding.layer.cornerRadius = 2.5;
    self.panding.layer.masksToBounds = YES;
    
    self.TitleLab.font = [UIFont systemFontOfSize:15];
    self.TitleLab.textColor = XCOLOR_DARKGRAY;
}

@end
