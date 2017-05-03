//
//  searchSectionFootView.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "searchSectionFootView.h"

@interface searchSectionFootView()
@property(nonatomic,strong)UIView *shadowView;
@property(nonatomic,strong)UIButton *footerBtn;
@end
@implementation searchSectionFootView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
       
        UIView *shadowView =[[UIView alloc] init];
        shadowView.backgroundColor =[UIColor whiteColor];
//        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
//        shadowView.layer.shadowOpacity = 0.1;
//        shadowView.layer.shadowOffset = CGSizeMake(0, 4);
        [self addSubview:shadowView];
        self.shadowView = shadowView;
        
        UIButton *footerBtn =[[UIButton alloc] init];
        [footerBtn setTitle:@"查看更多课程" forState:UIControlStateNormal];
        [footerBtn addTarget:self action:@selector(moreSubjectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [footerBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
        footerBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        [self addSubview:footerBtn];
        self.footerBtn = footerBtn;
        
     }
    return self;
}

-(void)setUniObj:(UniversityNew *)uniObj
{
    _uniObj = uniObj;
    
}
-(void)moreSubjectPressed:(UIButton *)sender
{
    if (self.actionBlock) {
        
        self.actionBlock(self.uniObj.NO_id);
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize  = self.bounds.size;

    CGFloat shadownW = contentSize.width;
    CGFloat shadownH = contentSize.height - 10;
    self.shadowView.frame = CGRectMake(0, 0,shadownW, shadownH);
    
    CGFloat footerW = contentSize.width;
    CGFloat footerH = shadownH;
    CGFloat footerX = 0;
    CGFloat footerY = 0;
    self.footerBtn.frame = CGRectMake(footerX, footerY, footerW, footerH);
    
}
@end
