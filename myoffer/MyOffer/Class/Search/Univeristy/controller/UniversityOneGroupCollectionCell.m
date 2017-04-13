//
//  UniversityOneGroupCollectionCell.m
//  OfferDemo
//
//  Created by sara on 16/8/20.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "UniversityOneGroupCollectionCell.h"
@interface UniversityOneGroupCollectionCell ()
@property(nonatomic,strong)UIImageView *iconView;
@end

@implementation UniversityOneGroupCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView  = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.image   = [UIImage imageNamed:@"PlaceHolderImage"];
        [self.contentView addSubview:iconView];
        iconView.layer.cornerRadius = CORNER_RADIUS;
        iconView.layer.masksToBounds = YES;
        self.iconView = iconView;
        self.contentView.backgroundColor  = [UIColor whiteColor];
        
    }
    return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
     self.iconView.frame = self.bounds;
}


-(void)setPath:(NSString *)path{

    _path = path;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
}

@end


