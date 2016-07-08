//
//  BottomBackgroudView.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/16.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "BottomBackgroudView.h"
@interface BottomBackgroudView ()
@property(nonatomic,strong)UIButton *clearFilterButton;
@property(nonatomic,strong)UIButton *FilterCommitButton;
@end
@implementation BottomBackgroudView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
  
        self.clearFilterButton  = [self createButtonItemWithTitle:GDLocalizedString(@"SearchResult_clear") andButtonTag:99];
         self.clearFilterButton.backgroundColor =[UIColor lightGrayColor];
        [self addSubview: self.clearFilterButton ];
        
        self.FilterCommitButton  = [self createButtonItemWithTitle:GDLocalizedString(@"SearchResult_commit")  andButtonTag:100];
        self.FilterCommitButton.backgroundColor = XCOLOR_RED;
        [self addSubview: self.FilterCommitButton];
 

    }
    return self;
}
-(UIButton *)createButtonItemWithTitle:(NSString *)titleName andButtonTag:(NSInteger)tag
{
    UIButton *sender  =[[UIButton alloc] init];
    [sender setTitle:titleName   forState:UIControlStateNormal];
    sender.tag = tag;
    [sender addTarget:self action:@selector(FilterResultCommit:) forControlEvents:UIControlEventTouchUpInside];
   
    return sender;
}

-(void)FilterResultCommit:(UIButton *)sender
{
 
    
    if ([self.delegate respondsToSelector:@selector(BottomBackgroudView:andButtonItem:)]) {
        
        [self.delegate BottomBackgroudView:self andButtonItem:sender];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.clearFilterButton.frame =CGRectMake(0, 0, APPSIZE.width*0.5, 50);
    self.FilterCommitButton.frame =CGRectMake(APPSIZE.width*0.5, 0, APPSIZE.width*0.5, 50);
    
}


 

@end
