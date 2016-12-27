//
//  XWGJCityCollectionViewHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigaryCityCollectionHeaderView.h"

@implementation CatigaryCityCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.panding = [[UILabel alloc] init];
        self.panding.backgroundColor = XCOLOR_LIGHTBLUE;
        [self addSubview:self.panding];
        self.panding.layer.cornerRadius =  2.5;
        self.panding.layer.masksToBounds = YES;
        
        self.countryLab = [UILabel labelWithFontsize:15.0f TextColor:XCOLOR_DARKGRAY  TextAlignment:NSTextAlignmentLeft];
        self.countryLab.text = GDLocalizedString(@"CategoryNew-country");
        [self addSubview:self.countryLab];
        
        
        self.englishBtn = [self makeButtonWithImage:[UIImage imageNamed:GDLocalizedString(@"Category-UK") ] tag:0];
        [self addSubview:self.englishBtn];
        
        self.autraliaBtn = [self makeButtonWithImage:[UIImage imageNamed:GDLocalizedString(@"Category-AU") ] tag:1];
        [self addSubview:self.autraliaBtn];
        
    }
    return self;
}

- (UIButton *)makeButtonWithImage:(UIImage *)image tag:(NSInteger)tag{
   
    UIButton *sender =  [[UIButton alloc] init];
    sender.tag = tag;
    sender.layer.cornerRadius = 5;
    sender.layer.masksToBounds = YES;
    [sender setImage:image forState:UIControlStateNormal];
    [sender setImage:image forState:UIControlStateHighlighted];
    sender.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    return sender;
}


- (void)onClick:(UIButton *)sender{
 
    if (self.actionBlock)  self.actionBlock(sender);
    
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat pandx = margin;
    CGFloat pandy = 10;
    CGFloat pandw = 5;
    CGFloat pandh = 15;
    self.panding.frame = CGRectMake(pandx, pandy, pandw, pandh);


    CGFloat countryx = CGRectGetMaxX(self.panding.frame)+margin;
    CGFloat countryy = pandy;
    CGFloat countryw = XSCREEN_WIDTH - countryx;
    CGFloat countryh = pandh;
    self.countryLab.frame = CGRectMake(countryx, countryy, countryw,countryh);
    
    CGFloat englishx = margin;
    CGFloat englishy = CGRectGetMaxY(self.countryLab.frame) + 15;
    CGFloat englishw = XSCREEN_WIDTH - englishx * 2;
    CGFloat englishh = (Country_Width - 20);
    self.englishBtn.frame = CGRectMake(englishx, englishy, englishw, englishh);
    
    CGFloat aux = englishx;
    CGFloat auy = CGRectGetMaxY(self.englishBtn.frame) + margin;
    CGFloat auw = englishw;
    CGFloat auh = englishh;
    self.autraliaBtn.frame = CGRectMake(aux, auy, auw, auh);
    
}

@end
