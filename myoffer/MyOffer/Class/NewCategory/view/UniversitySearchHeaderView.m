//
//  UniversitySearchHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversitySearchHeaderView.h"

@implementation UniversitySearchHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.titleLab =[UILabel labelWithFontsize: 20.0f TextColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLab];
        self.contentView.backgroundColor = XCOLOR_BG;

        
    }
    return  self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
     self.titleLab.frame = CGRectMake(ITEM_MARGIN, 0, XScreenWidth, self.bounds.size.height);
    
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLab.text = title;
    
}


@end
