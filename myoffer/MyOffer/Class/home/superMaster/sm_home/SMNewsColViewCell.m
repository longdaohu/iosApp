//
//  SMNewsColViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMNewsColViewCell.h"

@interface SMNewsColViewCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *uni_Lab;
@property(nonatomic,strong)UIButton *playBtn;
@end

@implementation SMNewsColViewCell

static NSString *identify = @"sm_news";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       [self makeUI];
        
    }
    return self;
}

- (void)makeUI{
    
    self.contentView.backgroundColor = XCOLOR_WHITE;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconView];
    iconView.clipsToBounds = YES;
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    [self addLable:titleLab fontSize:16 textColor:XCOLOR_TITLE];
 
    
    UILabel *nameLab = [[UILabel alloc] init];
    self.nameLab = nameLab;
    [self addLable:nameLab fontSize:14 textColor:XCOLOR_SUBTITLE];
    
    
    UILabel *uni_Lab = [[UILabel alloc] init];
    self.uni_Lab = uni_Lab;
    [self addLable:uni_Lab fontSize:14 textColor:XCOLOR_SUBTITLE];
    
    
    UIButton *playBtn = [UIButton  new];
    [playBtn setTitle:@"观看视频" forState:UIControlStateNormal];
    playBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    playBtn.backgroundColor = XCOLOR_RED;
    self.playBtn = playBtn;
    playBtn.layer.cornerRadius = CORNER_RADIUS;
    playBtn.layer.masksToBounds = true;
    [self.contentView addSubview:playBtn];
    playBtn.userInteractionEnabled = NO;
    
}


- (void)addLable:(UILabel *)itemLable fontSize:(CGFloat)size textColor:(UIColor *)textColor{
    
    itemLable.font = [UIFont systemFontOfSize:size];
    itemLable.textColor = textColor;
    itemLable.numberOfLines = 2;
    [self.contentView addSubview:itemLable];
    
}

- (void)setNewsFrame:(SMNewsFrame *)newsFrame{

    _newsFrame = newsFrame;
    

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:newsFrame.news.ad_post_mc]];
    self.titleLab.text =  newsFrame.news.main_title;
    self.nameLab.text = newsFrame.news.guest_name;
    self.uni_Lab.text = newsFrame.news.guest_university;

    
    self.iconView.frame = newsFrame.icon_Frame;
    self.titleLab.frame = newsFrame.title_Frame;
    self.nameLab.frame = newsFrame.name_Frame;
    self.uni_Lab.frame = newsFrame.uni_Frame;
    self.playBtn.frame = newsFrame.play_Frame;
    
}
 





@end




