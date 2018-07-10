//
//  XliuxueHeaderView.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "WYLXHeaderView.h"

@interface WYLXHeaderView ()
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIButton *dismissBtn;
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation WYLXHeaderView
+ (instancetype)headViewWithTitle:(NSString *)title{
   
    WYLXHeaderView *header = [[WYLXHeaderView  alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
    
    header.title = title;
    
    return header;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        NSString *path = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"nav.png"];
        UIImage *navImage =[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.contentMode = UIViewContentModeScaleToFill;
        bgView.image = navImage;
        self.bgView = bgView;
        [self addSubview:bgView];

        self.clipsToBounds = YES;

        
        UIButton *dismissBtn = [[UIButton alloc] init];
        self.dismissBtn = dismissBtn;
        [self addSubview:dismissBtn];
         dismissBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [dismissBtn setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(dismissBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        dismissBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.numberOfLines = 0;
        titleLab.font = XFONT(18);
        titleLab.textColor = XCOLOR_WHITE;
        self.titleLab = titleLab;
        [self addSubview:titleLab];
        
        
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{

    _title = title;
    
    self.titleLab.text = title;
    
    CGFloat dis_W = 40;
    CGFloat dis_H = dis_W;
    CGFloat dis_X = 14;
    CGFloat dis_Y = 32;
    self.dismissBtn.frame = CGRectMake(dis_X,dis_Y,dis_W,dis_H);
    
    CGFloat margin = 10 + XFONT_SIZE(1) * 10;
    
    CGFloat title_X = dis_X;
    CGFloat title_Y = self.dismissBtn.center.y + margin;
    CGFloat title_W = self.bounds.size.width - 2 * title_X;
    CGFloat title_H = [self.title  KD_sizeWithAttributeFont:XFONT(18) maxWidth:title_W].height;
    self.titleLab.frame = CGRectMake(title_X, title_Y, title_W, title_H);
    
    self.mj_h = CGRectGetMaxY(self.titleLab.frame) + margin;
    
    self.bgView.frame = self.bounds;
}



- (void)dismissBtnOnClick{

    if (self.actionBlock) self.actionBlock();
}



@end
