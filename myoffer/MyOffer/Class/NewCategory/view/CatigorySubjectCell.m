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
@property(nonatomic,strong)UIImageView *IconView;
//cell标题
@property(nonatomic,strong)UILabel *TitleLab;

@end


@implementation CatigorySubjectCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    
    self.IconView =[[UIImageView alloc] init];
    self.IconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.IconView];
    
    self.TitleLab =[UILabel labelWithFontsize: 20.0f TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentCenter];
    self.TitleLab.numberOfLines = 2;
    [self.contentView addSubview:self.TitleLab];
    self.contentView.backgroundColor = XCOLOR_WHITE;
    
}

-(void)setSubject:(CatigorySubject *)subject
{
    _subject = subject;
    
    self.IconView.image = [UIImage imageNamed:subject.IconName];
    self.TitleLab.text = subject.TitleName;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat ix = 0;
    CGFloat iw = FLOWLAYOUT_SubW;
    CGFloat iy = [self.subject.IconName containsString:@"ICON"]? iw * 0.15 : iw * 0.1;
    CGFloat ih = [self.subject.IconName containsString:@"ICON"] ? iw * 0.45 : iw * 0.6;
    self.IconView.frame =CGRectMake(ix, iy, iw, ih);
    
    CGFloat Tx = 0;
    CGFloat Ty = iw * 0.65;
    CGFloat Tw = iw;
    CGFloat Th = iw * 0.3;
    self.TitleLab.frame =CGRectMake(Tx, Ty, Tw, Th);
    
    self.TitleLab.font = [UIFont systemFontOfSize:0.12 *FLOWLAYOUT_SubW];
    
}

@end
