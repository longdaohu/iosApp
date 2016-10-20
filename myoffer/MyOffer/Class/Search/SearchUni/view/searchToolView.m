//
//  searchToolView.m
//  myOffer
//
//  Created by sara on 15/12/15.
//  Copyright © 2015年 UVIC. All rights reserved.
//
typedef enum {
    leftType = 10,
    rightType
}buttonType;

#import "searchToolView.h"
@interface searchToolView ()
@property(nonatomic,strong)UIButton *lastButton;
@property(nonatomic,strong)UIView *centerLine;

@end
@implementation searchToolView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1];
        
        self.leftButton =[self createButton:leftType andButtonTitleColor:XCOLOR_RED andButtonTitle:GDLocalizedString(@"SearchResult_worldxxxRank")];
        self.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        
        self.LeftView = [[UIImageView alloc] init];
        self.LeftView.contentMode = UIViewContentModeCenter;
        self.LeftView.image = [UIImage imageNamed:@"arrow_down"];
        [self addSubview:self.LeftView];
 
        
        self.rightButton =[self createButton:rightType andButtonTitleColor:[UIColor blackColor] andButtonTitle:GDLocalizedString(@"SearchResult_filter")];
        [self.rightButton setImage:[UIImage imageNamed:@"filter_nomal"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"filter_high"] forState:UIControlStateSelected];
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        
        
        self.centerLine =[[UIView alloc] init];
        self.centerLine.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
        [self addSubview:self.centerLine];
    }
    
    return self;
}

-(UIButton *)createButton:(buttonType)tag andButtonTitleColor:(UIColor *)titleColor andButtonTitle:(NSString *)titleName
{
    UIButton *sender =[[UIButton alloc] init];
    sender.tag = tag;
    [sender addTarget:self action:@selector(senderPressed:) forControlEvents:UIControlEventTouchUpInside];
    sender.titleLabel.font =[UIFont systemFontOfSize:16];
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitle:titleName forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];
    [sender setTitleColor:XCOLOR_RED   forState:UIControlStateSelected];
    
    [self addSubview:sender];
    
    return sender;
}

-(void)senderPressed:(UIButton *)sender
{
    
    if (sender == self.rightButton) {
        
        self.rightButton.selected = !self.rightButton.selected;
        self.leftButton.selected  = NO;
        self.LeftView.image = [UIImage imageNamed:@"arrow_down"];
        
    }
    
    if(sender == self.leftButton)
    {
        
         self.leftButton.selected = !self.leftButton.selected;
        self.rightButton.selected = NO;

        
        UIImage *leftImage =  self.leftButton.selected ? [UIImage imageNamed:@"arrow_up"] : [UIImage imageNamed:@"arrow_down"];
        self.LeftView.image = leftImage;
        
    }
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat LBH = self.frame.size.height;
    
    CGFloat LBW = XScreenWidth * 0.5;
    
    self.leftButton.frame = CGRectMake(0, 0,LBW,LBH);
    
    self.LeftView.frame = CGRectMake(LBW - LBH - 5, 0,LBH, LBH);
    
    self.rightButton.frame = CGRectMake(XScreenWidth*0.5, 0, XScreenWidth*0.5, self.frame.size.height);
    
     self.centerLine.frame = CGRectMake(XScreenWidth * 0.5, 10, 1, LBH - 20);
    
    
}



@end
