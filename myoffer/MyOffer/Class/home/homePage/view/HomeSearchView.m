//
//  HomeSearchView.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/13.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HomeSearchView.h"

@implementation HomeSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.LeftBtn =[self makeButtonWithImageName:@"search_icon_gray"  andTitle:@""];
        self.LeftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.RightBtn =[self makeButtonWithImageName:@""  andTitle:@"地区/学校/专业，任你搜"];
        self.layer.cornerRadius = 22.0f;
        self.backgroundColor = XCOLOR_WHITE;
        self.layer.borderColor = XCOLOR_line.CGColor;
        self.layer.borderWidth = 1;
        
    }
    return self;
}

-(UIButton *)makeButtonWithImageName:(NSString *)imageName andTitle:(NSString *)title
{
    UIButton *sender =[[UIButton alloc] init];
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateNormal];
     sender.titleLabel.font = XFONT(XFONT_SIZE(14));
    [sender addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];
    
    return sender;
}

-(void)tap{
   
    if (self.actionBlock)  self.actionBlock();
    
 }

+(instancetype)ViewWithFrame:(CGRect)frame
{
    
    return [[HomeSearchView alloc] initWithFrame:frame];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat LeftH = self.bounds.size.height;
    CGFloat LeftW = LeftH;
    self.LeftBtn.frame = CGRectMake(0, 0, LeftW, LeftH);
    
    CGFloat RightX = 0;
    CGFloat RightY = 0;
    CGFloat RightW = self.bounds.size.width - RightX;
    CGFloat RightH = LeftH;
    self.RightBtn.frame = CGRectMake(RightX, RightY, RightW, RightH);
    
    
}

-(void)searchViewWithScrollViewDidScrollContentOffsetY:(CGFloat)contant;
{
    
    if (contant > 40) {
        
        self.top = contant;
        
        [self searchViewWithAnimation:YES];
        
    }else{
        
        
        self.top = 40;
        
        if (self.top == 40) [self  searchViewWithAnimation:NO];
            
        
    }
    
}


-(void)searchViewWithAnimation:(BOOL)animated
{
    
    self.RightBtn.hidden = !animated;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.width = animated ? (XSCREEN_WIDTH - 40) : 44;
        
    }];
    
}


@end
