//
//  PriceCellView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "PriceCellView.h"
#import "YasiCatigoryItemModel.h"

@interface PriceCellView ()
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation PriceCellView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.discountLab.textColor = XCOLOR_RED;
    self.priceLab.textColor = XCOLOR_RED;
    [self.commitBtn setBackgroundImage:XImage(@"button_red_nomal") forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:XImage(@"button_red_highlight") forState:UIControlStateHighlighted];
    self.commitBtn.backgroundColor = XCOLOR_CLEAR;
    [self.commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setItem:(YasiCatigoryItemModel *)item{

    _item = item;
    
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",item.price];
    self.discountLab.text = [NSString stringWithFormat:@"￥%@",item.display_price];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.discountLab.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.discountLab.text.length)];
    [self.discountLab setAttributedText:attri];
    
 }

- (void)commitClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end
