//
//  SecondCollectionViewCell.m
//  myOffer
//
//  Created by sara on 16/3/27.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import "SecondCollectionViewCell.h"

@implementation SecondCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.logoView = [[UIImageView alloc] init];
        self.logoView.image = [UIImage imageNamed:@"PlaceHolderImage"];
        self.logoView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.logoView];
        
        self.mengView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu_Mask"]];
        self.mengView.alpha = 0.7;
        self.mengView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.mengView];
        
        self.titleLab = [UILabel labelWithFontsize:KDUtilSize(15)  TextColor:XCOLOR_WHITE TextAlignment:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 2;
        [self.contentView addSubview:self.titleLab];
        
        self.contentView.layer.masksToBounds = YES;
 

    }
    return self;
}


-(void)setItemInfo:(NSDictionary *)itemInfo
{
     _itemInfo = itemInfo;
    
     self.titleLab.text = itemInfo[@"title"];
    
     [self.logoView sd_setImageWithURL:[NSURL URLWithString:[itemInfo[@"cover_url"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
  
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat logox = 0;
    CGFloat logoy = 0;
    CGFloat logow = contentSize.width + 20;
    CGFloat logoh = contentSize.height;
    self.logoView.frame = CGRectMake(logox, logoy, logow, logoh);
    
    CGFloat mengx = 0;
    CGFloat mengy = logoh * 0.5;
    CGFloat mengw = logow;
    CGFloat mengh = logoh * 0.5;
    self.mengView.frame =CGRectMake(mengx, mengy, mengw, mengh);
    
    
    if (self.titleLab.text) {
        
        CGFloat titlex      = 10;
        CGFloat titlew      = contentSize.width - 2 * ITEM_MARGIN;
        CGSize  titleSize   = [self.titleLab.text KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(15))];
        CGFloat titleh      =  titleSize.width > titlew  ? titleSize.height * 2 :titleSize.width;
        CGFloat titley      = contentSize.height - titleh - 10;
        self.titleLab.frame = CGRectMake(titlex, titley, titlew, titleh);
        
     }

}


@end
