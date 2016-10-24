//
//  UniversitySearchHeaderView.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "NomalTableSectionHeaderView.h"
@interface NomalTableSectionHeaderView ()
@property(nonatomic,strong)UILabel *titleLab;

@end
@implementation NomalTableSectionHeaderView


+(instancetype)sectionViewWithTableView:(UITableView *)tableView{

    NomalTableSectionHeaderView *header =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    if (!header) {
        
        header =[[NomalTableSectionHeaderView alloc] initWithReuseIdentifier:@"header"];
    }
    
    return header;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *titleLab = [UILabel labelWithFontsize: 20.0f TextColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
 
        self.contentView.backgroundColor = XCOLOR_BG;

    }
    return  self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
     CGSize contentSize = self.contentView.bounds.size;
    
     self.titleLab.frame = CGRectMake(ITEM_MARGIN, 0, contentSize.width, contentSize.height);
    
}

-(void)sectionHeaderWithTitle:(NSString *)title FontSize:(CGFloat)fontSize
{
    self.titleLab.text = title;
    self.titleLab.font = XFONT(fontSize);
    
}


@end


