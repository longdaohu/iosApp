//
//  YsCatigoryItemCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YsCatigoryItemCell.h"
#import "YasiCatigoryItemModel.h"

@interface YsCatigoryItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation YsCatigoryItemCell

- (void)setItem:(YasiCatigoryItemModel *)item{
    _item = item;
    self.titleLab.text  = item.name;
}

- (void)setCell_selected:(BOOL)cell_selected{
    _cell_selected = cell_selected;
    
    self.titleLab.textColor = cell_selected ? XCOLOR_LIGHTBLUE : XCOLOR_WHITE;
    

}



@end
