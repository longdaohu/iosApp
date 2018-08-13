//
//  RoomTextCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomTextCell.h"
@interface RoomTextCell ()
@property(nonatomic,strong)UIView *top_line;
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation RoomTextCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_line;
        self.top_line = line;
        [self.contentView addSubview:line];
        
  
        UILabel *titleLab = [UILabel new];
        self.titleLab = titleLab;
        [self.contentView addSubview:titleLab];
        titleLab.textColor = XCOLOR_TITLE;
        titleLab.numberOfLines = 0;
    }
    
    return  self;
}

- (void)setItem:(NSString *)item{
    _item = item;
    self.titleLab.text = item;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.itemFrameModel) {
        self.titleLab.font = XFONT(self.itemFrameModel.intro_font_size);
        self.top_line.frame = self.itemFrameModel.top_line_frame;
        self.titleLab.frame = self.itemFrameModel.intro_frame;
    }

}

@end
