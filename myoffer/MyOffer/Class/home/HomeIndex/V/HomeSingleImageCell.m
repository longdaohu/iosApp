//
//  HomeSingleImageCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/13.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeSingleImageCell.h"
@interface HomeSingleImageCell ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)CAShapeLayer *shaper;

@end

@implementation HomeSingleImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
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
        
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
        

        
    }
    return self;
}

- (CAShapeLayer *)shaper{
    
    if (!_shaper) {
        
        CAShapeLayer *shaper = [CAShapeLayer layer];
        shaper.shadowColor =  XCOLOR_RED.CGColor;
        shaper.shadowOffset = CGSizeMake(0, 3);
        shaper.shadowRadius = 5;
        shaper.shadowOpacity = 0.1;
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

- (void)setItem:(NSDictionary *)item{
    
    _item = item;
    
    [self.iconView setImage:XImage(item[@"icon"])];
    self.titleLab.text  = item[@"name"];
}

- (void)setCity:(HomeRoomIndexCityObject *)city{
    _city = city;
    self.path = city.img;
    self.titleLab.text  = city.fullName;
 }

- (void)layoutSubviews{
    [super layoutSubviews];

    self.iconView.frame = self.contentView.bounds;
    self.titleLab.frame = self.contentView.bounds;
    
    if (self.shadowEnable) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
        self.shaper.shadowPath = path.CGPath;
    }
 
}


@end
