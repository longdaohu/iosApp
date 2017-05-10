//
//  XWGJSubjectCollectionViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#import "CatigorySubjectCell.h"
#import "CatigorySubject.h"
@interface CatigorySubjectCell ()
//cell图片
@property(nonatomic,strong)UIImageView *iconView;
//cell标题
@property(nonatomic,strong)UILabel *titleLab;

@end


@implementation CatigorySubjectCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.iconView =[[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconView];
    
    self.titleLab =[UILabel labelWithFontsize: 20.0f TextColor:XCOLOR_TITLE TextAlignment:NSTextAlignmentCenter];
    self.titleLab.numberOfLines = 2;
    [self.contentView addSubview:self.titleLab];
    
 
}

- (void)setSubject:(CatigorySubject *)subject
{
    _subject = subject;
    
    self.iconView.image = [UIImage imageNamed:subject.icon];
    
    self.titleLab.text = subject.title;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat iconx =  0;
    CGFloat iconh =  self.iconView.image.size.width;
    CGFloat iconw =  iconh;
    CGFloat icony =  0;
    self.iconView.frame =CGRectMake(iconx, icony, iconw, iconh);
    self.iconView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - 10);
    
    CGFloat titlex = 0;
    CGFloat titley = contentSize.width * 0.65;
    CGFloat titlew = contentSize.width;
    CGFloat titleh = contentSize.width * 0.3;
    self.titleLab.frame =CGRectMake(titlex,titley, titlew, titleh);
    
    self.titleLab.font = [UIFont systemFontOfSize:0.12 *FLOWLAYOUT_SubW];
    
}

@end
