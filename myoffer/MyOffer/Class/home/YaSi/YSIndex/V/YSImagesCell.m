//
//  YSImagesCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSImagesCell.h"
@interface YSImagesCell ()
@property(nonatomic,strong)NSMutableArray *iconView_arr;
@end

@implementation YSImagesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
 
        for (NSInteger index = 0; index < 5; index++) {
            
            UIImageView *iconView = [[UIImageView alloc] init];
            iconView.contentMode = UIViewContentModeScaleToFill;
            [self.contentView addSubview:iconView];
            [self.iconView_arr addObject:iconView];
            iconView.backgroundColor = XCOLOR_RANDOM;
        }
   
    }
    
    return self;
}

- (void)setItems:(NSArray *)items{
    _items = items;

    
    NSArray *array = (self.iconView_arr.count > self.items.count) ?  self.items : self.iconView_arr;
    for (NSInteger index = 0; index < array.count; index++) {
        UIImageView *iconView = self.iconView_arr[index];
        [iconView sd_setImageWithURL:[NSURL URLWithString:self.items[index]] placeholderImage:nil];
    }
}

- (NSMutableArray *)iconView_arr{
    
    if (!_iconView_arr) {
        _iconView_arr = [NSMutableArray array];
    }
    return _iconView_arr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
    NSArray *array = (self.iconView_arr.count > self.items.count) ?  self.items : self.iconView_arr;
    CGFloat icon_x  = 0;
    CGFloat icon_y  = 0;
    CGFloat icon_w  = self.bounds.size.width;
    CGFloat icon_h  = 200;
    for (NSInteger index = 0; index < array.count; index++) {
        
        UIImageView *iconView = self.iconView_arr[index];
        iconView.frame = CGRectMake(icon_x, icon_y, icon_w, icon_h);
        icon_y += icon_h;
    }
    
}

@end
