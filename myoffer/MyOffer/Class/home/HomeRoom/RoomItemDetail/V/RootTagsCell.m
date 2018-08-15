//
//  RootTagsCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/13.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RootTagsCell.h"
@interface RootTagsCell ()
@property(nonatomic,strong)UIView *top_line;
@property(nonatomic,strong)UIView *boxView;
@end

@implementation RootTagsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [UIView new];
        line.backgroundColor = XCOLOR_line;
        self.top_line = line;
        [self.contentView addSubview:line];
        
        UIView *boxView = [UIView new];
        self.boxView = boxView;
        [self.contentView addSubview:boxView];
      
    }
    
    return  self;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    
    
    if (self.boxView.subviews.count > 0) {
        return;
    }
    for (int index = 0; index < items.count; index++) {
        [self makeButtonWithTitle:items[index]];
    }
}

- (void)makeButtonWithTitle:(NSString *)title{
    
    UILabel *sender = [[UILabel alloc]init];
    sender.textColor = XCOLOR_WHITE;
    sender.backgroundColor = XCOLOR_LIGHTBLUE;
    sender.layer.cornerRadius = CORNER_RADIUS;
    sender.layer.masksToBounds = YES;
    sender.text = title;
    sender.textAlignment = NSTextAlignmentCenter;
    [self.boxView addSubview:sender];
 
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.itemFrameModel) {
        
        self.top_line.frame = self.itemFrameModel.top_line_frame;
        self.boxView.frame = self.itemFrameModel.tag_box_frame;
 
        for (NSInteger index = 0; index < self.itemFrameModel.tagFrames.count; index++) {
            
            UILabel *tagLab = self.boxView.subviews[index];
            tagLab.font = [UIFont systemFontOfSize:self.itemFrameModel.tag_font_size];
            NSValue *tagValue = self.itemFrameModel.tagFrames[index];
            tagLab.frame = tagValue.CGRectValue;
        }
        
    }
    
}




@end




