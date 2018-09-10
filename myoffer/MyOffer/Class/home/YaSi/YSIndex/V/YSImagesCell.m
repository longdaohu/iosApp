//
//  YSImagesCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSImagesCell.h"
#import "YasiCatigoryItemModel.h"

@interface YSImagesCell ()
@property(nonatomic,strong)NSMutableArray *iconView_arr;
@end

@implementation YSImagesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = XCOLOR(0, 19, 30, 1);
        for (NSInteger index = 0; index < 5; index++) {
            
            UIImageView *iconView = [[UIImageView alloc] init];
            iconView.contentMode = UIViewContentModeScaleToFill;
            [self.contentView addSubview:iconView];
            [self.iconView_arr addObject:iconView];
        }
        
    }
    
    return self;
}


- (NSMutableArray *)iconView_arr{
    
    if (!_iconView_arr) {
        _iconView_arr = [NSMutableArray array];
    }
    return _iconView_arr;
}

-  (void)setItem:(YasiCatigoryItemModel *)item{
    
    _item = item;
    
    if (!item) return;
    
    NSArray *imageFrames = item.imagesFrame_arr[self.current_index];
    
    NSArray *images = item.items[self.current_index];
    NSArray *array = (self.iconView_arr.count > images.count) ?  images : self.iconView_arr;
    for (NSInteger index = 0; index < array.count; index++) {
        UIImageView *iconView = self.iconView_arr[index];
        NSURL *path = [NSURL URLWithString: images[index]];
        [iconView sd_setImageWithURL: path placeholderImage:nil];
        NSValue *value = imageFrames[index];
        iconView.frame = value.CGRectValue;
    }
    
}

@end
