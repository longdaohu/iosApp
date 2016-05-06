//
//  SearchViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/17.
//  Copyright © 2015年 UVIC. All rights reserved.
//
#define CELLITEMFONT 18
#import "FiltContent.h"
#import "SearchViewCell.h"
@interface SearchViewCell()
@property(nonatomic,strong)UIImageView *logoMV;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *contentBackView;


@end

@implementation SearchViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.logoMV =[[UIImageView alloc] init];
        self.logoMV.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:self.logoMV];
        
        
        self.titleLabel =[[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLabel];
        
        self.contentBackView =[[UIView alloc] init];
        [self addSubview:self.contentBackView];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logoMV.frame =CGRectMake(15, 15, 20, 20);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxY(self.logoMV.frame) +10, 15, 200, 20);

}


-(void)setFileritem:(FiltContent *)fileritem
{
    _fileritem =fileritem;
    
    self.titleLabel.text = fileritem.titleName;
    self.logoMV.image = [UIImage imageNamed:fileritem.detailTitleName];
    
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 15);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = APPSIZE.width - 30;
    
    for (int i = 0; i < fileritem.buttonArray.count; i ++) {
        
        CGFloat keyWordWidth = [fileritem.buttonArray[i] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:CELLITEMFONT]].width +15;
        
        if (keyWordWidth > MAXWidth) {
            
            keyWordWidth = MAXWidth;
        }
        if (MAXWidth - startSize.width < keyWordWidth) {
            
            startSize.height += 35.0;
            
            startSize.width = 0;
        }
        //创建 label点击事件
        UIButton *sender = [[UIButton alloc]init];
        sender.tag = i;
        [sender addTarget:self action:@selector(cellButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        sender.frame =CGRectMake(startSize.width, startSize.height, keyWordWidth, 25);
        sender.layer.cornerRadius = 5;
        [sender setTitle:fileritem.buttonArray[i] forState:UIControlStateNormal];
        
        sender.backgroundColor = [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

         sender.titleLabel.font = [UIFont systemFontOfSize:15];
         [self.contentBackView addSubview:sender];
        
        //起点 增加
        startSize.width += keyWordWidth + padding;
    }
    self.contentBackView.frame =  CGRectMake(15,35,APPSIZE.width - 30, fileritem.contentheigh);
    
}

-(void)cellButtonItemPressed:(UIButton *)sender
{
    
     if (self.actionBlock) {
        
        self.actionBlock(sender);
    }

}


@end
