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
        self.RightBtn.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        self.layer.cornerRadius = 5;
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
   
    if (self.actionBlock) {
        
        self.actionBlock();
        
    }
}

+(instancetype)View
{
    return [[self alloc] init];
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
@end
