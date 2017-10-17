//
//  RankTypeHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankTypeHeaderView.h"
@interface RankTypeHeaderView ()
@property(nonatomic,strong)UILabel *desc_lab;
@end

@implementation RankTypeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.3];
        
        UILabel *desc_lab = [UILabel label];
        desc_lab.font = [UIFont systemFontOfSize:16];
        desc_lab.textColor = XCOLOR_WHITE;
        desc_lab.numberOfLines = 0;
        desc_lab.textAlignment = NSTextAlignmentLeft;
        self.desc_lab = desc_lab;
        [self addSubview:desc_lab];
        
    }
    
    return self;
}

- (void)setTypeFrame:(RankItemFrameModel *)typeFrame{
    
    _typeFrame = typeFrame;
    
    self.desc_lab.frame = typeFrame.desc_frame;
    self.frame = typeFrame.header_frame;
    
    self.desc_lab.text = typeFrame.rankItem.descrpt;
    
}





@end
