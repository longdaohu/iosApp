//
//  HomeSingleImageCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/13.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeSingleImageCell.h"
@interface HomeSingleImageCell ()
//@property (weak, nonatomic) IBOutlet
@property(nonatomic,strong)UIImageView *iconView;
@end

@implementation HomeSingleImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        [iconView setImage:XImage(@"alipay")];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = CORNER_RADIUS;
        iconView.backgroundColor = XCOLOR_line;
        self.iconView = iconView;
    }
    return self;
}

- (void)setPath:(NSString *)path{
    _path = path;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    NSArray *items =  self.contentView.subviews;
//    if (items.count > 0) {
        self.iconView.frame = self.contentView.bounds;
//    }
}


@end
