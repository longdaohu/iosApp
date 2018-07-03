//
//  HomeYESUserCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/26.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYESUserCell.h"
#import "AppButton.h"
@interface HomeYESUserCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation HomeYESUserCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        [iconView setImage:XImage(@"alipay")];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLab = [UILabel new];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont boldSystemFontOfSize:11];
        titleLab.textColor = XCOLOR(63, 63, 63, 1);
        titleLab.numberOfLines = 0;
        self.titleLab = titleLab;
        [self.contentView addSubview:titleLab];

    }
    return self;
}

- (void)setItem:(NSDictionary *)item{
    
    _item = item;
    
    [self.iconView setImage:XImage(item[@"icon"])];
    self.titleLab.text  = item[@"title"];
    [self setNeedsLayout];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
    CGSize content_size = self.contentView.bounds.size;
    
    CGFloat icon_w = 98;
    CGFloat icon_h = icon_w;
    CGFloat icon_x = (content_size.width - icon_w) * 0.5;
    CGFloat icon_y = 0;
    self.iconView.frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    CGFloat title_w = content_size.width;
    CGFloat title_h = [self.titleLab.text sizeWithfontSize:11 maxWidth:content_size.width].height;
    CGFloat title_x = 0;
    CGFloat title_y = icon_y + icon_h + 5;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
}


@end




