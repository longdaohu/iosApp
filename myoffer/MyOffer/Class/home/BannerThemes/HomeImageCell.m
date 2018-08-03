//
//  HomeImageCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/7/27.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeImageCell.h"

@interface HomeImageCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)CAShapeLayer *shaper;

@end

@implementation HomeImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:iconView];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = 8;
        self.iconView = iconView;
    }
    return self;
}

- (CAShapeLayer *)shaper{
    
    if (!_shaper) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor =  XCOLOR_BLACK.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 3);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.2;
        _shaper = shaper;
        [self.contentView.layer insertSublayer:shaper atIndex:0];
    }
    
    return _shaper;
}


- (void)setPath:(NSString *)path{
    _path = path;
    
    path = [path toUTF8WithString];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.iconView.frame = self.contentView.bounds;
 
    if (self.shadowEnable) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
        self.shaper.shadowPath = path.CGPath;
    }
    
}


@end
