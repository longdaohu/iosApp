//
//  MessageSectionView.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageSectionView.h"

@interface XWGJMessageSectionView ()
@property(nonatomic,strong)UILabel *SectionNameLab;

@end

@implementation XWGJMessageSectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat Fsize = 16 + 0.02 * (APPSIZE.width - 320);
        
        self.SectionNameLab = [[UILabel alloc] init];
        self.SectionNameLab.font = [UIFont systemFontOfSize:Fsize];
        self.SectionNameLab.textColor =XCOLOR_DARKGRAY;
        [self addSubview:self.SectionNameLab];
        self.backgroundColor = BACKGROUDCOLOR;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat sx = 15;
    CGFloat sy = 5;
    CGFloat sw = self.bounds.size.width - sx;
    CGFloat sh = self.bounds.size.height;
    self.SectionNameLab.frame = CGRectMake(sx, sy, sw, sh);
    
}

-(void)setSecitonName:(NSString *)SecitonName
{
    _SecitonName = SecitonName;
    
    self.SectionNameLab.text = SecitonName;
}

@end
