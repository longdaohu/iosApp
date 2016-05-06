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

@end
@implementation searchToolView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1];
        
        
        self.leftButton =[[XUButton alloc] init];
        self.leftButton.tag = leftType;
        [self.leftButton  addTarget:self action:@selector(senderPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.leftButton .titleLabel.font =[UIFont systemFontOfSize:16];
        self.leftButton .backgroundColor = [UIColor whiteColor];
        [self.leftButton  setTitle:GDLocalizedString(@"SearchResult_worldxxxRank") forState:UIControlStateNormal];
        [self addSubview:self.leftButton];
        [self.leftButton setTitleColor:XCOLOR_RED   forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"arrow_down"]  forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"arrow_up"]  forState:UIControlStateSelected];
  
        
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
        
         self.leftButton.selected = NO;
         
        [self.leftButton setTitleColor:[UIColor blackColor]   forState:UIControlStateNormal];

         
      
    }
    
     if(sender == self.leftButton)
    {
        
 
      
        self.leftButton.selected = !self.leftButton.selected;
        
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
    
    
    self.rightButton.frame = CGRectMake(APPSIZE.width*0.5+1, 0, APPSIZE.width*0.5, self.frame.size.height - 0.5);
    
}

 

@end
