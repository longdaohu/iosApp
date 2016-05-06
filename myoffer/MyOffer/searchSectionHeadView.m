//
//  searchSectionHeadView.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "searchSectionHeadView.h"
@interface searchSectionHeadView()
@property(nonatomic,strong)LogoView *LogoMView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;
@property(nonatomic,strong)UILabel *LocalLabel;
@property(nonatomic,strong)UILabel *rankLabel;
@property(nonatomic,strong)UIButton *followButton;
@property(nonatomic,strong)UIImageView *recommendMV;
@end

@implementation searchSectionHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.LogoMView =[[LogoView alloc] init];
        [self addSubview:self.LogoMView];
        
        self.titleLabel =[[UILabel alloc] init];
        self.titleLabel.font =[UIFont systemFontOfSize:14.0];
        [self addSubview:self.titleLabel];
        
        self.subTitleLabel =[[UILabel alloc] init];
        self.subTitleLabel.font =[UIFont systemFontOfSize:14.0];
        [self addSubview:self.subTitleLabel];
        
        self.LocalLabel =[[UILabel alloc] init];
        self.LocalLabel.textColor = [UIColor darkGrayColor];
        self.LocalLabel.font =[UIFont systemFontOfSize:13.0];
        [self addSubview:self.LocalLabel];
        
        
        self.rankLabel =[[UILabel alloc] init];
        self.rankLabel.textColor = [UIColor darkGrayColor];
        self.rankLabel.font =[UIFont systemFontOfSize:13.0];
        [self addSubview:self.rankLabel];
        
        
        self.followButton = [[UIButton alloc] init];
        [self.followButton addTarget:self action:@selector(followButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.followButton];
        
        self.recommendMV =[[UIImageView alloc] init];
        self.recommendMV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.recommendMV];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroudView:)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

-(void)setUniversityInfo:(NSDictionary *)universityInfo
{
    _universityInfo = universityInfo;
    [self.LogoMView.logoImageView KD_setImageWithURL:universityInfo[@"logo"]];
     self.titleLabel.text = universityInfo[@"name"];
     self.subTitleLabel.text = universityInfo[@"official_name"];
     self.LocalLabel.text =[NSString stringWithFormat:@"%@：%@ - %@",GDLocalizedString(@"UniversityDetail-005"), universityInfo[@"country"], universityInfo[@"state"]];
     self.rankLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"ApplicationStutasVC-001"),[universityInfo[@"ranking_ti"] intValue] == 99999 ? @"暂无排名" : universityInfo[@"ranking_ti"]];

    if ([universityInfo[@"favorited"] boolValue]) {
        
        [self.followButton setImage:[UIImage imageNamed:@"button_like"] forState:UIControlStateNormal];
    
    }else{
        
         [self.followButton setImage:[UIImage imageNamed:@"button_Nolike"] forState:UIControlStateNormal];
    }
    
    self.recommendMV.image =[UIImage imageNamed:@"university_cost"];
    
    
}

-(void)tapBackgroudView:(UITapGestureRecognizer *)tap
{
    if (self.actionBlock) {
        self.actionBlock(self.universityInfo[@"_id"]);
    }

}

-(void)followButtonPress:(UIButton *)sender
{
    if (self.followBlock) {
        self.followBlock(sender);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat Fx = APPSIZE.width - 60;
    CGFloat Fy = self.frame.size.height - 40;
    CGFloat Fw = 40;
    CGFloat Fh = 40;
    self.followButton.frame = CGRectMake(Fx, Fy, Fw, Fh);
    
    CGFloat RCx = APPSIZE.width - 60;
    CGFloat RCy = 0;
    CGFloat RCw = 60;
    CGFloat RCh = 60;
    self.recommendMV.frame = CGRectMake(RCx,RCy, RCw ,RCh);
    

    
    CGFloat Lx = 15;
    CGFloat Ly = 15;
    CGFloat Lw = 70;
    CGFloat Lh = 70;
    self.LogoMView.frame = CGRectMake(Lx, Ly, Lw, Lh);
    
    CGFloat Tx = CGRectGetMaxX(self.LogoMView.frame) + 10;
    CGFloat Ty = Ly;
    CGFloat Tw = APPSIZE.width - Tx - 80;
    CGFloat Th = 17;
    self.titleLabel.frame = CGRectMake(Tx, Ty, Tw, Th);
    
    CGFloat Sx = Tx;
    CGFloat Sy = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat Sw = Tw;
    CGFloat Sh = Th;
     self.subTitleLabel.frame = CGRectMake(Sx, Sy, Sw, Sh);
    

    CGFloat LOx = Tx;
    CGFloat LOy = CGRectGetMaxY(self.subTitleLabel.frame) + 5;
    CGFloat LOw = Tw;
    CGFloat LOh = 17;
    self.LocalLabel.frame = CGRectMake(LOx,LOy,LOw, LOh);
    
    CGFloat Rx = Tx;
    CGFloat Ry = CGRectGetMaxY(self.LocalLabel.frame);
    CGFloat Rw = Tw;
    CGFloat Rh = 17;
    self.rankLabel.frame = CGRectMake(Rx,Ry,Rw, Rh);
    
    
}
@end
