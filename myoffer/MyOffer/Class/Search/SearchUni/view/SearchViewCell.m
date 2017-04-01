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
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *itemsView;


@end

@implementation SearchViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.logoView =[[UIImageView alloc] init];
        self.logoView.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:self.logoView];
        
        
        self.titleLab =[[UILabel alloc] init];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLab];
        
        self.itemsView =[[UIView alloc] init];
        [self addSubview:self.itemsView];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
 
    self.logoView.frame =CGRectMake(15, 15, 20, 20);
    self.titleLab.frame = CGRectMake(CGRectGetMaxY(self.logoView.frame) +10, 15, 200, 20);

}


-(void)setFileritem:(FiltContent *)fileritem
{
    _fileritem =fileritem;
    
    self.titleLab.text = fileritem.titleName;
    self.logoView.image = [UIImage imageNamed:fileritem.detailTitleName];
    
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 15);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = XSCREEN_WIDTH - 30;
    
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
         [self.itemsView addSubview:sender];
        
        //起点 增加
        startSize.width += keyWordWidth + padding;
    }
    
}

-(void)cellButtonItemPressed:(UIButton *)sender
{
    
     if (self.actionBlock) {
        
        self.actionBlock(sender);
    }

}


@end
