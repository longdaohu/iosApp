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
        self.IconView =[[UIImageView alloc] init];
        self.IconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.IconView];
        
        self.SectionTitleLab =[[UILabel alloc] init];
        self.SectionTitleLab.font = [UIFont systemFontOfSize:UNIVERISITYTITLEFONT];
        self.SectionTitleLab.textColor = XCOLOR_LIGHTBLUE;
        [self.contentView addSubview:self.SectionTitleLab];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat Ix = ITEM_MARGIN - 5;
    CGFloat Iw = ICON_WIDTH;
    CGFloat Ih = Iw;
    CGFloat Iy = self.bounds.size.height - Ih;
    self.IconView.frame = CGRectMake(Ix, Iy, Iw, Ih);
    
    
    CGFloat Tx = CGRectGetMaxX(self.IconView.frame);
    CGFloat Tw = XScreenWidth - Tx - ITEM_MARGIN;
    CGFloat Th = Iw;
    CGFloat Ty = Iy;
    self.SectionTitleLab.frame = CGRectMake(Tx, Ty, Tw, Th);
 
}

-(void)setGroup:(XWGJTJSectionGroup *)group
{
    _group = group;
    
     self.IconView.image =[UIImage imageNamed:_group.SectionIconName];
    
    self.SectionTitleLab.text = _group.SectionTitleName;
    
    
 }
@end
