//
//  PipeiCountryView.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiCountryView.h"

@interface PipeiCountryView ()
@property(nonatomic,strong)UIButton *sender;
@property(nonatomic,strong)UILabel *contentLab;
@property(nonatomic,strong)UIImageView *logoView;
@end
@implementation PipeiCountryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        UIButton *sender = [[UIButton alloc] init];
        [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sender];
        self.sender = sender;
        
        
        UILabel *contentLab = [UILabel labelWithFontsize:16 TextColor:XCOLOR_LIGHTGRAY TextAlignment:NSTextAlignmentLeft];
        [self addSubview:contentLab];
        self.contentLab = contentLab;
        
        
        UIImageView *logoView = [[UIImageView alloc] init];
        [self addSubview:logoView];
        self.logoView = logoView;
        logoView.contentMode =  UIViewContentModeScaleAspectFit;
        
        self.layer.borderColor = XCOLOR_LIGHTGRAY.CGColor;
        self.layer.borderWidth = 1;
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    self.sender.frame = self.bounds;
    
    CGFloat contentX = PADDING_TABLEGROUP;
    CGFloat contentY = 0;
    CGFloat contentW = contentSize.width;
    CGFloat contentH = contentSize.height;
    self.contentLab.frame = CGRectMake(contentX, contentY, contentW, contentH);
    
    CGFloat logoY = 10;
    CGFloat logoH = contentSize.height - logoY * 2;
    CGFloat logoW = logoH;
    CGFloat logoX = contentSize.width - logoW - PADDING_TABLEGROUP;
    self.logoView.frame = CGRectMake(logoX, logoY, logoW, logoH);
    
}

- (void)onClick:(UIButton *)sender{

    sender.selected = !sender.selected;
    
    [self configUI:sender.selected];
    
    if (self.actionBlock) {
        
        self.actionBlock(self.contentLab.text);
    }
    
}


- (void)setContryName:(NSString *)contryName{

    _contryName = contryName;
    
    self.contentLab.text = contryName;
    
    NSString *imageName = [contryName isEqualToString:@"英国"] ? @"UK-flag" : @"AU-flag";
  
    self.logoView.image = XImage(imageName);
    
}


-(void)countryIsSelected:(BOOL)select{
    
    self.sender.selected = select;

    [self configUI:select];
    
    
}

-(void)configUI:(BOOL)isSelected{
    
    if (isSelected) {
        
        self.contentLab.textColor = XCOLOR_RED;
        self.layer.borderColor = XCOLOR_RED.CGColor;
        
    }else{
        
        self.contentLab.textColor = XCOLOR_LIGHTGRAY;
        self.layer.borderColor = XCOLOR_LIGHTGRAY.CGColor;
    }
}



@end
