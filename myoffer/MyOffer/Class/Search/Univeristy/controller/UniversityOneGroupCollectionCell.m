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
        
        self.iconView         = [[UIImageView alloc] init];
        self.iconView.contentMode = UIViewContentModeScaleToFill;
        self.iconView.image   = [UIImage imageNamed:@"logo"];
        [self.contentView addSubview:self.iconView];
        self.iconView.layer.cornerRadius = 6;
        self.iconView.layer.masksToBounds = YES;
        
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
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo"]];
    
}

@end


