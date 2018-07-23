//
//  HomeSingleImageCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/13.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeSingleImageCell.h"
@interface HomeSingleImageCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
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
        iconView.backgroundColor = XCOLOR(224, 224, 224, 1);
        self.iconView = iconView;
        
        UILabel *titleLab = [UILabel new];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        titleLab.textColor = XCOLOR_WHITE;
        titleLab.numberOfLines = 2;
        self.titleLab = titleLab;
        [self.contentView addSubview:titleLab];
        titleLab.shadowOffset = CGSizeMake(1, 1);
        titleLab.layer.shadowOpacity = 1.0;
        titleLab.layer.shadowRadius = 1.0;
        titleLab.layer.shadowColor = XCOLOR_BLACK.CGColor;
        titleLab.layer.shadowOffset = CGSizeMake(1, 1);
 
        
    }
    return self;
}

- (void)setPath:(NSString *)path{
    _path = path;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
}

- (void)setItem:(NSDictionary *)item{
    
    _item = item;
    
    [self.iconView setImage:XImage(item[@"icon"])];
    self.titleLab.text  = item[@"name"];

}

- (void)layoutSubviews{
    [super layoutSubviews];
//    NSArray *items =  self.contentView.subviews;
//    if (items.count > 0) {
        self.iconView.frame = self.contentView.bounds;
        self.titleLab.frame = self.contentView.bounds;
//    }
}


@end
