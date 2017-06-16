//
//  XWGJSectionHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//


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
        

        self.contentView.backgroundColor = XCOLOR_BG;
        
        self.SectionTitleLab =[[UILabel alloc] init];
        self.SectionTitleLab.font = [UIFont systemFontOfSize:Uni_subject_FontSize];
        self.SectionTitleLab.textColor = XCOLOR_TITLE;
        [self.contentView addSubview:self.SectionTitleLab];
        
    }
    return self;
}



-(void)setGroup:(XWGJTJSectionGroup *)group{
    
    _group = group;
    
     self.SectionTitleLab.text = _group.sectionTitleName;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat titleX = 14;
    CGFloat titleW = contentSize.width - titleX - ITEM_MARGIN;
    CGFloat titleH = 35;
    CGFloat titleY = contentSize.height - titleH;
    self.SectionTitleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
}

@end
