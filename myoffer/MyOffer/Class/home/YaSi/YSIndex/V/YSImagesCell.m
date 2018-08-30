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
        
        
        for (NSInteger index = 0; index < 3; index++) {
            
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

- (void)layoutSubviews{
    [super layoutSubviews];
 
}

@end
