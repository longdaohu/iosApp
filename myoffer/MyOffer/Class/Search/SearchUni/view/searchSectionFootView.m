//
//  searchSectionFootView.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "searchSectionFootView.h"

@interface searchSectionFootView()
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIButton *footerButton;
@end
@implementation searchSectionFootView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        self.contentView =[[UIView alloc] init];
        self.contentView.backgroundColor =[UIColor whiteColor];
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOpacity = 0.1;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 4);
        [self addSubview:self.contentView];
        
        
        self.footerButton =[[UIButton alloc] init];
        [self.footerButton setTitle:GDLocalizedString(@"SearchResult_more") forState:UIControlStateNormal];
        [self.footerButton addTarget:self action:@selector(moreSubjectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerButton setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        self.footerButton.titleLabel.font =[UIFont systemFontOfSize:15];
        self.footerButton.layer.cornerRadius = 5;
        self.footerButton.layer.borderWidth = 1;
        self.footerButton.layer.borderColor = XCOLOR_RED.CGColor;
        [self addSubview:self.footerButton];
        
     }
    return self;
}

-(void)setUniObj:(UniversityObj *)uniObj
{
    _uniObj = uniObj;
    
}
-(void)moreSubjectPressed:(UIButton *)sender
{
    if (self.actionBlock) {
        self.actionBlock(self.uniObj.universityID);
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, XScreenWidth, 50);
    self.footerButton.frame = CGRectMake((XScreenWidth - 200)*0.5, 5, 200, 40);
    
}
@end
