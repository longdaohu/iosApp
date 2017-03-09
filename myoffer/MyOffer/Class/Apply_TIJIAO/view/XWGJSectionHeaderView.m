//
//  XWGJSectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#define ICON_WIDTH  30
#import "XWGJSectionHeaderView.h"
#import "XWGJTJSectionGroup.h"

@interface XWGJSectionHeaderView ()

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *SectionTitleLab;
@end


@implementation XWGJSectionHeaderView

+(instancetype)SectionViewWithTableView:(UITableView *)tableView
{
    static NSString *Identifier =@"TJSectionView";
    
    XWGJSectionHeaderView *sectionHeader =[tableView dequeueReusableHeaderFooterViewWithIdentifier:Identifier];
    if (!sectionHeader) {
        
        sectionHeader = [[XWGJSectionHeaderView alloc] initWithReuseIdentifier:Identifier];
        
    }
    return sectionHeader;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        

        self.contentView.backgroundColor = XCOLOR_CLEAR;
        
        self.iconView =[[UIImageView alloc] init];
        self.iconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.iconView];
        
        self.SectionTitleLab =[[UILabel alloc] init];
        self.SectionTitleLab.font = [UIFont systemFontOfSize:Uni_subject_FontSize];
        self.SectionTitleLab.textColor = XCOLOR_LIGHTBLUE;
        [self.contentView addSubview:self.SectionTitleLab];
        
    }
    return self;
}



-(void)setGroup:(XWGJTJSectionGroup *)group{
    
    _group = group;
    
     self.iconView.image =[UIImage imageNamed:_group.SectionIconName];
     self.SectionTitleLab.text = _group.SectionTitleName;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat iconX = ITEM_MARGIN - 5;
    CGFloat iconW = ICON_WIDTH;
    CGFloat iconH = iconW;
    CGFloat iconY = contentSize.height - iconH;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame);
    CGFloat titleW = contentSize.width - titleX - ITEM_MARGIN;
    CGFloat titleH = iconW;
    CGFloat titleY = iconY;
    self.SectionTitleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
}

@end
