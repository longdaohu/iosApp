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
    
    self.backgroundColor = XCOLOR(246, 246, 246, 1);
    self.discountLab.textColor = XCOLOR(205, 0, 87, 1);
    self.priceLab.textColor = XCOLOR_RED;
    [self.commitBtn setBackgroundImage:XImage(@"button_red_nomal") forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:XImage(@"button_red_highlight") forState:UIControlStateHighlighted];
    self.commitBtn.backgroundColor = XCOLOR_CLEAR;
    [self.commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    self.commitBtn.layer.shadowOffset = CGSizeMake(0, 3);
    self.commitBtn.layer.shadowOpacity = 0.5;
    self.commitBtn.layer.shadowColor = XCOLOR_RED.CGColor;
}

- (void)setItem:(YasiCatigoryItemModel *)item{

    _item = item;
    
    BOOL selected = (item.boughtCount > 0) && LOGIN ? YES : NO;
    self.commitBtn.selected  = selected;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",item.price];
    self.discountLab.text = [NSString stringWithFormat:@"￥%@",item.display_price];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.discountLab.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.discountLab.text.length)];
    [self.discountLab setAttributedText:attri];
    
 }

- (void)commitClick:(UIButton *)sender{
    
    if (self.actionBlock) {
        BOOL isPay = (self.commitBtn.selected ? NO : YES);
        self.actionBlock(isPay);
    }
}


@end
