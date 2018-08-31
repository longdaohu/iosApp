//
//  YsCatigoryItemCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YsCatigoryItemCell.h"
#import "YasiCatigoryItemModel.h"

@implementation YsCatigoryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titleBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
    self.titleBtn.userInteractionEnabled = NO;
}

- (void)setItem:(YasiCatigoryItemModel *)item{
    _item = item;
    
    [self.titleBtn setTitle:item.name forState:UIControlStateNormal];

}

- (void)setCell_selected:(BOOL)cell_selected{
    _cell_selected = cell_selected;
    
    self.titleBtn.enabled = !cell_selected;
}



@end
