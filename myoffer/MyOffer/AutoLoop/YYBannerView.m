//
//  YYBannerView.m
//  YYDailyNewsDemo
//
//  Created by REiFON-MAC on 15/12/29.
//  Copyright © 2015年 L. All rights reserved.
//

#import "YYBannerView.h"
//#import "UIImageView+YYImg.h"
#import "UIView+Extension.h"
#import "YYToolKit.h"


@implementation YYBannerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *upMV =[[UIImageView alloc] init];
        upMV.image = [UIImage imageNamed:@"gradient_bg"];
        self.upMV = upMV;
        [self addSubview:upMV];
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        UILabel *lab = [[UILabel alloc] init];
        lab.numberOfLines = 0;
        [self addSubview:lab];
        _titleLab = lab;


        
        
        [self configTapGes];
    }
    return self;
}


#pragma mark - 添加手势
- (void)configTapGes{

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGes];
    
}

#pragma mark - User Action
- (void)tapAction{

    _clickBannerCallBackBlock(_bannerNewsBO);

}

#pragma mark - Setter


- (void)setBannerNewsBO:(YYSingleNewsBO *)bannerNewsBO{
    
    _bannerNewsBO = bannerNewsBO;
   
//       [self setImage:[UIImage imageNamed:@"PlaceHolderImage"]];
//        [self yy_setImageWithUrlString:bannerNewsBO.imageUrl placeholderImage:[UIImage imageNamed:@""]];
//       [self KD_setImageWithURL:bannerNewsBO.imageUrl];
    [self sd_setImageWithURL:[NSURL URLWithString:bannerNewsBO.imageUrl]  placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:bannerNewsBO.newsTitle attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:21],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        CGSize size =  [attStr boundingRectWithSize:CGSizeMake(kScreenWidth-30, AdjustF(200.f)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
        _titleLab.frame = CGRectMake(15, 0, kScreenWidth-30, size.height);
        [_titleLab setBottom:AdjustF(180.f)];
        _titleLab.attributedText = attStr;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
     self.upMV.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
