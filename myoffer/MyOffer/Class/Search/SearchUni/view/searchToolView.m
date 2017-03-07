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
        
        self.leftButton =[self createButton:leftType andButtonTitleColor:XCOLOR_RED andButtonTitle:@"世界排名"];
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
    
    CGSize contentSize  = self.bounds.size;
    
    CGFloat leftX = 0;
    CGFloat leftY = 0;
    CGFloat leftW = contentSize.width * 0.5;
    CGFloat leftH = contentSize.height;
    self.leftButton.frame = CGRectMake(leftX, leftY,leftW,leftH);
    

    CGFloat iconH = contentSize.height;
    CGFloat iconW =  iconH;
    CGFloat iconX = contentSize.width - iconW - 5;
    CGFloat iconY = 0;
    self.LeftView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    

    CGFloat rightX = CGRectGetMaxX(self.leftButton.frame);
    CGFloat rightY = 0;
    CGFloat rightH = leftH;
    CGFloat rightW =  contentSize.width - leftW;
    self.rightButton.frame = CGRectMake(rightX, rightY, rightW , rightH);
    
     self.centerLine.frame = CGRectMake(contentSize.width * 0.5, 10, 1, contentSize.height - 20);
    
    
}



@end
