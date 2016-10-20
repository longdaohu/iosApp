//
//  AdvertiView.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "AdvertiView.h"
@interface AdvertiView ()
@property(nonatomic,strong)UIImageView *advertiImageView;
@property(nonatomic,strong)UIButton  *tapBtn;

@end

@implementation AdvertiView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.advertiImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guid_smart"]];
        self.advertiImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.advertiImageView];
        
         self.tapBtn =[[UIButton alloc] init];
        [self.tapBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        [self.tapBtn setTitle:GDLocalizedString(@"Evaluate-pipei") forState:UIControlStateNormal];
         self.tapBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(22 * XScreenWidth / 320.0)];
        [self.tapBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tapBtn];
        self.tapBtn.layer.cornerRadius = 5;
        self.tapBtn.layer.masksToBounds = YES;
        self.tapBtn.layer.borderColor = XCOLOR_RED.CGColor;
        self.tapBtn.layer.borderWidth = 1;
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];

        
    }
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.advertiImageView.frame = CGRectMake(0, 0,self.bounds.size.width,XScreenHeight);
    CGFloat Ty = XScreenHeight  - (70 * XScreenHeight / 568.0);
    CGFloat Tw = 240 * XScreenWidth / 320.0;
    CGFloat Th = 40 * XScreenWidth/ 320.0;
    CGFloat Tx =  0.5 *(XScreenWidth - Tw);
    self.tapBtn.frame = CGRectMake(Tx, Ty, Tw, Th);
    
}


-(void)tap
{
   
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}
@end
