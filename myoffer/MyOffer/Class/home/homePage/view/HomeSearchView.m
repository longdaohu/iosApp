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
        
        self.LeftBtn =[self makeButtonWithImageName:@"search_darkgrey"  andTitle:@""];
        self.LeftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.LeftBtn.hidden = YES;
        
        self.RightBtn =[self makeButtonWithImageName:@"search-no-result"  andTitle:GDLocalizedString(@"Discover_search")];
        self.layer.cornerRadius = CORNER_RADIUS;
        self.backgroundColor = XCOLOR_WHITE;
        
    }
    return self;
}

-(UIButton *)makeButtonWithImageName:(NSString *)imageName andTitle:(NSString *)title
{
    UIButton *sender =[[UIButton alloc] init];
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateNormal];
     sender.titleLabel.font = FontWithSize(KDUtilSize(12));
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

-(void)searchViewWithScrollViewDidScrollContentOffsetY:(CGFloat)contentOffsetY;
{

    CGFloat contant = XSCREEN_HEIGHT * 0.7 * 0.6 + 20 -22 - contentOffsetY;
    
    if (contant > 20) {
        
        self.top = contant;
        
        [self searchViewWithAnimation:YES];
        
    }else{
        
        
        self.top = 20;
        
        if (self.top == 20) {
            
            [self  searchViewWithAnimation:NO];
        }
    }
    
}


-(void)searchViewWithAnimation:(BOOL)animated
{
    self.LeftBtn.hidden  = animated;
    self.RightBtn.hidden = !animated;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.width = animated ? (XSCREEN_WIDTH - 40) : 44;
        
        self.layer.cornerRadius = animated ? 5.0f : 22.0f;
    }];
    
}


@end
