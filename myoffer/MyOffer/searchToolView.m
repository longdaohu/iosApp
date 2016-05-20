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
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIButton *lastButton;
@property(nonatomic,assign)BOOL leftButtonSelected;

@end
@implementation searchToolView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1];
        
        self.leftButton =[self createButton:leftType andButtonTitleColor:XCOLOR_RED andButtonTitle:GDLocalizedString(@"SearchResult_worldxxxRank")];
        [self.leftButton setTitleColor:XCOLOR_RED   forState:UIControlStateNormal];
        //        [self.leftButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        //        self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -188);
        self.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        self.leftButtonSelected = NO;
        
        self.LeftView = [[UIImageView alloc] init];
        self.LeftView.contentMode = UIViewContentModeCenter;
        self.LeftView.image = [UIImage imageNamed:@"arrow_down"];
        [self addSubview:self.LeftView];
        
        
        self.rightButton =[self createButton:rightType andButtonTitleColor:[UIColor blackColor] andButtonTitle:GDLocalizedString(@"SearchResult_filter")];
        [self.rightButton setImage:[UIImage imageNamed:@"filter_nomal"] forState:UIControlStateNormal];
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
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
    
    [self addSubview:sender];
    
    return sender;
}

-(void)senderPressed:(UIButton *)sender
{
    
    if (sender == self.rightButton) {
        
        
        [self.rightButton setTitleColor:XCOLOR_RED  forState:UIControlStateNormal];
        
        [self.rightButton setImage:[UIImage imageNamed:@"filter_high"] forState:UIControlStateNormal];
        
        self.leftButtonSelected = NO;
        
        [self.leftButton setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];
        
        self.LeftView.image = [UIImage imageNamed:@"arrow_down"];
        
        
    }
    
    if(sender == self.leftButton)
    {
        
        self.leftButtonSelected =  !self.leftButtonSelected;
        
        
        UIImage *leftImage =  self.leftButtonSelected ? [UIImage imageNamed:@"arrow_up"] : [UIImage imageNamed:@"arrow_down"];
        self.LeftView.image = leftImage;
        
        
        //        [self.leftButton setImage:leftImage forState:UIControlStateNormal];
        
        [self.leftButton setTitleColor:XCOLOR_RED   forState:UIControlStateNormal];
        
        [self.rightButton setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        
        [self.rightButton setImage:[UIImage imageNamed:@"filter_nomal"] forState:UIControlStateNormal];
    }
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat LBH = self.frame.size.height - 0.5 ;
    
    CGFloat LBW = APPSIZE.width*0.5;
    
    self.leftButton.frame = CGRectMake(0, 0,LBW,LBH);
    
    self.LeftView.frame = CGRectMake(LBW - LBH - 5, 0,LBH, LBH);
    
    self.rightButton.frame = CGRectMake(APPSIZE.width*0.5+1, 0, APPSIZE.width*0.5, self.frame.size.height - 0.5);
    
}



@end
