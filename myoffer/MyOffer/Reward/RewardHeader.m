//
//  RewardHeader.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RewardHeader.h"
#import "Masonry.h"

@interface RewardHeader()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *dollarLab;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIImageView *bottomLine;

@end


@implementation RewardHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"现金券";
        titleLab.font = XFONT(14);
        self.titleLab = titleLab;
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(14);
            make.top.mas_equalTo(self);
            make.right.mas_equalTo(self).mas_offset(-14);
            make.height.mas_equalTo(57);
        }];
        
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleToFill;
        iconView.image = XImage(@"histroyExtract_header");
        self.iconView = iconView;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLab.mas_left);
            make.top.mas_equalTo(titleLab.mas_bottom);
            make.height.mas_equalTo(80);
            make.width.mas_equalTo(@[titleLab]);
        }];


        UIImageView *bottomLine =  [UIImageView new];
        self.bottomLine = bottomLine;
        [bottomLine setImage:[UIImage KD_imageWithColor:XCOLOR_line]];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(self.mas_left).offset(16);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
 
        UILabel *dollarLab = [[UILabel alloc] init];
        dollarLab.font = XFONT(32);
        dollarLab.text = @"0";
        dollarLab.textColor = XCOLOR_WHITE;
        dollarLab.textAlignment = NSTextAlignmentCenter;
        self.dollarLab = dollarLab;
        [self addSubview:dollarLab];
        [dollarLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(iconView.mas_centerX);
            make.centerY.mas_equalTo(iconView.mas_centerY);
            make.width.mas_equalTo(@[iconView]);
        }];
        
    }
    return self;
}

- (void)setDollor:(NSString *)dollor{
    _dollor = dollor;
    
    if (_isMoney) {
         NSString *dollor_a = [NSString stringWithFormat:@"￥%@",dollor];
         NSMutableAttributedString *atti = [[NSMutableAttributedString alloc] initWithString:dollor_a];
        [atti addAttribute:NSFontAttributeName  value:XFONT(15) range:NSMakeRange(0, 1)];
         self.dollarLab.attributedText = atti;
    }else{
        self.dollarLab.text = dollor;
    }
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)bottomLineHiden:(BOOL)hiden{
    
    self.bottomLine.hidden = hiden;
}

@end
